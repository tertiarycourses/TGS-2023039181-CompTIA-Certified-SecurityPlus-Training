# Lab 27 — File Integrity Monitoring with AIDE — Instructions

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
- Step 2 — Configure scope
- Step 3 — Initialise the baseline
- Step 4 — First check (should report no changes)
- Step 5 — Tamper and re-check
- Step 6 — Roll the baseline forward (legitimate change)
- Step 7 — Schedule a daily check

> Reset the playground between labs that change firewall, PAM, routing or disk state.
