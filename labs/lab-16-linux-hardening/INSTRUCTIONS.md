# Lab 16 — Linux Hardening Baseline with Lynis — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install Lynis and automatic updates
2. Run the initial audit and note the score
3. Disable unused services
4. Harden the SSH configuration
5. Set a directive login banner
6. Apply kernel sysctl hardening
7. Enable automatic security updates
8. Re-audit and compare the hardening index

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
