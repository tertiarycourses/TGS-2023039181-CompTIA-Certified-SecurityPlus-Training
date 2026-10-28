# Lab 23 — Data Classification and Data Loss Prevention — Instructions

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
2. Create a synthetic data set
3. Label each file by classification
4. Write a regex DLP scanner with a Luhn check
5. Run the scan and find the mislabelled file
6. Mask and tokenise the sensitive fields
7. Pseudonymise with a keyed hash instead of a plain hash
8. Apply permission restrictions by classification
9. Re-scan the protected output to confirm no raw PII remains

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
