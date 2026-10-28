#!/usr/bin/env bash
# Lab 10 — SQL Injection (SQLi)
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y sqlite3 php-cli php-sqlite3 curl

echo '=== block 2 ==='
sqlite3 app.db "CREATE TABLE users(u TEXT, p TEXT); INSERT INTO users VALUES('admin','s3cret');"
cat > login.php <<'EOF'
<?php
$db = new SQLite3('app.db');
$u = $_GET['u']; $p = $_GET['p'];
$sql = "SELECT * FROM users WHERE u='$u' AND p='$p'";   /* VULNERABLE */
$r = $db->query($sql);
echo $r && $r->fetchArray() ? "LOGIN OK\n" : "DENIED\n";
EOF

echo '=== block 3 ==='
php -S 127.0.0.1:8080 -t . >/tmp/php.log 2>&1 &
sleep 1 && echo "server up"

echo '=== block 4 ==='
curl -s 'http://127.0.0.1:8080/login.php?u=admin&p=s3cret'
curl -s 'http://127.0.0.1:8080/login.php?u=admin&p=wrong'

echo '=== block 5 ==='
curl -s "http://127.0.0.1:8080/login.php?u=admin'--+&p=anything"

echo '=== block 6 ==='
cat > login.php <<'EOF'
<?php
$db = new SQLite3('app.db');
$st = $db->prepare("SELECT * FROM users WHERE u=:u AND p=:p");   /* FIXED */
$st->bindValue(':u', $_GET['u'], SQLITE3_TEXT);
$st->bindValue(':p', $_GET['p'], SQLITE3_TEXT);
$r = $st->execute();
echo $r && $r->fetchArray() ? "LOGIN OK\n" : "DENIED\n";
EOF

echo '=== block 7 ==='
curl -s "http://127.0.0.1:8080/login.php?u=admin'--+&p=anything"
curl -s 'http://127.0.0.1:8080/login.php?u=admin&p=s3cret'

echo '=== block 8 ==='
B=$(curl -s "http://127.0.0.1:8080/login.php?u=admin'--+&p=x")
echo "After patch, injection returns: $B"
echo "$B" | grep -q DENIED && echo "PATCH OK — bound parameters defeat the injection"
