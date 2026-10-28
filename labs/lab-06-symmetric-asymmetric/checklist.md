# Lab 06 — Symmetric vs. Asymmetric Encryption and Key Exchange — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Encrypt and decrypt with a shared AES-256 key
- [ ] Step 3 — Compare ECB and CBC block modes
- [ ] Step 4 — Compare key lengths and speed
- [ ] Step 5 — Agree a shared secret with X25519 key exchange
- [ ] Step 6 — Generate an asymmetric GPG key pair
- [ ] Step 7 — Encrypt to the public key and decrypt with the private key
- [ ] Step 8 — Inspect the hybrid structure of the GPG message

## Verification

- [ ] Expected: `1` (AES round trip works), `4` (ECB repeated one ciphertext block four times), `KEY EXCHANGE OK`, and `1` (GPG round trip works).

## Reflection

- [ ] Why does every real-world protocol in this lab (TLS, PGP, S/MIME) use asymmetric cryptography for the key and symmetric cryptography for the data, instead of one or the other alone?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
