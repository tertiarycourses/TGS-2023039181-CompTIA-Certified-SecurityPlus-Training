# Lab 27 — Storage Resilience with Software RAID (mdadm) — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install mdadm and create virtual disks
2. Attach the images as loop devices
3. Build a RAID 1 mirror and watch it sync
4. Create a filesystem and record checksums
5. Fail a disk and prove the data survives
6. Replace the failed disk and rebuild the mirror
7. Build a RAID 5 array and compare capacity
8. Show that RAID is not a backup, and save the configuration

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
