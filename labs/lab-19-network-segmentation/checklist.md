# Lab 19 — Network Segmentation and Security Zones — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Create three zone namespaces
- [ ] Step 3 — Wire each zone to the host router with veth pairs
- [ ] Step 4 — Start services and prove the flat network allows lateral movement
- [ ] Step 5 — Apply a default-deny zone policy
- [ ] Step 6 — Re-test the screened-subnet policy
- [ ] Step 7 — Read the counters and dropped-packet logs

## Verification

- [ ] Expected: `200`, then `PASS: DMZ cannot reach internal`. The `default deny` rule in `iptables -L ZONES -n -v` shows a non-zero packet count.

## Reflection

- [ ] The DMZ web server is compromised. Using your counters, explain how the zone policy limited the attacker's blast radius, and which rule implements the jump server concept.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
