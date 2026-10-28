# Lab 06 — Symmetric vs. Asymmetric Encryption and Key Exchange — Instructions

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
2. Encrypt and decrypt with a shared AES-256 key
3. Compare ECB and CBC block modes
4. Compare key lengths and speed
5. Agree a shared secret with X25519 key exchange
6. Generate an asymmetric GPG key pair
7. Encrypt to the public key and decrypt with the private key
8. Inspect the hybrid structure of the GPG message

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
