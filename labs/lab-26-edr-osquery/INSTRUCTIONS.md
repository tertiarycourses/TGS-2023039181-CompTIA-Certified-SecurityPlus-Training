# Lab 26 — Endpoint Detection with osquery — Instructions

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
- Step 2 — Interactive SQL queries
- Step 3 — Detect a "fileless" process
- Step 4 — Detect new SUID binaries
- Step 5 — Schedule the queries (osqueryd)
- Step 6 — File integrity (FIM) with osquery

> Reset the playground between labs that change firewall, PAM, routing or disk state.
