# Lab 03 — Deception: Honeypots, Honeyfiles and Honeytokens — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Write a low-interaction honeypot
- [ ] Step 3 — Deploy the honeypot and simulate an attacker probe
- [ ] Step 4 — Plant a honeyfile and watch it with auditd
- [ ] Step 5 — Raise a real-time honeyfile alert with inotifywait
- [ ] Step 6 — Plant a honeytoken and detect its use
- [ ] Step 7 — Build a mini honeynet in a network namespace
- [ ] Step 8 — Summarise the deception alerts

## Verification

- [ ] Expected: at least 1 hit on port 2222, at least 3 hits on ports 21/23 (scan plus probes), at least 1 auditd record for `uid=intruder`, and `ALERT: honeytoken AKIAHONEYTOKEN0LAB03 was used`.

## Reflection

- [ ] Why does a honeypot produce far fewer false positives than an IDS watching production traffic, and what is the risk of deploying a high-interaction honeypot on the production network?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
