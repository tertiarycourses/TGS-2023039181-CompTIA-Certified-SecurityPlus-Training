#!/usr/bin/env bash
# Lab 01 — Security Controls Categorization
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y iptables auditd bsdextrautils curl openssh-server
systemctl enable --now auditd
mkdir -p /root/lab01 /run/sshd && cd /root/lab01

echo '=== block 2 ==='
cat > /root/lab01/controls.csv <<'EOF'
Control,Category,Type
Locked server-room door,Physical,Preventive
Warning sign at the perimeter fence,Physical,Deterrent
CCTV recording the lobby,Physical,Detective
Fire suppression system,Physical,Corrective
Acceptable use policy,Managerial,Directive
Annual risk assessment,Managerial,Preventive
Quarterly user access review,Operational,Detective
Security awareness training,Operational,Preventive
Firewall DROP rule on port 23,Technical,Preventive
IDS alert on a port scan,Technical,Detective
Restore server from backup,Operational,Corrective
Isolated VLAN for an unpatchable host,Technical,Compensating
EOF
column -t -s, /root/lab01/controls.csv
echo "--- controls per type ---"; tail -n +2 /root/lab01/controls.csv | cut -d, -f3 | sort | uniq -c

echo '=== block 3 ==='
nohup python3 -m http.server 23 --bind 127.0.0.1 >/dev/null 2>&1 &
sleep 1
curl -s -m 3 -o /dev/null -w "before rule: HTTP %{http_code}\n" http://127.0.0.1:23/
iptables -I INPUT -p tcp --dport 23 -j DROP
curl -s -m 3 -o /dev/null -w "after rule: HTTP %{http_code}\n" http://127.0.0.1:23/ || echo "after rule: connection timed out (blocked)"
iptables -L INPUT -n --line-numbers | head -5

echo '=== block 4 ==='
cat > /etc/issue.net <<'EOF'
WARNING: Authorised users only. All activity on this system is monitored and logged.
Unauthorised access is an offence under the Computer Misuse Act 1993 (Singapore).
EOF
echo "Banner /etc/issue.net" > /etc/ssh/sshd_config.d/10-banner.conf
sshd -t && sshd -T | grep -i '^banner'
cat /etc/issue.net

echo '=== block 5 ==='
auditctl -w /etc/passwd -p wa -k passwd_changes
auditctl -l
useradd -m lab01user
sleep 1
ausearch -k passwd_changes -i | grep -E "type=SYSCALL" | tail -3

echo '=== block 6 ==='
mkdir -p /root/known-good
cp -a /etc/issue.net /root/known-good/issue.net
sha256sum /etc/issue.net > /root/known-good/issue.net.sha256
echo "Welcome! Everyone is allowed in." > /etc/issue.net
sha256sum -c /root/known-good/issue.net.sha256 || cp -a /root/known-good/issue.net /etc/issue.net
sha256sum -c /root/known-good/issue.net.sha256

echo '=== block 7 ==='
iptables -I INPUT 1 -s 10.10.10.5 -p tcp --dport 23 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 23 -j LOG --log-prefix "LEGACY-TELNET " --log-level 4
iptables -L INPUT -n --line-numbers | head -6
curl -s -m 3 -o /dev/null http://127.0.0.1:23/ || echo "non-jump-host access still blocked"
dmesg | grep LEGACY-TELNET | tail -2

echo '=== block 8 ==='
cat > /root/lab01/evidence.csv <<'EOF'
Implemented control,Category,Type,Evidence
iptables DROP tcp/23,Technical,Preventive,iptables -L INPUT
SSH warning banner,Technical,Deterrent + Directive,sshd -T | grep banner
auditd watch on /etc/passwd,Technical,Detective,ausearch -k passwd_changes
Known-good restore of /etc/issue.net,Operational,Corrective,sha256sum -c
Jump-host-only Telnet + LOG,Technical,Compensating,iptables -L INPUT and dmesg
EOF
column -t -s, /root/lab01/evidence.csv

echo '=== block 9 ==='
iptables -S INPUT | grep -- "--dport 23"
sshd -T | grep -i '^banner'
ausearch -k passwd_changes -i | grep -c lab01user
sha256sum -c /root/known-good/issue.net.sha256
