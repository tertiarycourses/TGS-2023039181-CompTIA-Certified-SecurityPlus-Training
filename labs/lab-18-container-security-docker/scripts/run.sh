#!/usr/bin/env bash
# Lab 18 — Container Security with Docker
# Auto-assembled from the lab README's command blocks. Review before running.
# Run on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive

echo '=== block 1 ==='
apt-get update -qq
command -v docker >/dev/null 2>&1 || DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io
DEBIAN_FRONTEND=noninteractive apt-get install -y libcap2-bin jq curl
systemctl start docker 2>/dev/null || true
docker version --format 'Client {{.Client.Version}} / Server {{.Server.Version}}'
mkdir -p /root/lab18 && cd /root/lab18

echo '=== block 2 ==='
docker run -d --name web-default nginx:alpine
sleep 2
docker exec web-default id
docker exec web-default grep CapEff /proc/1/status
capsh --decode=$(docker exec web-default awk '/CapEff/{print $2}' /proc/1/status)

echo '=== block 3 ==='
echo "Host kernel: $(uname -r)   Container kernel: $(docker exec web-default uname -r)"
docker exec web-default ps
PID=$(docker inspect -f '{{.State.Pid}}' web-default)
echo "Container PID 1 is host PID $PID"
readlink /proc/1/ns/pid /proc/$PID/ns/pid
readlink /proc/1/ns/net /proc/$PID/ns/net

echo '=== block 4 ==='
cd /root/lab18
cat > Dockerfile <<'EOF'
FROM alpine:3.20
RUN addgroup -S -g 10001 app && adduser -S -D -H -u 10001 -G app app
USER 10001:10001
CMD ["sleep", "3600"]
EOF
docker build -q -t lab18/app:1.0 .
docker run --rm lab18/app:1.0 id

echo '=== block 5 ==='
docker run -d --name app-hardened --read-only --tmpfs /tmp:rw,noexec,nosuid,size=16m \
  --cap-drop ALL --security-opt no-new-privileges:true lab18/app:1.0
sleep 1
docker exec app-hardened id -u
docker exec -u 0 app-hardened touch /etc/pwned 2>&1 || echo "BLOCKED: root filesystem is read-only"
docker exec app-hardened sh -c 'touch /tmp/scratch && echo "tmpfs /tmp is writable"'
docker exec -u 0 app-hardened chown 0 /tmp/scratch 2>&1 || echo "BLOCKED: root has no CAP_CHOWN"
docker exec app-hardened awk '/CapEff/{print "CapEff:", $2}' /proc/1/status

echo '=== block 6 ==='
docker run -d --name app-capped --memory 64m --cpus 0.5 --pids-limit 30 lab18/app:1.0
sleep 1
docker inspect -f 'Memory={{.HostConfig.Memory}} NanoCpus={{.HostConfig.NanoCpus}} PidsLimit={{.HostConfig.PidsLimit}}' app-capped
docker exec app-capped sh -c 'for i in $(seq 1 60); do sleep 30 & done' 2>&1 | tail -2
echo "Processes in container: $(docker exec app-capped ps -o pid= 2>/dev/null | wc -l)"
docker stats --no-stream app-capped

echo '=== block 7 ==='
for c in web-default app-hardened app-capped; do
  docker inspect -f '{{.Name}}: user={{.Config.User}} readonly={{.HostConfig.ReadonlyRootfs}} capdrop={{.HostConfig.CapDrop}} secopt={{.HostConfig.SecurityOpt}} privileged={{.HostConfig.Privileged}} mem={{.HostConfig.Memory}} pids={{.HostConfig.PidsLimit}}' "$c"
done

echo '=== block 8 ==='
cd /root/lab18
curl -sSL -o trivy.deb https://github.com/aquasecurity/trivy/releases/download/v0.74.0/trivy_0.74.0_Linux-64bit.deb
dpkg -i trivy.deb >/dev/null && trivy --version | head -1
trivy image --quiet --scanners vuln --severity HIGH,CRITICAL nginx:1.21-alpine | grep -E 'Total|^nginx' | head -5
trivy image --quiet --scanners vuln --severity HIGH,CRITICAL lab18/app:1.0 | grep -E 'Total' | head -3

echo '=== block 9 ==='
docker exec app-hardened id -u
docker exec -u 0 app-hardened touch /etc/pwned 2>&1 | grep -c "Read-only file system"
docker inspect -f '{{.HostConfig.CapDrop}} {{.HostConfig.ReadonlyRootfs}} {{.HostConfig.PidsLimit}}' app-hardened app-capped
