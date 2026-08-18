# Lab 24 — SIEM Basics with Wazuh Manager (single-node) — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install Wazuh all-in-one
- Step 2 — Confirm services
- Step 3 — Register a local agent
- Step 4 — Generate brute-force evidence
- Step 5 — Query via the REST API
- Step 6 — Build a saved search in the dashboard

> Reset the playground between labs that change firewall, PAM, routing or disk state.
