# Lab 38 — Container Security with Docker — Completion Checklist

Tick each item once you have verified it in the lab.

- [ ] Completed **Step 1 — Install Docker and run a container**
- [ ] Completed **Step 2 — Inspect the default (root) user**
- [ ] Completed **Step 3 — Re-run dropping all capabilities and as non-root**
- [ ] Completed **Step 4 — Confirm the container cannot write the filesystem**
- [ ] Completed **Step 5 — Scan the image for known CVEs**
- [ ] Completed **Step 6 — Limit resources to blunt a DoS**

## Verification (lab passes when true)

- [ ] The hardened container runs as UID 1000 with no capabilities on a read-only root, and Trivy lists the image CVEs.
