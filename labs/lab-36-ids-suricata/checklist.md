# Lab 36 — Network IDS with Suricata — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install Suricata and helpers
- [ ] Step 2 — Download the open ruleset
- [ ] Step 3 — Start a local web server to protect
- [ ] Step 4 — Write custom signatures
- [ ] Step 5 — Run Suricata in IDS mode on loopback
- [ ] Step 6 — Generate suspicious traffic against your own host
- [ ] Step 7 — Read and summarise the alerts
- [ ] Step 8 — Tune a noisy rule and compare IDS with IPS

## Verification

- [ ] Expected: the three local sids `1000001`, `1000002` and `1000003` are listed, proving the content rule, the web-attack rule and the threshold (scan) rule all fired.

## Reflection

- [ ] Your scan rule uses a threshold rather than a single packet: which is more likely to produce false positives in a busy network, and how would you tune it without creating false negatives?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
