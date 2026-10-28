# Lab 17 — Cloud Shared Responsibility and IAM Least Privilege — Instructions

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
2. Build the shared responsibility matrix
3. Query the matrix for who owns each control
4. Create an over-permissive IAM policy
5. Evaluate requests with a policy simulator
6. Rewrite the policy to least privilege and re-evaluate
7. Scan an IaC template for misconfigurations
8. Fix the template and confirm a clean scan

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
