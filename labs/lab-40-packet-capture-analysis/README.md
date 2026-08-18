# Lab 40 — Packet Capture & Traffic Analysis

The learner captures live traffic with tcpdump, saves a PCAP, and analyses it for suspicious flows — the same skill a SOC analyst uses to confirm an alert.

Run on https://killercoda.com/playgrounds/scenario/ubuntu

**Objective:** Capture and analyse network traffic for indicators

**You'll build:** A saved PCAP plus a filtered analysis showing the target flow and any cleartext credentials.

**Tools:** tcpdump, tshark, curl

---

## Step 1 — Install the capture tools

```bash
apt install -y tcpdump tshark
```


## Step 2 — Capture traffic to a PCAP file

```bash
tcpdump -i any -w /tmp/cap.pcap -c 50 &
```


## Step 3 — Generate some HTTP traffic

```bash
curl -s http://example.com > /dev/null
```


## Step 4 — List conversations in the capture

```bash
tshark -r /tmp/cap.pcap -q -z conv,ip | head
```


## Step 5 — Filter for a suspicious port / plaintext

```bash
tshark -r /tmp/cap.pcap -Y 'http.request' -T fields -e ip.dst -e http.host | head
```


## Step 6 — Upload the PCAP to the browser PCAP Analyzer

```bash
echo "Open https://alfredang.github.io/pcapanalyzer/ and load /tmp/cap.pcap"
```


---

## Verify

The PCAP is written and tshark lists the IP conversations and the HTTP requests it contains.
