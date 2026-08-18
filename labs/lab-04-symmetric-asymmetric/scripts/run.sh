#!/usr/bin/env bash
# Lab 4 — Symmetric vs. Asymmetric Encryption
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y gnupg

echo '=== block 2 ==='
echo "top secret message" > msg.txt
openssl enc -aes-256-cbc -pbkdf2 -salt -in msg.txt -out msg.aes -pass pass:Lab1234!
xxd msg.aes | head
openssl enc -d -aes-256-cbc -pbkdf2 -in msg.aes -pass pass:Lab1234!

echo '=== block 3 ==='
gpg --batch --pinentry-mode loopback --passphrase '' \
    --quick-generate-key 'Alice <alice@lab.local>' rsa2048 default 1y
gpg --list-keys
gpg --armor --export alice@lab.local > alice.pub

echo '=== block 4 ==='
gpg --yes --trust-model always -r alice@lab.local -e -o msg.gpg msg.txt
gpg --pinentry-mode loopback --passphrase '' -d msg.gpg

echo '=== block 5 ==='
gpg --list-packets msg.gpg | head -20

