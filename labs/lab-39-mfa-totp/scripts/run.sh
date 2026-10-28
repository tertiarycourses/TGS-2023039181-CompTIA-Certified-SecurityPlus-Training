#!/usr/bin/env bash
# Lab 39 — Multifactor Authentication with TOTP
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y libpam-google-authenticator oathtool qrencode pamtester openssh-server

echo '=== block 2 ==='
id mfauser >/dev/null 2>&1 || useradd -m -s /bin/bash mfauser
echo 'mfauser:Labs-Pass-2026' | chpasswd
sudo -u mfauser google-authenticator -t -d -f -r 10 -R 30 -w 3 -e 5 -q -s /home/mfauser/.google_authenticator
ls -l /home/mfauser/.google_authenticator

echo '=== block 3 ==='
SECRET=$(head -1 /home/mfauser/.google_authenticator)
echo "Shared secret (Base32): $SECRET"
grep '^"' /home/mfauser/.google_authenticator
URI="otpauth://totp/SecPlus-Lab:mfauser?secret=${SECRET}&issuer=SecPlus-Lab&digits=6&period=30"
echo "$URI"
qrencode -t ANSIUTF8 "$URI"

echo '=== block 4 ==='
SECRET=$(head -1 /home/mfauser/.google_authenticator)
oathtool --totp -b "$SECRET"
oathtool --totp -b -w 2 "$SECRET"
oathtool --hotp -b -c 0 -w 2 "$SECRET"
date -u +%s | awk '{print "Seconds left in this time step:", 30 - ($1 % 30)}'

echo '=== block 5 ==='
cat > /etc/pam.d/mfa-lab <<'EOF'
# Factor 1 (know) + factor 2 (have): password immediately followed by the 6-digit TOTP code
auth    required    pam_google_authenticator.so forward_pass
auth    required    pam_unix.so use_first_pass
account required    pam_unix.so
EOF
cat /etc/pam.d/mfa-lab

echo '=== block 6 ==='
echo 'Labs-Pass-2026' | pamtester mfa-lab mfauser authenticate || echo "REJECTED: password only"
echo 'Labs-Pass-2026000000' | pamtester mfa-lab mfauser authenticate || echo "REJECTED: password + wrong code"

echo '=== block 7 ==='
SECRET=$(head -1 /home/mfauser/.google_authenticator)
CODE=$(oathtool --totp -b "$SECRET")
echo "Labs-Pass-2026${CODE}" | pamtester mfa-lab mfauser authenticate && echo "ACCEPTED: password + current code"
echo "Labs-Pass-2026${CODE}" | pamtester mfa-lab mfauser authenticate || echo "REJECTED: replay of a used code"
SCRATCH=$(grep -E '^[0-9]{8}$' /home/mfauser/.google_authenticator | head -1)
echo "Labs-Pass-2026${SCRATCH}" | pamtester mfa-lab mfauser authenticate && echo "ACCEPTED: backup code (now burned)"
grep -cE '^[0-9]{8}$' /home/mfauser/.google_authenticator

echo '=== block 8 ==='
cp -n /etc/pam.d/sshd /root/sshd.pam.bak
grep -q pam_google_authenticator /etc/pam.d/sshd || echo 'auth required pam_google_authenticator.so nullok' >> /etc/pam.d/sshd
echo 'KbdInteractiveAuthentication yes' > /etc/ssh/sshd_config.d/60-mfa.conf
grep -q 'Match User mfauser' /etc/ssh/sshd_config || printf '\nMatch User mfauser\n    AuthenticationMethods keyboard-interactive\n' >> /etc/ssh/sshd_config
sshd -t && systemctl restart ssh && echo "sshd config valid and reloaded"

echo '=== block 9 ==='
SECRET=$(head -1 /home/mfauser/.google_authenticator)
echo 'Labs-Pass-2026' | pamtester mfa-lab mfauser authenticate || echo "PASS: password alone rejected"
sleep 31
echo "Labs-Pass-2026$(oathtool --totp -b "$SECRET")" | pamtester mfa-lab mfauser authenticate && echo "PASS: both factors accepted"
sshd -T -C user=mfauser,host=localhost,addr=127.0.0.1 | grep -i authenticationmethods
