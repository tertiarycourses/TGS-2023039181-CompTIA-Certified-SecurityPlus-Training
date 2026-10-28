# Lab 05 — Hashing, Salting, and Digital Signatures — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Hash data and observe fixed length and the avalanche effect
- [ ] Step 3 — Verify file integrity with a checksum manifest
- [ ] Step 4 — See why unsalted password hashes are weak
- [ ] Step 5 — Salt the hash the way /etc/shadow does
- [ ] Step 6 — Slow attackers down with key stretching
- [ ] Step 7 — Add authenticity with an HMAC
- [ ] Step 8 — Sign a document with a private key
- [ ] Step 9 — Tamper with the document and watch verification fail

## Verification

- [ ] Expected: `1` (the tampered installer is caught), `2` (two different salted hashes for one password), and `Verified OK` once the original order text is restored.

## Reflection

- [ ] A hash, an HMAC and a digital signature can all detect that a file changed. Which of the three can also prove *who* created the file to a third party, and why can the other two not?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
