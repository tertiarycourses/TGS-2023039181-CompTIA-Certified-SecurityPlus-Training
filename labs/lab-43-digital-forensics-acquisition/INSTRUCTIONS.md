# Lab 43 — Digital Forensics — Evidence Acquisition & Hashing — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Prepare evidence media with a file, then delete it
- Step 2 — Acquire a bit-for-bit image
- Step 3 — Hash the image on acquisition
- Step 4 — Recover the deleted artefact
- Step 5 — Re-verify the image hash is unchanged
- Step 6 — Record the chain of custody

> Reset the playground between labs that change firewall, PAM, routing or disk state.
