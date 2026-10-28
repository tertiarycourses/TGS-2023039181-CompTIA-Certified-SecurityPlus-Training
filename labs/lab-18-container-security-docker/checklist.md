# Lab 18 — Container Security with Docker — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install Docker and check the engine
- [ ] Step 2 — Run a default container and inspect its privileges
- [ ] Step 3 — Compare container isolation with the host
- [ ] Step 4 — Build an image that runs as a non-root user
- [ ] Step 5 — Harden the container: read-only, no capabilities, no new privileges
- [ ] Step 6 — Apply resource limits and survive a fork bomb
- [ ] Step 7 — Audit default versus hardened settings
- [ ] Step 8 — Scan images for known vulnerabilities

## Verification

- [ ] Expected: `10001`, then `1` (write blocked even for root), then `[ALL] true <nil>` for the hardened container and `[] false 30` for the capped one.

## Reflection

- [ ] A developer argues that containers are "as isolated as VMs". Using what you saw in step 3 and step 5, explain the security implication of a shared kernel and which hardening flags reduce it.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
