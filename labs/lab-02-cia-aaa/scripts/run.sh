#!/usr/bin/env bash
# Lab 02 — CIA Triad and AAA on Linux
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y openssh-server sudo curl python3
mkdir -p /run/sshd && systemctl enable --now ssh
id alice >/dev/null 2>&1 || useradd -m -s /bin/bash alice
id bob   >/dev/null 2>&1 || useradd -m -s /bin/bash bob

echo '=== block 2 ==='
echo "salary: 120000" > /home/alice/secret.txt
chown alice:alice /home/alice/secret.txt
chmod 600 /home/alice/secret.txt
ls -l /home/alice/secret.txt
sudo -u bob cat /home/alice/secret.txt 2>&1 || echo "DENIED - confidentiality enforced"

echo '=== block 3 ==='
sha256sum /home/alice/secret.txt > /root/secret.sha256
sha256sum -c /root/secret.sha256
echo "salary: 990000" > /home/alice/secret.txt
sha256sum -c /root/secret.sha256 || echo "INTEGRITY FAILED - file was altered"

echo '=== block 4 ==='
mkdir -p /srv/cia-web && echo "service is up" > /srv/cia-web/index.html
cat > /etc/systemd/system/cia-web.service <<'EOF'
[Unit]
Description=CIA lab web service (availability demo)
[Service]
ExecStart=/usr/bin/python3 -m http.server 8080 --directory /srv/cia-web
Restart=always
RestartSec=2
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload && systemctl enable --now cia-web
sleep 2 && curl -s http://127.0.0.1:8080/
systemctl kill -s SIGKILL cia-web
sleep 4 && curl -s http://127.0.0.1:8080/
systemctl show cia-web -p NRestarts

echo '=== block 5 ==='
echo 'alice:Lab1234!' | chpasswd -c SHA512
STORED=$(getent shadow alice | cut -d: -f2)
SALT=$(echo "$STORED" | cut -d'$' -f3)
echo "stored hash: $STORED"
[ "$(openssl passwd -6 -salt "$SALT" 'Lab1234!')" = "$STORED" ] && echo "correct password: AUTHENTICATED"
[ "$(openssl passwd -6 -salt "$SALT" 'Guess123')" = "$STORED" ] || echo "wrong password: REJECTED"

echo '=== block 6 ==='
[ -f /root/svc_backup_key ] || ssh-keygen -t ed25519 -N '' -C 'svc-backup@lab' -f /root/svc_backup_key -q
install -d -m 700 -o alice -g alice /home/alice/.ssh
cat /root/svc_backup_key.pub >> /home/alice/.ssh/authorized_keys
chown alice:alice /home/alice/.ssh/authorized_keys && chmod 600 /home/alice/.ssh/authorized_keys
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
ssh -i /root/svc_backup_key -o BatchMode=yes -o StrictHostKeyChecking=accept-new alice@127.0.0.1 'echo "logged in as $(whoami) with a key"'

echo '=== block 7 ==='
cat > /etc/sudoers.d/alice-ops <<'EOF'
alice ALL=(root) NOPASSWD: /usr/bin/systemctl restart cia-web
EOF
chmod 440 /etc/sudoers.d/alice-ops && visudo -cf /etc/sudoers.d/alice-ops
sudo -l -U alice | tail -2
sudo -u alice sudo -n /usr/bin/systemctl restart cia-web && echo "ALLOWED - restart cia-web"
sudo -u alice sudo -n /usr/bin/cat /etc/shadow 2>&1 | tail -1 || true

echo '=== block 8 ==='
journalctl _COMM=sudo --no-pager | grep -E "alice" | tail -4
journalctl -u ssh --no-pager | grep -E "Accepted publickey for alice" | tail -2
grep -hE "sudo:|sshd.*Accepted" /var/log/auth.log 2>/dev/null | tail -4 || true

echo '=== block 9 ==='
sudo -u bob cat /home/alice/secret.txt 2>/dev/null || echo "C: bob denied"
sha256sum -c /root/secret.sha256 2>/dev/null || echo "I: tampering detected"
curl -s http://127.0.0.1:8080/ && systemctl show cia-web -p NRestarts
sudo -l -U alice | grep -c "systemctl restart cia-web"
journalctl _COMM=sudo --no-pager | grep -c "USER=root ; COMMAND=/usr/bin/systemctl restart cia-web"
