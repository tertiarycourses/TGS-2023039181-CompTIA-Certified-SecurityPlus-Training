# Lab 30 — Asset Inventory, Media Sanitisation and Disposal Certificate — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Build the asset inventory and enumerate this host
- [ ] Step 3 — Check retention and legal hold before disposal
- [ ] Step 4 — Prove that deleting is not sanitising
- [ ] Step 5 — Clear the media with shred
- [ ] Step 6 — Use the alternatives: dd zero-fill and blkdiscard
- [ ] Step 7 — Verify the result and keep evidence
- [ ] Step 8 — Purge by cryptographic erase
- [ ] Step 9 — Issue the certificate and close the asset record

## Verification

- [ ] Expected: `0` with `residual-matches-exit=1` (nothing found), a certificate showing the Clear level and a 64-hex-character hash, and the inventory status `Sanitised - certificate on file`.

## Reflection

- [ ] A failed SSD that cannot be overwritten holds Restricted payment data. Which NIST SP 800-88 level and technique do you choose, who signs the certificate, and why is overwriting alone a poor choice for SSDs?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
