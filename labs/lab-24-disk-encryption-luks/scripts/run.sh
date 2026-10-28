#!/usr/bin/env bash
# Lab 24 — Data at Rest: LUKS2 Disk Encryption
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y cryptsetup
modprobe dm_crypt 2>/dev/null || true
cryptsetup --version

echo '=== block 2 ==='
mkdir -p /root/lab24 && cd /root/lab24
dd if=/dev/zero of=vault.img bs=1M count=64 status=none
LOOP=$(losetup -f --show vault.img)
echo "$LOOP" > loopdev
echo "Virtual disk attached as $LOOP"

echo '=== block 3 ==='
cd /root/lab24 && LOOP=$(cat loopdev)
printf '%s' 'Lab24-Vault-Pass-One' > pass1 && chmod 600 pass1
cryptsetup luksFormat -q --type luks2 --cipher aes-xts-plain64 --key-size 512 --hash sha256 \
  --pbkdf argon2id --pbkdf-memory 65536 "$LOOP" pass1
cryptsetup luksDump "$LOOP" | grep -E 'Version|Cipher:|Key:|PBKDF|Memory|^  [0-9]+: luks2' | head -12

echo '=== block 4 ==='
cd /root/lab24 && LOOP=$(cat loopdev)
cryptsetup open --key-file pass1 "$LOOP" vault
mkfs.ext4 -q /dev/mapper/vault
mkdir -p /mnt/vault && mount /dev/mapper/vault /mnt/vault
echo "CONFIDENTIAL: payroll export 2024 - synthetic" > /mnt/vault/payroll.txt
ls -l /mnt/vault && lsblk "$LOOP"

echo '=== block 5 ==='
cd /root/lab24
umount /mnt/vault && cryptsetup close vault
dd if=/dev/zero of=plain.img bs=1M count=16 status=none && mkfs.ext4 -q -F plain.img
mkdir -p /mnt/plain && mount -o loop plain.img /mnt/plain
echo "CONFIDENTIAL: payroll export 2024 - synthetic" > /mnt/plain/payroll.txt
sync && umount /mnt/plain
echo "Unencrypted disk image: $(grep -a -c 'payroll export' plain.img) match(es)"
echo "LUKS-encrypted image  : $(grep -a -c 'payroll export' vault.img) match(es)"

echo '=== block 6 ==='
cd /root/lab24 && LOOP=$(cat loopdev)
printf '%s' 'Lab24-Vault-Pass-Two' > pass2 && chmod 600 pass2
cryptsetup luksChangeKey "$LOOP" --key-file pass1 --pbkdf-memory 65536 pass2
cryptsetup open --test-passphrase --key-file pass1 "$LOOP" 2>/dev/null && echo "old passphrase still works" || echo "old passphrase rejected"
cryptsetup open --test-passphrase --key-file pass2 "$LOOP" && echo "new passphrase accepted"

echo '=== block 7 ==='
cd /root/lab24 && LOOP=$(cat loopdev)
dd if=/dev/urandom of=luks.key bs=64 count=1 status=none && chmod 400 luks.key
cryptsetup luksAddKey "$LOOP" --key-file pass2 --pbkdf-memory 65536 luks.key
cryptsetup luksDump "$LOOP" | grep -E '^  [0-9]+: luks2'
[ -f vault-header.bak ] || cryptsetup luksHeaderBackup "$LOOP" --header-backup-file vault-header.bak
ls -l vault-header.bak
cryptsetup open --key-file luks.key "$LOOP" vault && mount /dev/mapper/vault /mnt/vault
cat /mnt/vault/payroll.txt
umount /mnt/vault && cryptsetup close vault

echo '=== block 8 ==='
cd /root/lab24 && LOOP=$(cat loopdev)
grep -a -c 'payroll export' vault.img
cryptsetup open --test-passphrase --key-file luks.key "$LOOP" && echo "keyfile unlocks"
cryptsetup open --test-passphrase --key-file pass1 "$LOOP" 2>/dev/null || echo "old passphrase rejected"
