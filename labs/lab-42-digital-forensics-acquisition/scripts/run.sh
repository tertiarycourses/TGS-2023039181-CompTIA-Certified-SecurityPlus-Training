#!/usr/bin/env bash
# Lab 42 — Digital Forensics: Acquisition & Chain of Custody
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y dcfldd sleuthkit foremost e2fsprogs
mkdir -p /cases/CASE-042/{evidence,images,work,reports}

echo '=== block 2 ==='
cd /cases/CASE-042
cat > reports/legal-hold-notice.txt <<EOF
LEGAL HOLD NOTICE - CASE-042          Issued: $(date -u +%F)
Matter: suspected leak of Project Nightfall plans (synthetic exercise)
Custodians: J. Doe (finance), IT operations
Scope: laptop disk FIN-LT-0457, mailbox jdoe, file share /finance
Instruction: suspend all deletion, re-imaging and log rotation for the scope above until released in writing by Legal.
EOF
printf 'utc_time,item_id,action,handler,location,sha256\n' > reports/chain-of-custody.csv
echo "$(date -u +%FT%TZ),FIN-LT-0457,received under legal hold,$(whoami),evidence locker A3," >> reports/chain-of-custody.csv
cat reports/legal-hold-notice.txt

echo '=== block 3 ==='
cd /cases/CASE-042/evidence
date -u +%FT%TZ > v01-system-time.txt; uptime >> v01-system-time.txt
ps auxww > v02-processes.txt
ss -tunap > v03-network.txt; ip neigh > v03-arp.txt
who -a > v04-users.txt
sha256sum v0* | tee volatile.sha256
echo "$(date -u +%FT%TZ),VOL-001,volatile data captured,$(whoami),/cases/CASE-042/evidence,$(sha256sum volatile.sha256 | cut -d' ' -f1)" >> ../reports/chain-of-custody.csv

echo '=== block 4 ==='
dd if=/dev/zero of=/cases/CASE-042/FIN-LT-0457.raw bs=1M count=32 status=none
LOOP=$(losetup -f --show /cases/CASE-042/FIN-LT-0457.raw) && echo "$LOOP" > /cases/CASE-042/loopdev
mkfs.ext4 -q -L FIN-LT-0457 "$LOOP"
mkdir -p /mnt/suspect && mount "$LOOP" /mnt/suspect
echo "Quarterly budget - nothing sensitive" > /mnt/suspect/budget.txt
echo "CONFIDENTIAL: Project Nightfall launch plan - send to competitor contact" > /mnt/suspect/nightfall.txt
printf '\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x00\x00\x01\x00\x01\x00\x00NIGHTFALL-BLUEPRINT\xff\xd9' > /mnt/suspect/blueprint.jpg
sync; rm /mnt/suspect/nightfall.txt /mnt/suspect/blueprint.jpg; sync
umount /mnt/suspect
blockdev --setro "$LOOP" && blockdev --getro "$LOOP"

echo '=== block 5 ==='
LOOP=$(cat /cases/CASE-042/loopdev)
sha256sum "$LOOP" | awk '{print $1}' | tee /cases/CASE-042/reports/source-before.sha256
echo "$(date -u +%FT%TZ),FIN-LT-0457,source hashed before acquisition,$(whoami),write-blocked $LOOP,$(cat /cases/CASE-042/reports/source-before.sha256)" >> /cases/CASE-042/reports/chain-of-custody.csv

echo '=== block 6 ==='
cd /cases/CASE-042 && LOOP=$(cat loopdev)
dd if="$LOOP" of=images/FIN-LT-0457.dd bs=1M conv=noerror,sync status=none
dcfldd if="$LOOP" of=images/FIN-LT-0457.dcfldd.img bs=1M hash=sha256 hashlog=reports/dcfldd-hash.log
cat reports/dcfldd-hash.log

echo '=== block 7 ==='
cd /cases/CASE-042 && LOOP=$(cat loopdev)
sha256sum images/FIN-LT-0457.dd images/FIN-LT-0457.dcfldd.img | tee reports/images.sha256
sha256sum "$LOOP" | awk '{print $1}' > reports/source-after.sha256
diff reports/source-before.sha256 reports/source-after.sha256 && echo "SOURCE UNCHANGED"
[ "$(awk '{print $1}' reports/images.sha256 | sort -u | wc -l)" = 1 ] && grep -q "$(cat reports/source-before.sha256)" reports/images.sha256 && echo "IMAGES MATCH SOURCE"
echo "$(date -u +%FT%TZ),IMG-001,dd image created and verified,$(whoami),/cases/CASE-042/images,$(cut -d' ' -f1 reports/images.sha256 | head -1)" >> reports/chain-of-custody.csv

echo '=== block 8 ==='
cd /cases/CASE-042
cp images/FIN-LT-0457.dd work/working-copy.dd
mkdir -p /mnt/case042 && mount -o ro,noload,loop work/working-copy.dd /mnt/case042
ls -la /mnt/case042
fls -r -d work/working-copy.dd
grep -a -o 'CONFIDENTIAL: Project Nightfall.*competitor contact' work/working-copy.dd | head -1
printf 'jpg y 200000 \\xff\\xd8\\xff\\xe0\\x00\\x10 \\xff\\xd9\n' > work/foremost.conf
foremost -q -c work/foremost.conf -i work/working-copy.dd -o work/carved && ls -R work/carved | head
umount /mnt/case042
sha256sum images/FIN-LT-0457.dd | cut -d' ' -f1 | grep -q "$(cat reports/source-before.sha256)" && echo "MASTER IMAGE STILL INTACT"

echo '=== block 9 ==='
cd /cases/CASE-042
chmod 0444 images/* && chattr +i images/FIN-LT-0457.dd 2>/dev/null; lsattr images/ 2>/dev/null
losetup -d "$(cat loopdev)"
echo "$(date -u +%FT%TZ),IMG-001,master image sealed (0444 + immutable),$(whoami),/cases/CASE-042/images," >> reports/chain-of-custody.csv
cat > reports/forensic-report.txt <<EOF
CASE-042 forensic acquisition report        $(date -u +%FT%TZ)
Media: FIN-LT-0457 (32 MB ext4), write-blocked with blockdev --setro
Source SHA-256 before: $(cat reports/source-before.sha256)
Source SHA-256 after:  $(cat reports/source-after.sha256)
Images: dd and dcfldd, both hashes equal to the source
Findings: deleted file nightfall.txt content recovered from unallocated space;
          deleted JPEG carved by foremost (work/carved/jpg)
Method: analysis on a working copy mounted ro,noload; master image sealed
Chain of custody: reports/chain-of-custody.csv
EOF
cat reports/forensic-report.txt; column -s, -t < reports/chain-of-custody.csv

echo '=== block 10 ==='
cd /cases/CASE-042
sha256sum -c reports/images.sha256
grep -c . reports/chain-of-custody.csv
ls work/carved/jpg/ | wc -l
