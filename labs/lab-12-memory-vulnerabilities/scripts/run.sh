#!/usr/bin/env bash
# Lab 12 — Memory Vulnerabilities & Exploit Mitigations
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq && apt-get install -y gcc gdb binutils python3

echo '=== block 2 ==='
cat > vuln.c <<'EOF'
#include <stdio.h>
#include <string.h>
int main(int argc, char **argv) {
    char buf[16];
    if (argc < 2) { printf("usage: %s <input>\n", argv[0]); return 1; }
    strcpy(buf, argv[1]);      /* no bounds check: overflow */
    printf("stored: %s\n", buf);
    return 0;
}
EOF

echo '=== block 3 ==='
gcc -fno-stack-protector -z execstack -no-pie -O0 -o vuln_off vuln.c
file vuln_off

echo '=== block 4 ==='
./vuln_off hello; echo "short exit=$?"
./vuln_off "$(python3 -c 'print("A"*64)')"; echo "long exit=$?"

echo '=== block 5 ==='
cat /proc/sys/kernel/randomize_va_space

echo '=== block 6 ==='
gcc -fstack-protector-strong -D_FORTIFY_SOURCE=2 -O2 -pie -fPIE -o vuln_on vuln.c

echo '=== block 7 ==='
./vuln_on "$(python3 -c 'print("A"*64)')" 2>&1 | head -2; echo "exit=${PIPESTATUS[0]}"

echo '=== block 8 ==='
file vuln_on
readelf -d vuln_on 2>/dev/null | grep -i 'bind\|now' || true
nm vuln_on 2>/dev/null | grep -i stack_chk || echo "canary symbol resolved at runtime"

echo '=== block 9 ==='
./vuln_off "$(python3 -c 'print("A"*64)')" 2>/dev/null; OFF=$?
./vuln_on  "$(python3 -c 'print("A"*64)')" 2>/dev/null; ON=$?
echo "unprotected=$OFF protected=$ON"
[ "$OFF" -ge 128 ] && [ "$ON" -ge 128 ] && echo "BOTH CRASH, but protected one printed 'stack smashing detected' = mitigation works"
