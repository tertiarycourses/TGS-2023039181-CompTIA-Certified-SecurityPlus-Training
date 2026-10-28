#!/usr/bin/env bash
# Lab 23 — Data Classification and Data Loss Prevention
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y python3 openssl acl
mkdir -p /srv/lab23/{data,out,vault} && cd /srv/lab23

echo '=== block 2 ==='
cd /srv/lab23/data
cat > press-release.txt <<'EOF'
FOR IMMEDIATE RELEASE - Example Pte Ltd opens new Jurong office.
Media contact: media@example.com
Customer quote supplied by Tan Ah Kow (NRIC S1234567D) - approved for release.
EOF
cat > staff-memo.txt <<'EOF'
Internal memo: the office will close early on Friday. Questions to hr-team@example.com
EOF
cat > hr-salaries.csv <<'EOF'
name,nric_fin,email,monthly_salary
Tan Ah Kow,S1234567D,ahkow.tan@example.com,6200
Priya Raman,T0123456G,priya.r@example.com,7400
Li Wei,G1234567X,li.wei@example.com,5800
Maria Santos,M1234567K,maria.s@example.com,5100
EOF
cat > payments.csv <<'EOF'
order_id,cardholder,card_number,expiry
ORD-1001,Tan Ah Kow,4111111111111111,12/28
ORD-1002,Priya Raman,5555555555554444,03/27
ORD-1003,Li Wei,378282246310005,09/29
ORD-1004,Test Typo,4111111111111112,01/27
EOF
cat > product-formula.txt <<'EOF'
Trade secret: SuperGlue v7 cure ratio 3:1 at 42C for 90 seconds. Do not distribute.
EOF
ls -l

echo '=== block 3 ==='
cd /srv/lab23
cat > labels.csv <<'EOF'
file,classification
press-release.txt,Public
staff-memo.txt,Private
hr-salaries.csv,Confidential
payments.csv,Restricted
product-formula.txt,Confidential
EOF
column -s, -t labels.csv 2>/dev/null || cat labels.csv

echo '=== block 4 ==='
cat > /srv/lab23/dlp_scan.py <<'EOF'
#!/usr/bin/env python3
"""Minimal content-inspection DLP scanner for Lab 23 (synthetic data only).
Usage: dlp_scan.py <folder> [labels.csv]   (files without a label are treated as Public)"""
import csv, re, sys, pathlib

NRIC = re.compile(r"\b[STFGM]\d{7}[A-Z]\b")
EMAIL = re.compile(r"\b[\w.+-]+@[\w-]+(?:\.[\w-]+)+\b")
CARD = re.compile(r"\b\d(?:[ -]?\d){12,18}\b")

def luhn_ok(candidate):
    digits = [int(c) for c in candidate if c.isdigit()]
    total = 0
    for i, d in enumerate(reversed(digits)):
        if i % 2 == 1:
            d *= 2
            if d > 9:
                d -= 9
        total += d
    return 13 <= len(digits) <= 19 and total % 10 == 0

# What each classification is allowed to contain
ALLOWED = {"Public": {"EMAIL"}, "Private": {"EMAIL"},
           "Confidential": {"EMAIL", "NRIC"}, "Restricted": {"EMAIL", "NRIC", "CARD"}}

def scan(text):
    hits = {"NRIC": NRIC.findall(text), "EMAIL": EMAIL.findall(text),
            "CARD": [c for c in CARD.findall(text) if luhn_ok(c)]}
    return {k: v for k, v in hits.items() if v}

folder = pathlib.Path(sys.argv[1])
labels = {}
if len(sys.argv) > 2:
    labels = {r["file"]: r["classification"] for r in csv.DictReader(open(sys.argv[2]))}
violations = 0
for f in sorted(p for p in folder.iterdir() if p.is_file()):
    label = labels.get(f.name, "Public")
    hits = scan(f.read_text(errors="ignore"))
    bad = set(hits) - ALLOWED[label]
    summary = ", ".join(f"{k} x{len(v)}" for k, v in hits.items()) or "no sensitive data"
    status = "VIOLATION" if bad else "ok"
    violations += bool(bad)
    print(f"[{status:9}] {f.name:24} label={label:12} found: {summary}")
    for k in sorted(bad):
        print(f"            -> {k} not permitted in {label} data: {hits[k]}")
print(f"Files with policy violations: {violations}")
sys.exit(1 if violations else 0)
EOF
chmod 755 /srv/lab23/dlp_scan.py
python3 -c "import py_compile; py_compile.compile('/srv/lab23/dlp_scan.py', doraise=True)" && echo "Scanner compiles"

echo '=== block 5 ==='
cd /srv/lab23
python3 dlp_scan.py data labels.csv

