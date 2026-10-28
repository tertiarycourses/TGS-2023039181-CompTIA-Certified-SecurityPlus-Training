# Free Tools Reference — CompTIA Security+ SY0-701 Labs

Every tool listed here is **100% free** (open-source, freeware, or free tier with no time limit).

Two categories:

1. **Inside Killercoda** — installed in the disposable Ubuntu VM via `apt` or a single binary download. Nothing touches your own machine.
2. **External / Standalone** — downloaded onto your own PC/laptop, or used in a browser. Useful when you're offline, on a school PC, or want a GUI.

Killercoda playground (free, no signup): https://killercoda.com/playgrounds/scenario/ubuntu

---

## Section A — Tools installed inside the Killercoda Ubuntu VM

### A1. Cryptography & PKI
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `openssl` | pre-installed | Hash, encrypt, CA, TLS test | 5, 6, 7, 24, 25 |
| `gnupg` | `apt install gnupg` | OpenPGP encryption / signing | 6 |
| `cryptsetup` | `apt install cryptsetup` | LUKS full-disk encryption | 24 |

### A2. Identity, Access & Auth
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `sudo`, PAM | pre-installed | RBAC, time/lockout policies | 2, 38 |
| `libpam-google-authenticator` | `apt install libpam-google-authenticator` | TOTP MFA for SSH/login | 39 |
| `oathtool` | `apt install oathtool` | Generate TOTP from CLI | 39 |
| `qrencode` | `apt install qrencode` | Render TOTP QR codes | 39 |
| `openssh-server` | pre-installed | SSH + key auth | 2, 35, 39 |
| `fail2ban` | `apt install fail2ban` | Auto-ban brute-force IPs | 35 |

### A3. Network Security
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `iptables` / `nftables` | pre-installed / `apt install nftables` | Stateful firewall | 1, 15, 19, 20, 40 |
| `ufw` | `apt install ufw` | Friendly firewall front-end | 20 |
| `wireguard`, `wireguard-tools` | `apt install wireguard wireguard-tools` | Modern VPN | 22 |
| `iproute2` (`ip netns`) | pre-installed | Network namespaces / zoning | 19, 22 |
| `nginx` | `apt install nginx` | TLS / WAF target | 15, 20, 21, 25, 50 |
| `apache2` | `apt install apache2` | Web target for scanners | 31 |

### A4. Detection & Monitoring
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `auditd` | `apt install auditd` | Linux audit framework | 1 |
| `suricata` + `suricata-update` | `apt install suricata` | Open-source IDS/IPS | 36 |
| `osquery` | apt repo | EDR via SQL queries | 37 |
| `aide` | `apt install aide` | File integrity monitoring | 34 |
| `inotify-tools` | `apt install inotify-tools` | Filesystem event watcher | 40 |
| Wazuh | install script | Open-source SIEM (manager + agent) | 33 |

### A5. Vulnerability & Pentest
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `nmap` | `apt install nmap` | Port scanner / NSE | 50 |
| `nikto` | `apt install nikto` | Web vulnerability scanner | 31 |
| `nuclei` | binary release | Template-based vuln scanner | 31 |
| `trivy` | apt repo | Container / OS / secret scanner | 32 |
| `lynis` | `apt install lynis` | System hardening audit | 16 |
| `metasploit-framework` | apt repo | Exploitation framework | 51 |
| `hydra` | `apt install hydra` | Network login brute-force | 13 |
| `john` (the Ripper) | `apt install john` | Offline hash cracker | 13 |
| `sqlmap` | `apt install sqlmap` | Automated SQL injection | 10 |
| `hping3` | `apt install hping3` | Custom packet crafting / SYN flood | 15 |
| `theharvester` | `pip install theHarvester` | Email/host OSINT | 49 |
| `subfinder` | `go install ...` | Passive subdomain discovery | 49 |
| `whois`, `dnsutils` | `apt install whois dnsutils` | WHOIS / DNS lookups | 9, 49 |

