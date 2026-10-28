# Lab 38 — Identity & Access Management with PAM and sudo — Instructions

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
2. Provision role groups and users
3. Assign file permissions with DAC and ACLs
4. Scope sudo per role (RBAC and least privilege)
5. Grant a just-in-time privilege that revokes itself
6. Enforce a password policy (length, complexity, reuse, age)
7. Lock out repeated failures with pam_faillock
8. Restrict logins by time of day with pam_time
9. De-provision a leaver

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
