# CompTIA Security+ Certification (SY0-701) — Lab Index

**52 hands-on labs**, numbered in the official SY0-701 order: Domain → Objective → Lab. Every exam objective has at least one lab.

All labs run on the free **Killercoda Ubuntu Playground**: **https://killercoda.com/playgrounds/scenario/ubuntu**

Each lab is a self-contained folder:

| File | Purpose |
|---|---|
| `README.md` | Full step-by-step instructions, troubleshooting, challenge and exam tips |
| `INSTRUCTIONS.md` | Quick start |
| `checklist.md` | Completion checklist |
| `scripts/run.sh` | Every command block assembled into one script |
| `lab-NN-slug.pdf` | Printable copy |

## Domain 1 — General Security Concepts (12%)

| Lab | Objective | Title | Tools | Time |
|---|---|---|---|---|
| 1 | 1.1 Types of Security Controls | [Security Controls Categorization](lab-01-security-controls/README.md) | iptables, auditd, ausearch, sshd, sha256sum, column | ~35 min |
| 2 | 1.2 Fundamental Security Concepts | [CIA Triad and AAA on Linux](lab-02-cia-aaa/README.md) | chmod, sha256sum, systemd, chpasswd, openssl passwd, ssh-keygen, sudo, journalctl | ~35 min |
| 3 | 1.2 Fundamental Security Concepts | [Deception: Honeypots, Honeyfiles and Honeytokens](lab-03-deception-honeypots/README.md) | python3, netcat, auditd, inotifywait, ip netns, curl | ~35 min |
| 4 | 1.3 Change Management | [Change Management with Version-Controlled Configuration](lab-04-change-management/README.md) | etckeeper, git, nginx, curl, systemctl | ~45 min |
| 5 | 1.4 Cryptographic Solutions | [Hashing, Salting, and Digital Signatures](lab-05-hashing-signatures/README.md) | sha256sum, openssl passwd, openssl kdf, openssl dgst, openssl genpkey, chpasswd | ~45 min |
| 6 | 1.4 Cryptographic Solutions | [Symmetric vs. Asymmetric Encryption and Key Exchange](lab-06-symmetric-asymmetric/README.md) | openssl enc, openssl speed, openssl pkeyutl, gnupg, od | ~25 min |
| 7 | 1.4 Cryptographic Solutions | [PKI: Build Your Own Certificate Authority](lab-07-pki-ca/README.md) | openssl req, openssl ca, openssl verify, openssl ocsp, openssl crl, update-ca-certificates | ~35 min |

## Domain 2 — Threats, Vulnerabilities & Mitigations (22%)

| Lab | Objective | Title | Tools | Time |
|---|---|---|---|---|
| 8 | 2.1 Threat Actors & Motivations | [Threat Actors & the MITRE ATT&CK Framework](lab-08-threat-actors-mitre-attack/README.md) | jq, curl | ~20 min |
| 9 | 2.2 Threat Vectors & Attack Surfaces | [Phishing Email Analysis (SPF / DKIM / DMARC)](lab-09-phishing-email-analysis/README.md) | dnsutils, dig, swaks | ~25 min |
| 10 | 2.3 Types of Vulnerabilities | [SQL Injection (SQLi)](lab-10-sql-injection/README.md) | sqlite3, php-cli, php-sqlite3, curl | ~20 min |
| 11 | 2.3 Types of Vulnerabilities | [Cross-Site Scripting (XSS)](lab-11-xss/README.md) | php-cli, curl | ~15 min |
| 12 | 2.3 Types of Vulnerabilities | [Memory Vulnerabilities & Exploit Mitigations](lab-12-memory-vulnerabilities/README.md) | gcc, gdb | ~25 min |
| 13 | 2.4 Indicators of Malicious Activity | [Password Attacks: Spraying & Brute Force](lab-13-password-attacks/README.md) | hydra, john, openssh-server | ~30 min |
| 14 | 2.4 Indicators of Malicious Activity | [Malware Static Analysis & Linux IOC Hunting](lab-14-malware-static-analysis/README.md) | file, binutils, yara, procps, net-tools | ~30 min |
| 15 | 2.4 Indicators of Malicious Activity | [DoS Simulation and Detection](lab-15-dos-detection/README.md) | hping3, nginx, iptables | ~30 min |
| 16 | 2.5 Mitigation Techniques | [Linux Hardening Baseline with Lynis](lab-16-linux-hardening/README.md) | lynis, unattended-upgrades | ~55 min |

## Domain 3 — Security Architecture (18%)

