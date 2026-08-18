#!/usr/bin/env bash
# Lab 14 — Network Segmentation with Linux Namespaces
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
ip netns add dmz
ip netns add internal
ip netns add mgmt
ip netns list

echo '=== block 2 ==='
for z in dmz internal mgmt; do
  ip link add veth-$z type veth peer name veth-${z}-r
  ip link set veth-$z netns $z
done
ip link set veth-dmz-r up
ip link set veth-internal-r up
ip link set veth-mgmt-r up

echo '=== block 3 ==='
ip netns exec dmz      ip addr add 10.0.10.2/24 dev veth-dmz
ip netns exec internal ip addr add 10.0.20.2/24 dev veth-internal
ip netns exec mgmt     ip addr add 10.0.30.2/24 dev veth-mgmt

ip addr add 10.0.10.1/24 dev veth-dmz-r
ip addr add 10.0.20.1/24 dev veth-internal-r
ip addr add 10.0.30.1/24 dev veth-mgmt-r

for z in dmz internal mgmt; do
  ip netns exec $z ip link set veth-$z up
  ip netns exec $z ip link set lo up
done
ip netns exec dmz      ip route add default via 10.0.10.1
ip netns exec internal ip route add default via 10.0.20.1
ip netns exec mgmt     ip route add default via 10.0.30.1
sysctl -w net.ipv4.ip_forward=1

echo '=== block 4 ==='
ip netns exec dmz ping -c1 10.0.20.2
ip netns exec internal ping -c1 10.0.30.2

echo '=== block 5 ==='
iptables -P FORWARD DROP
iptables -A FORWARD -s 10.0.30.0/24 -j ACCEPT
iptables -A FORWARD -d 10.0.30.0/24 -j DROP
iptables -A FORWARD -s 10.0.20.0/24 -d 10.0.10.0/24 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -L FORWARD -n -v

echo '=== block 6 ==='
echo "DMZ->Internal (should fail):";     ip netns exec dmz ping -c1 -W1 10.0.20.2 || true
echo "Internal->DMZ (should pass):";     ip netns exec internal ping -c1 -W1 10.0.10.2
echo "Mgmt->DMZ (should pass):";         ip netns exec mgmt ping -c1 -W1 10.0.10.2
echo "DMZ->Mgmt (should fail):";         ip netns exec dmz ping -c1 -W1 10.0.30.2 || true

