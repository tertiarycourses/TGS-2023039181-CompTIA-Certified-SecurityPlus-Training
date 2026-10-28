#!/usr/bin/env bash
# Lab 20 — Stateful Firewall with UFW and nftables
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y ufw nftables netcat-openbsd curl python3 iproute2 iputils-ping
mkdir -p /root/lab20

echo '=== block 2 ==='
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH admin - always first'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw --force enable
ufw status verbose

echo '=== block 3 ==='
ufw status numbered
iptables -S ufw-user-input
iptables -S INPUT | head -3

echo '=== block 4 ==='
ufw --force disable
ip netns add srv
ip link add veth-host type veth peer name veth-srv
ip link set veth-srv netns srv
ip addr add 10.20.0.1/24 dev veth-host && ip link set veth-host up
ip netns exec srv ip addr add 10.20.0.2/24 dev veth-srv
ip netns exec srv ip link set veth-srv up
ip netns exec srv ip link set lo up
ip netns exec srv python3 -c 'import http.server as h, socketserver as s; s.TCPServer(("10.20.0.2", 80), h.SimpleHTTPRequestHandler).serve_forever()' >/dev/null 2>&1 &
ip netns exec srv nc -lk 22 >/dev/null 2>&1 &
ip netns exec srv nc -lk 23 >/dev/null 2>&1 &
sleep 1
for p in 22 23 80; do nc -z -w2 10.20.0.2 $p && echo "port $p open (no firewall yet)"; done

echo '=== block 5 ==='
cat > /root/lab20/srv.nft <<'EOF'
flush ruleset
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    iif "lo" accept
    ct state established,related accept
    ct state invalid counter drop comment "invalid packets"
    ip saddr 10.20.0.1 tcp dport 22 counter accept comment "SSH from admin host only"
    tcp dport { 80, 443 } counter accept comment "published web"
    icmp type echo-request limit rate 5/second counter accept comment "rate-limited ping"
    counter drop comment "default deny"
  }
  chain forward {
    type filter hook forward priority 0; policy drop;
  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}
EOF
nft -c -f /root/lab20/srv.nft && echo "Syntax OK"

echo '=== block 6 ==='
ip netns exec srv nft -f /root/lab20/srv.nft
curl -s -o /dev/null -w "HTTP 80  -> %{http_code}\n" http://10.20.0.2/
nc -z -w2 10.20.0.2 22 && echo "SSH 22   -> allowed (admin host)"
nc -z -w2 10.20.0.2 23 || echo "Telnet 23 -> blocked (default deny)"
ping -c2 -W1 10.20.0.2 >/dev/null && echo "ICMP     -> allowed (rate limited)"

echo '=== block 7 ==='
for i in $(seq 1 20); do curl -s -o /dev/null http://10.20.0.2/; done
for i in 1 2 3; do nc -z -w1 10.20.0.2 23; done
ip netns exec srv nft list chain inet filter input

echo '=== block 8 ==='
curl -s -o /dev/null -w "SQLi payload through the L4 firewall -> HTTP %{http_code}\n" \
  "http://10.20.0.2/?id=1%27%20OR%20%271%27=%271"
ip netns exec srv nft list chain inet filter input | grep 'published web'

echo '=== block 9 ==='
curl -s -o /dev/null -w "%{http_code}\n" http://10.20.0.2/
nc -z -w2 10.20.0.2 23 && echo "FAIL: telnet reachable" || echo "PASS: telnet blocked"
ip netns exec srv nft list chain inet filter input | grep -E 'default deny'
