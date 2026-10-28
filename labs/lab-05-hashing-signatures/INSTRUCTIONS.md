# Lab 05 — Hashing, Salting, and Digital Signatures — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install the tools
2. Hash data and observe fixed length and the avalanche effect
3. Verify file integrity with a checksum manifest
4. See why unsalted password hashes are weak
5. Salt the hash the way /etc/shadow does
6. Slow attackers down with key stretching
7. Add authenticity with an HMAC
8. Sign a document with a private key
9. Tamper with the document and watch verification fail

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
