# Lab 41 — Incident Response: Live Triage — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Prepare: install the jump-bag tools and open a case
- [ ] Step 2 — Simulate the incident (exercise set-up)
- [ ] Step 3 — Detect: confirm the alert and list the indicators
- [ ] Step 4 — Analyse: collect volatile evidence in order of volatility, then hash it
- [ ] Step 5 — Contain: stop the spread without destroying evidence
- [ ] Step 6 — Eradicate: remove the cause and the persistence
- [ ] Step 7 — Recover: validate that the host is clean and keep watching
- [ ] Step 8 — Lessons learned: root cause analysis and the incident report

## Verification

- [ ] Expected: the case folder holds the numbered evidence files, `report.md` and `evidence.sha256`; every hash line verifies `OK`; and the listener count is `0`.

## Reflection

- [ ] Why did you collect processes and sockets in step 4 before killing anything in step 5, and which item of evidence would you have lost if you had contained first?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
