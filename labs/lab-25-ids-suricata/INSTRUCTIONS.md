# Lab 25 — Network IDS with Suricata — Instructions

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
- Step 2 — Identify the live interface
- Step 3 — Run Suricata in IDS mode (foreground)
- Step 4 — Trigger the EICAR alert (always present in ET Open)
- Step 5 — Write a custom signature
- Step 6 — IDS vs. IPS

> Reset the playground between labs that change firewall, PAM, routing or disk state.
