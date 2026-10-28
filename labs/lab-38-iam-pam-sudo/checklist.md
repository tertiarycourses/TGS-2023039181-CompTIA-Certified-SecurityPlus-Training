# Lab 38 — Identity & Access Management with PAM and sudo — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Provision role groups and users
- [ ] Step 3 — Assign file permissions with DAC and ACLs
- [ ] Step 4 — Scope sudo per role (RBAC and least privilege)
- [ ] Step 5 — Grant a just-in-time privilege that revokes itself
- [ ] Step 6 — Enforce a password policy (length, complexity, reuse, age)
- [ ] Step 7 — Lock out repeated failures with pam_faillock
- [ ] Step 8 — Restrict logins by time of day with pam_time
- [ ] Step 9 — De-provision a leaver

## Verification

- [ ] Wait two minutes after step 5, then confirm the JIT grant has gone, the roles still work and the leaver is fully disabled.

## Reflection

- [ ] A temporary ACL for Bob and a permanent JIT grant both "worked". Which access control principle does each one violate if nobody reviews it, and which automated control from this lab prevents that drift?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