### A6. Static Analysis & Forensics
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `yara` | `apt install yara` | Malware pattern matching | 14 |
| `binutils` (`strings`) | pre-installed | Extract printable strings | 14 |
| `file`, `coreutils` | pre-installed | File-type ID, hashing | 2, 14, 41 |
| `sleuthkit` (optional) | `apt install sleuthkit` | Disk forensics | 41 |

### A7. Compliance & Governance
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `libopenscap8` | `apt install libopenscap8` | SCAP scanner engine | 48 |
| `ssg-debian`, `ssg-debderived` | `apt install ssg-debian ssg-debderived` | CIS / STIG XCCDF content | 48 |
| `python3` | pre-installed | ALE/SLE math, JSON wrangling | 46 |

### A8. Backup & Resilience
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `restic` | `apt install restic` | Encrypted, deduplicated backup | 26 |

### A9. Mail / Phishing Lab
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `swaks` | `apt install swaks` | SMTP test client | 9 |
| MailHog | `docker run mailhog/mailhog` | Local SMTP sink (safe testing) | 52 |
| GoPhish | binary release | Phishing simulation platform | 52 |

### A10. Web Lab Targets
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `php-cli`, `php-sqlite3` | `apt install php-cli php-sqlite3` | Vulnerable web apps | 10, 11 |
| `sqlite3` | `apt install sqlite3` | Lab database | 10 |
| `docker.io` | `apt install docker.io` | Run vulnerable / scanner containers | 32, 51, 52 |
| Metasploitable / DVWA images | `docker pull` | Authorised exploit targets | 51 |

---

### A11. Tools added for the v2.0 objective-aligned labs
| Tool | Install | Purpose | Lab |
|------|---------|---------|-----|
| `inotify-tools`, `auditd`, `socat` | `apt install inotify-tools auditd socat` | Honeyfile / honeytoken / honeypot listener alerts | 3 |
| `etckeeper`, `git` | `apt install etckeeper git` | Version-controlled configuration and backout for change management | 4 |
| MITRE ATT&CK STIX JSON + `jq` | `curl` from github.com/mitre/cti, `apt install jq` | Profile threat actors and their techniques | 8 |
| `gcc`, `gdb` | `apt install build-essential gdb` | Buffer-overflow demo and compiler protections (canary, FORTIFY, PIE) | 12 |
| `grep -P`, `python3` | pre-installed | PII discovery (NRIC/FIN, Luhn-valid card numbers), masking and tokenization | 23 |
| `bandit` | `python3 -m venv v && v/bin/pip install bandit` | Static application security testing (SAST) of Python code | 29 |
| `pamtester`, `libpam-pwquality` | `apt install pamtester libpam-pwquality` | Test PAM stacks and enforce password policy | 38, 39 |
| `tcpdump`, `tshark` | `apt install tcpdump tshark` | Packet capture and protocol analysis | 43 |
| `journalctl`, `awk` | pre-installed | Log investigation and timeline building | 44 |
| `syft` | official install script (anchore/syft) | Generate a Software Bill of Materials (SBOM) | 47 |

## Section B — External / Standalone Free Tools (download or browser)

### B1. Cryptography & Encoding
| Tool | Type | Link |
|------|------|------|
| **Cryptography Toolkit** ⭐ used in many labs | Web | https://alfredang.github.io/cryptography-toolkit/ |
| **Hash Generator** ⭐ used in many labs | Web | https://alfredang.github.io/hashgenerator/ |
| OnlineHashCrack identifier | Web | https://www.onlinehashcrack.com/hash-identification.php |
| CrackStation | Web (look-up) | https://crackstation.net |
| Travis Tidwell RSA generator | Web | https://travistidwell.com/jsencrypt/demo/ |
| VeraCrypt | Win/Mac/Linux GUI | https://www.veracrypt.fr |

### B2. PKI / TLS
| Tool | Type | Link |
|------|------|------|
| Let's Encrypt | Free public CA | https://letsencrypt.org |
| SSL Labs Server Test | Web | https://www.ssllabs.com/ssltest |
| Mozilla SSL Config Generator | Web | https://ssl-config.mozilla.org |
| Hardenize | Web | https://www.hardenize.com |
| CipherSuite.info | Web | https://ciphersuite.info |
| crt.sh (Cert Transparency) | Web | https://crt.sh |
| testssl.sh | CLI | https://testssl.sh |

