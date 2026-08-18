#!/usr/bin/env bash
# Lab 2 — CIA Triad and AAA on Linux
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
useradd -m alice
useradd -m bob
echo "salary: 120000" > /home/alice/secret.txt
chown alice:alice /home/alice/secret.txt
chmod 600 /home/alice/secret.txt
sudo -u bob cat /home/alice/secret.txt 2>&1 || echo "DENIED — confidentiality enforced"

echo '=== block 2 ==='
sha256sum /home/alice/secret.txt > /tmp/secret.sha256
cat /tmp/secret.sha256

echo '=== block 3 ==='
echo "tampered" >> /home/alice/secret.txt
sha256sum -c /tmp/secret.sha256 || echo "Integrity FAILED"

echo '=== block 4 ==='
systemctl status ssh --no-pager | head
systemctl restart ssh
ss -tlnp | grep :22

echo '=== block 5 ==='
passwd alice <<EOF
Lab1234!
Lab1234!
EOF
su - alice -c 'whoami'

echo '=== block 6 ==='
echo "alice ALL=(ALL) NOPASSWD: /usr/bin/cat /var/log/auth.log" >> /etc/sudoers
su - alice -c 'sudo cat /var/log/auth.log | head -3'
su - alice -c 'sudo cat /etc/shadow' 2>&1 | tail -1

echo '=== block 7 ==='
tail -20 /var/log/auth.log

