# Lab 30 — Asset Inventory, Media Sanitisation and Disposal Certificate — Instructions

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
2. Build the asset inventory and enumerate this host
3. Check retention and legal hold before disposal
4. Prove that deleting is not sanitising
5. Clear the media with shred
6. Use the alternatives: dd zero-fill and blkdiscard
7. Verify the result and keep evidence
8. Purge by cryptographic erase
9. Issue the certificate and close the asset record

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
