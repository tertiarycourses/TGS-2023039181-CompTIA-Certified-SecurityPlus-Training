# Lab 37 — Cloud Shared Responsibility & IAM Least Privilege — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Create an over-permissive policy granting *:* 
- Step 2 — Flag the wildcard as a finding
- Step 3 — Rewrite it to least privilege (read one bucket)
- Step 4 — Confirm the wildcard is gone
- Step 5 — Map who secures what for IaaS/PaaS/SaaS

> Reset the playground between labs that change firewall, PAM, routing or disk state.
