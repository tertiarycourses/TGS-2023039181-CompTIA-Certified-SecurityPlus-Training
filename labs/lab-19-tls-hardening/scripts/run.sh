#!/usr/bin/env bash
# Lab 19 — TLS Hardening and Cipher Audit
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y nginx openssl git
openssl req -x509 -newkey rsa:2048 -nodes -days 30 \
    -keyout /etc/ssl/private/lab.key -out /etc/ssl/certs/lab.crt \
    -subj "/CN=lab.local"

cat > /etc/nginx/sites-available/default <<'EOF'
server {
  listen 443 ssl default_server;
  ssl_certificate /etc/ssl/certs/lab.crt;
  ssl_certificate_key /etc/ssl/private/lab.key;
  root /var/www/html;
}
EOF
systemctl restart nginx

echo '=== block 2 ==='
git clone --depth 1 https://github.com/drwetter/testssl.sh.git
cd testssl.sh
./testssl.sh -p -P -s --color 0 https://localhost 2>&1 | tee ../baseline.txt
grep -E "^ (TLS|Cipher|FS)" ../baseline.txt | head -20

echo '=== block 3 ==='
cat > /etc/nginx/snippets/tls-hardening.conf <<'EOF'
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers on;
ssl_ciphers 'TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
ssl_ecdh_curve secp384r1;
ssl_session_tickets off;
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "DENY" always;
EOF

sed -i '/listen 443/a include /etc/nginx/snippets/tls-hardening.conf;' \
    /etc/nginx/sites-available/default
nginx -t && systemctl reload nginx

echo '=== block 4 ==='
cd testssl.sh
./testssl.sh -p -P -s --color 0 https://localhost 2>&1 | tee ../hardened.txt
diff <(grep "^ Cipher" ../baseline.txt) <(grep "^ Cipher" ../hardened.txt) | head

echo '=== block 5 ==='
echo | openssl s_client -connect localhost:443 -tls1_1 2>&1 | grep -i "alert\|protocol" | head
echo | openssl s_client -connect localhost:443 -tls1_3 2>&1 | grep -i "protocol\|cipher" | head

