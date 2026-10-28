#!/usr/bin/env bash
# Lab 28 — Mobile and Endpoint Hardening Baseline
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y libpam-pwquality libpwquality-tools dconf-cli cryptsetup jq

echo '=== block 2 ==='
mkdir -p /etc/baseline
cat > /etc/baseline/endpoint-baseline.json <<'EOF'
{
  "policy": "SecPlus-ENDPOINT-BASELINE v1.0",
  "passcode":    {"min_length": 12, "min_classes": 3, "max_age_days": 90},
  "screen_lock": {"idle_seconds": 300, "user_can_change": false},
  "encryption":  {"required": true, "examples": "LUKS2, BitLocker, FileVault, Android/iOS device encryption"},
  "apps":        {"deny_list": ["telnet", "inetutils-telnet", "rsh-client"], "sideloading": "blocked"},
  "radios":      {"bluetooth": "disabled unless an exception is approved", "wifi": "WPA3-Enterprise only"},
  "integrity":   {"root_or_jailbreak_detection": true, "uid0_accounts_allowed": 1}
}
EOF
cat > /etc/baseline/corp-wifi-wpa3.conf <<'EOF'
# Wi-Fi profile an MDM would push (wpa_supplicant syntax). WPA3-Enterprise, EAP-TLS, PMF required.
# For WPA3-Personal you would use key_mgmt=SAE with a passphrase instead of 802.1X.
network={
    ssid="CORP-SECURE"
    key_mgmt=WPA-EAP-SHA256
    ieee80211w=2
    eap=TLS
    identity="alice@corp.example"
    ca_cert="/etc/baseline/radius-ca.pem"
    client_cert="/etc/baseline/alice.pem"
    private_key="/etc/baseline/alice.key"
}
EOF
jq . /etc/baseline/endpoint-baseline.json

echo '=== block 3 ==='
mkdir -p /etc/security/pwquality.conf.d
cat > /etc/security/pwquality.conf.d/50-baseline.conf <<'EOF'
minlen = 12
minclass = 3
dictcheck = 1
retry = 3
EOF
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/; s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs
grep -E '^PASS_(MAX|MIN)_DAYS' /etc/login.defs
echo 'Summer24' | pwscore || echo "-> rejected by the baseline"
echo 'Cobalt-Harbour-Lantern-81' | pwscore

echo '=== block 4 ==='
cat > /etc/profile.d/99-idle-lock.sh <<'EOF'
# Baseline: terminate idle interactive shells after 600 seconds
TMOUT=600
readonly TMOUT
export TMOUT
EOF
mkdir -p /etc/dconf/profile /etc/dconf/db/local.d/locks
printf 'user-db:user\nsystem-db:local\n' > /etc/dconf/profile/user
cat > /etc/dconf/db/local.d/00-screenlock <<'EOF'
[org/gnome/desktop/session]
idle-delay=uint32 300

[org/gnome/desktop/screensaver]
lock-enabled=true
lock-delay=uint32 0
EOF
cat > /etc/dconf/db/local.d/locks/screenlock <<'EOF'
/org/gnome/desktop/session/idle-delay
/org/gnome/desktop/screensaver/lock-enabled
/org/gnome/desktop/screensaver/lock-delay
EOF
dconf update && ls -l /etc/dconf/db/local

echo '=== block 5 ==='
truncate -s 32M /root/secure-folder.img
head -c 64 /dev/urandom > /root/secure-folder.key && chmod 600 /root/secure-folder.key
cryptsetup luksFormat --batch-mode --type luks2 /root/secure-folder.img /root/secure-folder.key
cryptsetup isLuks /root/secure-folder.img && echo "secure-folder.img is LUKS-encrypted"
cryptsetup luksDump /root/secure-folder.img | grep -iE '^version|cipher:|pbkdf:' | head -4

echo '=== block 6 ==='
cat > /etc/apt/preferences.d/99-baseline-deny-list <<'EOF'
Package: telnet inetutils-telnet rsh-client
Pin: release *
Pin-Priority: -1
EOF
apt-cache policy telnet | head -3
mkdir -p /mnt/downloads
mountpoint -q /mnt/downloads || mount -t tmpfs -o size=16m,noexec,nosuid,nodev tmpfs /mnt/downloads
printf '#!/bin/sh\necho "sideloaded app is running"\n' > /mnt/downloads/freegame.sh
chmod +x /mnt/downloads/freegame.sh
/mnt/downloads/freegame.sh || echo "BLOCKED: the untrusted location is mounted noexec"

echo '=== block 7 ==='
cat > /etc/modprobe.d/99-baseline-bluetooth.conf <<'EOF'
# Baseline: Bluetooth disabled unless a documented exception exists
install bluetooth /bin/false
install btusb /bin/false
EOF
systemctl disable --now bluetooth.service 2>/dev/null || echo "no bluetooth service on this host"
ss -tulpn | awk 'NR==1 || /LISTEN/'
awk -F: '$3==0 {print "UID 0 account:", $1}' /etc/passwd
find / -xdev -perm -4000 -type f 2>/dev/null | sort > /etc/baseline/suid-baseline.txt
wc -l /etc/baseline/suid-baseline.txt

echo '=== block 8 ==='
cat > /usr/local/sbin/baseline-check <<'EOF'
#!/bin/bash
# MDM-style compliance check against /etc/baseline/endpoint-baseline.json
pass=0; fail=0
check() { if eval "$2" >/dev/null 2>&1; then echo "PASS  $1"; pass=$((pass+1)); else echo "FAIL  $1"; fail=$((fail+1)); fi; }
check "Passcode minimum length >= 12" "grep -Eq '^minlen *= *(1[2-9]|[2-9][0-9])' /etc/security/pwquality.conf.d/50-baseline.conf"
check "Password maximum age <= 90 days" "awk '/^PASS_MAX_DAYS/ {exit !(\$2<=90)}' /etc/login.defs"
check "Idle shell timeout configured" "grep -q '^TMOUT=' /etc/profile.d/99-idle-lock.sh"
check "Desktop screen lock locked" "test -s /etc/dconf/db/local.d/locks/screenlock"
check "Secure folder encrypted" "cryptsetup isLuks /root/secure-folder.img"
check "Telnet blocked by deny-list" "apt-cache policy telnet | grep -q 'Candidate: (none)'"
check "Sideload path mounted noexec" "findmnt -no OPTIONS /mnt/downloads | grep -q noexec"
check "Bluetooth module disabled" "grep -q '^install bluetooth /bin/false' /etc/modprobe.d/99-baseline-bluetooth.conf"
check "Only root has UID 0" "test \$(awk -F: '\$3==0' /etc/passwd | wc -l) -eq 1"
echo "Result: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
EOF
chmod 755 /usr/local/sbin/baseline-check
baseline-check | tee /etc/baseline/compliance-report.txt

echo '=== block 9 ==='
baseline-check; echo "exit=$?"
umount /mnt/downloads && baseline-check; echo "exit=$?"
mount -t tmpfs -o size=16m,noexec,nosuid,nodev tmpfs /mnt/downloads && baseline-check | tail -1
