# Lab 29 — Incident Response: Live-Triage and Forensics — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Preparation: build an evidence drop
- Step 2 — Plant a "compromise"
- Step 3 — Detection: identify the indicators
- Step 4 — Analysis: collect volatile evidence first (Order of Volatility)
- Step 5 — Containment
- Step 6 — Eradication
- Step 7 — Recovery: validate the system is clean
- Step 8 — Lessons learned (what to add to the playbook)
- Step 9 — Generate the report

> Reset the playground between labs that change firewall, PAM, routing or disk state.
