#!/usr/bin/env bash
# Lab 52 — Security Awareness: Phishing Simulation
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y unzip curl
mkdir -p /opt/gophish && cd /opt/gophish
curl -sLO https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip
unzip -o gophish-v0.12.1-linux-64bit.zip && chmod +x gophish

echo '=== block 2 ==='
cd /opt/gophish
sed -i 's/127.0.0.1:3333/0.0.0.0:3333/' config.json
grep admin_server config.json

echo '=== block 3 ==='
cd /opt/gophish
(./gophish > gophish.log 2>&1 &) ; sleep 5
grep -iE "please login|admin|password" gophish.log | head -3

echo '=== block 4 ==='
apt-get install -y docker.io && (service docker start || systemctl start docker)
docker run -d -p 1025:1025 -p 8025:8025 mailhog/mailhog
docker ps | grep mailhog

echo '=== block 5 ==='
curl -s http://127.0.0.1:8025/api/v2/messages | head -c 200; echo
docker ps | grep -q mailhog && echo "MailHog sink running"
