#!/usr/bin/env bash
# Lab 16 — Linux Hardening Baseline with Lynis
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y lynis unattended-upgrades
lynis --version

echo '=== block 2 ==='
lynis audit system --quick 2>/dev/null | tee lynis-before.txt >/dev/null
grep -i 'hardening index' lynis-before.txt

echo '=== block 3 ==='
systemctl disable --now avahi-daemon cups 2>/dev/null
true   # ignore "not found" on minimal images

echo '=== block 4 ==='
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
systemctl reload ssh 2>/dev/null || service ssh reload 2>/dev/null || true

echo '=== block 5 ==='
printf 'WARNING: Authorised use only. All activity is logged.\n' > /etc/issue.net
sed -i 's|^#*Banner.*|Banner /etc/issue.net|' /etc/ssh/sshd_config
systemctl reload ssh 2>/dev/null || true

echo '=== block 6 ==='
cat > /etc/sysctl.d/99-hardening.conf <<'EOF'
kernel.dmesg_restrict=1
kernel.kptr_restrict=2
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.icmp_echo_ignore_broadcasts=1
EOF
sysctl --system >/dev/null

echo '=== block 7 ==='
dpkg-reconfigure -f noninteractive unattended-upgrades

echo '=== block 8 ==='
lynis audit system --quick 2>/dev/null | tee lynis-after.txt >/dev/null
grep -i 'hardening index' lynis-before.txt lynis-after.txt

echo '=== block 9 ==='
grep -q 'PermitRootLogin no' /etc/ssh/sshd_config && echo "SSH HARDENED"
test -f /etc/sysctl.d/99-hardening.conf && echo "SYSCTL BASELINE APPLIED"
B=$(grep -i 'hardening index' lynis-before.txt | grep -oE '[0-9]+' | head -1)
A=$(grep -i 'hardening index' lynis-after.txt  | grep -oE '[0-9]+' | head -1)
echo "before=$B after=$A"; [ "${A:-0}" -gt "${B:-0}" ] && echo "SCORE IMPROVED"
