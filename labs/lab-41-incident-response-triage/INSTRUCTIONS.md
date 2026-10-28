# Lab 41 — Incident Response: Live Triage — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Prepare: install the jump-bag tools and open a case
2. Simulate the incident (exercise set-up)
3. Detect: confirm the alert and list the indicators
4. Analyse: collect volatile evidence in order of volatility, then hash it
5. Contain: stop the spread without destroying evidence
6. Eradicate: remove the cause and the persistence
7. Recover: validate that the host is clean and keep watching
8. Lessons learned: root cause analysis and the incident report

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
