# Lab 16 — Web Application Firewall (WAF) with ModSecurity — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install
- Step 2 — Enable the rule engine and load the CRS
- Step 3 — Confirm CRS is loaded
- Step 4 — Fire common attack payloads
- Step 5 — Read the audit log
- Step 6 — Tune a false positive

> Reset the playground between labs that change firewall, PAM, routing or disk state.
