#!/usr/bin/env bash
# Lab 30 — Asset Inventory, Media Sanitisation and Disposal Certificate
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y util-linux coreutils e2fsprogs cryptsetup jq bsdextrautils || apt-get install -y util-linux coreutils e2fsprogs cryptsetup jq
mkdir -p /root/itam

echo '=== block 2 ==='
cd /root/itam
cat > inventory.csv <<'EOF'
asset_tag,type,model,serial,owner,custodian,classification,location,status
SG-LT-0142,laptop,Latitude 7440,SN-7F3K92,Finance (CFO),IT Ops,Confidential,SG-HQ,In service
SG-SRV-0007,server,PowerEdge R650,SN-Q2LX81,Payments (Head of Payments),Infra Team,Restricted,SG-DC1,In service
SG-USB-0031,usb-drive,Kingston DT 32GB,SN-KDT331,HR (HR Director),IT Ops,Confidential,SG-HQ,Lost - reported
SG-DISK-0099,disk,Virtual 64MiB,SN-LAB0099,Finance (CFO),IT Ops,Confidential,Lab,Retired
EOF
column -s, -t < inventory.csv
jq -n --arg host "$(hostname)" --arg os "$(. /etc/os-release; echo "$PRETTY_NAME")" --arg kernel "$(uname -r)" \
  --argjson pkgs "$(dpkg-query -W | wc -l)" --argjson disks "$(lsblk -J -d -o NAME,SIZE,TYPE)" \
  '{host:$host, os:$os, kernel:$kernel, installed_packages:$pkgs, disks:$disks.blockdevices}' | tee host-enum.json
dpkg-query -W -f='${Package} ${Version}\n' > software-inventory.txt
grep -E '^(telnet|john|hydra|nmap) ' software-inventory.txt || echo "No unapproved tools found in the software inventory"

echo '=== block 3 ==='
cd /root/itam
cat > retention-schedule.csv <<'EOF'
record_type,retention_period,basis,legal_hold
customer_invoices,5 years after the financial year,tax and accounting law,no
payroll_records,7 years,employment records policy,no
cctv_footage,30 days,privacy policy (PDPA),no
incident_2026_017_evidence,until the case is closed,legal counsel instruction,yes
EOF
cat > disposal-request-SG-DISK-0099.txt <<'EOF'
asset_tag=SG-DISK-0099
contents=customer_invoices (working copies; system of record is the ERP)
retention_met=yes
legal_hold=no
approved_by=Finance data owner
EOF
grep -q '^legal_hold=no' disposal-request-SG-DISK-0099.txt && grep -q '^retention_met=yes' disposal-request-SG-DISK-0099.txt \
  && echo "RETENTION CHECK PASSED - disposal of SG-DISK-0099 approved"

echo '=== block 4 ==='
cd /root/itam
truncate -s 64M retired-disk.img
LOOP=$(losetup -f --show retired-disk.img); echo "$LOOP" > loopdev; echo "SG-DISK-0099 attached as $LOOP"
mkfs.ext4 -q "$LOOP"
mkdir -p /mnt/retired && mount "$LOOP" /mnt/retired
for i in $(seq 1 200); do echo "CONFIDENTIAL,cust$i@example.com,invoice-2026-$i,SGD $((i*37))"; done > /mnt/retired/invoices.csv
sync; rm /mnt/retired/invoices.csv; sync; umount /mnt/retired
echo "Records still readable on the raw device after delete:"; grep -a -c 'CONFIDENTIAL' "$LOOP"

echo '=== block 5 ==='
LOOP=$(cat /root/itam/loopdev)
shred -v -n 1 -z "$LOOP"
grep -a -c 'CONFIDENTIAL' "$LOOP" || echo "-> 0 matches: data no longer recoverable by software"

echo '=== block 6 ==='
LOOP=$(cat /root/itam/loopdev)
SIZE=$(blockdev --getsize64 "$LOOP")
dd if=/dev/zero of="$LOOP" bs=1M count=$((SIZE/1048576)) oflag=direct status=progress
blkdiscard -f "$LOOP" && echo "blkdiscard completed" || echo "discard not supported on this device - overwrite already done"

echo '=== block 7 ==='
LOOP=$(cat /root/itam/loopdev)
SIZE=$(blockdev --getsize64 "$LOOP")
cmp -n "$SIZE" "$LOOP" /dev/zero && echo "VERIFIED: all $SIZE bytes of $LOOP read back as zero"
sha256sum "$LOOP" | tee /root/itam/verify-hash.txt
head -c "$SIZE" /dev/zero | sha256sum

echo '=== block 8 ==='
cd /root/itam
truncate -s 32M laptop-ssd.img
head -c 64 /dev/urandom > laptop-ssd.key && chmod 600 laptop-ssd.key
cryptsetup luksFormat --batch-mode --type luks2 laptop-ssd.img laptop-ssd.key
cryptsetup luksDump laptop-ssd.img | grep -A2 '^Keyslots:'
cryptsetup luksErase --batch-mode laptop-ssd.img
cryptsetup luksDump laptop-ssd.img | grep -A2 '^Keyslots:'
cryptsetup open --test-passphrase --key-file laptop-ssd.key laptop-ssd.img || echo "PURGED: no key slot can unlock this volume"

echo '=== block 9 ==='
cd /root/itam
LOOP=$(cat loopdev)
cat > certificate-SG-DISK-0099.txt <<EOF
CERTIFICATE OF MEDIA SANITISATION (fields per NIST SP 800-88 Rev. 1, Appendix G)
-------------------------------------------------------------------------------
Asset tag / serial     : SG-DISK-0099 / SN-LAB0099
Media type / model     : Virtual block device, 64 MiB ($LOOP)
Data owner             : Finance (CFO)
Data classification    : Confidential
Retention / legal hold : Retention met, no legal hold (disposal-request-SG-DISK-0099.txt)
Sanitisation level     : Clear (NIST SP 800-88)
Technique and tools    : shred -n 1 -z, dd zero fill, blkdiscard ($(shred --version | head -1))
Verification method    : Full read-back, cmp against /dev/zero, 0 residual matches
Verification SHA-256   : $(awk '{print $1}' verify-hash.txt)
Post-sanitisation      : Reuse internally, or send to an e-waste vendor for destruction
Performed by           : $(whoami)@$(hostname)
Date and time (UTC)    : $(date -u '+%Y-%m-%d %H:%M')
Validated by           : ______________________ (independent witness)
EOF
cat certificate-SG-DISK-0099.txt
sed -i 's/^\(SG-DISK-0099,.*\),Retired$/\1,Sanitised - certificate on file/' inventory.csv
grep '^SG-DISK-0099' inventory.csv
losetup -d "$LOOP" && echo "$LOOP detached"

echo '=== block 10 ==='
cd /root/itam
grep -a -c CONFIDENTIAL retired-disk.img; echo "residual-matches-exit=$?"
grep -E 'Sanitisation level|Verification SHA-256' certificate-SG-DISK-0099.txt
grep '^SG-DISK-0099' inventory.csv | cut -d, -f9
