#!/usr/bin/env bash
# Lab 48 — Compliance Audit with OpenSCAP
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq
apt-get install -y ssg-base ssg-debian ssg-debderived
apt-get install -y openscap-scanner || apt-get install -y libopenscap8
ls /usr/share/xml/scap/ssg/content/ | grep ubuntu

echo '=== block 2 ==='
DS=$(ls /usr/share/xml/scap/ssg/content/ssg-ubuntu*-ds.xml | head -1)
echo "Using $DS"

echo '=== block 3 ==='
oscap info "$DS" | grep -A1 -i profile | head -20

echo '=== block 4 ==='
oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cis_level1_server \
  --results-arf arf.xml \
  --report report.html \
  "$DS" 2>&1 | tail -10
ls -l report.html arf.xml

echo '=== block 5 ==='
oscap xccdf generate fix \
  --profile xccdf_org.ssgproject.content_profile_cis_level1_server \
  --output remediate.sh "$DS"
head -20 remediate.sh

echo '=== block 6 ==='
apt-get purge -y telnet 2>/dev/null || true
oscap xccdf eval \
  --rule xccdf_org.ssgproject.content_rule_package_telnet_removed \
  "$DS" 2>&1 | grep -i result

echo '=== block 7 ==='
test -s report.html && echo "HTML report generated"
grep -ci 'pass\|fail' report.html
