#!/usr/bin/env bash
# Lab 45 — Governance: Policies, Standards, Procedures
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y libpam-pwquality
mkdir -p ~/governance && cd ~/governance

echo '=== block 2 ==='
cd ~/governance
cat > aup.md <<'EOF'
# Acceptable Use Policy (POLICY)
Owner: CISO   Review: annual
1. Company systems are for authorised business use only.
2. Users must not share credentials or disable security controls.
3. All activity on company systems may be monitored and logged.
4. Suspected security incidents must be reported within 1 hour.
EOF
cat aup.md

echo '=== block 3 ==='
cd ~/governance
cat > password-standard.md <<'EOF'
# Password Standard (STANDARD — implements the AUP)
Owner: Security Engineering   Review: annual
- Minimum length: 12 characters
- Must include upper, lower and digit character classes
- Reject dictionary words and the username
- Enforced technically via pam_pwquality
EOF
cat password-standard.md

echo '=== block 4 ==='
sed -i 's/^#\?\s*minlen.*/minlen = 12/' /etc/security/pwquality.conf
sed -i 's/^#\?\s*minclass.*/minclass = 3/' /etc/security/pwquality.conf
grep -E '^(minlen|minclass)' /etc/security/pwquality.conf
# Prove it rejects a weak password (non-interactive check):
echo 'short' | pwscore || echo "REJECTED: weak password blocked by the standard"

echo '=== block 5 ==='
printf '%s\n' 'AUTHORISED USE ONLY. Activity on this system is monitored and logged.' > /etc/issue.net
printf '%s\n' 'AUTHORISED USE ONLY. Activity on this system is monitored and logged.' > /etc/issue
cat /etc/issue.net

echo '=== block 6 ==='
cd ~/governance
cat > onboarding.md <<'EOF'
# Onboarding Procedure (PROCEDURE)
Role: IT Service Desk   Trigger: HR new-joiner ticket
1. Create the account with least privilege only.
2. Add to role groups the manager approved in writing.
3. Issue MFA token and record the serial.
4. Capture signed AUP acknowledgement.
5. Record completion in the asset register.
EOF
cat onboarding.md

echo '=== block 7 ==='
cat > /etc/sudoers.d/helpdesk <<'EOF'
# Help desk may restart web services only — least privilege
%helpdesk ALL=(root) /usr/bin/systemctl restart nginx, /usr/bin/systemctl status nginx
EOF
chmod 440 /etc/sudoers.d/helpdesk
visudo -cf /etc/sudoers.d/helpdesk

echo '=== block 8 ==='
cd ~/governance
cat > raci.csv <<'EOF'
data_set,owner,controller,processor,custodian_steward
Customer PII,Head of Sales,Company (us),Cloud CRM vendor,DBA team
Payroll data,Head of HR,Company (us),Payroll provider,HR systems admin
EOF
column -t -s, raci.csv

echo '=== block 9 ==='
grep -E '^(minlen|minclass)' /etc/security/pwquality.conf
echo 'password' | pwscore || echo "weak password correctly REJECTED"
cat /etc/issue.net
visudo -cf /etc/sudoers.d/helpdesk && echo "sudoers OK"
column -t -s, ~/governance/raci.csv
