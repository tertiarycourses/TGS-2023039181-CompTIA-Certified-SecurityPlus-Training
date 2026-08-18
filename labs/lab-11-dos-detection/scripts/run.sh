#!/usr/bin/env bash
# Lab 11 — DoS Simulation and Detection
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y hping3 nginx
systemctl start nginx
ss -tlnp | grep :80

echo '=== block 2 ==='
ss -s

echo '=== block 3 ==='
timeout 10 hping3 -S -p 80 --flood --rand-source 127.0.0.1 &
sleep 3
ss -s | head

echo '=== block 4 ==='
iptables -A INPUT -p tcp --syn --dport 80 -j LOG --log-prefix "SYN: " --log-level 4
iptables -L INPUT -v -n | head

echo '=== block 5 ==='
sysctl -w net.ipv4.tcp_syncookies=1
iptables -I INPUT -p tcp --syn --dport 80 -m limit --limit 25/s --limit-burst 50 -j ACCEPT
iptables -A INPUT -p tcp --syn --dport 80 -j DROP

echo '=== block 6 ==='
timeout 10 hping3 -S -p 80 --flood --rand-source 127.0.0.1
ss -s