### B3. Email Anti-Spoofing (SPF / DKIM / DMARC)
| Tool | Type | Link |
|------|------|------|
| MXToolbox header analyzer | Web | https://mxtoolbox.com/EmailHeaders.aspx |
| Google Admin Toolbox Messageheader | Web | https://toolbox.googleapps.com/apps/messageheader/ |
| DMARC Analyzer | Web | https://www.dmarcanalyzer.com |
| PhishTool (free triage) | Web | https://www.phishtool.com |
| Have I Been Pwned | Web | https://haveibeenpwned.com |

### B4. Vulnerability Intel
| Tool | Type | Link |
|------|------|------|
| NVD / CVE search | Web | https://nvd.nist.gov |
| **FIRST CVSS calculator** ⭐ used in Labs 32 and 46 | Web | https://www.first.org/cvss/calculator/3.1 |
| FIRST CVSS v4 calculator | Web | https://www.first.org/cvss/calculator/4.0 |
| Ubuntu Security Tracker | Web | https://ubuntu.com/security/cves |
| GitHub Security Advisories | Web | https://github.com/advisories |
| OSV.dev open-source vuln DB | Web | https://osv.dev |
| CISA Known Exploited Vulns | Web | https://www.cisa.gov/known-exploited-vulnerabilities-catalog |
| Snyk free tier | Web | https://snyk.io |
| Greenbone OpenVAS Community | Self-hosted | https://www.greenbone.net |

### B5. Web Security / WAF
| Tool | Type | Link |
|------|------|------|
| OWASP CRS | Open ruleset | https://coreruleset.org |
| Cloudflare WAF (free tier) | Cloud | https://www.cloudflare.com |
| Mozilla Observatory | Web | https://observatory.mozilla.org |
| SecurityHeaders.com | Web | https://securityheaders.com |
| CSP Evaluator (Google) | Web | https://csp-evaluator.withgoogle.com |
| Wafw00f | CLI | https://github.com/EnableSecurity/wafw00f |
| OWASP Juice Shop (online) | Web | https://juice-shop.herokuapp.com |
| PortSwigger Web Security Academy | Free training | https://portswigger.net/web-security |

### B6. Malware Analysis (Online Sandboxes)
| Tool | Type | Link |
|------|------|------|
| VirusTotal | Web | https://www.virustotal.com |
| Hybrid Analysis | Web | https://www.hybrid-analysis.com |
| ANY.RUN community | Web | https://any.run |
| Joe Sandbox Cloud Basic | Web | https://www.joesandbox.com |
| MalwareBazaar (abuse.ch) | Web feed | https://bazaar.abuse.ch |

### B7. Recon / OSINT
| Tool | Type | Link |
|------|------|------|
| Shodan | Web | https://www.shodan.io |
| Censys | Web | https://search.censys.io |
| DNSDumpster | Web | https://dnsdumpster.com |
| SecurityTrails | Web | https://securitytrails.com |
| Hunter.io (free quota) | Web | https://hunter.io |
| OSINT Framework directory | Web | https://osintframework.com |
| Whoxy WHOIS | Web | https://www.whoxy.com |
| Hurricane Electric BGP | Web | https://bgp.he.net |

### B8. Identity / SSO / IdP
| Tool | Type | Link |
|------|------|------|
| Keycloak | Self-hosted | https://www.keycloak.org |
| FreeIPA | Self-hosted | https://www.freeipa.org |
| JumpCloud (free 10 users) | Cloud | https://jumpcloud.com |
| WebAuthn.io demo | Web | https://webauthn.io |
| Google / Microsoft Authenticator | Mobile | App stores |
| FreeOTP / Aegis | Mobile (FOSS) | https://freeotp.github.io / https://getaegis.app |
| YubiKey developer hub | Web | https://developers.yubico.com |

