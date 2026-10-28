#!/usr/bin/env bash
# Lab 11 — Cross-Site Scripting (XSS)
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y php-cli curl

echo '=== block 2 ==='
cat > search.php <<'EOF'
<?php
$q = $_GET['q'] ?? '';
echo "<h1>Results for: $q</h1>";   /* VULNERABLE: raw echo */
EOF

echo '=== block 3 ==='
php -S 127.0.0.1:8080 -t . >/tmp/php.log 2>&1 &
sleep 1 && echo "server up"

echo '=== block 4 ==='
curl -s 'http://127.0.0.1:8080/search.php?q=<b>INJECTED</b>'

echo '=== block 5 ==='
cat > search.php <<'EOF'
<?php
$q = $_GET['q'] ?? '';
echo "<h1>Results for: " . htmlspecialchars($q, ENT_QUOTES, 'UTF-8') . "</h1>";
EOF

echo '=== block 6 ==='
cat > router.php <<'EOF'
<?php
header("Content-Security-Policy: default-src 'self'");
header("X-Content-Type-Options: nosniff");
require __DIR__ . '/search.php';
EOF
pkill -f 'php -S' 2>/dev/null; sleep 1
php -S 127.0.0.1:8080 router.php >/tmp/php.log 2>&1 &
sleep 1 && echo "server restarted with CSP"

echo '=== block 7 ==='
curl -sD - 'http://127.0.0.1:8080/?q=<b>INJECTED</b>' | grep -i 'content-security-policy'
curl -s  'http://127.0.0.1:8080/?q=<b>INJECTED</b>'

echo '=== block 8 ==='
OUT=$(curl -sD /tmp/h.txt 'http://127.0.0.1:8080/?q=<b>x</b>')
echo "$OUT" | grep -q '&lt;b&gt;' && echo "ENCODING OK — markup shown as text"
grep -qi 'content-security-policy' /tmp/h.txt && echo "CSP HEADER OK"
