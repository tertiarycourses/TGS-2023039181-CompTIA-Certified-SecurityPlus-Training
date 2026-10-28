# Lab 19 — Network Segmentation and Security Zones — Instructions

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
2. Create three zone namespaces
3. Wire each zone to the host router with veth pairs
4. Start services and prove the flat network allows lateral movement
5. Apply a default-deny zone policy
6. Re-test the screened-subnet policy
7. Read the counters and dropped-packet logs

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
