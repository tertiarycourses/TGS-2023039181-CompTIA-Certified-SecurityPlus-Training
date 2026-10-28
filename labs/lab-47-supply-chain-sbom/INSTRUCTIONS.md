# Lab 47 — Supply Chain Security: SBOM and Vendor Trust — Instructions

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
2. Generate an SBOM of installed software
3. Read the SBOM component list
4. Download a vendor release and its published hashes
5. Verify the SHA-256 checksum (integrity)
6. Verify the GPG signature (authenticity)
7. Write the vendor-trust checklist

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
