#!/usr/bin/env bash
# Lab 27 — File Integrity Monitoring with AIDE
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y aide
aide --version

echo '=== block 2 ==='
cat > /etc/aide/aide.conf.d/99_lab <<'EOF'
# Debian/Ubuntu AIDE ships no LSPP/NORMAL macro, so define our own check groups
LAB_NORMAL = p+i+n+u+g+s+m+c+sha256
LAB_STRICT = p+i+n+u+g+s+b+m+c+acl+xattrs+sha256+sha512
/etc/passwd  LAB_NORMAL
/etc/shadow  LAB_NORMAL
/etc/sudoers LAB_NORMAL
/usr/bin     LAB_STRICT
/usr/sbin    LAB_STRICT
EOF

echo '=== block 3 ==='
aideinit -y -f
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
ls -lh /var/lib/aide/aide.db

echo '=== block 4 ==='
aide --check | head -10

echo '=== block 5 ==='
echo "# tampered $(date)" >> /etc/sudoers
useradd -m attacker
aide --check 2>&1 | head -25

echo '=== block 6 ==='
aide --update -B 'database_new=file:/var/lib/aide/aide.db.new'
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

echo '=== block 7 ==='
cat > /etc/cron.daily/aide-check <<'EOF'
#!/bin/sh
/usr/bin/aide --check | logger -t aide
EOF
chmod +x /etc/cron.daily/aide-check