### B9. SIEM / SOC / SOAR
| Tool | Type | Link |
|------|------|------|
| Wazuh | Self-hosted | https://wazuh.com |
| Elastic stack (free) | Self-hosted | https://www.elastic.co |
| Splunk Free (500 MB/day) | Self-hosted | https://www.splunk.com |
| Graylog Open | Self-hosted | https://www.graylog.org |
| Security Onion | Self-hosted SOC distro | https://securityonionsolutions.com |
| TheHive (case mgmt) | Self-hosted | https://thehive-project.org |
| Shuffle SOAR | Self-hosted | https://shuffler.io |
| n8n automation | Self-hosted | https://n8n.io |
| MISP threat intel | Self-hosted | https://www.misp-project.org |
| Sigma rule repository | Open ruleset | https://github.com/SigmaHQ/sigma |

### B10. IDS / IPS / EDR
| Tool | Type | Link |
|------|------|------|
| Suricata | Open IDS/IPS | https://suricata.io |
| Snort 3 | Open IDS | https://www.snort.org |
| Zeek | Open NSM | https://zeek.org |
| osquery | Open EDR | https://osquery.io |
| Fleet (osquery console) | Open | https://fleetdm.com |
| Velociraptor | Open DFIR | https://docs.velociraptor.app |
| Sysmon for Linux | Open telemetry | https://github.com/Sysinternals/SysmonForLinux |
| Atomic Red Team | Detection tests | https://atomicredteam.io |

### B11. Forensics
| Tool | Type | Link |
|------|------|------|
| Autopsy / Sleuth Kit | GUI / CLI | https://www.sleuthkit.org |
| Volatility 3 | Memory forensics | https://github.com/volatilityfoundation/volatility3 |
| FTK Imager (free) | Win GUI | https://www.exterro.com/forensic-toolkit |
| Wireshark | All OSes | https://www.wireshark.org |
| Cryptography Toolkit | Web | https://alfredang.github.io/cryptography-toolkit/ |

### B12. Pentest / Red Team Practice Ranges (legal)
| Range | Type | Link |
|-------|------|------|
| HackTheBox | Cloud range | https://www.hackthebox.com |
| TryHackMe | Cloud range | https://tryhackme.com |
| Vulnhub | VM downloads | https://www.vulnhub.com |
| OWASP Juice Shop | Self-hosted | https://owasp.org/www-project-juice-shop |
| DVWA | Self-hosted | https://github.com/digininja/DVWA |
| PortSwigger Web Security Academy | Cloud training | https://portswigger.net/web-security |
| Metasploit Unleashed | Free training | https://www.offsec.com/metasploit-unleashed/ |

### B13. Phishing Simulation / Awareness
| Tool | Type | Link |
|------|------|------|
| GoPhish | Self-hosted | https://getgophish.com |
| King Phisher | Self-hosted | https://github.com/rsmusllp/king-phisher |
| PhishER (free tier) | Cloud | https://www.knowbe4.com/products/phisher |
| MailHog (SMTP sink) | Self-hosted | https://github.com/mailhog/MailHog |
| CISA phishing guidance | Web | https://www.cisa.gov/topics/cyber-threats-and-advisories/phishing |
| Google Phishing Quiz | Web | https://phishingquiz.withgoogle.com |

### B14. GRC / Risk / Compliance
| Tool | Type | Link |
|------|------|------|
| **FIRST CVSS calculator** | Web | https://www.first.org/cvss/calculator/3.1 |
| Eramba (open GRC) | Self-hosted | https://www.eramba.org |
| SimpleRisk | Self-hosted | https://www.simplerisk.com |
| InSpec by Chef | CLI | https://www.inspec.io |
| OpenSCAP / SCAP Security Guide | CLI | https://www.open-scap.org |
| CIS-CAT Lite | Win/Linux | https://www.cisecurity.org/cybersecurity-tools/cis-cat-lite |
| CIS Benchmarks (free PDFs) | Web | https://www.cisecurity.org/cis-benchmarks |
| DISA STIG library | Web | https://public.cyber.mil/stigs/ |
| NIST publications portal | Web | https://csrc.nist.gov/publications |
| MITRE ATT&CK | Web | https://attack.mitre.org |
| MITRE D3FEND | Web | https://d3fend.mitre.org |

