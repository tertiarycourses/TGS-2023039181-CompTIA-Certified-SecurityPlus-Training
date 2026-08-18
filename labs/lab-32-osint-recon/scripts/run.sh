#!/usr/bin/env bash
# Lab 32 — Passive Reconnaissance / OSINT
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y whois dnsutils python3-pip jq unzip curl
pip3 install --break-system-packages git+https://github.com/laramies/theHarvester.git
SF_VER=$(curl -s https://api.github.com/repos/projectdiscovery/subfinder/releases/latest | grep -oP '"tag_name": "v\K[^"]+')
curl -sL "https://github.com/projectdiscovery/subfinder/releases/download/v${SF_VER}/subfinder_${SF_VER}_linux_amd64.zip" -o /tmp/subfinder.zip
unzip -o /tmp/subfinder.zip subfinder -d /usr/local/bin/
chmod +x /usr/local/bin/subfinder

echo '=== block 2 ==='
TARGET=example.com

echo '=== block 3 ==='
whois $TARGET | grep -Ei "registrar|registrant|expiry|name server" | head

echo '=== block 4 ==='
dig +short ANY $TARGET
dig +short MX $TARGET
dig +short TXT $TARGET
dig +short NS $TARGET

echo '=== block 5 ==='
subfinder -silent -d $TARGET | tee subs.txt
wc -l subs.txt

echo '=== block 6 ==='
theHarvester -d $TARGET -b crtsh,duckduckgo,bing 2>/dev/null | tail -30

echo '=== block 7 ==='
curl -s "https://crt.sh/?q=%25.$TARGET&output=json" | jq -r '.[].name_value' | sort -u | head -20

echo '=== block 8 ==='
cat > recon-$TARGET.md <<EOF
# Recon Report — $TARGET
## Footprint summary
- Subdomains found: $(wc -l < subs.txt)
- DMARC: $(dig +short TXT _dmarc.$TARGET | head -1)
- SPF: $(dig +short TXT $TARGET | grep spf)
EOF
cat recon-$TARGET.md

