# Lab 43 — Packet Capture and Traffic Analysis with tcpdump and tshark — Completion Checklist

Tick each item once you have verified it in the playground.

- [ ] Step 1 — Install the tools
- [ ] Step 2 — Start a local web service and a capture
- [ ] Step 3 — Generate HTTP, DNS and beaconing traffic
- [ ] Step 4 — Stop the capture and summarise it
- [ ] Step 5 — Apply display filters
- [ ] Step 6 — Follow a TCP stream
- [ ] Step 7 — Spot cleartext credentials
- [ ] Step 8 — Build a NetFlow-style summary
- [ ] Step 9 — Hunt for beaconing and DNS tunnelling indicators

## Verification

- [ ] Expected: `PCAP saved`, at least 7 HTTP requests (two logins plus five beacons), and `alice:Summer2026` recovered from the capture.

## Reflection

- [ ] Your SIEM alert says "host42 contacts the same URL every 2 seconds". Would you investigate first with flow data or a full packet capture, and what would each one tell you?

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
