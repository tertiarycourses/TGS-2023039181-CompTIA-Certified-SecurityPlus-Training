# Lab 26 — Backup and Recovery with restic — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install restic and rsync
2. Create production data and an encrypted repository
3. Take a baseline snapshot and prove the repository is encrypted
4. Change the data and take a second snapshot
5. Simulate a ransomware attack
6. Restore the clean snapshot and time the recovery
7. Replicate the repository off site and verify integrity
8. Schedule backups and apply a retention policy

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
