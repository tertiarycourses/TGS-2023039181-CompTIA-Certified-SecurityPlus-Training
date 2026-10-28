#!/usr/bin/env bash
# Lab 09 — Phishing Email Analysis (SPF / DKIM / DMARC)
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y dnsutils swaks

echo '=== block 2 ==='
cat > mail.eml <<'EOF'
Return-Path: <bounce@mailer-cheap-host.ru>
Received: from unknown (203.0.113.77) by mx.example.com
From: PayPal Service <service@paypal.com>
Subject: Your account has been limited
EOF
cat mail.eml

echo '=== block 3 ==='
grep -Ei 'received|return-path|^from' mail.eml

echo '=== block 4 ==='
dig +short TXT paypal.com | grep -i spf

echo '=== block 5 ==='
dig +short TXT _dmarc.paypal.com

echo '=== block 6 ==='
dig +short TXT selector1._domainkey.paypal.com
dig +short TXT s1._domainkey.paypal.com

echo '=== block 7 ==='
echo "spf=fail  dkim=none  dmarc=fail  =>  message is SPOOFED (phishing)"

echo '=== block 8 ==='
dig +short TXT paypal.com | grep -qi 'v=spf1' && echo "Real SPF record retrieved"
dig +short TXT _dmarc.paypal.com | grep -qi 'p=' && echo "DMARC policy retrieved"
grep -qi '203.0.113.77' mail.eml && echo "Relay IP in header is NOT in the SPF list => SPF fail => spoofed"
