#!/usr/bin/env bash
# Lab 37 — Cloud Shared Responsibility & IAM Least Privilege
# Auto-assembled from the lab's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail

echo '=== block 1 ==='
echo '{"Effect":"Allow","Action":"*","Resource":"*"}' > policy.json

echo '=== block 2 ==='
jq 'select(.Action=="*")' policy.json && echo "OVER-PERMISSIVE"

echo '=== block 3 ==='
echo '{"Effect":"Allow","Action":["s3:GetObject"],"Resource":"arn:aws:s3:::reports/*"}' > policy.json

echo '=== block 4 ==='
jq -e '.Action|index("*")|not' policy.json && echo LEAST-PRIV

echo '=== block 5 ==='
printf "IaaS: you=OS,app,data\nPaaS: you=app,data\nSaaS: you=data,IAM\n"

