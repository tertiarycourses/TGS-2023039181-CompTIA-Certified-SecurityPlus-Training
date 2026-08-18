#!/usr/bin/env bash
# Lab 38 — Container Security with Docker
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt install -y docker.io && docker run -d --name web nginx

echo '=== block 2 ==='
docker exec web whoami

echo '=== block 3 ==='
docker run -d --name safe --user 1000 --cap-drop ALL --read-only nginx 2>&1 | tail -1

echo '=== block 4 ==='
docker exec safe touch /tmp/x 2>&1 || echo "READ-ONLY enforced"

echo '=== block 5 ==='
trivy image --severity HIGH,CRITICAL nginx | head -30

echo '=== block 6 ==='
docker run -d --name capped --memory 128m --cpus 0.5 nginx

