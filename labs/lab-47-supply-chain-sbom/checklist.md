# Lab 47 — Supply Chain Security: SBOM and Vendor Trust — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Generate an SBOM of installed software
- [ ] Step 3 — Read the SBOM component list
- [ ] Step 4 — Download a vendor release and its published hashes
- [ ] Step 5 — Verify the SHA-256 checksum (integrity)
- [ ] Step 6 — Verify the GPG signature (authenticity)
- [ ] Step 7 — Write the vendor-trust checklist

## Verification

- [ ] Expected: `sbom.spdx.json` is non-empty and lists components with versions; the checksum reports `jq-linux-amd64: OK`; and `vendor-trust.md` records right-to-audit, questionnaire and supply-chain items.

## Reflection

- [ ] Objective 5.3 lists right-to-audit, questionnaires and supply chain analysis. Why is verifying a download's signature not enough on its own to trust a vendor?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
