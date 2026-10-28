# Lab 48 — Compliance Audit with OpenSCAP — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the SCAP Security Guide content and OpenSCAP scanner
- [ ] Step 2 — Select the Ubuntu SCAP datastream
- [ ] Step 3 — List available compliance profiles
- [ ] Step 4 — Run the CIS Level 1 audit
- [ ] Step 5 — Generate the auto-remediation script
- [ ] Step 6 — Apply one fix and re-check the rule

## Verification

- [ ] Expected: `report.html` exists and contains pass/fail results per control, and the single rule re-check in step 6 reports `pass` after `telnet` is removed.

## Reflection

- [ ] Objective 5.4 lists automation under compliance monitoring. How does an `oscap` scan provide *continuous* evidence that a once-a-year manual checklist cannot?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
