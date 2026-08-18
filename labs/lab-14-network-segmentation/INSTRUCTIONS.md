# Lab 14 — Network Segmentation with Linux Namespaces — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Create three zones
- Step 2 — Wire each zone to a central router (the host)
- Step 3 — Verify everything can reach everything (no policy yet)
- Step 4 — Apply zoning policy
- Step 5 — Re-test the policy

> Reset the playground between labs that change firewall, PAM, routing or disk state.
