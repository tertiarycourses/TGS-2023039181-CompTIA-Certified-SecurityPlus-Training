#!/usr/bin/env bash
# Lab 03 — Deception: Honeypots, Honeyfiles and Honeytokens
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y auditd inotify-tools netcat-openbsd iproute2 python3 curl
systemctl enable --now auditd
mkdir -p /opt/honeypot /root/lab03 && touch /var/log/honeypot.log

echo '=== block 2 ==='
cat > /opt/honeypot/honeypot.py <<'EOF'
#!/usr/bin/env python3
"""Low-interaction honeypot: honeypot.py PORT BANNER LOGFILE"""
import datetime, socketserver, sys

PORT, BANNER, LOG = int(sys.argv[1]), sys.argv[2].encode() + b"\r\n", sys.argv[3]

class Decoy(socketserver.BaseRequestHandler):
    def handle(self):
        self.request.settimeout(5)
        try:
            self.request.sendall(BANNER)
            data = self.request.recv(1024)
        except OSError:
            data = b""
        ts = datetime.datetime.now().isoformat(timespec="seconds")
        src = f"{self.client_address[0]}:{self.client_address[1]}"
        with open(LOG, "a") as f:
            f.write(f"{ts} HONEYPOT port={PORT} src={src} data={data[:60]!r}\n")

socketserver.ThreadingTCPServer.allow_reuse_address = True
socketserver.ThreadingTCPServer(("0.0.0.0", PORT), Decoy).serve_forever()
EOF
chmod 755 /opt/honeypot/honeypot.py && python3 -m py_compile /opt/honeypot/honeypot.py && echo "honeypot OK"

echo '=== block 3 ==='
nohup python3 /opt/honeypot/honeypot.py 2222 "SSH-2.0-OpenSSH_7.4" /var/log/honeypot.log >/dev/null 2>&1 &
sleep 1 && ss -tlnp | grep 2222
printf 'root:toor\n' | nc -w 3 127.0.0.1 2222
sleep 1 && tail -2 /var/log/honeypot.log

echo '=== block 4 ==='
mkdir -p /srv/finance
cat > /srv/finance/payroll-2026-FINAL.csv <<'EOF'
employee_id,name,monthly_salary
E1001,DECOY RECORD,0
E1002,DECOY RECORD,0
EOF
chmod 644 /srv/finance/payroll-2026-FINAL.csv
auditctl -w /srv/finance/payroll-2026-FINAL.csv -p r -k honeyfile
id intruder >/dev/null 2>&1 || useradd -m intruder
sudo -u intruder cat /srv/finance/payroll-2026-FINAL.csv >/dev/null
sleep 1 && ausearch -k honeyfile -i | grep "type=SYSCALL" | tail -1

echo '=== block 5 ==='
nohup inotifywait -m -e open --timefmt '%F %T' --format '%T HONEYFILE %e %w%f' /srv/finance/payroll-2026-FINAL.csv >> /var/log/honeyfile-alert.log 2>/dev/null &
sleep 1
sudo -u intruder head -1 /srv/finance/payroll-2026-FINAL.csv >/dev/null
sleep 1 && cat /var/log/honeyfile-alert.log

echo '=== block 6 ==='
mkdir -p /root/.aws
cat > /root/.aws/credentials.bak <<'EOF'
[prod-admin]
aws_access_key_id = AKIAHONEYTOKEN0LAB03
aws_secret_access_key = LabOnlyDecoySecretNotReal0000000000000000
EOF
mkdir -p /srv/decoy-api && echo "ok" > /srv/decoy-api/index.html
nohup python3 -m http.server 8088 --directory /srv/decoy-api >> /var/log/decoy-api.log 2>&1 &
sleep 1
curl -s -o /dev/null "http://127.0.0.1:8088/v1/login?access_key=AKIAHONEYTOKEN0LAB03"
cat > /usr/local/bin/honeytoken-check.sh <<'EOF'
#!/bin/bash
TOKEN="AKIAHONEYTOKEN0LAB03"
if grep -q "$TOKEN" /var/log/decoy-api.log; then
  echo "ALERT: honeytoken $TOKEN was used - treat /root/.aws as compromised"
  grep "$TOKEN" /var/log/decoy-api.log | tail -3
else
  echo "no honeytoken use detected"
fi
EOF
chmod 755 /usr/local/bin/honeytoken-check.sh && /usr/local/bin/honeytoken-check.sh

echo '=== block 7 ==='
ip netns add honeynet 2>/dev/null || true
ip link add veth-host type veth peer name veth-hn 2>/dev/null && ip link set veth-hn netns honeynet
ip addr add 10.66.0.1/24 dev veth-host 2>/dev/null; ip link set veth-host up
ip netns exec honeynet ip addr add 10.66.0.2/24 dev veth-hn 2>/dev/null
ip netns exec honeynet ip addr add 10.66.0.3/24 dev veth-hn 2>/dev/null
ip netns exec honeynet ip link set veth-hn up && ip netns exec honeynet ip link set lo up
ip netns exec honeynet nohup python3 /opt/honeypot/honeypot.py 21 "220 ProFTPD 1.3.5 Server (FILESRV01)" /var/log/honeypot.log >/dev/null 2>&1 &
ip netns exec honeynet nohup python3 /opt/honeypot/honeypot.py 23 "Ubuntu 14.04 LTS PAYROLL-DB login:" /var/log/honeypot.log >/dev/null 2>&1 &
sleep 1
nc -zv -w 2 10.66.0.2 20-23 2>&1 | grep succeeded
printf 'USER admin\n' | nc -w 3 10.66.0.2 21
printf 'admin\n' | nc -w 3 10.66.0.3 23

echo '=== block 8 ==='
sleep 1
echo "== Honeypot hits by port and source =="
grep HONEYPOT /var/log/honeypot.log | awk '{print $3, $4}' | sed 's/:[0-9]*$//' | sort | uniq -c
echo "== Honeyfile opens ==";  grep -c HONEYFILE /var/log/honeyfile-alert.log
echo "== Honeyfile readers (auditd) =="; ausearch -k honeyfile -i 2>/dev/null | grep -o ' uid=[a-z0-9]*' | sort | uniq -c
echo "== Honeytoken =="; /usr/local/bin/honeytoken-check.sh | head -1

echo '=== block 9 ==='
grep -c "port=2222" /var/log/honeypot.log
grep -cE "port=(21|23) " /var/log/honeypot.log
ausearch -k honeyfile -i | grep -c "uid=intruder"
/usr/local/bin/honeytoken-check.sh | head -1
