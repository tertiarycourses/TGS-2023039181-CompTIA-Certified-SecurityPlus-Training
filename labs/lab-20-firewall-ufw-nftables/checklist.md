# Lab 20 — Stateful Firewall with UFW and nftables — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Build a UFW default-deny allow-list
- [ ] Step 3 — Inspect the netfilter rules UFW generated
- [ ] Step 4 — Disable UFW and build a server namespace
- [ ] Step 5 — Write a stateful nftables ruleset for the server
- [ ] Step 6 — Load the ruleset and test allowed versus blocked ports
- [ ] Step 7 — Read per-rule counters
- [ ] Step 8 — Compare layer 4 rules with layer 7 filtering

## Verification

- [ ] Expected: `200`, `PASS: telnet blocked`, and a `default deny` rule whose packet counter is greater than 0.

## Reflection

- [ ] Your web server sits behind a correctly configured stateful firewall yet is breached by SQL injection. Which firewall type from Objective 3.2 would have helped, where would you place it, and should it fail open or fail closed?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
