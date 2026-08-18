#!/usr/bin/env bash
# Lab 31 — Risk Register, CVSS Scoring, and Quantitative Risk
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
mkdir -p ~/grc && cd ~/grc
cat > risk-register.csv <<'EOF'
id,asset,threat,vuln,likelihood,impact,owner,strategy,status
R-001,web-prod,SQL injection,unsanitised input,High,High,webops,Mitigate,Open
R-002,db-prod,Ransomware,no off-site backup,Medium,Critical,dbops,Mitigate,Open
R-003,laptop-fleet,Theft,no FDE,High,Medium,it,Mitigate,In-progress
R-004,paypal-spoof,Phishing,no DMARC reject,High,High,security,Mitigate,Open
R-005,legacy-app,Vendor EOL,no patches,Low,High,procurement,Transfer,Accepted
EOF
column -t -s, risk-register.csv

echo '=== block 2 ==='
python3 - <<'EOF'
AV, EF, ARO = 200000, 0.6, 0.5
SLE = AV * EF
ALE = SLE * ARO
print(f"SLE = {SLE:,.0f}")
print(f"ALE = {ALE:,.0f} per year")
print(f"Spend up to {ALE:,.0f} on a control to break even.")
EOF

echo '=== block 3 ==='
cat > kri.csv <<'EOF'
risk_id,indicator,threshold,current,status
R-001,WAF block rate,>0,124/day,Green
R-002,Days since last off-site backup,<7,2,Green
R-003,Laptops without FDE,<5%,12%,Red
R-004,DMARC policy,reject,quarantine,Amber
EOF
column -t -s, kri.csv

echo '=== block 4 ==='
python3 - <<'EOF' > board-report.md
print("# Quarterly Risk Report")
print("- Total open risks: 4")
print("- Critical: 1 (SQLi)")
print("- High: 2 (Phishing, Laptop FDE)")
print("- Medium: 1 (Ransomware backup gap)")
print("- ALE exposure (top 4): SGD 240,000")
print("- Recommended spend: SGD 35,000")
EOF
cat board-report.md

