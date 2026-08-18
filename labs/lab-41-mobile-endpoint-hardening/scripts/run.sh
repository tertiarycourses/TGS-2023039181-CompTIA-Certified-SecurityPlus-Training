#!/usr/bin/env bash
# Lab 41 — Mobile & Endpoint Hardening Baseline
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
sed -i "s/^PASS_MIN_LEN.*/PASS_MIN_LEN 12/" /etc/login.defs 2>/dev/null; grep PASS_ /etc/login.defs

echo '=== block 2 ==='
sed -i "s/^#*PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config

echo '=== block 3 ==='
echo "TMOUT=600; readonly TMOUT" > /etc/profile.d/timeout.sh

echo '=== block 4 ==='
systemctl disable --now avahi-daemon 2>/dev/null; echo done

echo '=== block 5 ==='
grep PermitRootLogin /etc/ssh/sshd_config && cat /etc/profile.d/timeout.sh

