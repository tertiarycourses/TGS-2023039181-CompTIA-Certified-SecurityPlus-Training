# Lab 22 — Site-to-Site VPN with WireGuard — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run every command block in order with the helper script (review it first):

   ```bash
   sudo bash scripts/run.sh
   ```

4. Tick every item in **checklist.md** before moving on.

## Steps in this lab

1. Install WireGuard and capture tools
2. Generate a key pair for each site
3. Create two site namespaces with WireGuard links
4. Configure keys, listen ports and allowed IPs
5. Point each peer at the other's endpoint
6. Verify the tunnel with ping and wg show
7. Capture the underlay to prove the traffic is encrypted
8. Test crypto-key routing with AllowedIPs

> Reset the playground between labs that change firewall, PAM, routing or disk state.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
