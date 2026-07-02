"""
SINGLE SOURCE OF TRUTH for the CompTIA Security+ (SY0-701) courseware.

Every artifact — the slide deck (PPT), Lesson Plan (LP), Learner Guide (LG)
and the labs/ folder — is generated from (or aligned to) the data in this
module, so titles, topic numbering, activities, learning outcomes and the
schedule can never drift apart.

Edit here, then re-run build_slides.py / build_lesson_plan.py /
build_learner_guide.py.
"""

# ------------------------------------------------------------------ metadata
TITLE        = "CompTIA Security+ Certification (SY0-701)"
SHORT_TITLE  = "CompTIA Security+ (SY0-701)"
COURSE_CODE  = "TGS-2023039181"
VERSION      = "v1.0"
VERSION_DATE = "2 July 2026"
ORG          = "Tertiary Infotech Academy Pte Ltd"
UEN          = "UEN: 201200696W"
TRAINER      = "Dr. Alfred Ang"
DAYS         = 3
REPO_URL     = "https://github.com/tertiarycourses/TGS-2023039181-SecurityPlus"
PRACTICE_EXAM_URL = "https://exams.tertiaryinfotech.com/practice-exams/comptia/comptia-security-plus"
KILLERCODA_URL    = "https://killercoda.com/playgrounds/scenario/ubuntu"

# ------------------------------------------------------------------ outcomes
LEARNING_OUTCOMES = [
    "LO1: Apply general security concepts — control categories and types, the CIA triad and AAA, cryptographic primitives (hashing, symmetric/asymmetric encryption) and PKI.",
    "LO2: Identify threats, vulnerabilities and mitigations — phishing, password and web attacks (SQLi, XSS), malware, denial-of-service, vulnerability scanning and host hardening.",
    "LO3: Implement secure architecture — network segmentation, firewalls, WAF, VPN, data-at-rest encryption, TLS hardening and resilient backup.",
    "LO4: Run security operations — SSH/identity hardening, MFA, SIEM, IDS, EDR, file-integrity monitoring, vulnerability management, incident response and automation.",
    "LO5: Manage the security program — risk registers and CVSS, reconnaissance, penetration testing, compliance auditing and security-awareness testing.",
]

# ------------------------------------------------------------------ topics (= exam domains)
# num, code, title, subtitle, weighting, concept bullets for the section
TOPICS = [
    dict(num=1, code="01",
         title="General Security Concepts",
         subtitle="Security controls · CIA & AAA · Hashing · Encryption · PKI",
         weighting="12%",
         concepts=[
            "Security controls are grouped by CATEGORY (technical, managerial, operational, physical) and by TYPE (preventive, deterrent, detective, corrective, compensating, directive).",
            "The CIA triad — confidentiality, integrity, availability — is the goal; AAA (authentication, authorization, accounting) is how identities are governed.",
            "Hashing proves integrity; salting defeats rainbow tables; digital signatures add authenticity and non-repudiation.",
            "Symmetric encryption is fast for bulk data; asymmetric (public-key) solves key exchange; PKI and certificate authorities bind keys to identities.",
         ]),
    dict(num=2, code="02",
         title="Threats, Vulnerabilities & Mitigations",
         subtitle="Phishing · Passwords · Malware · Web attacks · Scanning · Hardening",
         weighting="22%",
         concepts=[
            "Social engineering and phishing exploit people; SPF, DKIM and DMARC authenticate mail and expose spoofing.",
            "Password attacks (spraying, brute force, offline cracking) are countered by length, hashing with salt, and lockout.",
            "Web application flaws — SQL injection and cross-site scripting (XSS) — come from unvalidated input; mitigate with parameterisation and output encoding.",
            "Find weaknesses before attackers do: vulnerability scanning, malware analysis and a hardening baseline reduce the attack surface.",
         ]),
    dict(num=3, code="03",
         title="Security Architecture",
         subtitle="Segmentation · Firewalls · WAF · VPN · Encryption at rest · TLS · Backup",
         weighting="18%",
         concepts=[
            "Defence in depth layers controls; network segmentation and firewalls limit lateral movement and enforce least privilege between zones.",
            "A web application firewall (WAF) filters HTTP attacks; a VPN protects data in transit across untrusted networks.",
            "Protect data at rest with full-disk encryption (LUKS) and data in transit with hardened TLS ciphers and protocols.",
            "Resilience is a security property: a tested 3-2-1 backup and recovery plan defeats ransomware and hardware failure.",
         ]),
    dict(num=4, code="04",
         title="Security Operations",
         subtitle="Hardening · IAM · MFA · SIEM · IDS · EDR · FIM · Vuln mgmt · IR · SOAR",
         weighting="28%",
         concepts=[
            "Operational security hardens access (SSH, PAM, sudo, MFA) and monitors continuously (SIEM, IDS, EDR, file-integrity monitoring).",
            "A SIEM centralises and correlates logs; an IDS inspects network traffic; EDR and osquery interrogate endpoints.",
            "Vulnerability management is a continuous pipeline: discover, prioritise (CVSS), remediate and verify.",
            "Incident response follows preparation → detection → containment → eradication → recovery → lessons learned, increasingly automated with SOAR playbooks.",
         ]),
    dict(num=5, code="05",
         title="Security Program Management & Oversight",
         subtitle="Risk & CVSS · OSINT · Nmap · Pentesting · Compliance · Awareness",
         weighting="20%",
         concepts=[
            "Risk management records threats in a register, scores them (CVSS, likelihood × impact) and drives treatment decisions.",
            "Reconnaissance — passive OSINT and active scanning with Nmap — maps an organisation's exposure the way an attacker would.",
            "Penetration testing safely validates exploitability; every engagement needs authorisation and Rules of Engagement.",
            "Governance proves control effectiveness through compliance auditing (OpenSCAP/CIS) and measurable security-awareness testing.",
         ]),
]

# ------------------------------------------------------------------ 3-day schedule (8 training hours/day)
DAY_THEMES = {
    1: "General Concepts & Threats",
    2: "Architecture & Security Operations",
    3: "Operations, Program Management & Assessment",
}

# ------------------------------------------------------------------ assessment
ASSESSMENT = dict(
    written="Written Assessment (WA) — Short-Answer Questions (SAQ), 6 questions, 1 hour, open book.",
    practical="Practical Performance (PP) — 5 hands-on security tasks, 1 hour, open book.",
    note="A minimum of 75% attendance is required to be eligible for assessment and funding.",
)
