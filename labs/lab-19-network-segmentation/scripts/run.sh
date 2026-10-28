#!/usr/bin/env bash
# Lab 19 — Network Segmentation and Security Zones
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y iproute2 iptables iputils-ping netcat-openbsd curl python3

echo '=== block 2 ==='
for z in dmz internal mgmt; do ip netns add $z; done
ip netns list

echo '=== block 3 ==='
declare -A NET=([dmz]=10 [internal]=20 [mgmt]=30)
for z in dmz internal mgmt; do
  n=${NET[$z]}
  ip link add veth-$z type veth peer name veth-$z-r
  ip link set veth-$z netns $z
  ip addr add 10.0.$n.1/24 dev veth-$z-r && ip link set veth-$z-r up
  ip netns exec $z ip addr add 10.0.$n.2/24 dev veth-$z
  ip netns exec $z ip link set veth-$z up
  ip netns exec $z ip link set lo up
  ip netns exec $z ip route add default via 10.0.$n.1
done
sysctl -w net.ipv4.ip_forward=1
iptables -I FORWARD 1 -i veth-+ -o veth-+ -j ACCEPT   # temporary: flat network
ip -br addr | grep veth

echo '=== block 4 ==='
# a plain TCPServer avoids http.server's slow reverse-DNS lookup inside the namespace
ip netns exec dmz python3 -c 'import http.server as h, socketserver as s; s.TCPServer(("10.0.10.2", 80), h.SimpleHTTPRequestHandler).serve_forever()' >/dev/null 2>&1 &
ip netns exec internal nc -lk 5432 >/dev/null 2>&1 &
sleep 1
ip netns exec internal curl -s -o /dev/null -w "internal -> DMZ web: HTTP %{http_code}\n" http://10.0.10.2/
ip netns exec dmz nc -zv -w2 10.0.20.2 5432
ip netns exec dmz ping -c1 -W1 10.0.30.2 >/dev/null && echo "DMZ -> mgmt ping: reachable (bad)"

echo '=== block 5 ==='
iptables -D FORWARD -i veth-+ -o veth-+ -j ACCEPT
iptables -N ZONES 2>/dev/null || iptables -F ZONES
iptables -A ZONES -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A ZONES -s 10.0.30.0/24 -m comment --comment "mgmt/jump server to any" -j ACCEPT
iptables -A ZONES -s 10.0.20.0/24 -d 10.0.10.0/24 -p tcp --dport 80 -m comment --comment "internal to DMZ web" -j ACCEPT
iptables -A ZONES -m limit --limit 10/min -j LOG --log-prefix "ZONE-DROP "
iptables -A ZONES -m comment --comment "default deny" -j DROP
iptables -I FORWARD 1 -i veth-+ -o veth-+ -j ZONES
iptables -L ZONES -n --line-numbers

echo '=== block 6 ==='
echo "internal -> DMZ web (allow):"; ip netns exec internal curl -s -o /dev/null -w "  HTTP %{http_code}\n" http://10.0.10.2/
echo "internal -> DMZ ping (deny, not a published service):"; ip netns exec internal ping -c1 -W1 10.0.10.2 >/dev/null || echo "  blocked"
echo "DMZ -> internal DB (deny, lateral movement):"; ip netns exec dmz nc -zv -w2 10.0.20.2 5432 2>&1 | sed 's/^/  /'
echo "DMZ -> mgmt (deny):"; ip netns exec dmz ping -c1 -W1 10.0.30.2 >/dev/null || echo "  blocked"
echo "mgmt -> DMZ and internal (allow, jump server):"
ip netns exec mgmt ping -c1 -W1 10.0.10.2 >/dev/null && echo "  DMZ reachable"
ip netns exec mgmt nc -zv -w2 10.0.20.2 5432 2>&1 | sed 's/^/  /'

echo '=== block 7 ==='
iptables -L ZONES -n -v --line-numbers
dmesg 2>/dev/null | grep ZONE-DROP | tail -3

echo '=== block 8 ==='
ip netns exec internal curl -s -o /dev/null -w "%{http_code}\n" http://10.0.10.2/
ip netns exec dmz nc -z -w2 10.0.20.2 5432 && echo "FAIL: lateral path open" || echo "PASS: DMZ cannot reach internal"
