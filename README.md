# CompTIA Security+ (SY0-701) — WSQ CompTIA Certified Security+ Training

A five-day, hands-on WSQ course that teaches every objective of the CompTIA Security+ SY0-701 blueprint in order and practises each one in a browser-based Linux lab, finishing with a practice exam and the final assessment.

| Course detail | Information |
|---|---|
| Course code | `TGS-2023039181` |
| Programme | WSQ (SkillsFuture-funded) |
| Duration | 5 days · 40 training hours (9:30am–6:30pm) including a 2-hour assessment |
| Registration | [View course details and register](https://www.tertiarycourses.com.sg/wsq-comptia-certified-security-training.html) |
| Funding | Funded up to 70% for eligible learners and SMEs. Eligibility and terms apply — see the registration page. |
| Format | Instructor-led, 52 hands-on labs on the free Killercoda Ubuntu Playground |
| Courseware version | v3.0 · 28 October 2026 |

---

## About the course

CompTIA Security+ is the baseline certification for cybersecurity roles. This course prepares you for the **SY0-701** exam by following the official blueprint exactly: **5 domains → 28 objectives**, one domain per day. Every objective is taught with concept slides and exam tips, then practised in at least one hands-on lab, every domain closes with exam-style practice questions, and the course ends with a practice-exam walkthrough and the WSQ assessment (Written Assessment + Practical Performance, open book).

| Day | Exam domain | Weight | Labs |
|---|---|---|---|
| 1 | General Security Concepts | 12% | 1–7 |
| 2 | Threats, Vulnerabilities and Mitigations | 22% | 8–16 |
| 3 | Security Architecture | 18% | 17–27 |
| 4 | Security Operations | 28% | 28–44 |
| 5 | Security Program Management and Oversight + exam readiness + assessment | 20% | 45–52 |

## Learning outcomes

By the end of the course you will be able to:

1. Explain general security concepts — control types, CIA and AAA, Zero Trust, physical security, deception, change management and cryptography with PKI.
2. Analyse threat actors, vectors and social engineering, application and platform vulnerabilities, indicators of attack, and mitigation techniques.
3. Apply secure architecture — cloud and on-premises models, secure enterprise infrastructure, data protection, and resilience and recovery.
4. Perform security operations — hardening, asset and vulnerability management, monitoring, security capabilities, IAM, automation and incident response.
5. Support program oversight — governance, risk and third-party risk, compliance, audits and penetration testing, and security awareness.

## Topics covered

The course follows the 28 official SY0-701 exam objectives in order:

- **1.1** Compare and contrast various types of security controls
- **1.2** Summarize fundamental security concepts
- **1.3** Explain the importance of change management processes and the impact to security
- **1.4** Explain the importance of using appropriate cryptographic solutions
- **2.1** Compare and contrast common threat actors and motivations
- **2.2** Explain common threat vectors and attack surfaces
- **2.3** Explain various types of vulnerabilities
- **2.4** Given a scenario, analyze indicators of malicious activity
- **2.5** Explain the purpose of mitigation techniques used to secure the enterprise
- **3.1** Compare and contrast security implications of different architecture models
- **3.2** Given a scenario, apply security principles to secure enterprise infrastructure
- **3.3** Compare and contrast concepts and strategies to protect data
- **3.4** Explain the importance of resilience and recovery in security architecture
- **4.1** Given a scenario, apply common security techniques to computing resources
- **4.2** Explain the security implications of proper hardware, software, and data asset management
- **4.3** Explain various activities associated with vulnerability management
- **4.4** Explain security alerting and monitoring concepts and tools
- **4.5** Given a scenario, modify enterprise capabilities to enhance security
- **4.6** Given a scenario, implement and maintain identity and access management
- **4.7** Explain the importance of automation and orchestration related to secure operations
- **4.8** Explain appropriate incident response activities
- **4.9** Given a scenario, use data sources to support an investigation
- **5.1** Summarize elements of effective security governance
- **5.2** Explain elements of the risk management process
- **5.3** Explain the processes associated with third-party risk assessment and management
- **5.4** Summarize elements of effective security compliance
- **5.5** Explain types and purposes of audits and assessments
- **5.6** Given a scenario, implement security awareness practices

## Labs

All 52 labs run in the free [Killercoda Ubuntu Playground](https://killercoda.com/playgrounds/scenario/ubuntu) — nothing to install on your own machine. Each lab folder contains `README.md` (steps, troubleshooting, challenge, exam tips), `INSTRUCTIONS.md`, `checklist.md`, `scripts/run.sh` and a printable PDF. See the [lab index](labs/README.md) and the [free tools reference](labs/tools.md).

### Domain 1 — General Security Concepts (12%)

| Objective | Lab |
|---|---|
| 1.1 Types of Security Controls | [Lab 01 — Security Controls Categorization](labs/lab-01-security-controls/README.md) |
| 1.2 Fundamental Security Concepts | [Lab 02 — CIA Triad and AAA on Linux](labs/lab-02-cia-aaa/README.md) |
| 1.2 Fundamental Security Concepts | [Lab 03 — Deception: Honeypots, Honeyfiles and Honeytokens](labs/lab-03-deception-honeypots/README.md) |
| 1.3 Change Management | [Lab 04 — Change Management with Version-Controlled Config](labs/lab-04-change-management/README.md) |
| 1.4 Cryptographic Solutions | [Lab 05 — Hashing, Salting, and Digital Signatures](labs/lab-05-hashing-signatures/README.md) |
| 1.4 Cryptographic Solutions | [Lab 06 — Symmetric vs. Asymmetric Encryption and Key Exchange](labs/lab-06-symmetric-asymmetric/README.md) |
| 1.4 Cryptographic Solutions | [Lab 07 — PKI: Build Your Own Certificate Authority](labs/lab-07-pki-ca/README.md) |

### Domain 2 — Threats, Vulnerabilities & Mitigations (22%)

| Objective | Lab |
|---|---|
| 2.1 Threat Actors & Motivations | [Lab 08 — Threat Actors & the MITRE ATT&CK Framework](labs/lab-08-threat-actors-mitre-attack/README.md) |
| 2.2 Threat Vectors & Attack Surfaces | [Lab 09 — Phishing Email Analysis (SPF / DKIM / DMARC)](labs/lab-09-phishing-email-analysis/README.md) |
| 2.3 Types of Vulnerabilities | [Lab 10 — SQL Injection (SQLi)](labs/lab-10-sql-injection/README.md) |
| 2.3 Types of Vulnerabilities | [Lab 11 — Cross-Site Scripting (XSS)](labs/lab-11-xss/README.md) |
| 2.3 Types of Vulnerabilities | [Lab 12 — Memory Vulnerabilities & Exploit Mitigations](labs/lab-12-memory-vulnerabilities/README.md) |
| 2.4 Indicators of Malicious Activity | [Lab 13 — Password Attacks: Spraying & Brute Force](labs/lab-13-password-attacks/README.md) |
| 2.4 Indicators of Malicious Activity | [Lab 14 — Malware Static Analysis & Linux IOC Hunting](labs/lab-14-malware-static-analysis/README.md) |
| 2.4 Indicators of Malicious Activity | [Lab 15 — DoS Simulation and Detection](labs/lab-15-dos-detection/README.md) |
| 2.5 Mitigation Techniques | [Lab 16 — Linux Hardening Baseline with Lynis](labs/lab-16-linux-hardening/README.md) |

### Domain 3 — Security Architecture (18%)

| Objective | Lab |
|---|---|
| 3.1 Architecture Models | [Lab 17 — Cloud Shared Responsibility and IAM Least Privilege](labs/lab-17-cloud-shared-responsibility/README.md) |
| 3.1 Architecture Models | [Lab 18 — Container Security with Docker](labs/lab-18-container-security-docker/README.md) |
| 3.2 Securing Enterprise Infrastructure | [Lab 19 — Network Segmentation and Security Zones](labs/lab-19-network-segmentation/README.md) |
| 3.2 Securing Enterprise Infrastructure | [Lab 20 — Stateful Firewall with UFW and nftables](labs/lab-20-firewall-ufw-nftables/README.md) |
| 3.2 Securing Enterprise Infrastructure | [Lab 21 — Web Application Firewall with ModSecurity and the OWASP CRS](labs/lab-21-waf-modsecurity/README.md) |
| 3.2 Securing Enterprise Infrastructure | [Lab 22 — Site-to-Site VPN with WireGuard](labs/lab-22-vpn-wireguard/README.md) |
| 3.3 Protecting Data | [Lab 23 — Data Classification and Data Loss Prevention](labs/lab-23-data-classification-dlp/README.md) |
| 3.3 Protecting Data | [Lab 24 — Data at Rest: LUKS2 Disk Encryption](labs/lab-24-disk-encryption-luks/README.md) |
| 3.3 Protecting Data | [Lab 25 — Data in Transit: TLS Hardening and Cipher Audit](labs/lab-25-tls-hardening/README.md) |
| 3.4 Resilience and Recovery | [Lab 26 — Backup and Recovery with restic](labs/lab-26-backup-recovery/README.md) |
| 3.4 Resilience and Recovery | [Lab 27 — Storage Resilience with Software RAID (mdadm)](labs/lab-27-raid-mdadm/README.md) |

### Domain 4 — Security Operations (28%)

| Objective | Lab |
|---|---|
| 4.1 Securing Computing Resources | [Lab 28 — Mobile and Endpoint Hardening Baseline](labs/lab-28-mobile-endpoint-hardening/README.md) |
| 4.1 Securing Computing Resources | [Lab 29 — Application Security: Validation, SAST and Code Signing](labs/lab-29-appsec-sast-code-signing/README.md) |
| 4.2 Asset Management | [Lab 30 — Asset Inventory, Media Sanitisation and Disposal](labs/lab-30-data-sanitisation/README.md) |
| 4.3 Vulnerability Management | [Lab 31 — Vulnerability Scanning, Confirmation and Rescan](labs/lab-31-vulnerability-scanning/README.md) |
| 4.3 Vulnerability Management | [Lab 32 — Vulnerability Management Pipeline with Trivy](labs/lab-32-vulnerability-management-trivy/README.md) |
| 4.4 Alerting & Monitoring | [Lab 33 — SIEM Alerting and Monitoring with Wazuh](labs/lab-33-siem-wazuh/README.md) |
| 4.4 Alerting & Monitoring | [Lab 34 — File Integrity Monitoring with AIDE](labs/lab-34-file-integrity-aide/README.md) |
| 4.5 Enterprise Security Capabilities | [Lab 35 — Secure Remote Access: SSH Hardening and Fail2ban](labs/lab-35-ssh-hardening-fail2ban/README.md) |
| 4.5 Enterprise Security Capabilities | [Lab 36 — Network IDS with Suricata](labs/lab-36-ids-suricata/README.md) |
| 4.5 Enterprise Security Capabilities | [Lab 37 — Endpoint Detection and Response with osquery](labs/lab-37-edr-osquery/README.md) |
| 4.6 Identity & Access Management | [Lab 38 — Identity & Access Management with PAM and sudo](labs/lab-38-iam-pam-sudo/README.md) |
| 4.6 Identity & Access Management | [Lab 39 — Multifactor Authentication with TOTP](labs/lab-39-mfa-totp/README.md) |
| 4.7 Automation & Orchestration | [Lab 40 — Automation & Orchestration (Mini-SOAR)](labs/lab-40-automation-soar/README.md) |
| 4.8 Incident Response | [Lab 41 — Incident Response: Live Triage](labs/lab-41-incident-response-triage/README.md) |
| 4.8 Incident Response | [Lab 42 — Digital Forensics: Acquisition & Chain of Custody](labs/lab-42-digital-forensics-acquisition/README.md) |
| 4.9 Investigation Data Sources | [Lab 43 — Packet Capture & Traffic Analysis](labs/lab-43-packet-capture-analysis/README.md) |
| 4.9 Investigation Data Sources | [Lab 44 — Log Investigation: Building a Timeline](labs/lab-44-log-investigation/README.md) |

### Domain 5 — Security Program Management & Oversight (20%)

| Objective | Lab |
|---|---|
| 5.1 Security Governance | [Lab 45 — Governance: Policies, Standards, Procedures](labs/lab-45-governance-policies/README.md) |
| 5.2 Risk Management | [Lab 46 — Risk Register, CVSS Scoring, and Quantitative Risk](labs/lab-46-risk-register-cvss/README.md) |
| 5.3 Third-Party Risk | [Lab 47 — Supply Chain Security: SBOM and Vendor Trust](labs/lab-47-supply-chain-sbom/README.md) |
| 5.4 Security Compliance | [Lab 48 — Compliance Audit with OpenSCAP](labs/lab-48-compliance-openscap/README.md) |
| 5.5 Audits & Assessments | [Lab 49 — Passive Reconnaissance / OSINT](labs/lab-49-osint-recon/README.md) |
| 5.5 Audits & Assessments | [Lab 50 — Active Reconnaissance with Nmap](labs/lab-50-active-recon-nmap/README.md) |
| 5.5 Audits & Assessments | [Lab 51 — Penetration Testing in an Authorised Lab](labs/lab-51-pentest-metasploit/README.md) |
| 5.6 Security Awareness | [Lab 52 — Security Awareness: Phishing Simulation](labs/lab-52-phishing-awareness-gophish/README.md) |

## Courseware in this repository

| Item | Files |
|---|---|
| Slide deck (v3.0) | [PPTX](courseware/CompTIA%20Security%2B%20(SY0-701)-v3.0.pptx) · [PDF](courseware/CompTIA%20Security%2B%20(SY0-701)-v3.0.pdf) |
| Lesson Plan | [DOCX](courseware/LP-CompTIA%20Security%2B%20(SY0-701).docx) · [PDF](courseware/LP-CompTIA%20Security%2B%20(SY0-701).pdf) |
| Learner Guide | [DOCX](courseware/LG-CompTIA%20Security%2B%20(SY0-701).docx) · [PDF](courseware/LG-CompTIA%20Security%2B%20(SY0-701).pdf) · [Read on GitHub](LG-CompTIA%20Security%2B%20(SY0-701).md) |
| Exam objectives | [CompTIA SY0-701 exam objectives (PDF)](CompTIA-Security-Plus-SY0-701-Exam-Objectives.pdf) |
| Labs | [labs/](labs/) — 52 lab folders, [index](labs/README.md), [tools](labs/tools.md) |

The deck, Lesson Plan, Learner Guide and labs are generated from a single source, so they always agree.

## Practise in the browser

- **CyberLab — Security+ SY0-701 Simulator** — domain-by-domain simulations and a companion view for every lab: https://alfredang.github.io/cybersecuritysimulator/
- **Practice exam** — timed SY0-701 practice questions: https://exams.tertiaryinfotech.com/practice-exams/comptia/comptia-security-plus
- **Cryptography Toolkit** — https://alfredang.github.io/cryptography-toolkit/ · **Hash Generator** — https://alfredang.github.io/hashgenerator/

## Public and private materials

This public repository holds the learner-facing courseware: the slide deck, Lesson Plan, Learner Guide and labs. The assessment question papers and answer keys, the Facilitator Guide, the Assessment Plan and source reference decks are confidential, trainer-only and **not** published here.

## Legal and ethical use

Labs that involve scanning, exploitation, password cracking, phishing simulation or denial-of-service techniques must be run **only** against systems you own (the Killercoda VM and containers you start in it), targets listed in a signed authorisation, or public training ranges. Unauthorised use against third-party systems is an offence under the **Singapore Computer Misuse Act 1993**.

---

Delivered by [**Tertiary Infotech Academy Pte Ltd**](https://www.tertiarycourses.com.sg/) (UEN 201200696W). CompTIA and Security+ are trademarks of CompTIA, Inc.; this course is independent preparation material.
