#!/usr/bin/env bash
# Lab 25 — Data in Transit: TLS Hardening and Cipher Audit
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
systemctl stop apache2 2>/dev/null || true
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx openssl git curl bsdextrautils dnsutils
[ -d /opt/testssl ] || git clone --depth 1 --branch 3.2 https://github.com/testssl/testssl.sh.git /opt/testssl
/opt/testssl/testssl.sh --version 2>/dev/null | grep -m1 -i version || true

echo '=== block 2 ==='
openssl req -x509 -newkey rsa:2048 -nodes -days 30 \
  -keyout /etc/ssl/private/lab25.key -out /etc/ssl/certs/lab25.crt \
  -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 443 ssl default_server;
    server_name localhost;
    ssl_certificate     /etc/ssl/certs/lab25.crt;
    ssl_certificate_key /etc/ssl/private/lab25.key;
    # WEAK BASELINE - legacy protocols and every cipher
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers "ALL:@SECLEVEL=0";
    root /var/www/html;
}
EOF
echo "Lab 25 TLS test page" > /var/www/html/index.html
nginx -t && systemctl restart nginx
curl -skI https://127.0.0.1/ | head -1

echo '=== block 3 ==='
echo | openssl s_client -connect 127.0.0.1:443 -tls1_1 -cipher 'DEFAULT:@SECLEVEL=0' 2>/dev/null | grep -E '^New,|Protocol  :'
echo | openssl s_client -connect 127.0.0.1:443 -tls1_2 -cipher 'AES128-SHA:@SECLEVEL=0' 2>/dev/null | grep -E '^New,'

echo '=== block 4 ==='
/opt/testssl/testssl.sh --quiet --color 0 --warnings batch -p -f -h https://127.0.0.1 > /root/lab25-baseline.txt 2>&1
grep -E '^ (SSLv2|SSLv3|TLS 1 |TLS 1.1|TLS 1.2|TLS 1.3)' /root/lab25-baseline.txt
grep -iE 'Strict Transport Security' /root/lab25-baseline.txt

echo '=== block 5 ==='
cat > /etc/nginx/snippets/tls-hardening.conf <<'EOF'
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
ssl_prefer_server_ciphers off;
ssl_session_tickets off;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Content-Type-Options "nosniff" always;
EOF
sed -i -e '/WEAK BASELINE/d' -e '/ssl_protocols/d' -e '/ssl_ciphers/d' /etc/nginx/sites-available/default
sed -i '/ssl_certificate_key/a\    include /etc/nginx/snippets/tls-hardening.conf;' /etc/nginx/sites-available/default
cat /etc/nginx/sites-available/default

echo '=== block 6 ==='
nginx -t && systemctl reload nginx
echo | openssl s_client -connect 127.0.0.1:443 -tls1_1 -cipher 'DEFAULT:@SECLEVEL=0' 2>&1 | grep -E '^New,|alert|no protocols' | head -2
echo | openssl s_client -connect 127.0.0.1:443 -tls1_2 -cipher 'AES128-SHA:@SECLEVEL=0' 2>&1 | grep -E '^New,|alert' | head -1
echo | openssl s_client -connect 127.0.0.1:443 -tls1_3 2>/dev/null | grep -E '^New,'
curl -skI https://127.0.0.1/ | grep -i strict-transport

echo '=== block 7 ==='
/opt/testssl/testssl.sh --quiet --color 0 --warnings batch -p -f -h https://127.0.0.1 > /root/lab25-hardened.txt 2>&1
for f in baseline hardened; do
  echo "== $f"; grep -E '^ (TLS 1 |TLS 1.1|TLS 1.3)' /root/lab25-$f.txt; grep -iE 'Strict Transport Security' /root/lab25-$f.txt
done

echo '=== block 8 ==='
echo | openssl s_client -connect 127.0.0.1:443 -tls1_1 -cipher 'DEFAULT:@SECLEVEL=0' 2>&1 | grep -c 'Cipher is (NONE)'
echo | openssl s_client -connect 127.0.0.1:443 -tls1_3 2>/dev/null | grep -o 'TLSv1.3, Cipher is [A-Z0-9_]*'
curl -skI https://127.0.0.1/ | grep -ci strict-transport-security
