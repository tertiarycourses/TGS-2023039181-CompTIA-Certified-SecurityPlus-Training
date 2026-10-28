#!/usr/bin/env bash
# Lab 07 — PKI: Build Your Own Certificate Authority
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y openssl ca-certificates curl
mkdir -p /root/ca/{certs,private,newcerts,crl} && cd /root/ca
chmod 700 private && touch index.txt && echo 1000 > serial && echo 1000 > crlnumber
cat > /root/ca/openssl.cnf <<'EOF'
[ ca ]
default_ca = CA_default
[ CA_default ]
dir              = /root/ca
database         = $dir/index.txt
serial           = $dir/serial
new_certs_dir    = $dir/newcerts
certificate      = $dir/certs/ca.crt
private_key      = $dir/private/ca.key
crlnumber        = $dir/crlnumber
default_md       = sha256
default_days     = 397
default_crl_days = 7
policy           = pol_loose
copy_extensions  = copy
unique_subject   = no
x509_extensions  = server_cert
[ pol_loose ]
commonName       = supplied
organizationName = optional
[ req ]
distinguished_name = req_dn
[ req_dn ]
[ v3_root ]
basicConstraints       = critical, CA:TRUE
keyUsage               = critical, keyCertSign, cRLSign
subjectKeyIdentifier   = hash
[ server_cert ]
basicConstraints       = critical, CA:FALSE
keyUsage               = critical, digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid, issuer
authorityInfoAccess    = OCSP;URI:http://127.0.0.1:2560
crlDistributionPoints  = URI:http://127.0.0.1/lab.crl
EOF
ls /root/ca

echo '=== block 2 ==='
cd /root/ca
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out private/ca.key 2>/dev/null && chmod 600 private/ca.key
openssl req -x509 -new -key private/ca.key -sha256 -days 3650 -config openssl.cnf -extensions v3_root -subj "/CN=Lab Root CA/O=Tertiary Infotech Lab" -out certs/ca.crt
openssl x509 -in certs/ca.crt -noout -subject -issuer -dates
openssl x509 -in certs/ca.crt -noout -ext basicConstraints,keyUsage

echo '=== block 3 ==='
cd /root/ca
openssl req -new -newkey rsa:2048 -nodes -keyout private/web.key -subj "/CN=*.lab.local/O=Lab Web Team" -addext "subjectAltName=DNS:*.lab.local,DNS:lab.local" -out web.csr 2>/dev/null
openssl req -in web.csr -noout -verify -subject
openssl req -in web.csr -noout -text | grep -A1 "Subject Alternative Name"

echo '=== block 4 ==='
cd /root/ca
openssl ca -batch -config openssl.cnf -in web.csr -out certs/web.crt 2>&1 | tail -2
openssl x509 -in certs/web.crt -noout -subject -issuer -serial
openssl x509 -in certs/web.crt -noout -ext subjectAltName,extendedKeyUsage,authorityInfoAccess,crlDistributionPoints
cat index.txt

echo '=== block 5 ==='
cd /root/ca
openssl verify certs/web.crt 2>&1 | tail -2
openssl verify -CAfile certs/ca.crt certs/web.crt
cp certs/ca.crt /usr/local/share/ca-certificates/lab-root-ca.crt
update-ca-certificates 2>&1 | grep added
openssl verify certs/web.crt

echo '=== block 6 ==='
cd /root/ca
nohup openssl ocsp -index index.txt -port 2560 -rsigner certs/ca.crt -rkey private/ca.key -CA certs/ca.crt -nmin 5 > /root/ca/ocsp.log 2>&1 &
sleep 2
openssl ocsp -issuer certs/ca.crt -cert certs/web.crt -url http://127.0.0.1:2560 -CAfile certs/ca.crt 2>&1 | grep -E "Response verify|web.crt"

echo '=== block 7 ==='
cd /root/ca
openssl ca -config openssl.cnf -revoke certs/web.crt -crl_reason keyCompromise 2>&1 | tail -1
openssl ca -config openssl.cnf -gencrl -out crl/lab.crl 2>/dev/null
openssl crl -in crl/lab.crl -noout -text | grep -E -A3 "Revoked Certificates"
openssl verify -crl_check -CAfile certs/ca.crt -CRLfile crl/lab.crl certs/web.crt 2>&1 | tail -2
pkill -f "openssl ocsp -index" ; sleep 1
nohup openssl ocsp -index index.txt -port 2560 -rsigner certs/ca.crt -rkey private/ca.key -CA certs/ca.crt -nmin 5 > /root/ca/ocsp.log 2>&1 &
sleep 2
openssl ocsp -issuer certs/ca.crt -cert certs/web.crt -url http://127.0.0.1:2560 -CAfile certs/ca.crt 2>&1 | grep -E "web.crt|Reason"

echo '=== block 8 ==='
cd /root/ca
openssl req -x509 -newkey rsa:2048 -nodes -keyout /root/ca/private/selfsigned.key -days 30 -subj "/CN=selfsigned.lab.local" -out certs/selfsigned.crt 2>/dev/null
openssl x509 -in certs/selfsigned.crt -noout -subject -issuer
openssl verify certs/selfsigned.crt 2>&1 | tail -2
echo "trusted third-party roots in this OS: $(grep -c 'BEGIN CERTIFICATE' /etc/ssl/certs/ca-certificates.crt)"
openssl crl2pkcs7 -nocrl -certfile /etc/ssl/certs/ca-certificates.crt | openssl pkcs7 -print_certs -noout | grep -E "^subject=.*(ISRG Root X1|DigiCert Global Root G2)"

echo '=== block 9 ==='
cd /root/ca
openssl x509 -in certs/web.crt -noout -ext subjectAltName | grep -c '\*.lab.local'
grep -c '^R' index.txt
openssl crl -in crl/lab.crl -noout -text | grep -c "Serial Number: 1000"
openssl ocsp -issuer certs/ca.crt -cert certs/web.crt -url http://127.0.0.1:2560 -CAfile certs/ca.crt 2>/dev/null | grep -c "revoked"