| Lab | Objective | Title | Tools | Time |
|---|---|---|---|---|
| 17 | 3.1 Architecture Models | [Cloud Shared Responsibility and IAM Least Privilege](lab-17-cloud-shared-responsibility/README.md) | jq, python3, awk, column (bsdextrautils) | ~25 min |
| 18 | 3.1 Architecture Models | [Container Security with Docker](lab-18-container-security-docker/README.md) | docker.io, capsh (libcap2-bin), trivy | ~30 min |
| 19 | 3.2 Securing Enterprise Infrastructure | [Network Segmentation and Security Zones](lab-19-network-segmentation/README.md) | ip netns, veth, iptables, netcat, curl, python3 | ~25 min |
| 20 | 3.2 Securing Enterprise Infrastructure | [Stateful Firewall with UFW and nftables](lab-20-firewall-ufw-nftables/README.md) | ufw, nftables, iptables, netcat, curl, ip netns | ~25 min |
| 21 | 3.2 Securing Enterprise Infrastructure | [Web Application Firewall with ModSecurity and the OWASP CRS](lab-21-waf-modsecurity/README.md) | apache2, libapache2-mod-security2, modsecurity-crs, curl | ~25 min |
| 22 | 3.2 Securing Enterprise Infrastructure | [Site-to-Site VPN with WireGuard](lab-22-vpn-wireguard/README.md) | wireguard-tools, ip netns, tcpdump, netcat | ~25 min |
| 23 | 3.3 Protecting Data | [Data Classification and Data Loss Prevention](lab-23-data-classification-dlp/README.md) | python3 (re, hmac, secrets), openssl, chmod/chown, useradd | ~25 min |
| 24 | 3.3 Protecting Data | [Data at Rest: LUKS2 Disk Encryption](lab-24-disk-encryption-luks/README.md) | cryptsetup, losetup, mkfs.ext4, grep | ~15 min |
| 25 | 3.3 Protecting Data | [Data in Transit: TLS Hardening and Cipher Audit](lab-25-tls-hardening/README.md) | nginx, openssl s_client, testssl.sh, curl | ~20 min |
| 26 | 3.4 Resilience and Recovery | [Backup and Recovery with restic](lab-26-backup-recovery/README.md) | restic, rsync, cron, python3 | ~30 min |
| 27 | 3.4 Resilience and Recovery | [Storage Resilience with Software RAID (mdadm)](lab-27-raid-mdadm/README.md) | mdadm, losetup, mkfs.ext4, sha256sum | ~30 min |

## Domain 4 — Security Operations (28%)

