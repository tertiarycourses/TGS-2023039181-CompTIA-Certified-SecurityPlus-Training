#!/usr/bin/env bash
# Lab 22 — Identity & Access Management with PAM and sudo
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
groupadd webops
groupadd dbops
groupadd auditor

useradd -m -G webops  alice
useradd -m -G dbops   bob
useradd -m -G auditor carol

for u in alice bob carol; do echo "$u:Lab1234!" | chpasswd; done

echo '=== block 2 ==='
cat > /etc/sudoers.d/roles <<'EOF'
%webops  ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx, /bin/systemctl status nginx
%dbops   ALL=(ALL) NOPASSWD: /usr/bin/mysqldump, /bin/systemctl restart mariadb
%auditor ALL=(ALL) NOPASSWD: /usr/bin/cat /var/log/auth.log, /usr/bin/journalctl
EOF
chmod 440 /etc/sudoers.d/roles
visudo -cf /etc/sudoers.d/roles

echo '=== block 3 ==='
su - alice -c 'sudo systemctl status nginx 2>&1 | head -2'
su - alice -c 'sudo mysqldump --help 2>&1 | head -1'   # should DENY
su - carol -c 'sudo cat /var/log/auth.log | tail -2'

echo '=== block 4 ==='
cat >> /etc/security/time.conf <<'EOF'
# Allow alice to log in only Mon-Fri 09:00-18:00 SGT
*;*;alice;Wd0900-1800
EOF

grep -q pam_time /etc/pam.d/login || \
   echo 'account required pam_time.so' >> /etc/pam.d/login

echo '=== block 5 ==='
cat > /etc/security/faillock.conf <<'EOF'
deny = 5
unlock_time = 600
fail_interval = 900
EOF

# enable in PAM (common-auth's pam_unix line is "[success=1 default=ignore]" on modern Ubuntu)
sed -i '/pam_unix.so/i auth required pam_faillock.so preauth silent' /etc/pam.d/common-auth
sed -i '/pam_unix.so/a auth [default=die] pam_faillock.so authfail' /etc/pam.d/common-auth

faillock --user alice
for i in 1 2 3 4 5 6; do su - alice -c 'true' < /dev/null 2>/dev/null; done
faillock --user alice

echo '=== block 6 ==='
usermod -L alice           # lock account
chage -E 0 alice           # expire it
passwd -S alice

