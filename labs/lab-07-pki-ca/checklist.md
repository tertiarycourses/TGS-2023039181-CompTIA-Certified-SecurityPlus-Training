# Lab 07 — PKI: Build Your Own Certificate Authority — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools and build the CA layout
- [ ] Step 2 — Create the root CA (the root of trust)
- [ ] Step 3 — Generate a key and a wildcard CSR
- [ ] Step 4 — Sign the CSR as the CA
- [ ] Step 5 — Verify the chain and add the root to the trust store
- [ ] Step 6 — Check certificate status with OCSP
- [ ] Step 7 — Revoke the certificate and publish a CRL
- [ ] Step 8 — Compare self-signed and third-party certificates

## Verification

- [ ] Expected: `1` (wildcard SAN present), `1` (one revoked entry in the CA database), `1` (serial 1000 on the CRL) and `1` (OCSP reports the certificate as revoked).

## Reflection

- [ ] A user reports a browser warning on an internal site that uses your lab CA. Give two different fixes, one using a self-signed root of trust and one using a third-party CA, and the trade-off between them.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
