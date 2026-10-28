# Lab 43 — Packet Capture and Traffic Analysis with tcpdump and tshark — Instructions

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
2. Start a local web service and a capture
3. Generate HTTP, DNS and beaconing traffic
4. Stop the capture and summarise it
5. Apply display filters
6. Follow a TCP stream
7. Spot cleartext credentials
8. Build a NetFlow-style summary
9. Hunt for beaconing and DNS tunnelling indicators

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
