#!/usr/bin/env bash
# Lab 39 — Storage Resilience with Software RAID (mdadm)
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt install -y mdadm && for d in 1 2; do dd if=/dev/zero of=/disk$d.img bs=1M count=200; done

echo '=== block 2 ==='
lo1=$(losetup -f --show /disk1.img); lo2=$(losetup -f --show /disk2.img)

echo '=== block 3 ==='
mdadm --create /dev/md0 --level=1 --raid-devices=2 $lo1 $lo2

echo '=== block 4 ==='
mkfs.ext4 /dev/md0 && mkdir -p /mnt/r && mount /dev/md0 /mnt/r && echo IMPORTANT > /mnt/r/data.txt

echo '=== block 5 ==='
mdadm /dev/md0 --fail $lo1 --remove $lo1

echo '=== block 6 ==='
cat /mnt/r/data.txt && mdadm --detail /dev/md0 | grep State

