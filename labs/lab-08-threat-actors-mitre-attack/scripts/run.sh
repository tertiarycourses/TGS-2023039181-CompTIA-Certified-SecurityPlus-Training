#!/usr/bin/env bash
# Lab 08 — Threat Actors & the MITRE ATT&CK Framework
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y jq curl

echo '=== block 2 ==='
curl -sLo attack.json https://raw.githubusercontent.com/mitre/cti/master/enterprise-attack/enterprise-attack.json
ls -lh attack.json

echo '=== block 3 ==='
jq '.objects | length' attack.json

echo '=== block 4 ==='
jq -r '.objects[] | select(.type=="intrusion-set") | .name' attack.json | sort | head -20

echo '=== block 5 ==='
jq -r '.objects[] | select(.type=="intrusion-set" and .name=="APT29") | {name, aliases, description}' attack.json

echo '=== block 6 ==='
jq -r '.objects[] | select(.type=="attack-pattern") | [( .external_references[]? | select(.source_name=="mitre-attack") | .external_id), .name] | @tsv' attack.json | sort -u | head -20

echo '=== block 7 ==='
cat > profile.txt <<'EOF'
Threat-actor profile
Group:        APT29 (Cozy Bear)
Actor type:   Nation-state
Attributes:   External, high resources/funding, high sophistication
Motivation:   Espionage / data exfiltration
Techniques:   T1566 Phishing, T1059 Command and Scripting, T1071 App Layer Protocol
EOF
cat profile.txt

echo '=== block 8 ==='
test -s profile.txt && grep -Eiq 'nation-state' profile.txt && grep -Eiq 'espionage|exfiltration' profile.txt && grep -Ec 'T[0-9]{4}' profile.txt && echo "PROFILE OK"
