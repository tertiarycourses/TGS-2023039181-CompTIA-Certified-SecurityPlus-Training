#!/usr/bin/env bash
# Lab 05 — Hashing, Salting, and Digital Signatures
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y openssl coreutils
openssl version
mkdir -p /root/lab05 && cd /root/lab05

echo '=== block 2 ==='
cd /root/lab05
echo -n 'Pay Bob 100 SGD' | sha256sum
echo -n 'Pay Bob 900 SGD' | sha256sum
echo -n 'Pay Bob 100 SGD' | md5sum
echo -n 'Pay Bob 100 SGD' | sha256sum | cut -d' ' -f1 | tr -d '\n' | wc -c

echo '=== block 3 ==='
cd /root/lab05
echo "release notes v1.0" > notes.txt
echo "installer payload v1.0" > installer.bin
sha256sum notes.txt installer.bin > SHA256SUMS
sha256sum -c SHA256SUMS
echo "malicious bytes" >> installer.bin
sha256sum -c SHA256SUMS || echo "INTEGRITY FAILED - do not install"

echo '=== block 4 ==='
cd /root/lab05
printf 'carol:%s\ndave:%s\n' "$(echo -n 'Summer2026!' | sha256sum | cut -d' ' -f1)" "$(echo -n 'Summer2026!' | sha256sum | cut -d' ' -f1)" > unsalted.txt
cat unsalted.txt
cut -d: -f2 unsalted.txt | sort | uniq -d | sed 's/^/DUPLICATE HASH: /'

echo '=== block 5 ==='
openssl passwd -6 -salt "$(openssl rand -hex 8)" 'Summer2026!'
openssl passwd -6 -salt "$(openssl rand -hex 8)" 'Summer2026!'
for u in carol dave; do id "$u" >/dev/null 2>&1 || useradd -m "$u"; echo "$u:Summer2026!" | chpasswd; done
getent shadow carol dave | cut -d: -f1,2

echo '=== block 6 ==='
time openssl kdf -keylen 32 -kdfopt digest:SHA256 -kdfopt 'pass:Summer2026!' -kdfopt salt:Lab05UniqueSalt01 -kdfopt iter:1000 PBKDF2
time openssl kdf -keylen 32 -kdfopt digest:SHA256 -kdfopt 'pass:Summer2026!' -kdfopt salt:Lab05UniqueSalt01 -kdfopt iter:600000 PBKDF2

echo '=== block 7 ==='
cd /root/lab05
echo "Invoice 4471: amount 2500 SGD to account 123-456" > invoice.txt
openssl dgst -sha256 -hmac 'SharedLabKey-2026' invoice.txt | tee invoice.hmac
sed -i 's/123-456/999-999/' invoice.txt
openssl dgst -sha256 -hmac 'SharedLabKey-2026' invoice.txt

echo '=== block 8 ==='
cd /root/lab05
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out signer.key 2>/dev/null
chmod 600 signer.key
openssl pkey -in signer.key -pubout -out signer.pub
echo "PO-7781: 20 laptops, total 36000 SGD, approved by Alice" > order.txt
openssl dgst -sha256 -sign signer.key -out order.sig order.txt
openssl dgst -sha256 -verify signer.pub -signature order.sig order.txt

echo '=== block 9 ==='
cd /root/lab05
sed -i 's/20 laptops/200 laptops/' order.txt
openssl dgst -sha256 -verify signer.pub -signature order.sig order.txt || echo "SIGNATURE INVALID - document altered after signing"

echo '=== block 10 ==='
cd /root/lab05
sha256sum -c SHA256SUMS 2>/dev/null | grep -c FAILED
getent shadow carol dave | cut -d: -f2 | sort -u | wc -l
echo "PO-7781: 20 laptops, total 36000 SGD, approved by Alice" > order.txt
openssl dgst -sha256 -verify signer.pub -signature order.sig order.txt
