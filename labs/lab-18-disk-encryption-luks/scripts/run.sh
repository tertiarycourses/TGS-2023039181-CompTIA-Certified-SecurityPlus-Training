#!/usr/bin/env bash
# Lab 18 — Data at Rest: LUKS Full-Disk Encryption
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y cryptsetup

echo '=== block 2 ==='
dd if=/dev/zero of=vault.img bs=1M count=50
losetup -fP --show vault.img
LOOP=$(losetup -j vault.img | awk -F: '{print $1; exit}')
echo "Loop device: $LOOP"

echo '=== block 3 ==='
echo -n "Lab1234!" | cryptsetup luksFormat --type luks2 \
    --cipher aes-xts-plain64 --key-size 512 --hash sha256 \
    --pbkdf argon2id "$LOOP" -
cryptsetup luksDump "$LOOP" | head -25

echo '=== block 4 ==='
echo -n "Lab1234!" | cryptsetup luksOpen "$LOOP" vault -
mkfs.ext4 -q /dev/mapper/vault
mkdir -p /mnt/vault
mount /dev/mapper/vault /mnt/vault
echo "secret data" > /mnt/vault/file.txt
ls -l /mnt/vault

echo '=== block 5 ==='
umount /mnt/vault
cryptsetup luksClose vault
strings vault.img | grep -i "secret data" || echo "not found in plaintext (good)"

echo '=== block 6 ==='
echo -n "Lab1234!" | cryptsetup luksOpen "$LOOP" vault -
echo -e "Lab1234!\nNewPass!9" | cryptsetup luksChangeKey "$LOOP"
cryptsetup luksClose vault

echo '=== block 7 ==='
dd if=/dev/urandom of=/root/luks.key bs=1 count=64
chmod 400 /root/luks.key
echo -n "NewPass!9" | cryptsetup luksAddKey "$LOOP" /root/luks.key -
cryptsetup luksDump "$LOOP" | grep -E "Slot|Key Slot"

