#!/usr/bin/env bash
# Lab 50 — Active Reconnaissance with Nmap
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y nmap nginx openssh-server
service nginx start || systemctl start nginx
service ssh start || systemctl start ssh

echo '=== block 2 ==='
nmap -sn 127.0.0.0/30

echo '=== block 3 ==='
nmap -sS -p 1-1024 127.0.0.1

echo '=== block 4 ==='
nmap -sV -p 22,80 127.0.0.1

echo '=== block 5 ==='
nmap -O 127.0.0.1 2>&1 | grep -iE "os|device" | head

echo '=== block 6 ==='
nmap --script=banner,http-headers,ssh2-enum-algos -p 22,80 127.0.0.1

echo '=== block 7 ==='
time nmap -T4 -p- 127.0.0.1 | tail -10

echo '=== block 8 ==='
nmap -sV -oA scan-127 127.0.0.1
ls scan-127.*

echo '=== block 9 ==='
nmap -sV -p 22,80 127.0.0.1 | grep -iE "open|nginx|ssh"
ls scan-127.xml
