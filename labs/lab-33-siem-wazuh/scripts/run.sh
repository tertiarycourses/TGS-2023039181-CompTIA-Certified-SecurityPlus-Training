#!/usr/bin/env bash
# Lab 33 — SIEM Alerting and Monitoring with Wazuh
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y curl jq openssh-client
cd /root && curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh
bash wazuh-install.sh -a -i 2>&1 | tail -8

echo '=== block 2 ==='
for s in wazuh-manager wazuh-indexer wazuh-dashboard; do printf '%-16s %s\n' "$s" "$(systemctl is-active $s)"; done
ss -tlnp | grep -E ':(1514|1515|55000|9200|443) '
API_PASS=$(tar -xOf /root/wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt | grep -A1 "api_username: 'wazuh'" | awk -F"'" '/api_password/ {print $2}')
echo "API password captured: ${API_PASS:+yes}"

echo '=== block 3 ==='
touch /var/log/labapp.log
cat >> /var/ossec/etc/ossec.conf <<'EOF'
<ossec_config>
  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/labapp.log</location>
  </localfile>
</ossec_config>
EOF
cat >> /var/ossec/etc/rules/local_rules.xml <<'EOF'

<group name="local,labapp,">
  <rule id="100100" level="10">
    <match>LABAPP: bulk export</match>
    <description>Lab app: bulk export of customer records (possible data exfiltration)</description>
    <mitre><id>T1567</id></mitre>
  </rule>
</group>
EOF
systemctl restart wazuh-manager && sleep 10
echo 'Oct 28 10:15:00 web01 labapp: LABAPP: bulk export user=bob rows=50000' | /var/ossec/bin/wazuh-logtest 2>&1 | grep -E "id: '100100'|level:|description:"

echo '=== block 4 ==='
for i in $(seq 1 12); do ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=3 "baduser$i@127.0.0.1" true 2>/dev/null; done
echo "$(date '+%b %e %H:%M:%S') $(hostname) labapp: LABAPP: bulk export user=bob rows=50000" >> /var/log/labapp.log
sleep 20

echo '=== block 5 ==='
ALERTS=/var/ossec/logs/alerts/alerts.json
jq -c 'select(.rule.id=="5710" or .rule.id=="5712" or .rule.id=="100100") | {time:.timestamp, rule:.rule.id, level:.rule.level, desc:.rule.description, srcip:.data.srcip}' "$ALERTS" | tail -6
echo "== Alert summary by rule =="
jq -r '"\(.rule.level)\t\(.rule.id)\t\(.rule.description)"' "$ALERTS" | sort | uniq -c | sort -nr | head -10 | tee /root/alert-summary.txt

echo '=== block 6 ==='
cat >> /var/ossec/etc/rules/local_rules.xml <<'EOF'

<group name="local,tuning,">
  <rule id="100110" level="0">
    <if_sid>5710</if_sid>
    <srcip>10.99.99.99</srcip>
    <description>Tuning: approved scanner 10.99.99.99 (change CR-2026-118) - suppressed</description>
  </rule>
</group>
EOF
systemctl restart wazuh-manager && sleep 10
printf '%s\n' "Oct 28 02:00:01 web01 sshd[4242]: Invalid user admin from 10.99.99.99 port 51000" \
  | /var/ossec/bin/wazuh-logtest 2>&1 | grep -E "id: '|level:"
printf '%s\n' "Oct 28 02:00:02 web01 sshd[4243]: Invalid user admin from 203.0.113.50 port 51001" \
  | /var/ossec/bin/wazuh-logtest 2>&1 | grep -E "id: '|level:"

echo '=== block 7 ==='
API_PASS=$(tar -xOf /root/wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt | grep -A1 "api_username: 'wazuh'" | awk -F"'" '/api_password/ {print $2}')
TOKEN=$(curl -sk -u "wazuh:$API_PASS" -X POST "https://localhost:55000/security/user/authenticate?raw=true")
curl -sk -H "Authorization: Bearer $TOKEN" "https://localhost:55000/manager/status" | jq '.data.affected_items[0]' | head -12
curl -sk -H "Authorization: Bearer $TOKEN" "https://localhost:55000/agents?select=name,ip,status" | jq '.data.affected_items'

echo '=== block 8 ==='
sed -i 's|<logall_json>no</logall_json>|<logall_json>yes</logall_json>|' /var/ossec/etc/ossec.conf
grep -m1 logall_json /var/ossec/etc/ossec.conf
systemctl restart wazuh-manager && sleep 15
echo "$(date '+%b %e %H:%M:%S') $(hostname) labapp: LABAPP: login user=alice" >> /var/log/labapp.log
sleep 10
tail -1 /var/ossec/logs/archives/archives.json | jq -c '{time:.timestamp, location:.location, log:.full_log}'
ls /var/ossec/logs/alerts/ /var/ossec/logs/archives/

echo '=== block 9 ==='
jq -r 'select(.rule.id=="100100" or .rule.id=="5712" or .rule.id=="5710") | .rule.id' /var/ossec/logs/alerts/alerts.json | sort | uniq -c
grep -c '"rule":{"level":0' /var/ossec/logs/alerts/alerts.json || true
test -s /var/ossec/logs/archives/archives.json && echo "ARCHIVING ON"
