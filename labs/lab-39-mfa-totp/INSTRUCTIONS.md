# Lab 39 — Multifactor Authentication with TOTP — Instructions

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
2. Create a user and enrol a TOTP secret
3. Inspect the shared secret and the provisioning QR code
4. Generate codes like an authenticator app (TOTP versus HOTP)
5. Build a two-factor PAM service
6. Prove that one factor is not enough
7. Log in with both factors, then test replay protection and a backup code
8. Enforce MFA for SSH logins

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
