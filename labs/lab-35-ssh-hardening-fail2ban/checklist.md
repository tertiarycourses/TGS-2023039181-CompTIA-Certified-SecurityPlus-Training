# Lab 35 — Secure Remote Access: SSH Hardening and Fail2ban — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Audit the current exposure
- [ ] Step 3 — Create and authorise an Ed25519 key
- [ ] Step 4 — Harden sshd with a drop-in file
- [ ] Step 5 — Verify key-only login and the negotiated crypto
- [ ] Step 6 — Configure the Fail2ban jail
- [ ] Step 7 — Simulate a brute-force attempt from the attacker address
- [ ] Step 8 — Confirm the firewall block, then unban

## Verification

- [ ] Expected: `PASS key-only`, `PASS key-login` and `PASS ban active`.

## Reflection

- [ ] Moving SSH to port 2222 cut the number of failed logins by 95 percent. Has the risk changed, and how does that compare with the controls you applied in steps 4 and 6?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
