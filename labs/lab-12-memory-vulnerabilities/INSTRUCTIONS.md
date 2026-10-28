# Lab 12 — Memory Vulnerabilities & Exploit Mitigations — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install the tools
2. Write a tiny vulnerable program
3. Compile it with protections disabled
4. Trigger the overflow crash
5. Check the system ASLR setting
6. Rebuild with the mitigations on
7. Confirm the canary now catches the overflow
8. Verify the binary's protections

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
