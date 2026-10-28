# Lab 03 — Deception: Honeypots, Honeyfiles and Honeytokens — Instructions

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
2. Write a low-interaction honeypot
3. Deploy the honeypot and simulate an attacker probe
4. Plant a honeyfile and watch it with auditd
5. Raise a real-time honeyfile alert with inotifywait
6. Plant a honeytoken and detect its use
7. Build a mini honeynet in a network namespace
8. Summarise the deception alerts

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
