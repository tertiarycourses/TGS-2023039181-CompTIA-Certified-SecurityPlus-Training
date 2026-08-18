# Lab 6 — Phishing Email Header Analysis (SPF / DKIM / DMARC) — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install lookup tools
- Step 2 — Save a sample header
- Step 3 — Pull the real SPF record for the claimed sender
- Step 4 — Pull DMARC policy
- Step 5 — Pull DKIM selector
- Step 6 — Generate a test message with `swaks`

> Reset the playground between labs that change firewall, PAM, routing or disk state.
