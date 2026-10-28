# Lab 02 — CIA Triad and AAA on Linux — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools and create the lab users
- [ ] Step 2 — Confidentiality: restrict a file to its owner
- [ ] Step 3 — Integrity: baseline a hash and detect tampering
- [ ] Step 4 — Availability: make a service self-heal
- [ ] Step 5 — Authentication of people: verify a password hash
- [ ] Step 6 — Authentication of systems: log in with an SSH key
- [ ] Step 7 — Authorization: grant one least-privilege sudo command
- [ ] Step 8 — Accounting: trace who did what in the logs

## Verification

- [ ] Expected: `C: bob denied`, `I: tampering detected`, `service is up` with `NRestarts=1` or higher, a sudo rule count of `1`, and at least one sudo log entry for alice's allowed restart.

## Reflection

- [ ] alice successfully logged in but could not read `/etc/shadow`. Which AAA function stopped her, which one let her in, and which one proves both events happened?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
