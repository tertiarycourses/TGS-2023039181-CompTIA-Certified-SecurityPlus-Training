# Lab 21 — Web Application Firewall with ModSecurity and the OWASP CRS — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install Apache, ModSecurity and the OWASP CRS
- [ ] Step 2 — Create the ModSecurity configuration in DetectionOnly mode
- [ ] Step 3 — Send an attack in detection-only mode and read the warning
- [ ] Step 4 — Switch the rule engine to blocking mode
- [ ] Step 5 — Fire SQLi, XSS, traversal and command-injection payloads
- [ ] Step 6 — Read the matched rule IDs in the logs
- [ ] Step 7 — Tune a false positive with a narrow exclusion

## Verification

- [ ] Expected: `403` for the UNION-based SQL injection, `200` for the normal page, and `SecRuleEngine On`.

## Reflection

- [ ] Lab 20's layer 4 firewall passed the same SQL injection that the WAF blocked. Explain why, and decide whether this WAF should fail open or fail closed for an online banking site.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
