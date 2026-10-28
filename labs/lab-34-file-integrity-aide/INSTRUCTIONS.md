# Lab 34 — File Integrity Monitoring with AIDE — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install AIDE
2. Create the content to protect
3. Write a scoped AIDE configuration
4. Initialise the baseline and protect it
5. Simulate an intrusion
6. Detect the changes
7. Respond: restore and quarantine
8. Re-baseline after the approved change
9. Schedule the check and forward it to syslog

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
