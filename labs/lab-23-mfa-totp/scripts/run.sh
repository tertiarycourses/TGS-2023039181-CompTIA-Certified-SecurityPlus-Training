#!/usr/bin/env bash
# Lab 23 — Multi-Factor Authentication with TOTP
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y libpam-google-authenticator qrencode

echo '=== block 2 ==='
useradd -m mfauser && echo 'mfauser:Lab1234!' | chpasswd
sudo -u mfauser google-authenticator -t -d -f -r 3 -R 30 -W -q -s /home/mfauser/.google_authenticator
cat /home/mfauser/.google_authenticator | head -2

echo '=== block 3 ==='
SECRET=$(head -1 /home/mfauser/.google_authenticator)
qrencode -t ANSI "otpauth://totp/lab:mfauser?secret=$SECRET&issuer=lab"

echo '=== block 4 ==='
echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd
sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*KbdInteractiveAuthentication.*/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config
echo "AuthenticationMethods publickey,keyboard-interactive" >> /etc/ssh/sshd_config
systemctl restart ssh

echo '=== block 5 ==='
apt install -y oathtool
oathtool --totp -b "$SECRET"

