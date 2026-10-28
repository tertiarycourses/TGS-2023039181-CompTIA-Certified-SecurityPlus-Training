#!/usr/bin/env bash
# Lab 36 — Network IDS with Suricata
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y suricata jq nmap curl python3
suricata --build-info | grep -E "^This is Suricata|AF_PACKET"

echo '=== block 2 ==='
suricata-update -q || echo "Ruleset download failed — the custom rules in step 4 still work offline"
ls -lh /var/lib/suricata/rules/ 2>/dev/null
grep -c "^alert" /var/lib/suricata/rules/suricata.rules 2>/dev/null || true

echo '=== block 3 ==='
mkdir -p /srv/lab36 && echo "Lab 36 web app" > /srv/lab36/index.html
cd /srv/lab36 && nohup python3 -m http.server 8080 --bind 127.0.0.1 >/tmp/web36.log 2>&1 &
sleep 1; curl -s http://127.0.0.1:8080/

echo '=== block 4 ==='
mkdir -p /etc/suricata/rules
cat > /etc/suricata/rules/lab36.rules <<'EOF'
alert http any any -> any any (msg:"LAB36 access to restricted admin path"; flow:established,to_server; http.uri; content:"/secret-admin"; nocase; classtype:policy-violation; sid:1000001; rev:1;)
alert http any any -> any any (msg:"LAB36 SQL injection pattern in URI"; flow:established,to_server; http.uri; content:"union select"; nocase; classtype:web-application-attack; sid:1000002; rev:1;)
alert tcp any any -> any any (msg:"LAB36 possible TCP SYN port scan"; flags:S,12; threshold:type both, track by_src, count 20, seconds 10; classtype:attempted-recon; sid:1000003; rev:1;)
EOF
suricata -T -c /etc/suricata/suricata.yaml -s /etc/suricata/rules/lab36.rules -v 2>&1 | tail -3

echo '=== block 5 ==='
rm -f /var/log/suricata/eve.json
suricata -c /etc/suricata/suricata.yaml -i lo -k none -s /etc/suricata/rules/lab36.rules -l /var/log/suricata -D
sleep 15
tail -2 /var/log/suricata/suricata.log

echo '=== block 6 ==='
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/secret-admin
curl -s -o /dev/null -w "%{http_code}\n" "http://127.0.0.1:8080/search?q=1%20UNION%20SELECT%20password%20FROM%20users"
nmap -sS -p 1-200 -T4 127.0.0.1 >/dev/null
sleep 5

echo '=== block 7 ==='
jq -c 'select(.event_type=="alert") | {time:.timestamp, sid:.alert.signature_id, sig:.alert.signature, src:.src_ip, dport:.dest_port}' /var/log/suricata/eve.json | tail -5
jq -r 'select(.event_type=="alert") | .alert.signature' /var/log/suricata/eve.json | sort | uniq -c | sort -rn

echo '=== block 8 ==='
cat >> /etc/suricata/threshold.config <<'EOF'
# Lab 36 tuning: ignore scans from a trusted vulnerability scanner address
suppress gen_id 1, sig_id 1000003, track by_src, ip 10.0.0.50
EOF
grep -n "1000003" /etc/suricata/threshold.config
grep -nE "^\s*#?\s*(copy-mode|mode): " /etc/suricata/suricata.yaml | head -5

echo '=== block 9 ==='
jq -r 'select(.event_type=="alert") | .alert.signature_id' /var/log/suricata/eve.json | sort -u | grep -E "^100000[123]$"
