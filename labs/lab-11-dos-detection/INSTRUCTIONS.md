# Lab 11 — DoS Simulation and Detection — Instructions

## How to run this lab

1. Open the free Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Work through **README.md** step by step, running each command block in the playground shell.
3. Or run the whole lab non-interactively with the helper script:

   ```bash
   sudo bash scripts/run.sh
   ```

4. Confirm every item in **checklist.md** is ticked before moving on.

## Steps in this lab

- Step 1 — Install attack and target
- Step 2 — Baseline the open connections
- Step 3 — Launch a SYN flood (loopback only!)
- Step 4 — Detect with `iptables` counters
- Step 5 — Mitigate with rate-limit + SYN cookies
- Step 6 — Distinguish DoS from DDoS

> Reset the playground between labs that change firewall, PAM, routing or disk state.
