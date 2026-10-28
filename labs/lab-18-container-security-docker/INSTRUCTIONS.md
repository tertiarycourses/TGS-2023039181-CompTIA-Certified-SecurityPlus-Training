# Lab 18 — Container Security with Docker — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install Docker and check the engine
2. Run a default container and inspect its privileges
3. Compare container isolation with the host
4. Build an image that runs as a non-root user
5. Harden the container: read-only, no capabilities, no new privileges
6. Apply resource limits and survive a fork bomb
7. Audit default versus hardened settings
8. Scan images for known vulnerabilities

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
