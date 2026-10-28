# Lab 12 — Memory Vulnerabilities & Exploit Mitigations — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Write a tiny vulnerable program
- [ ] Step 3 — Compile it with protections disabled
- [ ] Step 4 — Trigger the overflow crash
- [ ] Step 5 — Check the system ASLR setting
- [ ] Step 6 — Rebuild with the mitigations on
- [ ] Step 7 — Confirm the canary now catches the overflow
- [ ] Step 8 — Verify the binary's protections

## Verification

- [ ] Confirm the two builds behave differently on the same hostile input.

## Reflection

- [ ] Objective 2.3 lists buffer overflow, memory injection and race conditions as application vulnerabilities. Why is a compiler/OS mitigation (canary, ASLR, PIE) a *defence-in-depth* layer rather than a fix for the underlying `strcpy` bug?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
