# Lab 25 — Data in Transit: TLS Hardening and Cipher Audit — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install nginx, OpenSSL and testssl.sh
- [ ] Step 2 — Create a certificate and a deliberately weak HTTPS site
- [ ] Step 3 — Probe the weak site with openssl s_client
- [ ] Step 4 — Run a baseline testssl.sh audit
- [ ] Step 5 — Write a hardened TLS configuration
- [ ] Step 6 — Reload nginx and re-test with openssl s_client
- [ ] Step 7 — Re-audit with testssl.sh and compare

## Verification

- [ ] Expected: `1` (TLS 1.1 handshake fails), `TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384` (or another TLS 1.3 AEAD suite), and `1` (HSTS present). The hardened testssl report shows `TLS 1` and `TLS 1.1` as `not offered`.

## Reflection

- [ ] A partner insists on connecting with TLS 1.0. Weigh availability against confidentiality and integrity, and name the compensating controls you would demand if a temporary exception were granted.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
