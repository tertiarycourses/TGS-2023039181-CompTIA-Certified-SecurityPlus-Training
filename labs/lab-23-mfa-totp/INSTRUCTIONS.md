# Lab 23 — Multi-Factor Authentication with TOTP — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install
- Step 2 — Enrol a user
- Step 3 — Display the secret as a QR (scan with Google/Microsoft Authenticator)
- Step 4 — Wire MFA into SSH PAM
- Step 5 — Generate a code from CLI to test
- Step 6 — Discuss the AAA factor catalogue

> Reset the playground between labs that change firewall, PAM, routing or disk state.
