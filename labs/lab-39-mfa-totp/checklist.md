# Lab 39 — Multifactor Authentication with TOTP — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Create a user and enrol a TOTP secret
- [ ] Step 3 — Inspect the shared secret and the provisioning QR code
- [ ] Step 4 — Generate codes like an authenticator app (TOTP versus HOTP)
- [ ] Step 5 — Build a two-factor PAM service
- [ ] Step 6 — Prove that one factor is not enough
- [ ] Step 7 — Log in with both factors, then test replay protection and a backup code
- [ ] Step 8 — Enforce MFA for SSH logins

## Verification

- [ ] Expected: the password alone is rejected, a fresh code plus the password is accepted, and `sshd -T` shows `authenticationmethods keyboard-interactive` for mfauser.

## Reflection

- [ ] An attacker phishes both the password and the current TOTP code through a fake login page and relays them within 30 seconds. Which MFA implementation from objective 4.6 would have stopped this, and why?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
