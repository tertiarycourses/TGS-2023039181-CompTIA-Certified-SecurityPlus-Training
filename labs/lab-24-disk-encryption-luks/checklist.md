# Lab 24 — Data at Rest: LUKS2 Disk Encryption — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install cryptsetup
- [ ] Step 2 — Create a virtual disk on a loop device
- [ ] Step 3 — Format the device with LUKS2 and inspect the header
- [ ] Step 4 — Open the volume, create a filesystem and store data
- [ ] Step 5 — Prove the plaintext is absent from the raw image
- [ ] Step 6 — Rotate the passphrase
- [ ] Step 7 — Add a keyfile slot and back up the header

## Verification

- [ ] Expected: `0` (no plaintext on the encrypted disk), `keyfile unlocks`, and `old passphrase rejected`. `luksDump` lists two key slots (0 and 1).

## Reflection

- [ ] A stolen, powered-off laptop and a laptop infected with malware while unlocked are both "data at rest" problems. Which one does full-disk encryption solve, and which control from Objective 3.3 addresses the other?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
