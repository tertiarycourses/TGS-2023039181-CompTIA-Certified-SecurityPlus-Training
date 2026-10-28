# Lab 27 — Storage Resilience with Software RAID (mdadm) — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install mdadm and create virtual disks
- [ ] Step 2 — Attach the images as loop devices
- [ ] Step 3 — Build a RAID 1 mirror and watch it sync
- [ ] Step 4 — Create a filesystem and record checksums
- [ ] Step 5 — Fail a disk and prove the data survives
- [ ] Step 6 — Replace the failed disk and rebuild the mirror
- [ ] Step 7 — Build a RAID 5 array and compare capacity
- [ ] Step 8 — Show that RAID is not a backup, and save the configuration

## Verification

- [ ] Expected: `State : clean` with `Active Devices : 2` after the rebuild, `database.bin: OK`, and `Raid Level : raid5`.

## Reflection

- [ ] A manager says "we have RAID 1, so we don't need backups". Using step 8, explain which threats RAID handles and which it cannot, and how replication, snapshots and offsite backups fill the gap.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
