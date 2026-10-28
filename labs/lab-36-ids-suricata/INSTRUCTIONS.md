# Lab 36 — Network IDS with Suricata — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install Suricata and helpers
2. Download the open ruleset
3. Start a local web server to protect
4. Write custom signatures
5. Run Suricata in IDS mode on loopback
6. Generate suspicious traffic against your own host
7. Read and summarise the alerts
8. Tune a noisy rule and compare IDS with IPS

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
