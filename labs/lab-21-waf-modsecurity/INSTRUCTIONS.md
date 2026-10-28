# Lab 21 — Web Application Firewall with ModSecurity and the OWASP CRS — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install Apache, ModSecurity and the OWASP CRS
2. Create the ModSecurity configuration in DetectionOnly mode
3. Send an attack in detection-only mode and read the warning
4. Switch the rule engine to blocking mode
5. Fire SQLi, XSS, traversal and command-injection payloads
6. Read the matched rule IDs in the logs
7. Tune a false positive with a narrow exclusion

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
