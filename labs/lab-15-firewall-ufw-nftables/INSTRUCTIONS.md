# Lab 15 — Stateful Firewall with UFW and nftables — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install
- Step 2 — UFW: an allow-list ruleset in three commands
- Step 3 — Test the policy
- Step 4 — Inspect the underlying nftables ruleset
- Step 5 — Write nftables directly
- Step 6 — Watch counters under load

> Reset the playground between labs that change firewall, PAM, routing or disk state.
