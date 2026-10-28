# Lab 11 — Cross-Site Scripting (XSS) — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install PHP
2. Create a vulnerable reflected page
3. Start the local server
4. Trigger the reflected payload
5. Mitigate with output encoding
6. Add a Content-Security-Policy header
7. Confirm encoding and the CSP header

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
