# Lab 22 — Identity & Access Management with PAM and sudo — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Create three roles (groups)
- Step 2 — Scope sudo by role (RBAC)
- Step 3 — Verify least privilege
- Step 4 — Time-of-day restriction with PAM (`pam_time`)
- Step 5 — Lockout policy with `pam_faillock`
- Step 6 — Demonstrate de-provisioning (offboarding)

> Reset the playground between labs that change firewall, PAM, routing or disk state.
