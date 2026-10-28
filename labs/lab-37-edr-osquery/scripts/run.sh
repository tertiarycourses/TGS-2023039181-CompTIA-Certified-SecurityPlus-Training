#!/usr/bin/env bash
# Lab 37 — Endpoint Detection and Response with osquery
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y curl jq cron netcat-openbsd ca-certificates
mkdir -p /etc/apt/keyrings /root/edr
curl -fsSL https://pkg.osquery.io/deb/pubkey.gpg -o /etc/apt/keyrings/osquery.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/osquery.asc] https://pkg.osquery.io/deb deb main" > /etc/apt/sources.list.d/osquery.list
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y osquery
osqueryi --version

echo '=== block 2 ==='
osqueryi --json "SELECT hostname, cpu_brand, physical_memory FROM system_info;"
osqueryi --json "SELECT pid, name, path, resident_size FROM processes ORDER BY resident_size DESC LIMIT 5;"
osqueryi --json "SELECT p.name, l.port, l.address, l.pid FROM listening_ports l JOIN processes p USING (pid) WHERE l.port != 0;"
osqueryi --json "SELECT username, uid, shell FROM users WHERE shell NOT LIKE '%nologin' AND shell NOT LIKE '%false';"

echo '=== block 3 ==='
osqueryi --json "SELECT path, command FROM crontab;" | tee /root/edr/baseline-crontab.json | jq length
osqueryi --json "SELECT path, username, permissions FROM suid_bin;" | tee /root/edr/baseline-suid.json | jq length
osqueryi --json "SELECT name, size, status FROM kernel_modules ORDER BY name;" | tee /root/edr/baseline-modules.json | jq length
osqueryi --json "SELECT path, username, permissions FROM suid_bin;" | jq -r '.[].path' | head -8

echo '=== block 4 ==='
mkdir -p /etc/osquery/packs /var/log/osquery
cat > /etc/osquery/packs/secplus-hunt.conf <<'EOF'
{
  "queries": {
    "suspicious_processes": {
      "query": "SELECT pid, name, path, cmdline, on_disk FROM processes WHERE on_disk = 0 OR path LIKE '/tmp/%' OR path LIKE '/dev/shm/%';",
      "interval": 30,
      "description": "Processes running from temp paths or whose binary was deleted"
    },
    "listening_ports": {
      "query": "SELECT p.name, p.path, l.port, l.address FROM listening_ports l JOIN processes p USING (pid) WHERE l.port != 0;",
      "interval": 30,
      "description": "New network listeners"
    },
    "crontab": {
      "query": "SELECT path, command FROM crontab;",
      "interval": 30,
      "description": "Cron persistence"
    },
    "suid_binaries": {
      "query": "SELECT path, username, permissions FROM suid_bin;",
      "interval": 60,
      "description": "New SUID or SGID binaries"
    },
    "kernel_modules": {
      "query": "SELECT name, size FROM kernel_modules;",
      "interval": 60,
      "description": "Kernel module changes"
    }
  }
}
EOF
cat > /etc/osquery/osquery.conf <<'EOF'
{
  "options": {
    "config_plugin": "filesystem",
    "logger_plugin": "filesystem",
    "logger_path": "/var/log/osquery",
    "schedule_splay_percent": 10,
    "utc": "true"
  },
  "packs": {
    "secplus-hunt": "/etc/osquery/packs/secplus-hunt.conf"
  }
}
EOF
jq empty /etc/osquery/osquery.conf /etc/osquery/packs/secplus-hunt.conf && echo "JSON valid"
osqueryd --config_check --config_path=/etc/osquery/osquery.conf && echo "osquery config OK"
systemctl enable osqueryd >/dev/null 2>&1; systemctl restart osqueryd
sleep 40; systemctl is-active osqueryd
jq -r '.name' /var/log/osquery/osqueryd.results.log | sort | uniq -c

echo '=== block 5 ==='
cp "$(readlink -f "$(command -v nc)")" /tmp/.kworker-update
nohup /tmp/.kworker-update -lk 4444 </dev/null >/dev/null 2>&1 &
sleep 1; rm -f /tmp/.kworker-update
echo '*/5 * * * * root /tmp/.kworker-update -lk 4444 >/dev/null 2>&1' > /etc/cron.d/kworker-update
cp /bin/bash /usr/local/bin/.dbus-helper && chmod 4755 /usr/local/bin/.dbus-helper
ss -tlnp | grep 4444

echo '=== block 6 ==='
osqueryi --json "SELECT pid, name, path, cmdline, on_disk FROM processes WHERE on_disk = 0 OR path LIKE '/tmp/%' OR path LIKE '/dev/shm/%';"
osqueryi --json "SELECT p.pid, p.path, l.port, l.address FROM listening_ports l JOIN processes p USING (pid) WHERE p.on_disk = 0 OR p.path LIKE '/tmp/%';"
osqueryi --json "SELECT path, command FROM crontab WHERE command LIKE '%/tmp/%' OR command LIKE '%/dev/shm/%';"
osqueryi --json "SELECT path, username, permissions FROM suid_bin;" | jq -r '.[].path' | sort > /root/edr/now-suid.txt
jq -r '.[].path' /root/edr/baseline-suid.json | sort | comm -13 - /root/edr/now-suid.txt

echo '=== block 7 ==='
sleep 40
jq -c 'select(.action=="added" and (.name|test("suspicious_processes|suid_binaries"))) | {time:.calendarTime, query:.name, row:.columns}' /var/log/osquery/osqueryd.results.log | tail -4
jq -c 'select(.action=="added") | select(.columns|tostring|test("kworker|4444")) | {query:.name, row:.columns}' /var/log/osquery/osqueryd.results.log | tail -4

echo '=== block 8 ==='
PID=$(osqueryi --json "SELECT pid FROM processes WHERE path LIKE '/tmp/.kworker-update%';" | jq -r '.[0].pid')
echo "Malicious PID: $PID"
cp "/proc/$PID/exe" /root/edr/kworker-update.evidence && chmod 400 /root/edr/kworker-update.evidence
sha256sum /root/edr/kworker-update.evidence | tee /root/edr/evidence.sha256
kill "$PID"
mv /etc/cron.d/kworker-update /root/edr/cron-kworker-update.evidence
mv /usr/local/bin/.dbus-helper /root/edr/dbus-helper.evidence && chmod 000 /root/edr/dbus-helper.evidence
osqueryi --json "SELECT pid, path FROM processes WHERE on_disk = 0 OR path LIKE '/tmp/%';"
sleep 70
jq -r 'select(.action=="removed") | .name' /var/log/osquery/osqueryd.results.log | sort | uniq -c

echo '=== block 9 ==='
osqueryi --json "SELECT pid, path FROM processes WHERE on_disk = 0 OR path LIKE '/tmp/%';"
osqueryi --json "SELECT path, command FROM crontab WHERE command LIKE '%/tmp/%';"
jq -r 'select(.name=="pack_secplus-hunt_suspicious_processes") | .action' /var/log/osquery/osqueryd.results.log | sort | uniq -c
cat /root/edr/evidence.sha256
