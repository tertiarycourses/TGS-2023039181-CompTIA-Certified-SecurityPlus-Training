#!/usr/bin/env bash
# Lab 41 — Incident Response: Live Triage
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y cron procps iproute2 psmisc lsof python3
systemctl enable --now cron
mkdir -p /evidence/IR-2026-041
cat > /evidence/IR-2026-041/case.txt <<EOF
Case ID:   IR-2026-041
Opened:    $(date -u +%FT%TZ)
Handler:   $(whoami)@$(hostname)
Severity:  TBD (set after analysis)
Playbook:  Suspected host compromise v1.2
EOF
cat /evidence/IR-2026-041/case.txt

echo '=== block 2 ==='
id svc-update >/dev/null 2>&1 || useradd -m -s /bin/bash -c "updater" svc-update
mkdir -p /tmp/.cache-www
cat > /tmp/.update.sh <<'EOF'
#!/bin/sh
echo "marker $(date -u +%FT%TZ)" >> /tmp/.update.marker
EOF
chmod +x /tmp/.update.sh
echo '* * * * * /tmp/.update.sh' | crontab -u svc-update -
nohup su -s /bin/sh svc-update -c 'python3 -m http.server 4444 --bind 127.0.0.1 --directory /tmp/.cache-www' >/dev/null 2>&1 &
sleep 2; echo "exercise indicators planted"

echo '=== block 3 ==='
ss -tlnp | grep 4444
ps -eo pid,ppid,user,lstart,cmd | grep '[h]ttp.server 4444'
awk -F: '$3 >= 1000 && $3 < 65000 {print $1, $3, $6, $7}' /etc/passwd
for u in $(awk -F: '$3 >= 1000 && $3 < 65000 {print $1}' /etc/passwd); do crontab -u "$u" -l 2>/dev/null | sed "s/^/$u: /"; done
ls -la /tmp | grep ' \.'

echo '=== block 4 ==='
cd /evidence/IR-2026-041
date -u +%FT%TZ > 00-collection-start.txt
ps auxwwf > 01-processes.txt
ss -tunap > 02-sockets.txt
ip neigh > 03-arp.txt; ip route > 03-routes.txt
who -a > 04-who.txt; last -n 20 > 04-last.txt 2>/dev/null || true
lsof -nP -i :4444 > 05-lsof-4444.txt 2>/dev/null || true
crontab -u svc-update -l > 06-cron-svc-update.txt
cp /tmp/.update.sh 07-update.sh.evidence
journalctl --since "-30 min" --no-pager > 08-journal-30min.txt
sha256sum 0* > evidence.sha256 && cat evidence.sha256

echo '=== block 5 ==='
usermod -L -e 1 svc-update
iptables -I INPUT -p tcp --dport 4444 -j DROP
pkill -u svc-update || true
sleep 1; ss -tlnp | grep 4444 || echo "listener stopped"
passwd -S svc-update

echo '=== block 6 ==='
crontab -u svc-update -r 2>/dev/null || true
rm -f /tmp/.update.sh /tmp/.update.marker
rm -rf /tmp/.cache-www
userdel -r svc-update 2>/dev/null || userdel svc-update
iptables -D INPUT -p tcp --dport 4444 -j DROP
echo "eradication complete"

echo '=== block 7 ==='
ss -tlnp | grep -q 4444 && echo "FAIL: listener still present" || echo "OK: no listener on 4444"
id svc-update 2>/dev/null && echo "FAIL: account still present" || echo "OK: rogue account removed"
ls /var/spool/cron/crontabs/ 2>/dev/null | grep -q svc-update && echo "FAIL: cron remains" || echo "OK: no cron persistence"
ls /tmp/.update.sh 2>/dev/null || echo "OK: dropped script removed"
cd /evidence/IR-2026-041 && sha256sum -c evidence.sha256

echo '=== block 8 ==='
ls /evidence/IR-2026-041/
sha256sum -c /evidence/IR-2026-041/evidence.sha256 | grep -c ': OK'
ss -tlnp | grep -c 4444
