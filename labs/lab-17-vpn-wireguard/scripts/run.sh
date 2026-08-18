#!/usr/bin/env bash
# Lab 17 — Site-to-Site VPN with WireGuard
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y wireguard wireguard-tools
modprobe wireguard
lsmod | grep wireguard

echo '=== block 2 ==='
mkdir -p ~/wg && cd ~/wg
wg genkey | tee siteA.key | wg pubkey > siteA.pub
wg genkey | tee siteB.key | wg pubkey > siteB.pub

echo '=== block 3 ==='
ip netns add siteA
ip netns add siteB
ip link add wgA type wireguard
ip link add wgB type wireguard
ip link set wgA netns siteA
ip link set wgB netns siteB

echo '=== block 4 ==='
ip netns exec siteA wg set wgA private-key siteA.key listen-port 51820 \
   peer "$(cat siteB.pub)" allowed-ips 10.99.0.2/32
ip netns exec siteB wg set wgB private-key siteB.key listen-port 51821 \
   peer "$(cat siteA.pub)" allowed-ips 10.99.0.1/32

ip netns exec siteA ip addr add 10.99.0.1/24 dev wgA
ip netns exec siteB ip addr add 10.99.0.2/24 dev wgB
ip netns exec siteA ip link set wgA up
ip netns exec siteB ip link set wgB up

echo '=== block 5 ==='
ip netns exec siteA wg set wgA peer "$(cat siteB.pub)" endpoint 127.0.0.1:51821
ip netns exec siteB wg set wgB peer "$(cat siteA.pub)" endpoint 127.0.0.1:51820

echo '=== block 6 ==='
ip netns exec siteA ping -c3 10.99.0.2
ip netns exec siteA wg show
ip netns exec siteB wg show

