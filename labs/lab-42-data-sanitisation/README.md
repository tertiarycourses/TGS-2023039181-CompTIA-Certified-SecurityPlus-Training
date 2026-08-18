# Lab 42 — Secure Data Sanitisation (Media Disposal)

The learner writes sensitive data to a virtual disk, then securely sanitises it and verifies the data is unrecoverable — the disposal stage of the asset lifecycle.

Run on https://killercoda.com/playgrounds/scenario/ubuntu

**Objective:** Securely wipe media and verify destruction

**You'll build:** A wiped virtual disk whose sensitive string is no longer recoverable, with before/after evidence.

**Tools:** dd, shred, grep, strings

---

## Step 1 — Create a virtual disk with secret data

```bash
dd if=/dev/zero of=/disk.img bs=1M count=50 && echo "TOP-SECRET-DATA" >> /disk.img
```


## Step 2 — Confirm the secret is present

```bash
strings /disk.img | grep TOP-SECRET && echo FOUND
```


## Step 3 — Securely overwrite the media

```bash
shred -v -n 3 -z /disk.img
```


## Step 4 — Confirm the secret is gone

```bash
strings /disk.img | grep TOP-SECRET || echo "SANITISED — not recoverable"
```


## Step 5 — Note the method for the disposal record

```bash
echo "Method: 3-pass overwrite + zero (NIST 800-88 clear)"
```


---

## Verify

The secret string is found before shred and is absent after — sanitisation is verified.
