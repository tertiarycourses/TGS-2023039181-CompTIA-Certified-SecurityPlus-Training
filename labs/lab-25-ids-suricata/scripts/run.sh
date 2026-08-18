#!/usr/bin/env bash
# Lab 25 — Network IDS with Suricata
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y suricata jq
suricata-update

echo '=== block 2 ==='
ip -brief link
IFACE=$(ip route | awk '/default/ {print $5; exit}')
echo "Listening on $IFACE"

echo '=== block 3 ==='
suricata -i $IFACE -l /var/log/suricata --runmode workers -D
sleep 5
ls /var/log/suricata

echo '=== block 4 ==='
curl -s --user-agent "test" "http://testmynids.org/uid/index.html"
sleep 3
jq -c 'select(.event_type=="alert") | {sig:.alert.signature, src:.src_ip, dst:.dest_ip}' /var/log/suricata/eve.json | tail

echo '=== block 5 ==='
mkdir -p /etc/suricata/rules
cat > /etc/suricata/rules/lab.rules <<'EOF'
alert http any any -> any any (msg:"LAB SQL injection attempt"; \
    flow:to_server; content:"' OR '1'='1"; sid:9000001; rev:1;)
alert http any any -> any any (msg:"LAB curl user-agent"; \
    http.user_agent; content:"curl/"; sid:9000002; rev:1;)
EOF

# include the file
sed -i '/^rule-files:/a\  - /etc/suricata/rules/lab.rules' /etc/suricata/suricata.yaml
suricatasc -c reload-rules 2>/dev/null || (kill $(pidof suricata); suricata -i $IFACE -l /var/log/suricata -D)

echo '=== block 6 ==='
sleep 3
curl -s "http://example.com/?id=' OR '1'='1" >/dev/null
sleep 2
jq -c 'select(.alert.signature_id>=9000001) | {sig:.alert.signature, ua:.http.http_user_agent}' /var/log/suricata/eve.json | tail

