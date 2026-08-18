# Lab 17 — Site-to-Site VPN with WireGuard — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install WireGuard
- Step 2 — Generate two key pairs
- Step 3 — Build two namespaces (Site A, Site B)
- Step 4 — Configure each tunnel endpoint
- Step 5 — Connect the tunnels via host loopback
- Step 6 — Verify
- Step 7 — Compare with IPsec / OpenVPN

> Reset the playground between labs that change firewall, PAM, routing or disk state.
