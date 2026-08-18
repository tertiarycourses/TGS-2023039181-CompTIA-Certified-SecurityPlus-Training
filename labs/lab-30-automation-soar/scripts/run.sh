#!/usr/bin/env bash
# Lab 30 — Automation & Orchestration (Mini-SOAR)
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y inotify-tools

echo '=== block 2 ==='
cat > /usr/local/bin/soar.sh <<'EOF'
#!/bin/bash
# Mini-SOAR: auto-ban brute-force IPs after 5 failures within 60s
THRESHOLD=5
WINDOW=60
TICKETS=/var/tickets
LOG=/var/log/soar.log
mkdir -p "$TICKETS"

declare -A counter
declare -A first_seen

tail -F /var/log/auth.log | while read -r line; do
  ip=$(grep -oE 'from [0-9.]+' <<<"$line" | awk '{print $2}')
  case "$line" in
    *"Failed password"*|*"Invalid user"*)
      [ -z "$ip" ] && continue
      now=$(date +%s)
      [ -z "${first_seen[$ip]}" ] && first_seen[$ip]=$now
      counter[$ip]=$(( ${counter[$ip]:-0} + 1 ))
      elapsed=$(( now - first_seen[$ip] ))
      if [ $elapsed -gt $WINDOW ]; then
        counter[$ip]=1; first_seen[$ip]=$now
      fi
      if [ ${counter[$ip]} -ge $THRESHOLD ]; then
        if ! iptables -C INPUT -s $ip -j DROP 2>/dev/null; then
          iptables -I INPUT -s $ip -j DROP
          ticket="$TICKETS/$(date +%s)-$ip.json"
          cat > "$ticket" <<JSON
{"ts":"$(date -u +%FT%TZ)","ip":"$ip","action":"banned","reason":"ssh-brute","count":${counter[$ip]}}
JSON
          logger -t soar "BANNED $ip (count=${counter[$ip]}) ticket=$ticket"
          echo "[$(date)] BANNED $ip" >> $LOG
        fi
      fi
      ;;
  esac
done
EOF
chmod +x /usr/local/bin/soar.sh

echo '=== block 3 ==='
cat > /etc/systemd/system/soar.service <<'EOF'
[Unit]
Description=Mini SOAR
After=network.target

[Service]
ExecStart=/usr/local/bin/soar.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now soar.service

echo '=== block 4 ==='
for i in $(seq 1 6); do ssh -o PubkeyAuthentication=no -o StrictHostKeyChecking=no \
   bad@127.0.0.1 2>/dev/null; done
sleep 3
ls /var/tickets/
iptables -L INPUT -n | head
journalctl -t soar -n 5 --no-pager

echo '=== block 5 ==='
# placeholder - in real life: curl -X POST https://hooks.slack.com/services/... -d "..."

