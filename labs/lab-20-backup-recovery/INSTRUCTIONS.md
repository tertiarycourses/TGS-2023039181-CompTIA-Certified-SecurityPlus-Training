# Lab 20 — Backup and Recovery with restic — Instructions

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
- Step 2 — Create a "production" data set and a backup repository
- Step 3 — Take the first snapshot
- Step 4 — Modify data, take a second snapshot
- Step 5 — Simulate ransomware
- Step 6 — Restore from the previous snapshot
- Step 7 — Apply 3-2-1 strategy

> Reset the playground between labs that change firewall, PAM, routing or disk state.
