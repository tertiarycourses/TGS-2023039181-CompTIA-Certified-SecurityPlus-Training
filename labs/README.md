# CompTIA Security+ (SY0-701) — Hands-On Labs

43 hands-on labs, organised by the five SY0-701 exam domains. Each lab is a self-contained folder with instructions, a runnable script, and a completion checklist.

Every lab runs free in the browser on the Killercoda Ubuntu Playground: https://killercoda.com/playgrounds/scenario/ubuntu

## Each lab folder contains

| File | Purpose |
|---|---|
| `README.md` | Full step-by-step lab instructions |
| `INSTRUCTIONS.md` | Quick start — how to run the lab |
| `checklist.md` | Completion / verification checklist |
| `scripts/run.sh` | All lab commands assembled into one runnable script |
| `lab-NN-slug.pdf` | Printable PDF of the lab |

## Labs by domain

### Domain 1 — General Security Concepts

- [Lab 1 — Security Controls Categorization](lab-01-security-controls/README.md)
- [Lab 2 — CIA Triad and AAA on Linux](lab-02-cia-aaa/README.md)
- [Lab 3 — Hashing, Salting, and Digital Signatures](lab-03-hashing-signatures/README.md)
- [Lab 4 — Symmetric vs. Asymmetric Encryption](lab-04-symmetric-asymmetric/README.md)
- [Lab 5 — PKI: Build Your Own Certificate Authority](lab-05-pki-ca/README.md)

### Domain 2 — Threats, Vulnerabilities & Mitigations

- [Lab 6 — Phishing Email Header Analysis (SPF / DKIM / DMARC)](lab-06-phishing-email-analysis/README.md)
- [Lab 7 — Password Attacks: Spraying, Brute Force, Cracking](lab-07-password-attacks/README.md)
- [Lab 8 — Malware Static Analysis (Safe Sample)](lab-08-malware-static-analysis/README.md)
- [Lab 9 — SQL Injection (SQLi)](lab-09-sql-injection/README.md)
- [Lab 10 — Cross-Site Scripting (XSS)](lab-10-xss/README.md)
- [Lab 11 — DoS Simulation and Detection](lab-11-dos-detection/README.md)
- [Lab 12 — Vulnerability Scanning with Nikto and Nuclei](lab-12-vulnerability-scanning/README.md)
- [Lab 13 — Linux Hardening Baseline with Lynis](lab-13-linux-hardening/README.md)

### Domain 3 — Security Architecture

- [Lab 14 — Network Segmentation with Linux Namespaces](lab-14-network-segmentation/README.md)
- [Lab 15 — Stateful Firewall with UFW and nftables](lab-15-firewall-ufw-nftables/README.md)
- [Lab 16 — Web Application Firewall (WAF) with ModSecurity](lab-16-waf-modsecurity/README.md)
- [Lab 17 — Site-to-Site VPN with WireGuard](lab-17-vpn-wireguard/README.md)
- [Lab 18 — Data at Rest: LUKS Full-Disk Encryption](lab-18-disk-encryption-luks/README.md)
- [Lab 19 — TLS Hardening and Cipher Audit](lab-19-tls-hardening/README.md)
- [Lab 20 — Backup and Recovery with restic](lab-20-backup-recovery/README.md)
- [Lab 37 — Cloud Shared Responsibility & IAM Least Privilege](lab-37-cloud-shared-responsibility/README.md)
- [Lab 38 — Container Security with Docker](lab-38-container-security-docker/README.md)
- [Lab 39 — Storage Resilience with Software RAID (mdadm)](lab-39-raid-mdadm/README.md)

### Domain 4 — Security Operations

- [Lab 21 — SSH Hardening + Fail2ban](lab-21-ssh-hardening-fail2ban/README.md)
- [Lab 22 — Identity & Access Management with PAM and sudo](lab-22-iam-pam-sudo/README.md)
- [Lab 23 — Multi-Factor Authentication with TOTP](lab-23-mfa-totp/README.md)
- [Lab 24 — SIEM Basics with Wazuh Manager (single-node)](lab-24-siem-elk-wazuh/README.md)
- [Lab 25 — Network IDS with Suricata](lab-25-ids-suricata/README.md)
- [Lab 26 — Endpoint Detection with osquery](lab-26-edr-osquery/README.md)
- [Lab 27 — File Integrity Monitoring with AIDE](lab-27-file-integrity-aide/README.md)
- [Lab 28 — Vulnerability Management Pipeline with Trivy](lab-28-vulnerability-management-trivy/README.md)
- [Lab 29 — Incident Response: Live-Triage and Forensics](lab-29-incident-response-forensics/README.md)
- [Lab 30 — Automation & Orchestration (Mini-SOAR)](lab-30-automation-soar/README.md)
- [Lab 40 — Packet Capture & Traffic Analysis](lab-40-packet-capture-analysis/README.md)
- [Lab 41 — Mobile & Endpoint Hardening Baseline](lab-41-mobile-endpoint-hardening/README.md)
- [Lab 42 — Secure Data Sanitisation (Media Disposal)](lab-42-data-sanitisation/README.md)
- [Lab 43 — Digital Forensics — Evidence Acquisition & Hashing](lab-43-digital-forensics-acquisition/README.md)

### Domain 5 — Program Management & Oversight

- [Lab 31 — Risk Register, CVSS Scoring, and Quantitative Risk](lab-31-risk-register-cvss/README.md)
- [Lab 32 — Passive Reconnaissance / OSINT](lab-32-osint-recon/README.md)
- [Lab 33 — Active Reconnaissance with Nmap](lab-33-active-recon-nmap/README.md)
- [Lab 34 — Penetration Testing with Metasploit (Authorised Lab)](lab-34-pentest-metasploit/README.md)
- [Lab 35 — Compliance Audit with OpenSCAP](lab-35-compliance-openscap/README.md)
- [Lab 36 — Security Awareness: Run a Phishing Simulation with GoPhish](lab-36-phishing-awareness-gophish/README.md)

See `tools.md` for the full tool reference.
