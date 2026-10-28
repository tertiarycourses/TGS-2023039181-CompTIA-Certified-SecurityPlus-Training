# Lab 20 — Stateful Firewall with UFW and nftables — Instructions

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
2. Build a UFW default-deny allow-list
3. Inspect the netfilter rules UFW generated
4. Disable UFW and build a server namespace
5. Write a stateful nftables ruleset for the server
6. Load the ruleset and test allowed versus blocked ports
7. Read per-rule counters
8. Compare layer 4 rules with layer 7 filtering

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
