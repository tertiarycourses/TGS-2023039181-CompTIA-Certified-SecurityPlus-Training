# Lab 13 — Password Attacks: Spraying & Brute Force — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install the tools and SSH server
2. Create a target account with a weak password
3. Build a small wordlist
4. Brute force SSH against localhost
5. Detect the attack in the auth log
6. Crack the shadow hash offline with John
7. Demonstrate password spraying
8. Spot the spraying signature

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
