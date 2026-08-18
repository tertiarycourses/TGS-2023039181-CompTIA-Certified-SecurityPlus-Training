# Lab 41 — Mobile & Endpoint Hardening Baseline

The learner applies a hardening baseline to a Linux endpoint (the stand-in for a managed mobile/endpoint), disabling weak services and enforcing policy, then verifies it.

Run on https://killercoda.com/playgrounds/scenario/ubuntu

**Objective:** Apply and verify an endpoint hardening baseline

**You'll build:** A hardened host with password policy, disabled root SSH, and a screen-lock/idle-timeout policy — verified against a checklist.

**Tools:** sshd_config, login.defs, pam, systemctl

---

## Step 1 — Enforce a minimum password age/length policy

```bash
sed -i "s/^PASS_MIN_LEN.*/PASS_MIN_LEN 12/" /etc/login.defs 2>/dev/null; grep PASS_ /etc/login.defs
```


## Step 2 — Disable direct root SSH login

```bash
sed -i "s/^#*PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config
```


## Step 3 — Set an idle session timeout

```bash
echo "TMOUT=600; readonly TMOUT" > /etc/profile.d/timeout.sh
```


## Step 4 — Disable an unneeded service

```bash
systemctl disable --now avahi-daemon 2>/dev/null; echo done
```


## Step 5 — Verify the baseline against a checklist

```bash
grep PermitRootLogin /etc/ssh/sshd_config && cat /etc/profile.d/timeout.sh
```


---

## Verify

Root SSH login is disabled, the password policy is set, and the idle-timeout policy is present.
