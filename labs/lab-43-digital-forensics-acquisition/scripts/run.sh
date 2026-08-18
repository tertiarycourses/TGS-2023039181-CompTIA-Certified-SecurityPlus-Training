#!/usr/bin/env bash
# Lab 43 — Digital Forensics — Evidence Acquisition & Hashing
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
dd if=/dev/zero of=/ev.img bs=1M count=20; mkfs.ext4 /ev.img; mkdir -p /m; mount /ev.img /m; echo secret > /m/evidence.txt; rm /m/evidence.txt; umount /m

echo '=== block 2 ==='
dd if=/ev.img of=/case01.dd bs=512 conv=noerror,sync

echo '=== block 3 ==='
sha256sum /case01.dd | tee /case01.sha256

echo '=== block 4 ==='
apt install -y foremost && foremost -i /case01.dd -o /recovered 2>&1 | tail -3

echo '=== block 5 ==='
sha256sum -c /case01.sha256

echo '=== block 6 ==='
echo "Collected by: <analyst>  Date: <UTC>  Hash: $(cut -d" " -f1 /case01.sha256)"

