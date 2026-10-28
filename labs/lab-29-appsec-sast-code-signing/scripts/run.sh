#!/usr/bin/env bash
# Lab 29 — Application Security: Validation, SAST and Code Signing
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y python3-venv gnupg curl jq
python3 -m venv /opt/sast && /opt/sast/bin/pip install -q bandit
/opt/sast/bin/bandit --version | head -1

echo '=== block 2 ==='
mkdir -p /opt/appsec/vuln
cat > /opt/appsec/vuln/lookup.py <<'EOF'
import hashlib, sqlite3, subprocess, sys

DB_PASSWORD = "Sup3rS3cret!"   # flaw 1: hard-coded secret (synthetic)

def init_db():
    con = sqlite3.connect(":memory:")
    con.execute("CREATE TABLE customers (id INTEGER PRIMARY KEY, name TEXT, card TEXT)")
    con.executemany("INSERT INTO customers (name, card) VALUES (?, ?)",
                    [("alice", "4111-XXXX-XXXX-1111"), ("bob", "5500-XXXX-XXXX-0004"), ("carol", "3400-XXXX-XXXX-0009")])
    return con

def find_customer(con, name):
    query = "SELECT id, name, card FROM customers WHERE name = '%s'" % name   # flaw 2: SQL injection
    return con.execute(query).fetchall()

def ping(host):
    return subprocess.check_output("ping -c 1 " + host, shell=True)           # flaw 3: command injection

def token(user):
    return hashlib.md5(user.encode()).hexdigest()                             # flaw 4: weak hash

def calc(expr):
    return eval(expr)                                                         # flaw 5: code injection

if __name__ == "__main__":
    print(find_customer(init_db(), sys.argv[1]))
EOF
python3 /opt/appsec/vuln/lookup.py alice

echo '=== block 3 ==='
cd /opt/appsec
/opt/sast/bin/bandit -r vuln -f json -o bandit-before.json || echo "Bandit found issues (non-zero exit)"
jq -r '.results[] | "\(.issue_severity)\t\(.test_id)\tline \(.line_number)\t\(.issue_text)"' bandit-before.json
jq '.metrics._totals | {high: ."SEVERITY.HIGH", medium: ."SEVERITY.MEDIUM", low: ."SEVERITY.LOW"}' bandit-before.json

echo '=== block 4 ==='
cd /opt/appsec
python3 vuln/lookup.py "x' OR '1'='1"

echo '=== block 5 ==='
mkdir -p /opt/appsec/fixed
cat > /opt/appsec/fixed/lookup.py <<'EOF'
import ast, hashlib, os, re, sqlite3, subprocess, sys

DB_PASSWORD = os.environ.get("APP_DB_PASSWORD", "")   # secret injected at run time, never in code
NAME_RE = re.compile(r"[a-z]{1,32}")                  # allow-list: lower-case letters only
HOST_RE = re.compile(r"[A-Za-z0-9.-]{1,253}")

def init_db():
    con = sqlite3.connect(":memory:")
    con.execute("CREATE TABLE customers (id INTEGER PRIMARY KEY, name TEXT, card TEXT)")
    con.executemany("INSERT INTO customers (name, card) VALUES (?, ?)",
                    [("alice", "4111-XXXX-XXXX-1111"), ("bob", "5500-XXXX-XXXX-0004"), ("carol", "3400-XXXX-XXXX-0009")])
    return con

def find_customer(con, name):
    if not NAME_RE.fullmatch(name):
        raise ValueError("invalid customer name")
    return con.execute("SELECT id, name, card FROM customers WHERE name = ?", (name,)).fetchall()

def ping(host):
    if not HOST_RE.fullmatch(host):
        raise ValueError("invalid host")
    return subprocess.run(["/usr/bin/ping", "-c", "1", host], capture_output=True, check=False).stdout

def token(user):
    return hashlib.sha256(user.encode()).hexdigest()

def calc(expr):
    return ast.literal_eval(expr)

if __name__ == "__main__":
    try:
        print(find_customer(init_db(), sys.argv[1]))
    except ValueError as err:
        print("REJECTED:", err)
EOF
cd /opt/appsec
python3 fixed/lookup.py alice
python3 fixed/lookup.py "x' OR '1'='1"
/opt/sast/bin/bandit -r fixed -ll && echo "SAST GATE PASSED: no medium or high findings"

echo '=== block 6 ==='
cat > /opt/appsec/cookie_server.py <<'EOF'
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        if self.path == "/insecure":
            self.send_header("Set-Cookie", "session=lab-0001; Path=/")
        else:
            self.send_header("Set-Cookie", "session=lab-0001; Path=/; Secure; HttpOnly; SameSite=Strict; Max-Age=900")
        self.end_headers()
        self.wfile.write(b"ok\n")

    def log_message(self, *args):
        pass

HTTPServer(("127.0.0.1", 8088), Handler).serve_forever()
EOF
python3 /opt/appsec/cookie_server.py & SRV=$!
sleep 1
curl -s -D - -o /dev/null http://127.0.0.1:8088/insecure | grep -i '^set-cookie'
curl -s -D - -o /dev/null http://127.0.0.1:8088/login | grep -i '^set-cookie'
kill "$SRV"

echo '=== block 7 ==='
export GNUPGHOME=/opt/appsec/gnupg
mkdir -p -m 700 "$GNUPGHOME"
cat > /opt/appsec/keyparams <<'EOF'
%no-protection
Key-Type: RSA
Key-Length: 3072
Key-Usage: sign
Name-Real: Course Release Signing (LAB ONLY)
Name-Email: release@lab.example
Expire-Date: 1y
%commit
EOF
gpg --batch --gen-key /opt/appsec/keyparams
cd /opt/appsec
tar -czf lookup-1.0.tar.gz -C fixed lookup.py
sha256sum lookup-1.0.tar.gz > lookup-1.0.tar.gz.sha256
gpg --batch --yes --armor --detach-sign lookup-1.0.tar.gz
gpg --verify lookup-1.0.tar.gz.asc lookup-1.0.tar.gz

echo '=== block 8 ==='
export GNUPGHOME=/opt/appsec/gnupg
cd /opt/appsec
cp lookup-1.0.tar.gz lookup-1.0-tampered.tar.gz && echo "backdoor" >> lookup-1.0-tampered.tar.gz
gpg --verify lookup-1.0.tar.gz.asc lookup-1.0-tampered.tar.gz || echo "SIGNATURE CHECK FAILED - do not install"
sha256sum -c lookup-1.0.tar.gz.sha256

echo '=== block 9 ==='
systemd-run --quiet --wait --pipe \
  -p PrivateNetwork=yes -p ProtectSystem=strict -p ProtectHome=yes -p PrivateTmp=yes -p NoNewPrivileges=yes \
  /bin/sh -c 'touch /etc/pwned 2>&1; curl -sS -m 3 http://example.com 2>&1 | head -1; echo "sandboxed run finished"'
test -e /etc/pwned && echo "ESCAPED" || echo "Host /etc untouched - sandbox held"

echo '=== block 10 ==='
export GNUPGHOME=/opt/appsec/gnupg; cd /opt/appsec
/opt/sast/bin/bandit -q -r fixed -ll; echo "bandit-fixed exit=$?"
python3 fixed/lookup.py "x' OR '1'='1"
gpg --verify lookup-1.0.tar.gz.asc lookup-1.0.tar.gz 2>&1 | grep -o 'Good signature'
gpg --verify lookup-1.0.tar.gz.asc lookup-1.0-tampered.tar.gz 2>&1 | grep -o 'BAD signature'
