# Lab 38 — Container Security with Docker

The learner runs a container, inspects its isolation, drops capabilities, runs as non-root and scans the image for vulnerabilities.

Run on https://killercoda.com/playgrounds/scenario/ubuntu

**Objective:** Run and harden a container securely

**You'll build:** A non-root, capability-dropped container and a Trivy image-scan report.

**Tools:** docker, trivy

---

## Step 1 — Install Docker and run a container

```bash
apt install -y docker.io && docker run -d --name web nginx
```


## Step 2 — Inspect the default (root) user

```bash
docker exec web whoami
```


## Step 3 — Re-run dropping all capabilities and as non-root

```bash
docker run -d --name safe --user 1000 --cap-drop ALL --read-only nginx 2>&1 | tail -1
```


## Step 4 — Confirm the container cannot write the filesystem

```bash
docker exec safe touch /tmp/x 2>&1 || echo "READ-ONLY enforced"
```


## Step 5 — Scan the image for known CVEs

```bash
trivy image --severity HIGH,CRITICAL nginx | head -30
```


## Step 6 — Limit resources to blunt a DoS

```bash
docker run -d --name capped --memory 128m --cpus 0.5 nginx
```


---

## Verify

The hardened container runs as UID 1000 with no capabilities on a read-only root, and Trivy lists the image CVEs.
