# Lab 19 — TLS Hardening and Cipher Audit — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Set up an HTTPS site
- Step 2 — Get testssl.sh
- Step 3 — Harden nginx
- Step 4 — Re-audit
- Step 5 — Cross-check with `openssl s_client`

> Reset the playground between labs that change firewall, PAM, routing or disk state.
