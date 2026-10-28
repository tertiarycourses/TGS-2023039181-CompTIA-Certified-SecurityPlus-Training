#!/usr/bin/env bash
# Lab 34 — File Integrity Monitoring with AIDE
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y aide
aide --version 2>&1 | head -1

echo '=== block 2 ==='
mkdir -p /srv/webapp /root/known-good /root/quarantine
echo '<h1>SecPlus Bank - Welcome</h1>' > /srv/webapp/index.html
printf '[db]\nhost=10.0.20.5\nuser=webapp\n' > /srv/webapp/app.ini
printf '#!/bin/sh\ntar -czf /tmp/webapp-backup.tgz /srv/webapp\n' > /usr/local/bin/backup-webapp.sh
chmod 755 /usr/local/bin/backup-webapp.sh
cp -a /srv/webapp/index.html /root/known-good/

echo '=== block 3 ==='
mkdir -p /var/lib/aide/lab
cat > /etc/aide/aide-lab.conf <<'EOF'
database_in=file:/var/lib/aide/lab/aide.db
database_out=file:/var/lib/aide/lab/aide.db.new
gzip_dbout=no
report_url=stdout
LAB = p+i+n+u+g+s+m+c+sha256
/srv/webapp LAB
/usr/local/bin LAB
/etc/passwd LAB
/etc/shadow LAB
/etc/group LAB
/etc/sudoers LAB
EOF
aide --config=/etc/aide/aide-lab.conf --config-check && echo "configuration OK"

echo '=== block 4 ==='
aide --config=/etc/aide/aide-lab.conf --init
cp /var/lib/aide/lab/aide.db.new /var/lib/aide/lab/aide.db
chmod 400 /var/lib/aide/lab/aide.db
mkdir -p /root/offhost && sha256sum /var/lib/aide/lab/aide.db | tee /root/offhost/aide-db.sha256
aide --config=/etc/aide/aide-lab.conf --check; echo "clean check exit code: $?"

echo '=== block 5 ==='
echo '<h1>HACKED by lab-actor</h1>' > /srv/webapp/index.html
cp /bin/sh /usr/local/bin/.sysupdate && chmod 4755 /usr/local/bin/.sysupdate
useradd -m -s /bin/bash svc-update

echo '=== block 6 ==='
aide --config=/etc/aide/aide-lab.conf --check > /root/aide-tamper-report.txt; echo "exit code: $?"
grep -E '^[fdl].*: /|^File: ' /root/aide-tamper-report.txt | head -20
grep -E '^(Added|Removed|Changed) entries|Total number' /root/aide-tamper-report.txt

echo '=== block 7 ==='
cp -a /root/known-good/index.html /srv/webapp/index.html
mv /usr/local/bin/.sysupdate /root/quarantine/sysupdate.evidence && chmod 000 /root/quarantine/sysupdate.evidence
sha256sum /root/quarantine/sysupdate.evidence 2>/dev/null || ls -l /root/quarantine/
usermod -L -s /usr/sbin/nologin svc-update
aide --config=/etc/aide/aide-lab.conf --check | grep -E '^(Added|Removed|Changed) entries|^f'

echo '=== block 8 ==='
sha256sum -c /root/offhost/aide-db.sha256
aide --config=/etc/aide/aide-lab.conf --update >/dev/null; echo "update exit code: $?"
chmod 600 /var/lib/aide/lab/aide.db && cp /var/lib/aide/lab/aide.db.new /var/lib/aide/lab/aide.db && chmod 400 /var/lib/aide/lab/aide.db
sha256sum /var/lib/aide/lab/aide.db > /root/offhost/aide-db.sha256
aide --config=/etc/aide/aide-lab.conf --check >/dev/null; echo "post-update check exit code: $?"

echo '=== block 9 ==='
cat > /etc/cron.d/aide-lab <<'EOF'
# Daily FIM check at 03:15, results to syslog for the SIEM
15 3 * * * root /usr/bin/aide --config=/etc/aide/aide-lab.conf --check 2>&1 | /usr/bin/logger -t aide-lab
EOF
/usr/bin/aide --config=/etc/aide/aide-lab.conf --check 2>&1 | /usr/bin/logger -t aide-lab
journalctl -t aide-lab --no-pager -n 20 | grep -iE 'differences|Changed entries' | head -3

echo '=== block 10 ==='
aide --config=/etc/aide/aide-lab.conf --check >/dev/null; echo "exit=$?"
echo "drift" >> /srv/webapp/app.ini
aide --config=/etc/aide/aide-lab.conf --check | grep -c 'app.ini'
sed -i '$d' /srv/webapp/app.ini
