#!/usr/bin/env bash
# Lab 06 — Symmetric vs. Asymmetric Encryption and Key Exchange
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y gnupg openssl
mkdir -p /root/lab06 && cd /root/lab06
echo "top secret message: merger announced on Monday" > msg.txt

echo '=== block 2 ==='
cd /root/lab06
openssl enc -aes-256-cbc -pbkdf2 -iter 200000 -salt -in msg.txt -out msg.aes -pass pass:Lab1234!
od -c msg.aes | head -3
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -in msg.aes -pass pass:Lab1234!

echo '=== block 3 ==='
cd /root/lab06
printf 'SECRET-PAYROLL!!%.0s' 1 2 3 4 > blocks.txt
KEY=$(openssl rand -hex 16); IV=$(openssl rand -hex 16)
openssl enc -aes-128-ecb -nosalt -K "$KEY" -in blocks.txt -out blocks.ecb
openssl enc -aes-128-cbc -nosalt -K "$KEY" -iv "$IV" -in blocks.txt -out blocks.cbc
echo "== ECB: repeated blocks =="; od -An -tx1 -w16 -v blocks.ecb | sort | uniq -c
echo "== CBC: all unique =="; od -An -tx1 -w16 -v blocks.cbc | sort | uniq -c

echo '=== block 4 ==='
cd /root/lab06
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out rsa3072.key 2>/dev/null
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out ec256.key
echo "RSA-3072 public key bytes: $(openssl pkey -in rsa3072.key -pubout -outform DER | wc -c)"
echo "ECC P-256 public key bytes: $(openssl pkey -in ec256.key -pubout -outform DER | wc -c)"
openssl speed -seconds 1 rsa3072 ecdsap256 2>/dev/null | tail -4
openssl speed -seconds 1 -bytes 16384 -evp aes-256-gcm 2>/dev/null | tail -2

echo '=== block 5 ==='
cd /root/lab06
for p in alice bob; do openssl genpkey -algorithm X25519 -out "$p-x.key"; openssl pkey -in "$p-x.key" -pubout -out "$p-x.pub"; done
openssl pkeyutl -derive -inkey alice-x.key -peerkey bob-x.pub -out alice-shared.bin
openssl pkeyutl -derive -inkey bob-x.key -peerkey alice-x.pub -out bob-shared.bin
sha256sum alice-shared.bin bob-shared.bin
echo "shared secret length: $(stat -c %s alice-shared.bin) bytes = $(( $(stat -c %s alice-shared.bin) * 8 )) bits"

echo '=== block 6 ==='
cd /root/lab06
gpg --list-keys alice@lab.local >/dev/null 2>&1 || gpg --batch --pinentry-mode loopback --passphrase '' --quick-generate-key 'Alice <alice@lab.local>' rsa3072 sign 1y
FPR=$(gpg --list-keys --with-colons alice@lab.local | awk -F: '/^fpr/{print $10; exit}')
gpg --list-keys alice@lab.local | grep -q '\[E\]' || gpg --batch --pinentry-mode loopback --passphrase '' --quick-add-key "$FPR" rsa3072 encr 1y
gpg --list-keys alice@lab.local
gpg --armor --export alice@lab.local > alice.pub
head -2 alice.pub

echo '=== block 7 ==='
cd /root/lab06
gpg --batch --yes --trust-model always -r alice@lab.local -e -o msg.gpg msg.txt
od -c msg.gpg | head -2
gpg --batch --pinentry-mode loopback --passphrase '' -d msg.gpg 2>/dev/null

echo '=== block 8 ==='
cd /root/lab06
gpg --batch --pinentry-mode loopback --passphrase '' --list-packets msg.gpg 2>&1 | grep -E "pubkey enc packet|encrypted data packet|aead encrypted packet|session key|cipher|algo" | head -6

echo '=== block 9 ==='
cd /root/lab06
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -in msg.aes -pass pass:Lab1234! | grep -c "merger"
od -An -tx1 -w16 -v blocks.ecb | sort | uniq -c | sort -rn | head -1 | awk '{print $1}'
[ "$(sha256sum < alice-shared.bin)" = "$(sha256sum < bob-shared.bin)" ] && echo "KEY EXCHANGE OK"
gpg --batch --pinentry-mode loopback --passphrase '' -d msg.gpg 2>/dev/null | grep -c "merger"
