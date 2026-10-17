# TGS-2023039181 — CompTIA Security+ (SY0-701) Hands-On Labs & Courseware

> **Course:** WSQ — CompTIA Certified Security+ Training
> **Course Code:** TGS-2023039181
> **Register here:** https://www.tertiarycourses.com.sg/wsq-comptia-certified-security-training.html
> **Funding:** up to 70% course-fee funding for eligible learners and SMEs. Eligibility and terms apply — see the registration page.

The official courseware and hands-on lab exercises for the WSQ **CompTIA Certified Security+ Training** course delivered by [**Tertiary Infotech Academy Pte Ltd**](https://www.tertiarycourses.com.sg/).

A complete set of **43 step-by-step labs**, organised by the five [CompTIA Security+ SY0-701 exam domains](CompTIA-Security-Plus-SY0-701-Exam-Objectives.pdf). Every lab runs on the free **Killercoda Ubuntu Playground** (https://killercoda.com/playgrounds/scenario/ubuntu) — no local install required.

This is a **5-day** course (40 training hours), taught one exam domain per day.

---

## Courseware

The slide deck, Lesson Plan and Learner Guide are aligned with the 43 labs and the SY0-701 exam domains. They live in [`courseware/`](courseware/):

- **Slide deck** — `CompTIA Security+ (SY0-701)-v2.0.pptx` (+ PDF) — all-white house style; exam-domain overview up front, every key concept taught per exam objective, an overview / step / verify slide for every lab, and exam-registration + practice-exam sections at the end.
- **Lesson Plan** — `LP-CompTIA Security+ (SY0-701).docx` (+ PDF) — 5-day schedule (9:30am–6:30pm), 8 training hours/day, final assessment on Day 5.
- **Learner Guide** — `LG-CompTIA Security+ (SY0-701).docx` (+ PDF), mirrored as [`LG-CompTIA Security+ (SY0-701).md`](LG-CompTIA%20Security%2B%20(SY0-701).md) for reading on GitHub.
- **Practice exam** — https://exams.tertiaryinfotech.com/practice-exams/comptia/comptia-security-plus

> Assessment materials (question papers + answer keys) are confidential and are **not** published in this repository.

---

## Exam domains

| Domain | Weight | Focus |
|---|---|---|
| 1 · General Security Concepts | 12% | Controls, CIA/AAA, Zero Trust, cryptography, PKI |
| 2 · Threats, Vulnerabilities & Mitigations | 22% | Actors, attacks, social engineering, vulnerabilities |
| 3 · Security Architecture | 18% | Cloud/enterprise, segmentation, containers, data protection, resilience |
| 4 · Security Operations | 28% | Hardening, monitoring, IAM, IR, forensics |
| 5 · Program Management & Oversight | 20% | Governance, risk, audits, awareness |

---

## How to use a lab

Each lab is a **self-contained folder** under [`labs/`](labs/):

| File | Purpose |
|---|---|
| `README.md` | Full step-by-step lab instructions |
| `INSTRUCTIONS.md` | Quick start — how to run the lab |
| `checklist.md` | Completion / verification checklist |
| `scripts/run.sh` | All lab commands assembled into one runnable script |
| `lab-NN-slug.pdf` | Printable PDF of the lab |

1. Open the Killercoda playground: https://killercoda.com/playgrounds/scenario/ubuntu
2. Pick a lab folder and follow `README.md` in order (or run `sudo bash scripts/run.sh`).
3. Tick every item in `checklist.md` before moving on.
4. Reset the playground between labs that change firewall, PAM, routing or disk state.

See [labs/tools.md](labs/tools.md) for every free tool used, and the browser ed-tools below.

---

## Lab catalogue

### Domain 1 — General Security Concepts (12%)
- [Lab 1 — Security Controls Categorization](labs/lab-01-security-controls/README.md)
- [Lab 2 — CIA Triad and AAA on Linux](labs/lab-02-cia-aaa/README.md)
- [Lab 3 — Hashing, Salting, and Digital Signatures](labs/lab-03-hashing-signatures/README.md)
- [Lab 4 — Symmetric vs. Asymmetric Encryption](labs/lab-04-symmetric-asymmetric/README.md)
- [Lab 5 — PKI: Build Your Own Certificate Authority](labs/lab-05-pki-ca/README.md)

### Domain 2 — Threats, Vulnerabilities & Mitigations (22%)
- [Lab 6 — Phishing Email Header Analysis (SPF/DKIM/DMARC)](labs/lab-06-phishing-email-analysis/README.md)
- [Lab 7 — Password Attacks: Spraying, Brute Force, Cracking](labs/lab-07-password-attacks/README.md)
- [Lab 8 — Malware Static Analysis (EICAR + YARA)](labs/lab-08-malware-static-analysis/README.md)
- [Lab 9 — SQL Injection (manual + sqlmap)](labs/lab-09-sql-injection/README.md)
- [Lab 10 — Cross-Site Scripting (XSS)](labs/lab-10-xss/README.md)
- [Lab 11 — DoS Simulation and Detection](labs/lab-11-dos-detection/README.md)
- [Lab 12 — Vulnerability Scanning with Nikto and Nuclei](labs/lab-12-vulnerability-scanning/README.md)
- [Lab 13 — Linux Hardening Baseline with Lynis](labs/lab-13-linux-hardening/README.md)

### Domain 3 — Security Architecture (18%)
- [Lab 14 — Network Segmentation with Linux Namespaces](labs/lab-14-network-segmentation/README.md)
- [Lab 15 — Stateful Firewall with UFW and nftables](labs/lab-15-firewall-ufw-nftables/README.md)
- [Lab 16 — Web Application Firewall with ModSecurity + OWASP CRS](labs/lab-16-waf-modsecurity/README.md)
- [Lab 17 — Site-to-Site VPN with WireGuard](labs/lab-17-vpn-wireguard/README.md)
- [Lab 18 — Data at Rest: LUKS Full-Disk Encryption](labs/lab-18-disk-encryption-luks/README.md)
- [Lab 19 — TLS Hardening and Cipher Audit](labs/lab-19-tls-hardening/README.md)
- [Lab 20 — Backup and Recovery with restic (3-2-1)](labs/lab-20-backup-recovery/README.md)
- [Lab 37 — Cloud Shared Responsibility & IAM Least Privilege](labs/lab-37-cloud-shared-responsibility/README.md)
- [Lab 38 — Container Security with Docker](labs/lab-38-container-security-docker/README.md)
- [Lab 39 — Storage Resilience with Software RAID (mdadm)](labs/lab-39-raid-mdadm/README.md)

### Domain 4 — Security Operations (28%)
- [Lab 21 — SSH Hardening + Fail2ban](labs/lab-21-ssh-hardening-fail2ban/README.md)
- [Lab 22 — Identity & Access Management with PAM and sudo](labs/lab-22-iam-pam-sudo/README.md)
- [Lab 23 — Multi-Factor Authentication with TOTP](labs/lab-23-mfa-totp/README.md)
- [Lab 24 — SIEM Basics with Wazuh Manager](labs/lab-24-siem-elk-wazuh/README.md)
- [Lab 25 — Network IDS with Suricata](labs/lab-25-ids-suricata/README.md)
- [Lab 26 — Endpoint Detection with osquery](labs/lab-26-edr-osquery/README.md)
- [Lab 27 — File Integrity Monitoring with AIDE](labs/lab-27-file-integrity-aide/README.md)
- [Lab 28 — Vulnerability Management Pipeline with Trivy](labs/lab-28-vulnerability-management-trivy/README.md)
- [Lab 29 — Incident Response: Live-Triage and Forensics](labs/lab-29-incident-response-forensics/README.md)
- [Lab 30 — Automation & Orchestration (Mini-SOAR)](labs/lab-30-automation-soar/README.md)
- [Lab 40 — Packet Capture & Traffic Analysis](labs/lab-40-packet-capture-analysis/README.md)
- [Lab 41 — Mobile & Endpoint Hardening Baseline](labs/lab-41-mobile-endpoint-hardening/README.md)
- [Lab 42 — Secure Data Sanitisation (Media Disposal)](labs/lab-42-data-sanitisation/README.md)
- [Lab 43 — Digital Forensics — Evidence Acquisition & Hashing](labs/lab-43-digital-forensics-acquisition/README.md)

### Domain 5 — Security Program Management & Oversight (20%)
- [Lab 31 — Risk Register, CVSS Scoring, and Quantitative Risk](labs/lab-31-risk-register-cvss/README.md)
- [Lab 32 — Passive Reconnaissance / OSINT](labs/lab-32-osint-recon/README.md)
- [Lab 33 — Active Reconnaissance with Nmap](labs/lab-33-active-recon-nmap/README.md)
- [Lab 34 — Penetration Testing with Metasploit](labs/lab-34-pentest-metasploit/README.md)
- [Lab 35 — Compliance Audit with OpenSCAP](labs/lab-35-compliance-openscap/README.md)
- [Lab 36 — Security Awareness: Phishing Simulation with GoPhish](labs/lab-36-phishing-awareness-gophish/README.md)

---

## Browser ed-tools (interactive, no install)

Used throughout the labs to visualise and practise concepts:

- **Cybersecurity Simulator** — https://alfredang.github.io/cybersecuritysimulator/
- **Ethical Hacking Toolkit** — https://alfredang.github.io/ethnicalhacking/
- **FauxBank Pentest Target** — https://pentest-fauxbank.vercel.app/
- **Cryptography Toolkit** — https://alfredang.github.io/cryptography-toolkit/
- **IP Calculator** — https://alfredang.github.io/ipcalculator/
- **PCAP Analyzer** — https://alfredang.github.io/pcapanalyzer/
- **Regex Generator** — https://alfredang.github.io/regexgenerator/

Full tool list: [labs/tools.md](labs/tools.md).

---

## Reference

- [labs/README.md](labs/README.md) — Lab index grouped by domain
- [labs/tools.md](labs/tools.md) — Complete list of free tools (Killercoda + browser ed-tools)
- [CompTIA-Security-Plus-SY0-701-Exam-Objectives.pdf](CompTIA-Security-Plus-SY0-701-Exam-Objectives.pdf) — Official exam blueprint

---

## Legal & ethical use

Labs that involve scanning, exploitation, password cracking, phishing simulation, or DoS techniques (Labs 7, 9, 10, 11, 32, 33, 34, 36) must be performed **only** against:

- Systems you own (the Killercoda VM, your own containers, the FauxBank practice target).
- Targets explicitly listed in a signed authorisation / Rules of Engagement.
- Public CTF / training ranges (HackTheBox, TryHackMe, VulnHub).

Unauthorised use against third-party systems is illegal in most jurisdictions, including the **Singapore Computer Misuse Act (Cap. 50A)**.
