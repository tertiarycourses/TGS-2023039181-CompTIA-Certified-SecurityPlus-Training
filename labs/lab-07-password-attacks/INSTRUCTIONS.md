# Lab 7 — Password Attacks: Spraying, Brute Force, Cracking — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install the attack tools
- Step 2 — Create a target user with a weak password
- Step 3 — Build a small wordlist
- Step 4 — Brute force SSH with hydra
- Step 5 — Detect the attack
- Step 6 — Crack a `/etc/shadow` hash with John
- Step 7 — Password spraying (one password, many users)

> Reset the playground between labs that change firewall, PAM, routing or disk state.
