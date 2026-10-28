# Lab 25 — Data in Transit: TLS Hardening and Cipher Audit — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install nginx, OpenSSL and testssl.sh
2. Create a certificate and a deliberately weak HTTPS site
3. Probe the weak site with openssl s_client
4. Run a baseline testssl.sh audit
5. Write a hardened TLS configuration
6. Reload nginx and re-test with openssl s_client
7. Re-audit with testssl.sh and compare

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
