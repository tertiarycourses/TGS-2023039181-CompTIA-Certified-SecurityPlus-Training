#!/usr/bin/env bash
# Lab 24 — SIEM Basics with Wazuh Manager (single-node)
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh
bash wazuh-install.sh -a -i 2>&1 | tail -20

echo '=== block 2 ==='
systemctl status wazuh-manager --no-pager | head -5
systemctl status wazuh-indexer --no-pager | head -5
ss -tlnp | grep -E "1514|55000|9200"

echo '=== block 3 ==='
/var/ossec/bin/manage_agents -a -n local -i 127.0.0.1 -q
KEY=$(/var/ossec/bin/manage_agents -e 001 | tail -1)
/var/ossec/bin/manage_agents -i "$KEY" -q

echo '=== block 4 ==='
curl -sO https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.9.0-1_amd64.deb
WAZUH_MANAGER='127.0.0.1' dpkg -i wazuh-agent_4.9.0-1_amd64.deb
systemctl enable --now wazuh-agent

echo '=== block 5 ==='
for i in $(seq 1 10); do ssh -o PubkeyAuthentication=no -o StrictHostKeyChecking=no \
    baduser@127.0.0.1 2>/dev/null; done

echo '=== block 6 ==='
tail -50 /var/ossec/logs/alerts/alerts.log
grep -E "rule_id|level" /var/ossec/logs/alerts/alerts.log | tail

echo '=== block 7 ==='
TOKEN=$(curl -sk -u wazuh-wui:wazuh-wui -X POST https://localhost:55000/security/user/authenticate | jq -r .data.token)
curl -sk -H "Authorization: Bearer $TOKEN" "https://localhost:55000/manager/stats" | jq | head

