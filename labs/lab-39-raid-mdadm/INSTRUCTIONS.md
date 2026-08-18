# Lab 39 — Storage Resilience with Software RAID (mdadm) — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install mdadm and create two virtual disks
- Step 2 — Attach them as loop devices
- Step 3 — Create a RAID 1 mirror
- Step 4 — Format and write a file
- Step 5 — Fail and remove one disk
- Step 6 — Confirm data survives on the degraded array

> Reset the playground between labs that change firewall, PAM, routing or disk state.
