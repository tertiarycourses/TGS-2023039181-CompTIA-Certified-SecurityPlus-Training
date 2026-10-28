#!/usr/bin/env bash
# Lab 15 — DoS Simulation and Detection
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y hping3 nginx iptables procps
service nginx start || systemctl start nginx

echo '=== block 2 ==='
ss -s
ss -tan state syn-recv | wc -l

echo '=== block 3 ==='
timeout 10 hping3 -S -p 80 --flood 127.0.0.1 >/dev/null 2>&1 &
echo "flood running for 10s"

echo '=== block 4 ==='
for i in 1 2 3 4 5; do echo "syn-recv: $(ss -tan state syn-recv | wc -l)"; sleep 1; done

echo '=== block 5 ==='
sysctl -w net.ipv4.tcp_syncookies=1

echo '=== block 6 ==='
iptables -I INPUT -p tcp --syn --dport 80 -m limit --limit 25/s --limit-burst 50 -j ACCEPT
iptables -A INPUT -p tcp --syn --dport 80 -j DROP
iptables -L INPUT -n --line-numbers | head

echo '=== block 7 ==='
timeout 10 hping3 -S -p 80 --flood 127.0.0.1 >/dev/null 2>&1 &
for i in 1 2 3 4 5; do echo "syn-recv: $(ss -tan state syn-recv | wc -l)"; sleep 1; done
ss -s

echo '=== block 8 ==='
sysctl net.ipv4.tcp_syncookies | grep -q ' = 1' && echo "SYN COOKIES ON"
iptables -S INPUT | grep -q 'limit 25/sec' && echo "RATE LIMIT RULE PRESENT"
echo "During the first flood SYN-RECV spiked; after mitigation it stays bounded."
