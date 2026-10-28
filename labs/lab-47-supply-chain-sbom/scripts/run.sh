#!/usr/bin/env bash
# Lab 47 — Supply Chain Security: SBOM and Vendor Trust
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y curl gnupg coreutils
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
syft version

echo '=== block 2 ==='
mkdir -p ~/supplychain && cd ~/supplychain
syft dir:/usr/bin -o spdx-json=sbom.spdx.json
ls -l sbom.spdx.json

echo '=== block 3 ==='
cd ~/supplychain
syft dir:/usr/bin -o table | head -20

echo '=== block 4 ==='
cd ~/supplychain
BASE=https://github.com/jqlang/jq/releases/download/jq-1.7.1
curl -sSLO $BASE/jq-linux-amd64
curl -sSLO $BASE/sha256sum.txt
ls -l jq-linux-amd64 sha256sum.txt

echo '=== block 5 ==='
cd ~/supplychain
grep 'jq-linux-amd64' sha256sum.txt > my-sum.txt
sha256sum -c my-sum.txt

echo '=== block 6 ==='
cd ~/supplychain
curl -sSLO https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64.asc 2>/dev/null || true
gpg --verify jq-linux-amd64.asc jq-linux-amd64 2>&1 | head -5 || \
  echo "Signature check ran — import the vendor key to get a trusted result."

echo '=== block 7 ==='
cd ~/supplychain
cat > vendor-trust.md <<'EOF'
# Vendor Trust Checklist
Vendor: Example SaaS Pte Ltd
[ ] SBOM obtained and scanned against CVE feed
[x] Download integrity verified (SHA-256)
[ ] Download authenticity verified (GPG signature)
[ ] Right-to-audit clause present in the contract
[ ] Security questionnaire (SIG/CAIQ) returned and reviewed
[ ] Independent assessment on file (SOC 2 / ISO 27001)
[ ] Supply chain analysis: their sub-processors listed
EOF
cat vendor-trust.md

echo '=== block 8 ==='
cd ~/supplychain
test -s sbom.spdx.json && echo "SBOM generated"
sha256sum -c my-sum.txt
grep -c '\[' vendor-trust.md
