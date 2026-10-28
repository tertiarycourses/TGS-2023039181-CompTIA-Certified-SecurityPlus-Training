# Lab 26 — Backup and Recovery with restic — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install restic and rsync
- [ ] Step 2 — Create production data and an encrypted repository
- [ ] Step 3 — Take a baseline snapshot and prove the repository is encrypted
- [ ] Step 4 — Change the data and take a second snapshot
- [ ] Step 5 — Simulate a ransomware attack
- [ ] Step 6 — Restore the clean snapshot and time the recovery
- [ ] Step 7 — Replicate the repository off site and verify integrity
- [ ] Step 8 — Schedule backups and apply a retention policy

## Verification

- [ ] Expected: `rec1.txt` shows the original record plus the `updated balance` line, `0` locked files remain in `/data`, and `no errors were found` followed by `Off-site replica verified`.

## Reflection

- [ ] The business says it can lose at most one hour of orders and must be trading again within two hours. Using your measured restore time and the cron schedule, does this design meet the RPO and RTO? What would you change?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