| Lab | Objective | Title | Tools | Time |
|---|---|---|---|---|
| 28 | 4.1 Securing Computing Resources | [Mobile and Endpoint Hardening Baseline](lab-28-mobile-endpoint-hardening/README.md) | libpam-pwquality, dconf-cli, cryptsetup, jq | ~10 min |
| 29 | 4.1 Securing Computing Resources | [Application Security: Validation, SAST and Code Signing](lab-29-appsec-sast-code-signing/README.md) | bandit (venv), gnupg, systemd-run, jq | ~15 min |
| 30 | 4.2 Asset Management | [Asset Inventory, Media Sanitisation and Disposal Certificate](lab-30-data-sanitisation/README.md) | util-linux, coreutils, shred, cryptsetup, jq | ~10 min |
| 31 | 4.3 Vulnerability Management | [Vulnerability Scanning, Confirmation and Rescan](lab-31-vulnerability-scanning/README.md) | apache2, nmap, nikto, curl | ~15 min |
| 32 | 4.3 Vulnerability Management | [Vulnerability Management Pipeline with Trivy](lab-32-vulnerability-management-trivy/README.md) | trivy, curl, jq | ~10 min |
| 33 | 4.4 Alerting & Monitoring | [SIEM Alerting and Monitoring with Wazuh](lab-33-siem-wazuh/README.md) | wazuh-manager, wazuh-indexer, curl, jq | ~25 min |
| 34 | 4.4 Alerting & Monitoring | [File Integrity Monitoring with AIDE](lab-34-file-integrity-aide/README.md) | aide, cron, logger, journalctl | ~20 min |
| 35 | 4.5 Enterprise Security Capabilities | [Secure Remote Access: SSH Hardening and Fail2ban](lab-35-ssh-hardening-fail2ban/README.md) | openssh-server, fail2ban, nftables, ssh-keygen | ~20 min |
| 36 | 4.5 Enterprise Security Capabilities | [Network IDS with Suricata](lab-36-ids-suricata/README.md) | suricata, suricata-update, jq, nmap | ~20 min |
| 37 | 4.5 Enterprise Security Capabilities | [Endpoint Detection and Response with osquery](lab-37-edr-osquery/README.md) | osquery, osqueryd, jq, netcat-openbsd | ~20 min |
| 38 | 4.6 Identity & Access Management | [Identity & Access Management with PAM and sudo](lab-38-iam-pam-sudo/README.md) | sudo, acl, libpam-pwquality, pam_faillock, pam_time, pamtester, chage | ~20 min |
| 39 | 4.6 Identity & Access Management | [Multifactor Authentication with TOTP](lab-39-mfa-totp/README.md) | libpam-google-authenticator, oathtool, qrencode, pamtester, openssh-server | ~15 min |
| 40 | 4.7 Automation & Orchestration | [Automation and Orchestration with a Mini-SOAR Playbook](lab-40-automation-soar/README.md) | jq, shellcheck, iptables, curl, python3, systemd, logger | ~15 min |
| 41 | 4.8 Incident Response | [Incident Response: Live Triage](lab-41-incident-response-triage/README.md) | cron, procps, iproute2, psmisc, lsof, sha256sum, iptables | ~15 min |
| 42 | 4.8 Incident Response | [Digital Forensics: Acquisition & Chain of Custody](lab-42-digital-forensics-acquisition/README.md) | dcfldd, dd, sleuthkit, foremost, losetup, blockdev, sha256sum | ~15 min |
| 43 | 4.9 Investigation Data Sources | [Packet Capture and Traffic Analysis with tcpdump and tshark](lab-43-packet-capture-analysis/README.md) | tcpdump, tshark, dnsutils, curl, python3 | ~15 min |
| 44 | 4.9 Investigation Data Sources | [Log Investigation: Building an Attack Timeline](lab-44-log-investigation/README.md) | grep, awk, sed, sort, uniq, journalctl, logger | ~20 min |

## Domain 5 — Security Program Management & Oversight (20%)

| Lab | Objective | Title | Tools | Time |
|---|---|---|---|---|
| 45 | 5.1 Security Governance | [Governance: Policies, Standards, Procedures](lab-45-governance-policies/README.md) | bash, libpam-pwquality, visudo, /etc/issue | ~20 min |
| 46 | 5.2 Risk Management | [Risk Register, CVSS Scoring, and Quantitative Risk](lab-46-risk-register-cvss/README.md) | python3, FIRST.org CVSS calculator, column | ~20 min |
| 47 | 5.3 Third-Party Risk | [Supply Chain Security: SBOM and Vendor Trust](lab-47-supply-chain-sbom/README.md) | syft, sha256sum, gpg, curl | ~20 min |
| 48 | 5.4 Security Compliance | [Compliance Audit with OpenSCAP](lab-48-compliance-openscap/README.md) | openscap-scanner/libopenscap8, ssg-base, ssg-debderived | ~40 min |
| 49 | 5.5 Audits & Assessments | [Passive Reconnaissance / OSINT](lab-49-osint-recon/README.md) | whois, dnsutils, theHarvester, subfinder, jq | ~25 min |
| 50 | 5.5 Audits & Assessments | [Active Reconnaissance with Nmap](lab-50-active-recon-nmap/README.md) | nmap, nginx, openssh-server | ~25 min |
| 51 | 5.5 Audits & Assessments | [Penetration Testing in an Authorised Lab](lab-51-pentest-metasploit/README.md) | metasploit-framework, docker.io, nmap | ~30 min |
| 52 | 5.6 Security Awareness | [Security Awareness: Phishing Simulation](lab-52-phishing-awareness-gophish/README.md) | gophish, docker.io, mailhog, curl, unzip | ~20 min |

## Suggested order

Follow the labs in number order — that is the SY0-701 blueprint order. Each lab is self-contained; reset the playground between labs that change PAM, firewall, routing or disk state.

## Tools reference

See [tools.md](tools.md) for the free-software inventory.

## Legal & ethical reminder

Labs that use scanning, exploitation, password-cracking, phishing-simulation or DoS techniques must be run **only** against systems you own (the Killercoda VM and containers you start in it), targets listed in a signed authorisation, or public training ranges. Unauthorised use is an offence under the **Singapore Computer Misuse Act 1993**.

---
*TGS-2023039181 — CompTIA Security+ Certification (SY0-701) · Tertiary Infotech Academy Pte Ltd*
