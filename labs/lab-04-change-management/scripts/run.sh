#!/usr/bin/env bash
# Lab 04 — Change Management with Version-Controlled Configuration
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y git curl
git config --global user.name "Lab Admin" && git config --global user.email "admin@lab.local"
DEBIAN_FRONTEND=noninteractive apt-get install -y etckeeper nginx
systemctl enable --now nginx
mkdir -p /root/change/staging && cd /root/change

echo '=== block 2 ==='
[ -d /etc/.git ] || etckeeper init
etckeeper commit "Baseline before CHG-1001" >/dev/null 2>&1 || true
git -C /etc log --oneline | head -5
git -C /etc status --short | wc -l

echo '=== block 3 ==='
cat > /root/change/CHG-1001.txt <<'EOF'
CHANGE REQUEST CHG-1001
Title        : Restrict nginx admin port 8081 to an allow list, add a deny list and nosniff header
Owner        : Lab Admin (web platform team)
Stakeholders : Web users, security operations, monitoring team, service desk
Type         : Normal change (CAB review required)
Reason       : Pen-test finding PT-17 - admin interface reachable from any address
Scope        : /etc/nginx/conf.d/chg-1001.conf on web01 only
Restricted   : No edits outside conf.d, no restart of other services, no package upgrades
Impact       : Admin port closed to all except allow list; config reload only (no downtime)
Dependencies : Monitoring health check polls 127.0.0.1:8081 every minute; legacy report tool uses port 80
Window       : Sunday 02:00-03:00 SGT (lowest traffic)
Test plan    : Staging instance; nginx -t; allow-listed source gets 200; header present
Backout plan : git -C /etc revert the CHG-1001 commit, nginx -t, systemctl reload nginx
Approval     : PENDING CAB
EOF
cat /root/change/CHG-1001.txt

echo '=== block 4 ==='
ss -tlnp | grep nginx
systemctl list-dependencies --reverse nginx.service --no-pager | head -5
ls /etc/nginx/conf.d/ /etc/nginx/sites-enabled/
grep -rn "listen" /etc/nginx/sites-enabled/
echo "Impact check $(date +%F): nginx on :80 only today; new :8081 listener; monitoring at 127.0.0.1 is a dependency" >> /root/change/CHG-1001.txt

echo '=== block 5 ==='
cat > /root/change/staging/chg-1001.conf <<'EOF'
# CHG-1001: admin allow list, deny list and security header
deny 203.0.113.0/24;
deny 198.51.100.23;
add_header X-Content-Type-Options "nosniff" always;
server {
    listen 8081;
    root /var/www/html;
    index index.html index.nginx-debian.html;
    location / {
        allow 10.10.0.0/16;
        deny  all;
    }
}
EOF
cat > /root/change/staging/nginx.conf <<'EOF'
pid /root/change/staging/nginx.pid;
error_log /root/change/staging/error.log;
events {}
http { access_log off; include /root/change/staging/chg-1001.conf; }
EOF
nginx -t -p /root/change/staging -c /root/change/staging/nginx.conf
nginx -p /root/change/staging -c /root/change/staging/nginx.conf && sleep 1
curl -s -o /dev/null -w "staging test 1 (monitoring host): HTTP %{http_code}\n" http://127.0.0.1:8081/
sed -i 's#allow 10.10.0.0/16;#allow 10.10.0.0/16;\n        allow 127.0.0.1;#' /root/change/staging/chg-1001.conf
nginx -p /root/change/staging -c /root/change/staging/nginx.conf -s reload && sleep 1
curl -s -o /dev/null -w "staging test 2 (monitoring host): HTTP %{http_code}\n" http://127.0.0.1:8081/
nginx -p /root/change/staging -c /root/change/staging/nginx.conf -s stop
echo "Test results $(date +%T): test 1 HTTP 403 (monitoring blocked), allow 127.0.0.1 added, test 2 HTTP 200" >> /root/change/CHG-1001.txt

echo '=== block 6 ==='
sed -i "s/^Approval     : PENDING CAB/Approval     : APPROVED by CAB on $(date +%F) for the Sunday window/" /root/change/CHG-1001.txt
grep '^Approval' /root/change/CHG-1001.txt
cp /root/change/staging/chg-1001.conf /etc/nginx/conf.d/chg-1001.conf
nginx -t
OLD=$(cat /run/nginx.pid); systemctl reload nginx; sleep 1; NEW=$(cat /run/nginx.pid)
echo "nginx master PID before=$OLD after=$NEW (same PID = reload, no downtime)"
curl -s -o /dev/null -w "production admin port from monitoring host: HTTP %{http_code}\n" http://127.0.0.1:8081/
curl -sI http://127.0.0.1/ | grep -i "x-content-type-options"

echo '=== block 7 ==='
etckeeper commit "CHG-1001: nginx admin allow list, deny list, nosniff header"
git -C /etc log --oneline -3
git -C /etc show --stat HEAD | head -12
cat >> /root/change/network-diagram.txt <<'EOF'
[Internet] --80/tcp--> [web01 nginx]   (deny list: 203.0.113.0/24, 198.51.100.23)
[Admin VLAN 10.10.0.0/16 + monitoring 127.0.0.1] --8081/tcp--> [web01 admin]   (updated CHG-1001)
EOF
echo "$(date +%F) CHG-1001 implemented and verified; SOP-WEB-02 updated with the allow-list request step" >> /root/change/CHANGELOG.txt
cat /root/change/network-diagram.txt /root/change/CHANGELOG.txt

echo '=== block 8 ==='
echo "deny 127.0.0.1" >> /etc/nginx/conf.d/chg-1001.conf
git -C /etc status --short nginx/
git -C /etc diff nginx/conf.d/chg-1001.conf | tail -3
nginx -t 2>&1 | tail -1 || true
git -C /etc checkout -- nginx/conf.d/chg-1001.conf
nginx -t && systemctl reload nginx
git -C /etc status --short nginx/ | wc -l
echo "$(date +%F) Unauthorised edit to chg-1001.conf detected and reverted; incident INC-2001 raised" >> /root/change/CHANGELOG.txt

echo '=== block 9 ==='
git -C /etc log --oneline | grep -c "CHG-1001:"
git -C /etc status --short nginx/ | wc -l
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8081/
curl -sI http://127.0.0.1/ | grep -ci "x-content-type-options: nosniff"
grep -c "APPROVED" /root/change/CHG-1001.txt
