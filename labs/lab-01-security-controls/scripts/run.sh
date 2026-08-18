#!/usr/bin/env bash
# Lab 1 — Security Controls Categorization
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
iptables -A INPUT -p tcp --dport 23 -j DROP
iptables -L INPUT -n --line-numbers | head

echo '=== block 2 ==='
apt update && apt install -y auditd
auditctl -w /etc/passwd -p wa -k passwd_changes
auditctl -l

echo '=== block 3 ==='
echo "# test" >> /etc/passwd
ausearch -k passwd_changes | tail

