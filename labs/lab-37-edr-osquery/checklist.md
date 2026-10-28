# Lab 37 — Endpoint Detection and Response with osquery — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install osquery from the official repository
- [ ] Step 2 — Ask the endpoint questions with osqueryi
- [ ] Step 3 — Baseline the persistence and privilege surface
- [ ] Step 4 — Schedule a detection pack with osqueryd
- [ ] Step 5 — Plant a suspicious process and cron persistence
- [ ] Step 6 — Hunt for the indicators
- [ ] Step 7 — Read the detections in the osqueryd telemetry
- [ ] Step 8 — Respond: preserve evidence, contain, eradicate and confirm

## Verification

- [ ] Expected: the first two queries return `[]`, the results log shows at least one `added` and one `removed` event for `suspicious_processes`, and the evidence hash file contains a 64-hex-character SHA-256.

## Reflection

- [ ] Signature antivirus would not have flagged a renamed copy of a legitimate netcat binary. Which behaviours made it suspicious, and why does that make EDR better suited to living-off-the-land and fileless attacks?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
