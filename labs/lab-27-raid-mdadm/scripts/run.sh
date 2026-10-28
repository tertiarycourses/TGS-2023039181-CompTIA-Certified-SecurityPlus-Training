#!/usr/bin/env bash
# Lab 27 — Storage Resilience with Software RAID (mdadm)
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y mdadm
modprobe raid1 2>/dev/null; modprobe raid456 2>/dev/null; true
mkdir -p /root/lab27 && cd /root/lab27
for d in 1 2 3 4 5 6; do truncate -s 128M disk$d.img; done
ls -lh /root/lab27/*.img

echo '=== block 2 ==='
cd /root/lab27
for d in 1 2 3 4 5 6; do losetup -f --show disk$d.img; done | tee loops.txt
mapfile -t LO < loops.txt
echo "Mirror: ${LO[0]} ${LO[1]}  Spare: ${LO[2]}  RAID5: ${LO[3]} ${LO[4]} ${LO[5]}"

echo '=== block 3 ==='
mapfile -t LO < /root/lab27/loops.txt
yes | mdadm --create /dev/md10 --level=1 --raid-devices=2 --run "${LO[0]}" "${LO[1]}"
cat /proc/mdstat
mdadm --wait /dev/md10 2>/dev/null; true
mdadm --detail /dev/md10 | grep -E 'Raid Level|Array Size|State :|Active Devices'

echo '=== block 4 ==='
mkfs.ext4 -q /dev/md10
mkdir -p /mnt/raid && mount /dev/md10 /mnt/raid
head -c 20M /dev/urandom > /mnt/raid/database.bin
echo "IMPORTANT synthetic ledger - balance 1,000,000" > /mnt/raid/ledger.txt
sha256sum /mnt/raid/database.bin /mnt/raid/ledger.txt | tee /root/lab27/before.sha256

echo '=== block 5 ==='
mapfile -t LO < /root/lab27/loops.txt
mdadm /dev/md10 --fail "${LO[0]}"
mdadm /dev/md10 --remove "${LO[0]}"
mdadm --detail /dev/md10 | grep -E 'State :|Active Devices|Failed Devices'
cat /proc/mdstat
sync && echo 3 > /proc/sys/vm/drop_caches
sha256sum -c /root/lab27/before.sha256

echo '=== block 6 ==='
mapfile -t LO < /root/lab27/loops.txt
mdadm /dev/md10 --add "${LO[2]}"
cat /proc/mdstat
mdadm --wait /dev/md10 2>/dev/null; true
mdadm --detail /dev/md10 | grep -E 'State :|Active Devices|Working Devices'

echo '=== block 7 ==='
mapfile -t LO < /root/lab27/loops.txt
yes | mdadm --create /dev/md11 --level=5 --raid-devices=3 --run "${LO[3]}" "${LO[4]}" "${LO[5]}"
mdadm --wait /dev/md11 2>/dev/null; true
for md in md10 md11; do
  echo "$md: $(mdadm --detail /dev/$md | grep -E 'Raid Level|Array Size' | tr -s ' ' | tr '\n' ' ')"
done
lsblk -o NAME,SIZE,TYPE /dev/md10 /dev/md11

echo '=== block 8 ==='
echo "CORRUPTED BY RANSOMWARE" > /mnt/raid/ledger.txt && sync
sha256sum -c /root/lab27/before.sha256
mdadm --detail /dev/md10 | grep 'State :'
mdadm --detail --scan | tee /root/lab27/mdadm.conf.sample

echo '=== block 9 ==='
mdadm --detail /dev/md10 | grep -E 'State :|Active Devices'
grep database.bin /root/lab27/before.sha256 | sha256sum -c
mdadm --detail /dev/md11 | grep -E 'Raid Level'
