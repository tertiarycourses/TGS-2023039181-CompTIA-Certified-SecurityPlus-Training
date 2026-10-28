#!/usr/bin/env bash
# Lab 40 — Automation and Orchestration with a Mini-SOAR Playbook
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y jq shellcheck iptables curl python3
mkdir -p /etc/soar /var/soar/tickets

echo '=== block 2 ==='
cat > /etc/soar/hr_feed.csv <<'EOF'
username,department,status
dtan,finance,active
mlim,engineering,active
rkumar,engineering,leaver
EOF
id rkumar >/dev/null 2>&1 || useradd -m rkumar
cat > /usr/local/bin/provision.sh <<'EOF'
#!/usr/bin/env bash
# provision.sh - create active staff, add to department security group, disable leavers
set -euo pipefail
FEED="${1:-/etc/soar/hr_feed.csv}"
while IFS=, read -r user dept status; do
  [ "$user" = "username" ] && continue
  getent group "sg-$dept" >/dev/null || groupadd "sg-$dept"
  if [ "$status" = "active" ]; then
    if id "$user" >/dev/null 2>&1; then echo "OK $user already provisioned"
    else useradd -m -G "sg-$dept" -c "dept=$dept" "$user"; echo "PROVISIONED $user -> sg-$dept"; fi
  elif id "$user" >/dev/null 2>&1; then
    usermod -L -e 1 "$user"; echo "DISABLED $user (leaver)"
  fi
done < "$FEED"
EOF
chmod +x /usr/local/bin/provision.sh
provision.sh
provision.sh
getent group sg-finance sg-engineering; passwd -S rkumar

echo '=== block 3 ==='
cat > /usr/local/bin/mock-api.py <<'EOF'
import datetime, json
from http.server import BaseHTTPRequestHandler, HTTPServer
class Hook(BaseHTTPRequestHandler):
    def do_POST(self):
        body = self.rfile.read(int(self.headers.get("Content-Length", 0))).decode()
        with open("/var/soar/escalations.log", "a") as f:
            f.write(datetime.datetime.now(datetime.timezone.utc).isoformat() + " " + body + "\n")
        self.send_response(201)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({"status": "on-call paged"}).encode())
    def log_message(self, *args):
        pass
HTTPServer(("127.0.0.1", 8088), Hook).serve_forever()
EOF
nohup python3 /usr/local/bin/mock-api.py >/dev/null 2>&1 &
sleep 1
curl -s -X POST -H 'Content-Type: application/json' -d '{"test":"ping"}' http://127.0.0.1:8088/hook; echo

echo '=== block 4 ==='
printf '127.0.0.1\n10.0.0.5\n' > /etc/soar/allowlist
cat > /usr/local/bin/soar.sh <<'EOF'
#!/usr/bin/env bash
# soar.sh - mini SOAR playbook: SSH brute force -> block -> ticket -> escalate
set -u
THRESHOLD="${THRESHOLD:-5}"
DRY_RUN="${DRY_RUN:-0}"
ALLOWLIST="${ALLOWLIST:-/etc/soar/allowlist}"
TICKETS="${TICKETS:-/var/soar/tickets}"
API="${API:-http://127.0.0.1:8088/hook}"
mkdir -p "$TICKETS"
declare -A count
while IFS= read -r line; do
  case "$line" in
    *"Failed password"*|*"Invalid user"*) ;;
    *) continue ;;
  esac
  ip=$(grep -oE 'from [0-9]{1,3}(\.[0-9]{1,3}){3}' <<<"$line" | awk '{print $2}')
  [ -n "$ip" ] || continue
  count[$ip]=$(( ${count[$ip]:-0} + 1 ))
  [ "${count[$ip]}" -eq "$THRESHOLD" ] || continue
  if grep -qxF "$ip" "$ALLOWLIST" 2>/dev/null; then
    sev="low"; action="alert-only (guard rail: allowlisted)"
  else
    sev="high"; action="blocked"
    if [ "$DRY_RUN" = "1" ]; then
      action="would-block (dry run)"
    else
      iptables -C INPUT -s "$ip" -j DROP 2>/dev/null || iptables -I INPUT -s "$ip" -j DROP
    fi
  fi
  id="INC-$(date +%Y%m%d%H%M%S)-${ip//./-}"
  jq -n --arg id "$id" --arg ip "$ip" --arg sev "$sev" --arg act "$action" --argjson n "${count[$ip]}" \
    '{id:$id, type:"ssh-brute-force", source_ip:$ip, failures:$n, severity:$sev, action:$act, ts:(now|todate)}' \
    > "$TICKETS/$id.json"
  logger -t soar "ticket=$id ip=$ip severity=$sev action=$action"
  if [ "$sev" = "high" ] && [ "$DRY_RUN" != "1" ]; then
    curl -s -m 3 -X POST -H 'Content-Type: application/json' -d @"$TICKETS/$id.json" "$API" >/dev/null \
      || logger -t soar "escalation API unreachable for $id"
  fi
  echo "$id $ip severity=$sev action=$action"
done
EOF
chmod +x /usr/local/bin/soar.sh

echo '=== block 5 ==='
bash -n /usr/local/bin/soar.sh && echo "syntax OK"
shellcheck -S warning /usr/local/bin/soar.sh /usr/local/bin/provision.sh && echo "lint OK"
{ for i in 1 2 3 4 5; do echo "sshd[1]: Failed password for root from 198.51.100.9 port 4$i ssh2"; done
  for i in 1 2 3 4 5; do echo "sshd[1]: Failed password for admin from 127.0.0.1 port 5$i ssh2"; done; } > /tmp/ci-sample.log
DRY_RUN=1 TICKETS=/tmp/ci-tickets /usr/local/bin/soar.sh < /tmp/ci-sample.log
iptables -C INPUT -s 198.51.100.9 -j DROP 2>/dev/null && echo "FAIL: dry run changed the firewall" || echo "PASS: dry run made no changes"

echo '=== block 6 ==='
cat > /etc/systemd/system/soar.service <<'EOF'
[Unit]
Description=Mini SOAR SSH brute-force playbook
After=network.target

[Service]
ExecStart=/bin/bash -c 'journalctl -f -n0 -o short -t sshd | /usr/local/bin/soar.sh'
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload && systemctl enable --now soar.service
systemctl is-active soar.service

echo '=== block 7 ==='
for i in $(seq 1 6); do logger -p auth.warning -t sshd "Failed password for invalid user admin from 203.0.113.50 port 50$i ssh2"; done
sleep 3
iptables -L INPUT -n | grep 203.0.113.50
ls /var/soar/tickets/ && jq . /var/soar/tickets/*203-0-113-50*.json
journalctl -t soar -n 3 --no-pager
cat /var/soar/escalations.log | tail -1

echo '=== block 8 ==='
iptables -D INPUT -s 203.0.113.50 -j DROP && echo "access re-enabled for 203.0.113.50"
T=$(ls /var/soar/tickets/*203-0-113-50*.json | head -1)
jq '.status="closed" | .resolution="reviewed by analyst, block lifted"' "$T" > "$T.tmp" && mv "$T.tmp" "$T"
jq -r '.id + " " + .status' "$T"
logger -t soar "rollback ip=203.0.113.50 ticket=$(jq -r .id "$T")"

echo '=== block 9 ==='
systemctl is-active soar.service
for i in $(seq 1 5); do logger -p auth.warning -t sshd "Failed password for root from 198.51.100.77 port 61$i ssh2"; done; sleep 3
iptables -L INPUT -n | grep -c 198.51.100.77
grep -c 198.51.100.77 /var/soar/escalations.log
