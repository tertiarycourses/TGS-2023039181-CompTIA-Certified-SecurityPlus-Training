#!/usr/bin/env bash
# Lab 40 — Packet Capture & Traffic Analysis
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt install -y tcpdump tshark

echo '=== block 2 ==='
tcpdump -i any -w /tmp/cap.pcap -c 50 &

echo '=== block 3 ==='
curl -s http://example.com > /dev/null

echo '=== block 4 ==='
tshark -r /tmp/cap.pcap -q -z conv,ip | head

echo '=== block 5 ==='
tshark -r /tmp/cap.pcap -Y 'http.request' -T fields -e ip.dst -e http.host | head

echo '=== block 6 ==='
echo "Open https://alfredang.github.io/pcapanalyzer/ and load /tmp/cap.pcap"

