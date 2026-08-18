# Lab 39 — Storage Resilience with Software RAID (mdadm) — Completion Checklist

Tick each item once you have verified it in the lab.

- [ ] Completed **Step 1 — Install mdadm and create two virtual disks**
- [ ] Completed **Step 2 — Attach them as loop devices**
- [ ] Completed **Step 3 — Create a RAID 1 mirror**
- [ ] Completed **Step 4 — Format and write a file**
- [ ] Completed **Step 5 — Fail and remove one disk**
- [ ] Completed **Step 6 — Confirm data survives on the degraded array**

## Verification (lab passes when true)

- [ ] The array reports a degraded state after the disk failure yet still returns the original file contents.