echo '=== block 6 ==='
cat > /srv/lab23/protect.py <<'EOF'
#!/usr/bin/env python3
"""Masking and tokenisation helpers for Lab 23."""
import csv, json, secrets, sys
BASE = "/srv/lab23"
def mask_nric(v):  return v[0] + "****" + v[-4:]            # S1234567D -> S****567D
def mask_email(v): return v[0] + "***@" + v.split("@", 1)[1]
if len(sys.argv) > 2 and sys.argv[1] == "detok":
    print(json.load(open(f"{BASE}/vault/tokens.json")).get(sys.argv[2], "UNKNOWN TOKEN"))
    sys.exit()
with open(f"{BASE}/data/hr-salaries.csv") as src, open(f"{BASE}/out/hr-masked.csv", "w", newline="") as dst:
    rows = list(csv.DictReader(src))
    w = csv.DictWriter(dst, fieldnames=rows[0].keys()); w.writeheader()
    for r in rows:
        r["nric_fin"], r["email"] = mask_nric(r["nric_fin"]), mask_email(r["email"])
        w.writerow(r)
vault = {}
with open(f"{BASE}/data/payments.csv") as src, open(f"{BASE}/out/payments-tokenised.csv", "w", newline="") as dst:
    rows = list(csv.DictReader(src))
    w = csv.DictWriter(dst, fieldnames=rows[0].keys()); w.writeheader()
    for r in rows:
        token = "tok_" + secrets.token_hex(8)
        vault[token] = r["card_number"]
        r["card_number"] = token + "-last4-" + r["card_number"][-4:]
        w.writerow(r)
json.dump(vault, open(f"{BASE}/vault/tokens.json", "w"), indent=1)
print("Wrote out/hr-masked.csv, out/payments-tokenised.csv and vault/tokens.json")
EOF
cd /srv/lab23 && python3 protect.py
chmod 700 vault && chmod 600 vault/tokens.json
head -3 out/hr-masked.csv; head -3 out/payments-tokenised.csv
TOKEN=$(awk -F, 'NR==2{split($3,a,"-last4-"); print a[1]}' out/payments-tokenised.csv)
echo "Detokenise $TOKEN -> $(python3 protect.py detok "$TOKEN")"

echo '=== block 7 ==='
cd /srv/lab23
openssl rand -hex 32 > vault/hmac.key && chmod 600 vault/hmac.key
python3 - <<'EOF'
import hashlib, hmac, itertools, string
target = hashlib.sha256(b"S1234567D").hexdigest()
print("Plain SHA-256 of the NRIC:", target[:16], "...")
# Attacker knows the first 5 digits (e.g. from birth year); tries the remaining 2 digits and the check letter
for d1, d2, letter in itertools.product(string.digits, string.digits, string.ascii_uppercase):
    guess = f"S12345{d1}{d2}{letter}"
    if hashlib.sha256(guess.encode()).hexdigest() == target:
        print("Brute-forced in at most 2600 guesses ->", guess)
        break
key = open("/srv/lab23/vault/hmac.key").read().strip().encode()
print("HMAC-SHA256 pseudonym   :", hmac.new(key, b"S1234567D", "sha256").hexdigest()[:16], "... (needs the key)")
EOF
python3 - <<'EOF'
import csv, hmac
key = open("/srv/lab23/vault/hmac.key").read().strip().encode()
rows = list(csv.DictReader(open("/srv/lab23/data/hr-salaries.csv")))
with open("/srv/lab23/out/hr-pseudonymised.csv", "w", newline="") as f:
    w = csv.writer(f); w.writerow(["person_id", "monthly_salary"])
    for r in rows:
        w.writerow([hmac.new(key, r["nric_fin"].encode(), "sha256").hexdigest()[:20], r["monthly_salary"]])
print(open("/srv/lab23/out/hr-pseudonymised.csv").read())
EOF

echo '=== block 8 ==='
cd /srv/lab23
groupadd -f hr
id analyst >/dev/null 2>&1 || useradd -m -s /bin/bash analyst
chown root:root data/press-release.txt data/staff-memo.txt && chmod 644 data/press-release.txt data/staff-memo.txt
chown root:hr data/hr-salaries.csv data/product-formula.txt && chmod 640 data/hr-salaries.csv data/product-formula.txt
chown root:root data/payments.csv && chmod 600 data/payments.csv
ls -l data
su - analyst -c 'head -1 /srv/lab23/data/press-release.txt'
su - analyst -c 'cat /srv/lab23/data/hr-salaries.csv' 2>&1 | head -1
usermod -aG hr analyst
su - analyst -c 'head -2 /srv/lab23/data/hr-salaries.csv'
su - analyst -c 'cat /srv/lab23/data/payments.csv /srv/lab23/vault/tokens.json' 2>&1 | head -2

echo '=== block 9 ==='
cd /srv/lab23
python3 dlp_scan.py out && echo "Sanitised output is safe to share"

echo '=== block 10 ==='
cd /srv/lab23
python3 dlp_scan.py data labels.csv | tail -1
python3 dlp_scan.py out | tail -1
su - analyst -c 'cat /srv/lab23/data/payments.csv' 2>&1 | grep -c "Permission denied"
