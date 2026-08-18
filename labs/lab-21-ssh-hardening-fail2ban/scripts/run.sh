#!/usr/bin/env bash
# Lab 21 — SSH Hardening + Fail2ban
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y fail2ban

echo '=== block 2 ==='
ssh-keygen -t ed25519 -f ~/.ssh/lab_ed25519 -N "" -C "lab-key"
mkdir -p ~/.ssh && cat ~/.ssh/lab_ed25519.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

echo '=== block 3 ==='
cat > /etc/ssh/sshd_config.d/99-hardening.conf <<'EOF'
PermitRootLogin prohibit-password
PasswordAuthentication no
PubkeyAuthentication yes
KbdInteractiveAuthentication no
MaxAuthTries 3
LoginGraceTime 20
ClientAliveInterval 300
ClientAliveCountMax 0
AllowUsers root
EOF
systemctl restart ssh

echo '=== block 4 ==='
ssh -i ~/.ssh/lab_ed25519 -o StrictHostKeyChecking=no root@127.0.0.1 'echo OK'
ssh -o PubkeyAuthentication=no root@127.0.0.1 2>&1 | head -2

echo '=== block 5 ==='
cat > /etc/fail2ban/jail.d/sshd.local <<'EOF'
[sshd]
enabled  = true
port     = ssh
filter   = sshd
backend  = systemd
maxretry = 3
findtime = 5m
bantime  = 1h
EOF
systemctl restart fail2ban
fail2ban-client status sshd

echo '=== block 6 ==='
for i in 1 2 3 4 5; do ssh -o PubkeyAuthentication=no -o StrictHostKeyChecking=no \
   baduser@127.0.0.1 2>/dev/null; done
sleep 5
fail2ban-client status sshd
iptables -L f2b-sshd -n

echo '=== block 7 ==='
fail2ban-client set sshd unbanip 127.0.0.1

