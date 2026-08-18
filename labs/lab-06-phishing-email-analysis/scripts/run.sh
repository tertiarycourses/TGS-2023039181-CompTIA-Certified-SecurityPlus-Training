#!/usr/bin/env bash
# Lab 6 — Phishing Email Header Analysis (SPF / DKIM / DMARC)
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y dnsutils swaks

echo '=== block 2 ==='
cat > mail.eml <<'EOF'
Return-Path: <attacker@evil.example>
Received: from mail.evil.example (1.2.3.4) by mx.victim.com
Authentication-Results: mx.victim.com;
 spf=fail (sender IP is 1.2.3.4) smtp.mailfrom=paypal.com;
 dkim=none;
 dmarc=fail action=quarantine header.from=paypal.com
From: "PayPal Security" <service@paypal.com>
To: bob@victim.com
Subject: Urgent: verify your account
EOF
cat mail.eml

echo '=== block 3 ==='
dig +short TXT paypal.com | grep spf

echo '=== block 4 ==='
dig +short TXT _dmarc.paypal.com

echo '=== block 5 ==='
dig +short TXT s1024._domainkey.paypal.com

echo '=== block 6 ==='
swaks --to test@example.com --from spoof@paypal.com \
      --server localhost --suppress-data --quit-after RCPT 2>&1 | head

