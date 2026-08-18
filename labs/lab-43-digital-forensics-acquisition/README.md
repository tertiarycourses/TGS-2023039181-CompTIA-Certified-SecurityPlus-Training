# Lab 43 — Digital Forensics — Evidence Acquisition & Hashing

The learner acquires a bit-for-bit forensic image of evidence media, hashes it for integrity, recovers a deleted artefact, and records the chain of custody.

Run on https://killercoda.com/playgrounds/scenario/ubuntu

**Objective:** Acquire a forensic image with a verifiable chain of custody

**You'll build:** A forensic image with matching acquisition/verification hashes and a recovered deleted file.

**Tools:** dd, sha256sum, foremost, mmls

---

## Step 1 — Prepare evidence media with a file, then delete it

```bash
dd if=/dev/zero of=/ev.img bs=1M count=20; mkfs.ext4 /ev.img; mkdir -p /m; mount /ev.img /m; echo secret > /m/evidence.txt; rm /m/evidence.txt; umount /m
```


## Step 2 — Acquire a bit-for-bit image

```bash
dd if=/ev.img of=/case01.dd bs=512 conv=noerror,sync
```


## Step 3 — Hash the image on acquisition

```bash
sha256sum /case01.dd | tee /case01.sha256
```


## Step 4 — Recover the deleted artefact

```bash
apt install -y foremost && foremost -i /case01.dd -o /recovered 2>&1 | tail -3
```


## Step 5 — Re-verify the image hash is unchanged

```bash
sha256sum -c /case01.sha256
```


## Step 6 — Record the chain of custody

```bash
echo "Collected by: <analyst>  Date: <UTC>  Hash: $(cut -d" " -f1 /case01.sha256)"
```


---

## Verify

The acquisition and verification hashes match, and foremost recovers file data from the image.
