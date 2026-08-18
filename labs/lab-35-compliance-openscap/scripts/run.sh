#!/usr/bin/env bash
# Lab 35 — Compliance Audit with OpenSCAP
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
apt update && apt install -y ssg-base ssg-debian ssg-debderived python3
apt install -y openscap-scanner || apt install -y libopenscap8
ls /usr/share/xml/scap/ssg/content/

echo '=== block 2 ==='
DS=$(ls /usr/share/xml/scap/ssg/content/ssg-ubuntu*-ds.xml | head -1)
oscap info $DS | grep -A1 Profile | head -20

echo '=== block 3 ==='
oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_cis_level1_server \
   --results-arf arf.xml \
   --report report.html \
   $DS 2>&1 | tail -10

echo '=== block 4 ==='
grep -E "result|Score" report.html 2>/dev/null | head
oscap xccdf generate guide --profile xccdf_org.ssgproject.content_profile_cis_level1_server $DS > guide.html

echo '=== block 5 ==='
oscap xccdf generate fix \
   --profile xccdf_org.ssgproject.content_profile_cis_level1_server \
   --output remediate.sh $DS
head -20 remediate.sh
chmod +x remediate.sh

echo '=== block 6 ==='
apt purge -y telnet 2>/dev/null
oscap xccdf eval --rule xccdf_org.ssgproject.content_rule_package_telnet_removed $DS

