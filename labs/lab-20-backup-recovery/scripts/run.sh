#!/usr/bin/env bash
# Lab 20 — Backup and Recovery with restic
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y restic
restic version

echo '=== block 2 ==='
mkdir -p /data /backup
for i in $(seq 1 5); do echo "important record $i" > /data/rec$i.txt; done

export RESTIC_PASSWORD='Lab1234!'
restic -r /backup init

echo '=== block 3 ==='
restic -r /backup backup /data
restic -r /backup snapshots

echo '=== block 4 ==='
echo "edit" >> /data/rec1.txt
echo "new record" > /data/rec6.txt
restic -r /backup backup /data
restic -r /backup snapshots

echo '=== block 5 ==='
for f in /data/*.txt; do echo "ENCRYPTED_BY_RANSOMWARE" > "$f"; done
ls -l /data && cat /data/rec1.txt

echo '=== block 6 ==='
SNAP=$(restic -r /backup snapshots --json | python3 -c "import sys,json; print(json.load(sys.stdin)[-2]['id'])")
echo "Restoring snapshot $SNAP"
restic -r /backup restore $SNAP --target /restore
diff -r /restore/data /data
ls /restore/data
cat /restore/data/rec1.txt

echo '=== block 7 ==='
# Replace with your B2 credentials, or use a local minio for testing
# export B2_ACCOUNT_ID=... B2_ACCOUNT_KEY=...
# restic -r b2:bucket:/path init

