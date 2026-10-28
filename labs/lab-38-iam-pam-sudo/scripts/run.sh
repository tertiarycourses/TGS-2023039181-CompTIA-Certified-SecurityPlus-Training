#!/usr/bin/env bash
# Lab 38 — Identity & Access Management with PAM and sudo
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo acl libpam-pwquality libpwquality-tools pamtester
grep pwquality /etc/pam.d/common-password

echo '=== block 2 ==='
for g in webops dbops auditor; do getent group "$g" >/dev/null || groupadd "$g"; done
while IFS=: read -r u g gecos; do
  id "$u" >/dev/null 2>&1 || useradd -m -s /bin/bash -G "$g" -c "$gecos" "$u"
  echo "$u:Labs-Pass-2026" | chpasswd
done <<'EOF'
alice:webops:Alice Tan - Web Ops - REQ-1001
bob:dbops:Bob Lim - DB Ops - REQ-1002
carol:auditor:Carol Ng - Audit - REQ-1003
EOF
for u in alice bob carol; do id "$u"; getent passwd "$u" | cut -d: -f5; done

echo '=== block 3 ==='
mkdir -p /srv/reports && echo "Q3 audit findings (synthetic data)" > /srv/reports/q3.txt
chown -R root:auditor /srv/reports && chmod 750 /srv/reports && chmod 640 /srv/reports/q3.txt
setfacl -m u:bob:rx /srv/reports && setfacl -m u:bob:r /srv/reports/q3.txt
getfacl -p /srv/reports/q3.txt
su - carol -c 'cat /srv/reports/q3.txt'
su - bob   -c 'cat /srv/reports/q3.txt'
su - alice -c 'cat /srv/reports/q3.txt' || echo "alice DENIED: no role membership and no ACL"

echo '=== block 4 ==='
cat > /etc/sudoers.d/10-roles <<'EOF'
# RBAC: each role gets only the commands its job needs (least privilege)
%webops  ALL=(root) NOPASSWD: /usr/bin/systemctl status cron, /usr/bin/systemctl restart cron
%dbops   ALL=(root) NOPASSWD: /usr/bin/du -sh /var/lib/*
%auditor ALL=(root) NOPASSWD: /usr/bin/last
EOF
chmod 440 /etc/sudoers.d/10-roles && visudo -cf /etc/sudoers.d/10-roles
sudo -l -U alice | tail -3
su - alice -c 'sudo -n systemctl status cron --no-pager | head -3'
su - alice -c 'sudo -n cat /etc/shadow' || echo "alice DENIED: command not in her role"

echo '=== block 5 ==='
cat > /etc/sudoers.d/90-jit-carol <<'EOF'
# JIT grant for CHG-2042 - expires automatically after 2 minutes
carol ALL=(root) NOPASSWD: /usr/bin/systemctl restart cron
EOF
chmod 440 /etc/sudoers.d/90-jit-carol && visudo -cf /etc/sudoers.d/90-jit-carol
systemd-run --unit=jit-revoke-carol --on-active=120 /bin/rm -f /etc/sudoers.d/90-jit-carol
su - carol -c 'sudo -n systemctl restart cron && echo "JIT privilege used by carol"'
systemctl list-timers --all --no-pager | grep jit-revoke

echo '=== block 6 ==='
cp -n /etc/security/pwquality.conf /root/pwquality.conf.bak
cat >> /etc/security/pwquality.conf <<'EOF'
# SecPlus lab password standard
minlen = 14
minclass = 3
maxrepeat = 3
dictcheck = 1
usercheck = 1
EOF
grep -q pam_pwhistory /etc/pam.d/common-password || \
  sed -i '/^password.*pam_unix.so/i password required pam_pwhistory.so remember=5 use_authtok' /etc/pam.d/common-password
grep -E 'pwquality|pwhistory|pam_unix' /etc/pam.d/common-password
for p in 'Summer2026' 'aaaaaaaaaaaaaaa1' 'correct-Horse-battery-staple-9'; do echo "== $p"; echo "$p" | pwscore 2>&1; done
chage -M 365 -m 1 -W 14 alice && chage -l alice

echo '=== block 7 ==='
cat > /etc/security/faillock.conf <<'EOF'
deny = 5
fail_interval = 900
unlock_time = 600
EOF
cp -n /etc/pam.d/common-auth /root/common-auth.bak
grep -q pam_faillock /etc/pam.d/common-auth || sed -i \
  -e '/^auth.*pam_unix.so/i auth    requisite                       pam_faillock.so preauth' \
  -e '/^auth.*pam_unix.so/a auth    [default=die]                   pam_faillock.so authfail' \
  -e '/^auth.*pam_unix.so/a auth    sufficient                      pam_faillock.so authsucc' \
  /etc/pam.d/common-auth
grep -q pam_faillock /etc/pam.d/common-account || echo 'account required pam_faillock.so' >> /etc/pam.d/common-account
printf '@include common-auth\n@include common-account\n' > /etc/pam.d/labauth
grep -E 'faillock|pam_unix' /etc/pam.d/common-auth
for i in 1 2 3 4 5 6; do echo 'wrong-guess' | pamtester labauth alice authenticate; done
faillock --user alice
echo 'Labs-Pass-2026' | pamtester labauth alice authenticate || echo "alice LOCKED OUT even with the right password"
faillock --user alice --reset
echo 'Labs-Pass-2026' | pamtester labauth alice authenticate

echo '=== block 8 ==='
cat >> /etc/security/time.conf <<'EOF'
# SecPlus lab rules: services;ttys;users;times
labauth;*;alice;Wk0800-1900
labauth;*;carol;!Al0000-2400
EOF
grep -q pam_time /etc/pam.d/labauth || echo 'account required pam_time.so' >> /etc/pam.d/labauth
date
pamtester labauth alice acct_mgmt || echo "alice is outside her permitted hours right now"
pamtester labauth carol acct_mgmt || echo "carol DENIED by the time-of-day rule"

echo '=== block 9 ==='
usermod -L -e 1 -s /usr/sbin/nologin bob
gpasswd -d bob dbops
setfacl -x u:bob /srv/reports/q3.txt && setfacl -x u:bob /srv/reports
pkill -KILL -u bob || true
tar -czf "/root/offboard-bob-$(date +%F).tgz" -C /home bob
passwd -S bob; chage -l bob | grep 'Account expires'; id bob
echo 'Labs-Pass-2026' | pamtester labauth bob authenticate || echo "bob can no longer authenticate"

echo '=== block 10 ==='
ls /etc/sudoers.d/
su - carol -c 'sudo -n systemctl restart cron' || echo "PASS: JIT privilege expired"
su - alice -c 'sudo -n systemctl status cron --no-pager | head -1'
passwd -S bob | awk '{print "bob password status:", $2}'
getfacl -p /srv/reports/q3.txt | grep -c 'user:bob' || echo "PASS: no ACL left for bob"
