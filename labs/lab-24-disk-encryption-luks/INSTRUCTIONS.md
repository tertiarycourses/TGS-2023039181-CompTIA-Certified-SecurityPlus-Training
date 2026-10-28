# Lab 24 — Data at Rest: LUKS2 Disk Encryption — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install cryptsetup
2. Create a virtual disk on a loop device
3. Format the device with LUKS2 and inspect the header
4. Open the volume, create a filesystem and store data
5. Prove the plaintext is absent from the raw image
6. Rotate the passphrase
7. Add a keyfile slot and back up the header

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
