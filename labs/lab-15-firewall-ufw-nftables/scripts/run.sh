#!/usr/bin/env bash
# Lab 15 — Stateful Firewall with UFW and nftables
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y ufw nftables nginx netcat-openbsd
systemctl start nginx

echo '=== block 2 ==='
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH from anywhere'
ufw allow 80/tcp comment 'HTTP from anywhere'
ufw --force enable
ufw status numbered verbose

echo '=== block 3 ==='
curl -sI http://127.0.0.1 | head -1
nc -zv 127.0.0.1 23 2>&1

echo '=== block 4 ==='
nft list ruleset | head -40

echo '=== block 5 ==='
ufw --force disable
nft flush ruleset

cat > /etc/nftables.conf <<'EOF'
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    iif "lo" accept
    ct state established,related accept
    tcp dport {22, 80, 443} accept
    icmp type echo-request limit rate 5/second accept
    counter comment "dropped"
  }
  chain forward { type filter hook forward priority 0; policy drop; }
  chain output  { type filter hook output  priority 0; policy accept; }
}
EOF
systemctl enable --now nftables
nft list ruleset

echo '=== block 6 ==='
for i in $(seq 1 20); do curl -s http://127.0.0.1 >/dev/null; done
nft list chain inet filter input | grep counter

