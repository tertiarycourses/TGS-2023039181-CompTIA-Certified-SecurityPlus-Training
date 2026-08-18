# Lab 10 — Cross-Site Scripting (XSS) — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install PHP
- Step 2 — Vulnerable page (reflected XSS)
- Step 3 — Trigger reflected XSS
- Step 4 — Stored XSS
- Step 5 — Mitigation 1: output encoding
- Step 6 — Mitigation 2: Content-Security-Policy header

> Reset the playground between labs that change firewall, PAM, routing or disk state.
