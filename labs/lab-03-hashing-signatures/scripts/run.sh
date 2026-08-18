#!/usr/bin/env bash
# Lab 3 — Hashing, Salting, and Digital Signatures
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
echo -n 'Pa$$w0rd' | sha256sum
echo -n 'Pa$$w0rd' | sha256sum

echo '=== block 2 ==='
SALT=$(openssl rand -hex 8)
echo "Salt: $SALT"
echo -n "${SALT}"'Pa$$w0rd' | sha256sum

echo '=== block 3 ==='
openssl passwd -6 -salt $(openssl rand -hex 4) 'Pa$$w0rd'

echo '=== block 4 ==='
openssl genrsa -out priv.pem 2048
openssl rsa -in priv.pem -pubout -out pub.pem
ls -l priv.pem pub.pem

echo '=== block 5 ==='
echo "Transfer 1000 USD to Bob" > order.txt
openssl dgst -sha256 -sign priv.pem -out order.sig order.txt
openssl dgst -sha256 -verify pub.pem -signature order.sig order.txt

echo '=== block 6 ==='
echo " - extra line" >> order.txt
openssl dgst -sha256 -verify pub.pem -signature order.sig order.txt

