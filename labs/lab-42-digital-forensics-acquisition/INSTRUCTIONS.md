# Lab 42 — Digital Forensics: Acquisition & Chain of Custody — Instructions

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
2. Open the case: legal hold and chain-of-custody form
3. Capture volatile data first (order of volatility)
4. Create the suspect disk and write-protect it
5. Hash the source before acquisition
6. Acquire bit-for-bit images with dd and dcfldd
7. Verify the images and record them in the chain of custody
8. Examine a working copy read-only and recover deleted artefacts
9. Preserve the evidence and write the report

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
