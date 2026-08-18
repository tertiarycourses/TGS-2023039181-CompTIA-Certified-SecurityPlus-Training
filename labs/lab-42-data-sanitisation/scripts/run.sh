#!/usr/bin/env bash
# Lab 42 — Secure Data Sanitisation (Media Disposal)
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
dd if=/dev/zero of=/disk.img bs=1M count=50 && echo "TOP-SECRET-DATA" >> /disk.img

echo '=== block 2 ==='
strings /disk.img | grep TOP-SECRET && echo FOUND

echo '=== block 3 ==='
shred -v -n 3 -z /disk.img

echo '=== block 4 ==='
strings /disk.img | grep TOP-SECRET || echo "SANITISED — not recoverable"

echo '=== block 5 ==='
echo "Method: 3-pass overwrite + zero (NIST 800-88 clear)"

