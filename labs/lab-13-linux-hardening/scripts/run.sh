#!/usr/bin/env bash
# Lab 13 — Linux Hardening Baseline with Lynis
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y lynis unattended-upgrades
lynis --version

echo '=== block 2 ==='
lynis audit system --quick 2>/dev/null | tee lynis-before.txt
grep -E "Hardening index|Warnings|Suggestions" lynis-before.txt

echo '=== block 3 ==='
systemctl disable --now avahi-daemon 2>/dev/null
systemctl disable --now cups 2>/dev/null

echo '=== block 4 ==='
chmod 600 /etc/ssh/sshd_config
chmod 644 /etc/passwd
chmod 600 /etc/shadow

echo '=== block 5 ==='
dpkg-reconfigure -f noninteractive unattended-upgrades

echo '=== block 6 ==='
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
systemctl reload ssh

echo '=== block 7 ==='
cat > /etc/issue.net <<'EOF'
WARNING: Authorised use only. All activity is logged.
EOF
sed -i 's|^#*Banner.*|Banner /etc/issue.net|' /etc/ssh/sshd_config
systemctl reload ssh

echo '=== block 8 ==='
cat >> /etc/sysctl.d/99-hardening.conf <<'EOF'
kernel.dmesg_restrict=1
kernel.kptr_restrict=2
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.icmp_echo_ignore_broadcasts=1
EOF
sysctl --system >/dev/null

echo '=== block 9 ==='
lynis audit system --quick 2>/dev/null | tee lynis-after.txt
grep "Hardening index" lynis-before.txt lynis-after.txt

echo '=== block 10 ==='
grep -E "^Suggestion|^Warning" lynis-after.txt | head -10

