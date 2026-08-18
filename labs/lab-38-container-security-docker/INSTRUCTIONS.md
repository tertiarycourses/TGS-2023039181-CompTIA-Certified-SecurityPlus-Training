# Lab 38 — Container Security with Docker — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install Docker and run a container
- Step 2 — Inspect the default (root) user
- Step 3 — Re-run dropping all capabilities and as non-root
- Step 4 — Confirm the container cannot write the filesystem
- Step 5 — Scan the image for known CVEs
- Step 6 — Limit resources to blunt a DoS

> Reset the playground between labs that change firewall, PAM, routing or disk state.
