#!/usr/bin/env bash
# Lab 26 — Endpoint Detection with osquery
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
curl -fsSL https://pkg.osquery.io/deb/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/osquery.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/osquery.gpg] https://pkg.osquery.io/deb deb main" \
  > /etc/apt/sources.list.d/osquery.list
apt update && apt install -y osquery
osqueryi --version

echo '=== block 2 ==='
osqueryi --json "SELECT name, pid, uid FROM processes WHERE on_disk = 0;"  # in-memory only
osqueryi --json "SELECT name, version FROM deb_packages WHERE name LIKE 'openssh%';"
osqueryi --json "SELECT username, type FROM users WHERE shell != '/usr/sbin/nologin';"
osqueryi --json "SELECT * FROM listening_ports WHERE address = '0.0.0.0';"

echo '=== block 3 ==='
cp /bin/sleep /tmp/.evil; /tmp/.evil 600 &
rm /tmp/.evil
osqueryi --json "SELECT name, pid, path FROM processes WHERE on_disk = 0;"

echo '=== block 4 ==='
osqueryi --json "SELECT path, mode FROM file WHERE path LIKE '/usr/bin/%' AND (mode LIKE '%4%') LIMIT 10;"

echo '=== block 5 ==='
cat > /etc/osquery/osquery.conf <<'EOF'
{
  "options": { "logger_path": "/var/log/osquery", "schedule_splay_percent": 10 },
  "schedule": {
    "fileless_proc": { "query": "SELECT name, pid FROM processes WHERE on_disk = 0;", "interval": 60 },
    "new_listeners": { "query": "SELECT pid, port, address FROM listening_ports;", "interval": 60 },
    "users": { "query": "SELECT username, uid FROM users;", "interval": 300 }
  }
}
EOF
mkdir -p /var/log/osquery
systemctl enable --now osqueryd
sleep 70
ls /var/log/osquery
tail -3 /var/log/osquery/osqueryd.results.log

echo '=== block 6 ==='
cat >> /etc/osquery/osquery.conf <<'EOF'
,
  "file_paths": { "etc": ["/etc/passwd", "/etc/shadow", "/etc/sudoers"] },
  "exclude_paths": { },
  "events": { "disable_subscribers": [] }
EOF

