# Lab 29 — Application Security: Validation, SAST and Code Signing — Instructions

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
2. Create the vulnerable application
3. Run static analysis with Bandit
4. Confirm the SQL injection dynamically
5. Fix the code with validation and parameterisation
6. Issue cookies with secure flags
7. Sign the release with GPG
8. Detect a tampered release
9. Run untrusted code in a sandbox

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
