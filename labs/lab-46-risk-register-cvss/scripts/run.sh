#!/usr/bin/env bash
# Lab 46 — Risk Register, CVSS Scoring, and Quantitative Risk
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
mkdir -p ~/grc && cd ~/grc
cat > risk-register.csv <<'EOF'
id,asset,threat,vuln,likelihood,impact,owner,strategy,status
R-001,web-prod,SQL injection,unsanitised input,High,High,webops,Mitigate,Open
R-002,db-prod,Ransomware,no off-site backup,Medium,Critical,dbops,Mitigate,Open
R-003,laptop-fleet,Theft,no FDE,High,Medium,it,Mitigate,In-progress
R-004,mail,Phishing,no DMARC reject,High,High,security,Mitigate,Open
R-005,legacy-app,Vendor EOL,no patches,Low,High,procurement,Transfer,Accepted
EOF
column -t -s, risk-register.csv

echo '=== block 2 ==='
cd ~/grc
python3 - <<'EOF'
AV, EF, ARO = 200000, 0.6, 0.5   # value, exposure factor, events/year
SLE = AV * EF
ALE = SLE * ARO
print(f"SLE = {SLE:,.0f} per event")
print(f"ALE = {ALE:,.0f} per year")
print(f"Spend up to {ALE:,.0f} on a control to break even.")
EOF

echo '=== block 3 ==='
cd ~/grc
cat > kri.csv <<'EOF'
risk_id,indicator,threshold,current,status
R-001,WAF block rate,>0/day,124/day,Green
R-002,Days since off-site backup,<7,2,Green
R-003,Laptops without FDE,<5%,12%,Red
R-004,DMARC policy,=reject,quarantine,Amber
EOF
column -t -s, kri.csv

echo '=== block 4 ==='
cd ~/grc
python3 - > board-report.md <<'EOF'
print("# Quarterly Risk Report")
print("- Open risks: 4 (1 Critical, 2 High, 1 Medium)")
print("- Top exposure: R-001 SQLi, ALE 60,000/yr, CVSS 9.8")
print("- Recommended spend: 35,000 across top 4 (all < their ALE)")
print("- Accepted: R-005 (signed off by risk owner, review in 6 months)")
EOF
cat board-report.md

echo '=== block 5 ==='
cd ~/grc
python3 -c "print('ALE =', 200000*0.6*0.5)"
cat board-report.md
