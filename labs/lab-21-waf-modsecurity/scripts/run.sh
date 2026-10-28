#!/usr/bin/env bash
# Lab 21 — Web Application Firewall with ModSecurity and the OWASP CRS
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
systemctl stop nginx 2>/dev/null || true
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 libapache2-mod-security2 modsecurity-crs curl
a2enmod security2 >/dev/null
systemctl restart apache2
apachectl -M 2>/dev/null | grep security2

echo '=== block 2 ==='
cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
grep -n '^SecRuleEngine' /etc/modsecurity/modsecurity.conf
grep -q 'modsecurity-crs' /etc/apache2/mods-enabled/security2.conf \
  && echo "CRS already included by security2.conf" \
  || echo 'IncludeOptional /usr/share/modsecurity-crs/*.load' > /etc/modsecurity/zz-load-crs.conf
apachectl configtest && systemctl restart apache2
ls /usr/share/modsecurity-crs/rules/*.conf | wc -l

echo '=== block 3 ==='
curl -s -o /dev/null -w "DetectionOnly SQLi -> HTTP %{http_code}\n" -G --data-urlencode "id=1' OR '1'='1" http://127.0.0.1/
sleep 1
grep 'ModSecurity: Warning' /var/log/apache2/error.log | grep -o 'id "[0-9]*"' | sort | uniq -c

echo '=== block 4 ==='
sed -i 's/^SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf
grep '^SecRuleEngine' /etc/modsecurity/modsecurity.conf
apachectl configtest && systemctl restart apache2

echo '=== block 5 ==='
for p in "id=1' OR '1'='1" "q=<script>alert(1)</script>" "file=../../../../etc/passwd" "cmd=;cat /etc/passwd"; do
  printf '%-32s -> ' "$p"
  curl -s -o /dev/null -w "%{http_code}\n" -G --data-urlencode "$p" http://127.0.0.1/
done
curl -s -o /dev/null -w "benign search                    -> %{http_code}\n" "http://127.0.0.1/?q=security+plus"

echo '=== block 6 ==='
grep -c 'Access denied with code 403' /var/log/apache2/error.log
grep 'ModSecurity' /var/log/apache2/error.log | grep -o 'id "[0-9]*"' | sort | uniq -c | sort -rn | head -12
grep 'Access denied' /var/log/apache2/error.log | tail -1 | grep -o 'msg "[^"]*"'

echo '=== block 7 ==='
curl -s -o /dev/null -w "editor body, before tuning -> %{http_code}\n" -G --data-urlencode "body=<script>alert(1)</script>" http://127.0.0.1/admin/edit
cat > /etc/modsecurity/zz-lab21-exclusions.conf <<'EOF'
# Lab 21: the CMS editor accepts HTML in ARGS:body on /admin/edit only
SecRule REQUEST_URI "@beginsWith /admin/edit" \
    "id:1000,phase:1,pass,nolog,ctl:ruleRemoveTargetByTag=attack-xss;ARGS:body"
EOF
apachectl configtest && systemctl reload apache2
sleep 1
curl -s -o /dev/null -w "editor body, after tuning  -> %{http_code}\n" -G --data-urlencode "body=<script>alert(1)</script>" http://127.0.0.1/admin/edit
curl -s -o /dev/null -w "other field, same path     -> %{http_code}\n" -G --data-urlencode "q=<script>alert(1)</script>" http://127.0.0.1/admin/edit
curl -s -o /dev/null -w "same field, other path     -> %{http_code}\n" -G --data-urlencode "body=<script>alert(1)</script>" http://127.0.0.1/

echo '=== block 8 ==='
curl -s -o /dev/null -w "%{http_code}\n" -G --data-urlencode "id=1' UNION SELECT username,password FROM users--" http://127.0.0.1/
curl -s -o /dev/null -w "%{http_code}\n" "http://127.0.0.1/"
grep '^SecRuleEngine' /etc/modsecurity/modsecurity.conf
