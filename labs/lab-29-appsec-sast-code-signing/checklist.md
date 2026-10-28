# Lab 29 — Application Security: Validation, SAST and Code Signing — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Create the vulnerable application
- [ ] Step 3 — Run static analysis with Bandit
- [ ] Step 4 — Confirm the SQL injection dynamically
- [ ] Step 5 — Fix the code with validation and parameterisation
- [ ] Step 6 — Issue cookies with secure flags
- [ ] Step 7 — Sign the release with GPG
- [ ] Step 8 — Detect a tampered release
- [ ] Step 9 — Run untrusted code in a sandbox

## Verification

- [ ] Expected: `bandit-fixed exit=0`, `REJECTED: invalid customer name`, `Good signature` for the original and `BAD signature` for the tampered copy.

## Reflection

- [ ] Your developers sign every release, yet a customer was still compromised by a signed build. What does code signing prove, what does it not prove, and which other 4.1 application-security technique would have caught the flaw earlier?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
