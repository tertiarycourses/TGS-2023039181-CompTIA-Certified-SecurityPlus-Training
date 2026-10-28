#!/usr/bin/env bash
# Lab 35 — Secure Remote Access: SSH Hardening and Fail2ban
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server openssh-client fail2ban python3-systemd nftables
systemctl enable --now ssh
systemctl is-active ssh

echo '=== block 2 ==='
sshd -T | grep -Ei '^(port|permitrootlogin|passwordauthentication|kbdinteractiveauthentication|pubkeyauthentication|maxauthtries|x11forwarding) '
ss -tlnp | grep -E ':(22|23|513) ' || true
ss -tln | grep -qE ':(23|513) ' && echo "WARNING: cleartext remote access listening" || echo "OK: no Telnet or rlogin listener"

echo '=== block 3 ==='
mkdir -p -m 700 ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/secplus_ed25519 -N "" -C "secplus-lab-key" -q
cat ~/.ssh/secplus_ed25519.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
ssh-keygen -lf ~/.ssh/secplus_ed25519.pub

echo '=== block 4 ==='
cat > /etc/issue.net <<'EOF'
AUTHORISED ACCESS ONLY. Activity on this system is monitored and recorded.
Unauthorised access is an offence under the Computer Misuse Act 1993.
EOF
cat > /etc/ssh/sshd_config.d/01-secplus-hardening.conf <<'EOF'
PermitRootLogin prohibit-password
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
PermitEmptyPasswords no
MaxAuthTries 3
LoginGraceTime 20
X11Forwarding no
ClientAliveInterval 300
ClientAliveCountMax 2
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
Banner /etc/issue.net
EOF
sshd -t && systemctl restart ssh && echo "sshd configuration valid and reloaded"
sshd -T | grep -Ei '^(passwordauthentication|maxauthtries|ciphers|kexalgorithms) '

echo '=== block 5 ==='
ssh -i ~/.ssh/secplus_ed25519 -o StrictHostKeyChecking=accept-new -o BatchMode=yes root@127.0.0.1 'echo KEY-LOGIN-OK'
ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password -o BatchMode=yes root@127.0.0.1 true 2>&1 | tail -1
ssh -v -i ~/.ssh/secplus_ed25519 -o BatchMode=yes root@127.0.0.1 true 2>&1 | grep -m2 -E 'kex: algorithm:|kex: server->client cipher'

echo '=== block 6 ==='
ip addr add 10.10.10.10/32 dev lo 2>/dev/null || true
cat > /etc/fail2ban/jail.d/sshd-secplus.local <<'EOF'
[sshd]
enabled    = true
backend    = systemd
port       = ssh
maxretry   = 3
findtime   = 10m
bantime    = 1h
ignoreself = false
ignoreip   =
EOF
systemctl restart fail2ban && sleep 3
fail2ban-client status sshd

echo '=== block 7 ==='
for u in admin oracle test guest ubuntu; do
  ssh -b 10.10.10.10 -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=3 "$u@10.10.10.10" true 2>/dev/null
done
sleep 5
fail2ban-client status sshd | grep -E 'Currently failed|Total failed|Banned IP list'

echo '=== block 8 ==='
nft list ruleset 2>/dev/null | grep -B3 -A3 '10.10.10.10' || iptables -S | grep -E 'f2b|10.10.10.10'
ssh -b 10.10.10.10 -o BatchMode=yes -o ConnectTimeout=3 root@10.10.10.10 true 2>&1 | tail -1
ssh -i ~/.ssh/secplus_ed25519 -o BatchMode=yes root@127.0.0.1 'echo STILL-OK-FROM-LOCALHOST'
fail2ban-client set sshd unbanip 10.10.10.10
fail2ban-client status sshd | grep 'Banned IP list'

echo '=== block 9 ==='
sshd -T | grep -E '^passwordauthentication no$' && echo "PASS key-only"
ssh -i ~/.ssh/secplus_ed25519 -o BatchMode=yes root@127.0.0.1 'echo PASS key-login'
for u in a b c d; do ssh -b 10.10.10.10 -o BatchMode=yes -o ConnectTimeout=3 "$u@10.10.10.10" true 2>/dev/null; done; sleep 5
fail2ban-client status sshd | grep -q '10.10.10.10' && echo "PASS ban active"
fail2ban-client set sshd unbanip 10.10.10.10
