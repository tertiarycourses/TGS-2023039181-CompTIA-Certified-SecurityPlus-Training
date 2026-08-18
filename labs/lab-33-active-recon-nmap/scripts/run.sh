#!/usr/bin/env bash
# Lab 33 — Active Reconnaissance with Nmap
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y nmap nginx openssh-server
systemctl start nginx
systemctl start ssh

echo '=== block 2 ==='
nmap -sn 127.0.0.0/30

echo '=== block 3 ==='
nmap -sS -p 1-1024 127.0.0.1

echo '=== block 4 ==='
nmap -sV -p 22,80 127.0.0.1

echo '=== block 5 ==='
nmap -O 127.0.0.1

echo '=== block 6 ==='
nmap --script=banner,http-headers,ssh2-enum-algos -p 22,80 127.0.0.1

echo '=== block 7 ==='
nmap --script=vuln -p 80 127.0.0.1

echo '=== block 8 ==='
time nmap -T4 -p- 127.0.0.1 | tail -10

echo '=== block 9 ==='
nmap -sV -oA scan-127 127.0.0.1
ls scan-127.*