### B15. Backup & Storage
| Tool | Type | Link |
|------|------|------|
| restic | CLI | https://restic.net |
| Backblaze B2 (10 GB free) | Cloud | https://www.backblaze.com/b2 |
| Wasabi (cold storage) | Cloud | https://wasabi.com |
| MinIO (self-hosted S3) | Self-hosted | https://min.io |
| rclone | CLI | https://rclone.org |

### B16. Browser sandboxes (Killercoda alternatives)
| Service | What you get | Link |
|---------|-------------|------|
| Killercoda Ubuntu Playground | Root Ubuntu shell | https://killercoda.com/playgrounds/scenario/ubuntu |
| Play with Docker | Linux VM | https://labs.play-with-docker.com |
| Replit | Linux shell + code | https://replit.com |
| GitHub Codespaces (free quota) | Cloud dev VM | https://github.com/features/codespaces |

---

## Lab → Primary Tool Quick Map

| Lab | Objective | Title | Primary tools |
|-----|-----------|-------|---------------|
| 1 | 1.1 | Security Controls Categorization | iptables, auditd, ausearch, sshd, sha256sum, column |
| 2 | 1.2 | CIA Triad and AAA on Linux | chmod, sha256sum, systemd, chpasswd, openssl passwd, ssh-keygen, sudo, journalctl |
| 3 | 1.2 | Deception: Honeypots, Honeyfiles and Honeytokens | python3, netcat, auditd, inotifywait, ip netns, curl |
| 4 | 1.3 | Change Management with Version-Controlled Config | etckeeper, git, nginx, curl, systemctl |
| 5 | 1.4 | Hashing, Salting, and Digital Signatures | sha256sum, openssl passwd, openssl kdf, openssl dgst, openssl genpkey, chpasswd |
| 6 | 1.4 | Symmetric vs. Asymmetric Encryption and Key Exchange | openssl enc, openssl speed, openssl pkeyutl, gnupg, od |
| 7 | 1.4 | PKI: Build Your Own Certificate Authority | openssl req, openssl ca, openssl verify, openssl ocsp, openssl crl, update-ca-certificates |
| 8 | 2.1 | Threat Actors & the MITRE ATT&CK Framework | jq, curl |
| 9 | 2.2 | Phishing Email Analysis (SPF / DKIM / DMARC) | dnsutils, dig, swaks |
| 10 | 2.3 | SQL Injection (SQLi) | sqlite3, php-cli, php-sqlite3, curl |
| 11 | 2.3 | Cross-Site Scripting (XSS) | php-cli, curl |
| 12 | 2.3 | Memory Vulnerabilities & Exploit Mitigations | gcc, gdb |
| 13 | 2.4 | Password Attacks: Spraying & Brute Force | hydra, john, openssh-server |
| 14 | 2.4 | Malware Static Analysis & Linux IOC Hunting | file, binutils, yara, procps, net-tools |
| 15 | 2.4 | DoS Simulation and Detection | hping3, nginx, iptables |
| 16 | 2.5 | Linux Hardening Baseline with Lynis | lynis, unattended-upgrades |
| 17 | 3.1 | Cloud Shared Responsibility and IAM Least Privilege | jq, python3, awk, column (bsdextrautils) |
| 18 | 3.1 | Container Security with Docker | docker.io, capsh (libcap2-bin), trivy |
| 19 | 3.2 | Network Segmentation and Security Zones | ip netns, veth, iptables, netcat, curl, python3 |
| 20 | 3.2 | Stateful Firewall with UFW and nftables | ufw, nftables, iptables, netcat, curl, ip netns |
| 21 | 3.2 | Web Application Firewall with ModSecurity and the OWASP CRS | apache2, libapache2-mod-security2, modsecurity-crs, curl |
| 22 | 3.2 | Site-to-Site VPN with WireGuard | wireguard-tools, ip netns, tcpdump, netcat |
| 23 | 3.3 | Data Classification and Data Loss Prevention | python3 (re, hmac, secrets), openssl, chmod/chown, useradd |
| 24 | 3.3 | Data at Rest: LUKS2 Disk Encryption | cryptsetup, losetup, mkfs.ext4, grep |
| 25 | 3.3 | Data in Transit: TLS Hardening and Cipher Audit | nginx, openssl s_client, testssl.sh, curl |
| 26 | 3.4 | Backup and Recovery with restic | restic, rsync, cron, python3 |
| 27 | 3.4 | Storage Resilience with Software RAID (mdadm) | mdadm, losetup, mkfs.ext4, sha256sum |
| 28 | 4.1 | Mobile and Endpoint Hardening Baseline | libpam-pwquality, dconf-cli, cryptsetup, jq |
| 29 | 4.1 | Application Security: Validation, SAST and Code Signing | bandit (venv), gnupg, systemd-run, jq |
| 30 | 4.2 | Asset Inventory, Media Sanitisation and Disposal | util-linux, coreutils, shred, cryptsetup, jq |
| 31 | 4.3 | Vulnerability Scanning, Confirmation and Rescan | apache2, nmap, nikto, curl |
| 32 | 4.3 | Vulnerability Management Pipeline with Trivy | trivy, curl, jq |
| 33 | 4.4 | SIEM Alerting and Monitoring with Wazuh | wazuh-manager, wazuh-indexer, curl, jq |
| 34 | 4.4 | File Integrity Monitoring with AIDE | aide, cron, logger, journalctl |
| 35 | 4.5 | Secure Remote Access: SSH Hardening and Fail2ban | openssh-server, fail2ban, nftables, ssh-keygen |
| 36 | 4.5 | Network IDS with Suricata | suricata, suricata-update, jq, nmap |
| 37 | 4.5 | Endpoint Detection and Response with osquery | osquery, osqueryd, jq, netcat-openbsd |
| 38 | 4.6 | Identity & Access Management with PAM and sudo | sudo, acl, libpam-pwquality, pam_faillock, pam_time, pamtester, chage |
| 39 | 4.6 | Multifactor Authentication with TOTP | libpam-google-authenticator, oathtool, qrencode, pamtester, openssh-server |
| 40 | 4.7 | Automation & Orchestration (Mini-SOAR) | jq, shellcheck, iptables, curl, python3, systemd, logger |
| 41 | 4.8 | Incident Response: Live Triage | cron, procps, iproute2, psmisc, lsof, sha256sum, iptables |
| 42 | 4.8 | Digital Forensics: Acquisition & Chain of Custody | dcfldd, dd, sleuthkit, foremost, losetup, blockdev, sha256sum |
| 43 | 4.9 | Packet Capture & Traffic Analysis | tcpdump, tshark, dnsutils, curl, python3 |
| 44 | 4.9 | Log Investigation: Building a Timeline | grep, awk, sed, sort, uniq, journalctl, logger |
| 45 | 5.1 | Governance: Policies, Standards, Procedures | bash, libpam-pwquality, visudo, /etc/issue |
| 46 | 5.2 | Risk Register, CVSS Scoring, and Quantitative Risk | python3, FIRST.org CVSS calculator, column |
| 47 | 5.3 | Supply Chain Security: SBOM and Vendor Trust | syft, sha256sum, gpg, curl |
| 48 | 5.4 | Compliance Audit with OpenSCAP | openscap-scanner/libopenscap8, ssg-base, ssg-debderived |
| 49 | 5.5 | Passive Reconnaissance / OSINT | whois, dnsutils, theHarvester, subfinder, jq |
| 50 | 5.5 | Active Reconnaissance with Nmap | nmap, nginx, openssh-server |
| 51 | 5.5 | Penetration Testing in an Authorised Lab | metasploit-framework, docker.io, nmap |
| 52 | 5.6 | Security Awareness: Phishing Simulation | gophish, docker.io, mailhog, curl, unzip |

---
*TGS-2023039181 — CompTIA Security+ (SY0-701) · Tertiary Infotech Academy Pte Ltd*
