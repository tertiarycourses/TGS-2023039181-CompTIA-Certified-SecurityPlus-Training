# Lab 17 — Cloud Shared Responsibility and IAM Least Privilege — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Build the shared responsibility matrix
- [ ] Step 3 — Query the matrix for who owns each control
- [ ] Step 4 — Create an over-permissive IAM policy
- [ ] Step 5 — Evaluate requests with a policy simulator
- [ ] Step 6 — Rewrite the policy to least privilege and re-evaluate
- [ ] Step 7 — Scan an IaC template for misconfigurations
- [ ] Step 8 — Fix the template and confirm a clean scan

## Verification

- [ ] Expected: `Findings: 0` (exit code 0) and `IMPLICIT DENY  iam:CreateUser ...`. Running `./iac-scan.sh template-v1.json` still reports 5 findings.

## Reflection

- [ ] Your company moves its HR system from IaaS virtual machines to a SaaS product. Which rows of your matrix move to the provider, and which rows can never move — and why does that matter for risk transference?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
