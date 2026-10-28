# Lab 07 — PKI: Build Your Own Certificate Authority — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install the tools and build the CA layout
2. Create the root CA (the root of trust)
3. Generate a key and a wildcard CSR
4. Sign the CSR as the CA
5. Verify the chain and add the root to the trust store
6. Check certificate status with OCSP
7. Revoke the certificate and publish a CRL
8. Compare self-signed and third-party certificates

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
