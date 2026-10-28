# Lab 35 — Secure Remote Access: SSH Hardening and Fail2ban — Instructions

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
2. Audit the current exposure
3. Create and authorise an Ed25519 key
4. Harden sshd with a drop-in file
5. Verify key-only login and the negotiated crypto
6. Configure the Fail2ban jail
7. Simulate a brute-force attempt from the attacker address
8. Confirm the firewall block, then unban

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
