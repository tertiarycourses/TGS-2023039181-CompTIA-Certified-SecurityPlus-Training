#!/usr/bin/env bash
# Lab 22 — Site-to-Site VPN with WireGuard
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y wireguard-tools iproute2 iputils-ping kmod tcpdump netcat-openbsd
modprobe wireguard && lsmod | grep wireguard

echo '=== block 2 ==='
mkdir -p /root/wg && cd /root/wg && umask 077
for s in siteA siteB; do wg genkey | tee $s.key | wg pubkey > $s.pub; done
ls -l /root/wg
echo "Site A public key: $(cat siteA.pub)"

echo '=== block 3 ==='
ip netns add siteA
ip netns add siteB
ip link add wgA type wireguard
ip link add wgB type wireguard
ip link set wgA netns siteA
ip link set wgB netns siteB
ip netns exec siteA ip link show wgA

echo '=== block 4 ==='
cd /root/wg
ip netns exec siteA wg set wgA private-key siteA.key listen-port 51820 \
  peer "$(cat siteB.pub)" allowed-ips 10.99.0.2/32
ip netns exec siteB wg set wgB private-key siteB.key listen-port 51821 \
  peer "$(cat siteA.pub)" allowed-ips 10.99.0.1/32
ip netns exec siteA ip addr add 10.99.0.1/24 dev wgA
ip netns exec siteB ip addr add 10.99.0.2/24 dev wgB

echo '=== block 5 ==='
cd /root/wg
ip netns exec siteA wg set wgA peer "$(cat siteB.pub)" endpoint 127.0.0.1:51821
ip netns exec siteB wg set wgB peer "$(cat siteA.pub)" endpoint 127.0.0.1:51820
ip netns exec siteA ip link set wgA up
ip netns exec siteB ip link set wgB up

echo '=== block 6 ==='
ip netns exec siteA ping -c3 10.99.0.2
ip netns exec siteA wg show

echo '=== block 7 ==='
cd /root/wg
timeout 12 tcpdump -i lo -nn -A -c 20 'udp port 51820 or udp port 51821' > capture.txt 2>/dev/null &
sleep 2
ip netns exec siteB sh -c 'timeout 6 nc -l 10.99.0.2 9000 > /root/wg/received.txt' &
sleep 1
echo "PAYROLL-TOP-SECRET-2024" | ip netns exec siteA nc -q 1 -w 3 10.99.0.2 9000
wait
echo "Received at Site B: $(cat received.txt)"
echo "Encrypted packets captured: $(grep -c 'UDP' capture.txt)"
grep -q "PAYROLL-TOP-SECRET" capture.txt && echo "PLAINTEXT LEAKED" || echo "Plaintext not visible on the wire - encrypted"

echo '=== block 8 ==='
ip netns exec siteB ip addr add 10.99.0.3/24 dev wgB
ip netns exec siteA ping -c2 -W1 10.99.0.3 2>&1 | grep -E 'Required key|Unreachable|packet loss' | head -2
ip netns exec siteA wg show wgA allowed-ips

echo '=== block 9 ==='
ip netns exec siteA ping -c2 -W2 10.99.0.2 | grep -E '[0-9]+ received'
ip netns exec siteA wg show wgA latest-handshakes
grep -c "PAYROLL-TOP-SECRET" /root/wg/capture.txt
