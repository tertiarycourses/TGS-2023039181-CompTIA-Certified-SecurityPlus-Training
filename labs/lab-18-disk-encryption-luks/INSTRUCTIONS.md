# Lab 18 — Data at Rest: LUKS Full-Disk Encryption — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install
- Step 2 — Create a 50 MB virtual disk file
- Step 3 — Format with LUKS2 (AES-XTS-512)
- Step 4 — Open, format, mount
- Step 5 — Confirm encryption
- Step 6 — Rotate the passphrase (key escrow workflow)
- Step 7 — Add a key-file slot (for unattended boot)

> Reset the playground between labs that change firewall, PAM, routing or disk state.
