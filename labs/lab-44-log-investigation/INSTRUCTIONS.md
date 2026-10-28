# Lab 44 — Log Investigation: Building an Attack Timeline — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install the tools and prepare a work area
2. Generate a synthetic auth.log
3. Generate a synthetic nginx access log
4. Find the brute-force source and count the failures
5. Find the successful login and link it to the brute force
6. Find the privilege escalation
7. Investigate the web attacks
8. Use journalctl for the same questions on a live system
9. Build the merged timeline

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
