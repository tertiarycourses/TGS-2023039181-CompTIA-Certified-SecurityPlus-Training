# Lab 5 — PKI: Build Your Own Certificate Authority — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Create the CA directory layout
- Step 2 — Generate the root CA key + self-signed root certificate
- Step 3 — Generate a server key + CSR
- Step 4 — Sign the CSR with your CA
- Step 5 — Revoke and publish a CRL
- Step 6 — Compare with third-party CAs

> Reset the playground between labs that change firewall, PAM, routing or disk state.
