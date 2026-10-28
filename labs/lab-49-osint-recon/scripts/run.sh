#!/usr/bin/env bash
# Lab 49 — Passive Reconnaissance / OSINT
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y whois dnsutils python3-pip jq unzip curl
pip3 install --break-system-packages git+https://github.com/laramies/theHarvester.git
SF=$(curl -s https://api.github.com/repos/projectdiscovery/subfinder/releases/latest | grep -oP '"tag_name": "v\K[^"]+')
curl -sL "https://github.com/projectdiscovery/subfinder/releases/download/v${SF}/subfinder_${SF}_linux_amd64.zip" -o /tmp/sf.zip
unzip -o /tmp/sf.zip subfinder -d /usr/local/bin/ && chmod +x /usr/local/bin/subfinder

echo '=== block 2 ==='
TARGET=example.com
echo "Target: $TARGET"

echo '=== block 3 ==='
whois "$TARGET" | grep -Ei "registrar|registrant|expir|name server" | head

echo '=== block 4 ==='
dig +short MX "$TARGET"
dig +short TXT "$TARGET"
dig +short TXT "_dmarc.$TARGET"
dig +short NS "$TARGET"

echo '=== block 5 ==='
subfinder -silent -d "$TARGET" | tee subs.txt
wc -l subs.txt

echo '=== block 6 ==='
theHarvester -d "$TARGET" -b crtsh,duckduckgo,bing 2>/dev/null | tail -30

echo '=== block 7 ==='
curl -s "https://crt.sh/?q=%25.$TARGET&output=json" | jq -r '.[].name_value' | sort -u | head -20

echo '=== block 8 ==='
cat > "recon-$TARGET.md" <<EOF
# Passive Recon Report — $TARGET
- Subdomains found: $(wc -l < subs.txt)
- DMARC: $(dig +short TXT _dmarc.$TARGET | head -1)
- SPF: $(dig +short TXT $TARGET | grep -i spf | head -1)
- Packets sent to target: 0 (all data from public sources)
EOF
cat "recon-$TARGET.md"

echo '=== block 9 ==='
cat "recon-example.com.md"
wc -l subs.txt
