#!/usr/bin/env bash
# Lab 26 — Backup and Recovery with restic
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y restic rsync python3
restic version

echo '=== block 2 ==='
mkdir -p /data /backup /root/lab26
for i in $(seq 1 5); do echo "important record $i - synthetic customer data" > /data/rec$i.txt; done
printf '%s\n' 'Lab26-Backup-Repo-Pass' > /root/lab26/restic.pass && chmod 600 /root/lab26/restic.pass
export RESTIC_REPOSITORY=/backup RESTIC_PASSWORD_FILE=/root/lab26/restic.pass
restic init

echo '=== block 3 ==='
export RESTIC_REPOSITORY=/backup RESTIC_PASSWORD_FILE=/root/lab26/restic.pass
restic backup /data --tag baseline
restic snapshots
grep -r "important record" /backup >/dev/null && echo "PLAINTEXT FOUND" || echo "Repository is encrypted - no plaintext on disk"

echo '=== block 4 ==='
export RESTIC_REPOSITORY=/backup RESTIC_PASSWORD_FILE=/root/lab26/restic.pass
echo "updated balance - synthetic" >> /data/rec1.txt
echo "important record 6 - synthetic customer data" > /data/rec6.txt
restic backup /data --tag daily
read -r OLD NEW <<< "$(restic snapshots --json | python3 -c 'import sys,json; s=json.load(sys.stdin); print(s[-2]["short_id"], s[-1]["short_id"])')"
restic diff "$OLD" "$NEW"

echo '=== block 5 ==='
for f in /data/*.txt; do echo "ENCRYPTED_BY_RANSOMWARE" > "$f"; mv "$f" "$f.locked"; done
echo "Your files are encrypted. Pay 5 BTC to recover them. (lab simulation)" > /data/README_RESTORE.txt
ls /data && cat /data/rec1.txt.locked

echo '=== block 6 ==='
export RESTIC_REPOSITORY=/backup RESTIC_PASSWORD_FILE=/root/lab26/restic.pass
time restic restore latest --target /restore
ls /restore/data && cat /restore/data/rec1.txt
mkdir -p /root/lab26/quarantine && mv /data/*.locked /data/README_RESTORE.txt /root/lab26/quarantine/
cp -a /restore/data/. /data/
ls /data

echo '=== block 7 ==='
export RESTIC_PASSWORD_FILE=/root/lab26/restic.pass
mkdir -p /offsite
rsync -a /backup/ /offsite/
restic -r /offsite check --read-data
restic -r /offsite snapshots

echo '=== block 8 ==='
cat > /etc/cron.d/restic-lab26 <<'EOF'
# Lab 26: back up /data every 4 hours (RPO = 4 h), then replicate off site
RESTIC_REPOSITORY=/backup
RESTIC_PASSWORD_FILE=/root/lab26/restic.pass
0 */4 * * * root restic backup /data --tag scheduled --quiet && rsync -a /backup/ /offsite/
30 2 * * * root restic forget --keep-hourly 24 --keep-daily 7 --keep-weekly 4 --prune --quiet
EOF
chmod 644 /etc/cron.d/restic-lab26 && cat /etc/cron.d/restic-lab26
export RESTIC_REPOSITORY=/backup RESTIC_PASSWORD_FILE=/root/lab26/restic.pass
restic forget --keep-last 1 --dry-run

echo '=== block 9 ==='
export RESTIC_PASSWORD_FILE=/root/lab26/restic.pass
cat /data/rec1.txt
ls /data/*.locked 2>/dev/null | wc -l
restic -r /offsite check && echo "Off-site replica verified"
