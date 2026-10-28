#!/usr/bin/env bash
# Lab 44 — Log Investigation: Building an Attack Timeline
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y gawk coreutils
mkdir -p /root/investigation && cd /root/investigation

echo '=== block 2 ==='
cat > /root/investigation/auth.log <<'EOF'
Mar 14 01:02:11 web01 sshd[1140]: Failed password for invalid user admin from 203.0.113.66 port 51001 ssh2
Mar 14 01:02:13 web01 sshd[1141]: Failed password for invalid user root from 203.0.113.66 port 51002 ssh2
Mar 14 01:02:15 web01 sshd[1142]: Failed password for invalid user oracle from 203.0.113.66 port 51003 ssh2
Mar 14 01:02:17 web01 sshd[1143]: Failed password for webadmin from 203.0.113.66 port 51004 ssh2
Mar 14 01:02:19 web01 sshd[1144]: Failed password for webadmin from 203.0.113.66 port 51005 ssh2
Mar 14 01:02:21 web01 sshd[1145]: Failed password for webadmin from 203.0.113.66 port 51006 ssh2
Mar 14 01:02:23 web01 sshd[1146]: Failed password for webadmin from 203.0.113.66 port 51007 ssh2
Mar 14 01:02:25 web01 sshd[1147]: Failed password for webadmin from 203.0.113.66 port 51008 ssh2
Mar 14 01:02:40 web01 sshd[1150]: Accepted password for webadmin from 203.0.113.66 port 51020 ssh2
Mar 14 01:02:40 web01 sshd[1150]: pam_unix(sshd:session): session opened for user webadmin by (uid=0)
Mar 14 01:03:05 web01 sudo:  webadmin : TTY=pts/0 ; PWD=/home/webadmin ; USER=root ; COMMAND=/usr/bin/cat /etc/shadow
Mar 14 01:03:30 web01 sudo:  webadmin : TTY=pts/0 ; PWD=/home/webadmin ; USER=root ; COMMAND=/usr/sbin/useradd -m -s /bin/bash support
Mar 14 01:03:31 web01 sudo:  webadmin : TTY=pts/0 ; PWD=/home/webadmin ; USER=root ; COMMAND=/usr/bin/passwd support
Mar 14 08:15:02 web01 sshd[2201]: Accepted publickey for ops from 198.51.100.4 port 44512 ssh2
Mar 14 08:16:40 web01 sudo:  ops : TTY=pts/1 ; PWD=/home/ops ; USER=root ; COMMAND=/usr/bin/apt-get update
EOF
wc -l /root/investigation/auth.log

echo '=== block 3 ==='
cat > /root/investigation/access.log <<'EOF'
198.51.100.9 - - [14/Mar/2026:00:58:01 +0000] "GET / HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
203.0.113.66 - - [14/Mar/2026:00:59:11 +0000] "GET /index.php?page=../../../../etc/passwd HTTP/1.1" 200 2048 "-" "sqlmap/1.7"
203.0.113.66 - - [14/Mar/2026:00:59:14 +0000] "GET /products?id=1%20UNION%20SELECT%20username,password%20FROM%20users HTTP/1.1" 500 512 "-" "sqlmap/1.7"
203.0.113.66 - - [14/Mar/2026:00:59:18 +0000] "GET /search?q=<script>alert(1)</script> HTTP/1.1" 200 640 "-" "sqlmap/1.7"
203.0.113.66 - - [14/Mar/2026:00:59:40 +0000] "POST /admin/login HTTP/1.1" 401 180 "-" "sqlmap/1.7"
203.0.113.66 - - [14/Mar/2026:01:00:05 +0000] "POST /admin/login HTTP/1.1" 401 180 "-" "sqlmap/1.7"
203.0.113.66 - - [14/Mar/2026:01:00:22 +0000] "POST /admin/login HTTP/1.1" 302 0 "-" "sqlmap/1.7"
198.51.100.9 - - [14/Mar/2026:01:05:00 +0000] "GET /about HTTP/1.1" 200 980 "-" "Mozilla/5.0"
203.0.113.66 - - [14/Mar/2026:01:06:10 +0000] "GET /uploads/shell.php?cmd=id HTTP/1.1" 200 44 "-" "curl/8.0"
EOF
wc -l /root/investigation/access.log

echo '=== block 4 ==='
cd /root/investigation
grep 'Failed password' auth.log | grep -oE 'from [0-9.]+' | awk '{print $2}' | sort | uniq -c | sort -rn
echo "--- usernames the attacker tried ---"
grep 'Failed password' auth.log | grep -oE '(invalid user [a-z]+|for [a-z]+) from' | sed -E 's/ from//; s/invalid user //; s/for //' | sort | uniq -c | sort -rn

echo '=== block 5 ==='
grep 'Accepted' auth.log
echo "--- did the successful login come from the brute-force IP? ---"
grep -E 'Accepted .* from 203.0.113.66' auth.log && echo ">> webadmin was compromised from the attacker IP"

echo '=== block 6 ==='
grep 'sudo:' auth.log | sed -E 's/.*sudo:  *([a-z]+) .*USER=([a-z]+) ; COMMAND=(.*)/\1 -> \2 : \3/'
echo "--- persistence: new account created by the compromised user ---"
grep -E 'sudo:.*webadmin.*useradd' auth.log

echo '=== block 7 ==='
cd /root/investigation
echo "--- requests from the attacker IP ---"
awk '$1=="203.0.113.66"' access.log | awk -F'"' '{print $2, "=>", $3}'
echo "--- attack signatures ---"
grep -En '\.\./|UNION SELECT|<script>|shell\.php' access.log
echo "--- auth attempts on /admin/login by status ---"
awk '/\/admin\/login/ {print $9}' access.log | sort | uniq -c

echo '=== block 8 ==='
logger -p auth.info -t sshd "Accepted password for webadmin from 203.0.113.66 port 51020 ssh2"
journalctl -t sshd --since "-5 min" --no-pager | tail -3
journalctl _COMM=sudo --since today --no-pager | tail -3 2>/dev/null || echo "(no sudo events in the journal yet)"
journalctl -t sshd --since "-10 min" -o short-iso --no-pager | grep -c 'Accepted\|Failed' || true

echo '=== block 9 ==='
cd /root/investigation
{
  awk '{t=$1" "$2" "$3; sub(/:[0-9]+$/,"",$0)}
       /Failed password/      {print $3"  AUTH  brute-force failure from "$0; }' auth.log >/dev/null
  # auth.log: field 3 is HH:MM:SS
  grep -E 'Failed password|Accepted|sudo:' auth.log | awk '{printf "%s  AUTH   %s\n", $3, substr($0, index($0,$5))}'
  # access.log: timestamp is inside [dd/Mon/yyyy:HH:MM:SS +0000]
  awk -F'[][]' '{split($2,a,":"); printf "%s:%s:%s  WEB    %s %s %s\n", a[2],a[3],a[4], $1, $3, ""}' access.log \
    | sed -E 's/(WEB  +[0-9.]+) - - /\1 /'
} | sort > timeline.txt
sed -n '1,30p' timeline.txt

echo '=== block 10 ==='
cd /root/investigation
echo "Top attacker: $(grep 'Failed password' auth.log | grep -oE 'from [0-9.]+' | awk '{print $2}' | sort | uniq -c | sort -rn | head -1)"
grep -q 'Accepted password for webadmin from 203.0.113.66' auth.log && echo "PASS: compromised account identified"
grep -qE 'useradd .* support' auth.log && echo "PASS: persistence (new account) found"
test -s timeline.txt && echo "PASS: timeline built with $(wc -l < timeline.txt) events"
