#!/usr/bin/env bash
# Lab 16 — Web Application Firewall (WAF) with ModSecurity
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y apache2 libapache2-mod-security2 modsecurity-crs

echo '=== block 2 ==='
cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sed -i 's/^SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf

# Apache's security2 config already does: IncludeOptional /etc/modsecurity/*.conf
# Add a file (loaded after modsecurity.conf) that pulls in the OWASP CRS.
echo 'Include /usr/share/modsecurity-crs/owasp-crs.load' > /etc/modsecurity/owasp-crs.conf

apachectl configtest && systemctl restart apache2

echo '=== block 3 ==='
apachectl -M 2>/dev/null | grep security2
grep -rh "^SecRule" /usr/share/modsecurity-crs/rules/*.conf | wc -l

echo '=== block 4 ==='
curl -s -o /dev/null -w "%{http_code}\n" "http://127.0.0.1/?id=1' OR '1'='1"
curl -s -o /dev/null -w "%{http_code}\n" "http://127.0.0.1/?q=<script>alert(1)</script>"
curl -s -o /dev/null -w "%{http_code}\n" "http://127.0.0.1/?file=../../etc/passwd"
curl -s -o /dev/null -w "%{http_code}\n" "http://127.0.0.1/?cmd=;id"

echo '=== block 5 ==='
tail -50 /var/log/modsec_audit.log
grep -E "Matched|attack" /var/log/modsec_audit.log | tail

echo '=== block 6 ==='
echo 'SecRule REQUEST_URI "@beginsWith /admin/edit" "id:1000,phase:1,pass,nolog,ctl:ruleRemoveById=941100"' \
  >> /etc/modsecurity/modsecurity.conf
systemctl reload apache2

