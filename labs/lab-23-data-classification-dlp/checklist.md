# Lab 23 — Data Classification and Data Loss Prevention — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Create a synthetic data set
- [ ] Step 3 — Label each file by classification
- [ ] Step 4 — Write a regex DLP scanner with a Luhn check
- [ ] Step 5 — Run the scan and find the mislabelled file
- [ ] Step 6 — Mask and tokenise the sensitive fields
- [ ] Step 7 — Pseudonymise with a keyed hash instead of a plain hash
- [ ] Step 8 — Apply permission restrictions by classification
- [ ] Step 9 — Re-scan the protected output to confirm no raw PII remains

## Verification

- [ ] Expected: `Files with policy violations: 1` (the mislabelled press release), `Files with policy violations: 0` for the protected output, and `1` (the analyst cannot read Restricted card data).

## Reflection

- [ ] Your team must share salary data with an external analytics vendor. Compare masking, tokenisation and keyed hashing for this purpose: which keeps the analysis useful, which can be reversed and by whom, and where must the key or vault live?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
