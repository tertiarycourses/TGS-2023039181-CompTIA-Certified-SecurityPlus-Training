#!/usr/bin/env bash
# Lab 36 — Security Awareness: Run a Phishing Simulation with GoPhish
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y unzip curl
cd /opt
curl -LO https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip
unzip -o gophish-v0.12.1-linux-64bit.zip -d gophish
cd gophish && chmod +x gophish

echo '=== block 2 ==='
sed -i 's/127.0.0.1:3333/0.0.0.0:3333/' config.json
./gophish 2>&1 | grep -E "admin|password" | head -3

echo '=== block 3 ==='
apt install -y docker.io && systemctl start docker
docker run -d -p 1025:1025 -p 8025:8025 mailhog/mailhog

