# Lab 22 — Site-to-Site VPN with WireGuard — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install WireGuard and capture tools
- [ ] Step 2 — Generate a key pair for each site
- [ ] Step 3 — Create two site namespaces with WireGuard links
- [ ] Step 4 — Configure keys, listen ports and allowed IPs
- [ ] Step 5 — Point each peer at the other's endpoint
- [ ] Step 6 — Verify the tunnel with ping and wg show
- [ ] Step 7 — Capture the underlay to prove the traffic is encrypted
- [ ] Step 8 — Test crypto-key routing with AllowedIPs

## Verification

- [ ] Expected: `2 received`, a non-zero Unix timestamp for the latest handshake, and `0` (the secret never appears in the capture).

## Reflection

- [ ] Your company is replacing its MPLS links with SD-WAN over broadband. Which part of this lab protects the branch traffic, and what does AllowedIPs contribute that a plain encrypted tunnel would not?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
