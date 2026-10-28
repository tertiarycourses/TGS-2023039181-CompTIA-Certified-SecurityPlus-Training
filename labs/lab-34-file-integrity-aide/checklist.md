# Lab 34 — File Integrity Monitoring with AIDE — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install AIDE
- [ ] Step 2 — Create the content to protect
- [ ] Step 3 — Write a scoped AIDE configuration
- [ ] Step 4 — Initialise the baseline and protect it
- [ ] Step 5 — Simulate an intrusion
- [ ] Step 6 — Detect the changes
- [ ] Step 7 — Respond: restore and quarantine
- [ ] Step 8 — Re-baseline after the approved change
- [ ] Step 9 — Schedule the check and forward it to syslog

## Verification

- [ ] Expected: `exit=0` on the clean system, then at least `1` match for `app.ini` after the drift. The last line reverts the content, but the file's inode and timestamps have still changed, so re-run step 8 if you want a clean baseline again.

## Reflection

- [ ] FIM told you that `/usr/local/bin` changed, but not who changed it or how they got in. Which other 4.4 and 4.5 tools (SIEM correlation, EDR, auditd) would you correlate with the AIDE alert, and why is FIM detective rather than preventive?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
