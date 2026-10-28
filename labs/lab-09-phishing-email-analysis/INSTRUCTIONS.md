# Lab 09 — Phishing Email Analysis (SPF / DKIM / DMARC) — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install the DNS and mail tools
2. Save a suspicious email header
3. Read the Received and Return-Path lines
4. Query the claimed sender's SPF record
5. Pull the DMARC policy
6. Pull a DKIM selector key
7. Compare the sending IP to the SPF list
8. Summarise the verdict

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
