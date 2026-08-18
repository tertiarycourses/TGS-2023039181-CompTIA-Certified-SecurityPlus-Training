#!/usr/bin/env bash
# Lab 5 — PKI: Build Your Own Certificate Authority
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
mkdir -p ~/ca/{certs,private,newcerts,crl}
cd ~/ca
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

echo '=== block 2 ==='
openssl genrsa -out private/ca.key 4096
openssl req -x509 -new -key private/ca.key -days 3650 -sha256 \
    -subj "/CN=Lab Root CA/O=Tertiary InfoTech" \
    -out certs/ca.crt
openssl x509 -in certs/ca.crt -noout -subject -issuer

echo '=== block 3 ==='
openssl genrsa -out private/server.key 2048
openssl req -new -key private/server.key \
    -subj "/CN=web.lab.local/O=Lab" \
    -out server.csr
openssl req -in server.csr -noout -subject

echo '=== block 4 ==='
cat > openssl.cnf <<'EOF'
[ ca ]
default_ca = CA_default
[ CA_default ]
dir = .
database = $dir/index.txt
serial = $dir/serial
new_certs_dir = $dir/newcerts
certificate = $dir/certs/ca.crt
private_key = $dir/private/ca.key
crlnumber = $dir/crlnumber
default_md = sha256
policy = pol
default_days = 365
default_crl_days = 30
[ pol ]
commonName = supplied
organizationName = optional
EOF

openssl ca -batch -config openssl.cnf -in server.csr -out certs/server.crt
openssl x509 -in certs/server.crt -noout -issuer -subject

echo '=== block 5 ==='
openssl ca -config openssl.cnf -revoke certs/server.crt
openssl ca -config openssl.cnf -gencrl -out crl/lab.crl
openssl crl -in crl/lab.crl -noout -text | head -15

echo '=== block 6 ==='
ls /etc/ssl/certs | head
awk '/Subject:/ {print}' /etc/ssl/certs/ca-certificates.crt | sort -u | head

