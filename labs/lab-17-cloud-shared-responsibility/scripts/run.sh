#!/usr/bin/env bash
# Lab 17 — Cloud Shared Responsibility and IAM Least Privilege
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y jq python3 bsdextrautils
mkdir -p /root/lab17 && cd /root/lab17
jq --version && python3 --version

echo '=== block 2 ==='
cd /root/lab17
cat > matrix.csv <<'EOF'
layer,on_prem,iaas,paas,saas
physical_datacentre,customer,provider,provider,provider
hardware_and_network,customer,provider,provider,provider
hypervisor,customer,provider,provider,provider
guest_os_patching,customer,customer,provider,provider
runtime_and_middleware,customer,customer,provider,provider
application_code,customer,customer,customer,provider
network_rules_security_groups,customer,customer,shared,provider
identity_and_access,customer,customer,customer,customer
data_and_classification,customer,customer,customer,customer
EOF
column -s, -t matrix.csv

echo '=== block 3 ==='
cd /root/lab17
echo "--- IaaS: the customer still owns ---"
awk -F, 'NR>1 && $3=="customer" {print "  " $1}' matrix.csv
echo "--- SaaS: the customer still owns ---"
awk -F, 'NR>1 && $5=="customer" {print "  " $1}' matrix.csv

echo '=== block 4 ==='
cd /root/lab17
cat > policy-v1.json <<'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {"Sid": "AdminEverything", "Effect": "Allow", "Action": "*", "Resource": "*"}
  ]
}
EOF
jq -r '.Statement[] | select(.Effect=="Allow")
  | select(([.Action]|flatten|any(.=="*" or endswith(":*"))) or ([.Resource]|flatten|any(.=="*")))
  | "FINDING: \(.Sid) allows Action=\(.Action) on Resource=\(.Resource)"' policy-v1.json

echo '=== block 5 ==='
cd /root/lab17
cat > evaluate.py <<'EOF'
#!/usr/bin/env python3
"""Tiny IAM evaluator: explicit Deny > Allow > implicit deny (lab use only)."""
import json, sys, fnmatch
def as_list(v):
    return v if isinstance(v, list) else [v]
policy = json.load(open(sys.argv[1]))
action, resource = sys.argv[2], sys.argv[3]
decision = "IMPLICIT DENY"
for st in policy["Statement"]:
    a_ok = any(fnmatch.fnmatchcase(action, a) for a in as_list(st["Action"]))
    r_ok = any(fnmatch.fnmatchcase(resource, r) for r in as_list(st["Resource"]))
    if a_ok and r_ok:
        if st["Effect"] == "Deny":
            decision = "EXPLICIT DENY"
            break
        decision = "ALLOW"
print(f"{decision:14} {action:24} {resource}")
EOF
cat > requests.txt <<'EOF'
s3:GetObject arn:aws:s3:::reports/q3-summary.pdf
s3:DeleteObject arn:aws:s3:::reports/q3-summary.pdf
iam:CreateUser arn:aws:iam::111122223333:user/backdoor
ec2:TerminateInstances arn:aws:ec2:ap-southeast-1:111122223333:instance/i-0abc123
EOF
while read -r act res; do python3 evaluate.py policy-v1.json "$act" "$res"; done < requests.txt

echo '=== block 6 ==='
cd /root/lab17
cat > policy-v2.json <<'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {"Sid": "ReadReports", "Effect": "Allow",
     "Action": ["s3:GetObject", "s3:ListBucket"],
     "Resource": ["arn:aws:s3:::reports", "arn:aws:s3:::reports/*"]},
    {"Sid": "NeverDelete", "Effect": "Deny", "Action": "s3:DeleteObject", "Resource": "*"}
  ]
}
EOF
while read -r act res; do python3 evaluate.py policy-v2.json "$act" "$res"; done < requests.txt
jq -e '[.Statement[] | select(.Effect=="Allow")
  | select(([.Action]|flatten|any(.=="*" or endswith(":*"))) or ([.Resource]|flatten|any(.=="*")))] | length == 0' \
  policy-v2.json >/dev/null && echo "LEAST PRIVILEGE: no wildcard Allow statements"

echo '=== block 7 ==='
cd /root/lab17
cat > template-v1.json <<'EOF'
{
  "resources": [
    {"type": "storage_bucket", "name": "reports", "public_read": true, "encryption": false, "region": "ap-southeast-1"},
    {"type": "security_group", "name": "web-sg",
     "ingress": [{"port": 443, "cidr": "0.0.0.0/0"}, {"port": 22, "cidr": "0.0.0.0/0"}]},
    {"type": "vm", "name": "web01", "image": "ubuntu-24.04", "public_ip": true, "disk_encrypted": false}
  ]
}
EOF
cat > iac-scan.sh <<'EOF'
#!/usr/bin/env bash
# Minimal policy-as-code checker for the lab template format. Exit 0 = clean.
out=$(jq -r '
  .resources[] as $r
  | ( if $r.type=="storage_bucket" and $r.public_read==true then "HIGH  \($r.name): bucket is publicly readable" else empty end ),
    ( if $r.type=="storage_bucket" and $r.encryption!=true then "HIGH  \($r.name): bucket not encrypted at rest" else empty end ),
    ( if $r.type=="security_group" then ($r.ingress[] | select(.cidr=="0.0.0.0/0" and .port!=443)
        | "HIGH  \($r.name): port \(.port) open to the whole internet") else empty end ),
    ( if $r.type=="vm" and $r.disk_encrypted!=true then "MED   \($r.name): VM disk not encrypted" else empty end ),
    ( if $r.type=="vm" and $r.public_ip==true then "MED   \($r.name): VM has a public IP (use a jump server or load balancer)" else empty end )
' "$1")
[ -n "$out" ] && echo "$out"
echo "Findings: $(printf '%s' "$out" | grep -c .)"
[ -z "$out" ]
EOF
chmod +x iac-scan.sh
./iac-scan.sh template-v1.json

echo '=== block 8 ==='
cd /root/lab17
cat > template-v2.json <<'EOF'
{
  "resources": [
    {"type": "storage_bucket", "name": "reports", "public_read": false, "encryption": true, "region": "ap-southeast-1"},
    {"type": "security_group", "name": "web-sg",
     "ingress": [{"port": 443, "cidr": "0.0.0.0/0"}, {"port": 22, "cidr": "10.0.30.0/24"}]},
    {"type": "vm", "name": "web01", "image": "ubuntu-24.04", "public_ip": false, "disk_encrypted": true}
  ]
}
EOF
./iac-scan.sh template-v2.json && echo "Template approved for deployment"
diff <(jq -S . template-v1.json) <(jq -S . template-v2.json)

echo '=== block 9 ==='
cd /root/lab17
./iac-scan.sh template-v2.json
python3 evaluate.py policy-v2.json iam:CreateUser arn:aws:iam::111122223333:user/backdoor
