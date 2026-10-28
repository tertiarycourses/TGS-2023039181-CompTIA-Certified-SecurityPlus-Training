# Lab 44 — Log Investigation: Building an Attack Timeline — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools and prepare a work area
- [ ] Step 2 — Generate a synthetic auth.log
- [ ] Step 3 — Generate a synthetic nginx access log
- [ ] Step 4 — Find the brute-force source and count the failures
- [ ] Step 5 — Find the successful login and link it to the brute force
- [ ] Step 6 — Find the privilege escalation
- [ ] Step 7 — Investigate the web attacks
- [ ] Step 8 — Use journalctl for the same questions on a live system
- [ ] Step 9 — Build the merged timeline

## Verification

- [ ] Expected: the top attacker is `203.0.113.66` with 8 failures, the compromise of `webadmin` and the `support` account creation are both found, and the timeline contains all the merged events in time order.

## Reflection

- [ ] You found 8 failed logins and 1 success from the same IP. Why is correlating the web log with the auth log more convincing than either log alone, and what does the quiet 198.51.100.4 teach you about false positives?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
