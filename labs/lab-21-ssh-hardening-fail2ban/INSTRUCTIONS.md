# Lab 21 — SSH Hardening + Fail2ban — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install Fail2ban
- Step 2 — Generate a key pair (no passphrase for the lab)
- Step 3 — Harden sshd
- Step 4 — Configure Fail2ban for sshd
- Step 5 — Trigger a ban
- Step 6 — Unban (admin override)

> Reset the playground between labs that change firewall, PAM, routing or disk state.
