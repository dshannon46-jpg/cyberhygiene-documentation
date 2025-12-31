# Multi-Factor Authentication Options for FreeIPA
**Created:** December 11, 2025
**System:** dc1.cyberinabox.net
**Purpose:** Evaluate MFA solutions with separate password/OTP prompts

## Executive Summary

FreeIPA natively supports TOTP-based MFA with Google Authenticator, but uses a **concatenated password+OTP** format (single prompt). This creates usability and security concerns:

- ❌ Cannot determine which factor failed (password vs. OTP)
- ❌ Potential password exposure in logs
- ❌ Poor user experience and confusion
- ❌ Difficult to audit

**Recommendation:** Implement a solution that provides **separate prompts** for password and OTP.

---

## Option 1: FreeIPA Native OTP (Current Capability)

### Description
Built-in TOTP support using ipa-otpd service (already running on your system).

### Authentication Flow
```
login: username
Password: password123456
         ^^^^^^^^------  (password + 6-digit OTP concatenated)
```

### Pros
- ✅ Already installed and running
- ✅ Zero additional cost
- ✅ Works with any TOTP app (Google Authenticator, FreeOTP, Authy, etc.)
- ✅ Centrally managed in FreeIPA
- ✅ NIST 800-171 compliant (technically)

### Cons
- ❌ Single-prompt concatenation (your primary concern)
- ❌ Unclear error messages
- ❌ Password+OTP captured together in some logs
- ❌ Poor user experience

### Implementation Time
30 minutes

### Annual Cost
$0

### Maintenance Burden
Low (part of FreeIPA)

### NIST 800-171 Compliance
✅ Yes - Satisfies IA-2(1), IA-2(2), AC-17

---

## Option 2: privacyIDEA (Open Source Enterprise)

### Description
Open-source MFA server with native FreeIPA integration. Industry-standard solution used by Red Hat, SUSE, and major enterprises.

### Authentication Flow
```
login: username
Password: [password]
One Time Password: [123456]
✅ Separate prompts - clear which factor failed
```

### Architecture
```
User → SSH/VPN → privacyIDEA Middleware → FreeIPA (password check)
                                       → privacyIDEA (OTP check)
```

### Pros
- ✅ **Separate password and OTP prompts** ⭐
- ✅ Open source (AGPLv3)
- ✅ Web-based token management UI
- ✅ Self-service enrollment portal
- ✅ Supports TOTP, HOTP, U2F, WebAuthn, SMS, email
- ✅ Detailed audit logs (shows which factor failed)
- ✅ Hardware token support (YubiKey, etc.)
- ✅ On-premises (full control)
- ✅ Active development and community

### Cons
- ❌ Additional server infrastructure required
- ❌ Complex initial setup (4-8 hours)
- ❌ Requires database (MariaDB/PostgreSQL)
- ❌ Another service to monitor and maintain
- ❌ Learning curve for administration

### Implementation Time
4-8 hours initial setup
1-2 hours user training/documentation

### Annual Cost
$0 (open source)
Optional: Commercial support available if desired

### Maintenance Burden
Medium:
- Database maintenance
- Software updates
- Service monitoring
- Backup/restore procedures

### NIST 800-171 Compliance
✅ Yes - Satisfies IA-2(1), IA-2(2), AC-17
✅ Enhanced audit capabilities

### Installation Overview
```bash
# Server requirements
- Rocky Linux 9.6 VM or container
- 2 CPU, 4GB RAM, 20GB disk
- MariaDB or PostgreSQL database

# Installation
sudo dnf install epel-release python3-pip mariadb-server
sudo pip3 install privacyidea
privacyidea-setup-freeipa

# Configure FreeIPA backend
privacyidea-manage configure-freeipa \
  --ldap-uri ldaps://dc1.cyberinabox.net \
  --ldap-base dc=cyberinabox,dc=net

# Configure PAM for SSH
# Update /etc/pam.d/sshd to use privacyIDEA
```

### Resources
- Official Docs: https://privacyidea.readthedocs.io/
- FreeIPA Integration: https://privacyidea.readthedocs.io/en/latest/faq/freeipa.html
- GitHub: https://github.com/privacyidea/privacyidea

---

## Option 3: Duo Security (Commercial SaaS)

### Description
Commercial 2FA service (Cisco-owned) with excellent Linux/FreeIPA integration via PAM module.

### Authentication Flow
```
login: username
Password: [password]

Duo two-factor login for 'username'
Enter a passcode or select one of the following options:
 1. Duo Push to XXX-XXX-1234
 2. Phone call to XXX-XXX-1234
 3. SMS passcodes to XXX-XXX-1234

Passcode or option (1-3): 1
[Push notification sent to phone]
✅ Extremely user-friendly
```

### Pros
- ✅ **Separate password and OTP prompts** ⭐
- ✅ **Push notifications** (best UX) ⭐
- ✅ Easiest to implement (1-2 hours)
- ✅ No local infrastructure needed
- ✅ Managed service (high availability)
- ✅ Excellent mobile apps (iOS/Android)
- ✅ SMS/phone call backup methods
- ✅ Hardware token support
- ✅ Extensive documentation
- ✅ Used by thousands of enterprises
- ✅ SOC 2 Type 2 certified

### Cons
- ❌ Recurring subscription cost
- ❌ Requires internet connectivity
- ❌ External dependency (vendor lock-in)
- ❌ Cisco privacy concerns (for some)
- ❌ Data stored in cloud

### Implementation Time
1-2 hours

### Annual Cost
- **Free tier:** Up to 10 users forever
- **Duo MFA:** $3/user/month ($540/year for 15 users)
- **Duo Access:** $9/user/month ($1,620/year for 15 users)

**For 15 users:** $0-1,620/year depending on tier

### Maintenance Burden
Very Low:
- No servers to maintain
- Automatic updates
- Cloud-based monitoring
- 99.99% SLA

### NIST 800-171 Compliance
✅ Yes - Satisfies IA-2(1), IA-2(2), AC-17
✅ Duo is FedRAMP authorized
✅ Compliance reports available

### Installation Overview
```bash
# Install Duo Unix package
sudo rpm -Uvh https://dl.duosecurity.com/duo_unix-latest.x86_64.rpm

# Configure integration
sudo vi /etc/duo/pam_duo.conf
# Add keys from Duo admin panel:
# [duo]
# ikey = YOUR_INTEGRATION_KEY
# skey = YOUR_SECRET_KEY
# host = api-XXXXXX.duosecurity.com

# Update SSH PAM
sudo vi /etc/pam.d/sshd
# Add: auth required pam_duo.so

# Restart SSH
sudo systemctl restart sshd
```

### Resources
- Duo Unix Docs: https://duo.com/docs/duounix
- FreeIPA Guide: https://duo.com/docs/freeipa
- Pricing: https://duo.com/pricing

---

## Option 4: YubiKey Hardware Tokens

### Description
FIPS 140-2 certified hardware security keys for phishing-resistant authentication.

### Authentication Flow
```
login: username
Password: [password]
Please touch your YubiKey: [user touches key]
✅ Physical separation of factors
```

### Pros
- ✅ **Separate password and hardware action** ⭐
- ✅ **Phishing-resistant** (FIDO2/WebAuthn) ⭐
- ✅ FIPS 140-2 certified
- ✅ No phone dependency
- ✅ Works offline
- ✅ Long lifespan (5+ years)
- ✅ Multiple protocols (TOTP, U2F, FIDO2, PIV)
- ✅ Recommended by NIST, CISA

### Cons
- ❌ Upfront hardware cost
- ❌ Users can lose/forget keys (need backups)
- ❌ Requires physical possession
- ❌ USB port required
- ❌ Not ideal for remote workers

### Implementation Time
2-4 hours setup
+ User training time

### Annual Cost
**One-time hardware cost:**
- YubiKey 5 NFC: $45/key
- YubiKey 5C NFC: $55/key (USB-C)
- YubiKey 5 FIPS: $65/key (FIPS certified)

**For 15 users (2 keys each):** $1,350-1,950 one-time

**Annual cost after initial:** ~$200 (replacements)

### Maintenance Burden
Low:
- Key enrollment
- Replacement key management
- User support for lost keys

### NIST 800-171 Compliance
✅ Yes - Satisfies IA-2(1), IA-2(2), AC-17
✅ **Exceeds** requirements (phishing-resistant)
✅ FIPS 140-2 certified (YubiKey 5 FIPS series)

### Implementation Overview
```bash
# Install YubiKey PAM module
sudo dnf install pam-u2f yubikey-manager

# Configure for each user
mkdir ~/.yubico
pamu2fcfg > ~/.yubico/u2f_keys
# User touches YubiKey to register

# Update PAM
sudo vi /etc/pam.d/sshd
# Add: auth required pam_u2f.so
```

### Resources
- YubiKey Guide: https://developers.yubico.com/pam-u2f/
- FreeIPA Integration: https://www.yubico.com/solutions/freeipa/

---

## Option 5: FreeRADIUS + FreeIPA OTP

### Description
Deploy RADIUS server that validates password via FreeIPA LDAP and OTP via FreeIPA's ipa-otpd.

### Authentication Flow
```
login: username
Password: [password]
Token: [123456]
✅ Separate prompts via RADIUS attributes
```

### Pros
- ✅ **Separate password and OTP prompts** ⭐
- ✅ Open source
- ✅ Standards-based (RADIUS)
- ✅ On-premises control
- ✅ Works with VPN, WiFi, SSH

### Cons
- ❌ Complex configuration (6-12 hours)
- ❌ Requires RADIUS expertise
- ❌ High maintenance burden
- ❌ Troubleshooting can be difficult
- ❌ Not well-documented for FreeIPA

### Implementation Time
6-12 hours

### Annual Cost
$0

### Maintenance Burden
High:
- RADIUS server maintenance
- Certificate management
- Log monitoring
- Troubleshooting authentication issues

### NIST 800-171 Compliance
✅ Yes - Satisfies IA-2(1), IA-2(2), AC-17

---

## Comparison Matrix

| Feature | FreeIPA Native | privacyIDEA | Duo Security | YubiKey | FreeRADIUS |
|---------|----------------|-------------|--------------|---------|------------|
| **Separate Prompts** | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Setup Time** | 30 min | 4-8 hrs | 1-2 hrs | 2-4 hrs | 6-12 hrs |
| **Year 1 Cost** | $0 | $0 | $0-1620 | $1350-1950 | $0 |
| **Annual Cost (ongoing)** | $0 | $0 | $540-1620 | ~$200 | $0 |
| **Maintenance** | Low | Medium | Very Low | Low | High |
| **User Experience** | Poor | Good | Excellent | Good | Good |
| **NIST 800-171** | ✅ | ✅ | ✅ | ✅✅ | ✅ |
| **Phishing Resistant** | ❌ | Partial* | Partial* | ✅ | ❌ |
| **Offline Support** | ✅ | ✅ | ❌ | ✅ | ✅ |
| **Push Notifications** | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Hardware Required** | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Vendor Lock-in** | ❌ | ❌ | ✅ | Partial | ❌ |

*Partial phishing resistance with U2F/WebAuthn support

---

## Decision Framework

### Choose **FreeIPA Native** if:
- Budget is absolutely $0
- You can tolerate single-prompt concatenation
- You're willing to document workarounds clearly
- Users are technically sophisticated

### Choose **privacyIDEA** if:
- You want open source solution
- You have time for complex setup
- You want full infrastructure control
- You plan to scale beyond 20 users
- You need advanced features (SMS backup, etc.)

### Choose **Duo Security** if:
- User experience is top priority ⭐
- Budget allows $500-1600/year
- You want minimal maintenance burden
- You prefer managed services
- You need quick implementation

### Choose **YubiKey** if:
- Maximum security is required
- You can afford one-time hardware cost
- Users work on-site (not remote)
- Phishing-resistance is critical
- FIPS 140-2 certification required

### Choose **FreeRADIUS** if:
- You have RADIUS expertise in-house
- You need custom authentication flows
- You're already using RADIUS elsewhere
- You have time for complex troubleshooting

---

## Recommendation for Your Environment

**Organization Profile:**
- Size: <15 users
- Industry: Government contractor (CUI/FCI)
- Compliance: NIST 800-171 required
- Budget: Small business
- IT Staff: Limited (likely 1-2 people)

### Recommended Approach: **Duo Security**

**Rationale:**

1. **User Experience = Adoption**
   - Push notifications are intuitive
   - Reduces support tickets
   - Higher compliance rate

2. **Time is Money**
   - 1-2 hours vs. 4-12 hours for alternatives
   - Your time is valuable
   - Focus on business, not MFA infrastructure

3. **Cost is Justified**
   - $540/year for excellent MFA (if >10 users)
   - NIST 800-171 compliance **required** for contracts
   - Losing one contract > cost of Duo

4. **Managed Service**
   - 99.99% uptime SLA
   - Automatic updates
   - No maintenance burden

5. **Compliance Benefits**
   - FedRAMP authorized
   - SOC 2 Type 2 certified
   - Compliance reports for auditors

### Alternative: **privacyIDEA** (if open source is critical)

If budget is truly $0 or open source is a hard requirement:
- Invest the 4-8 hours once
- Run on existing VM/container infrastructure
- Full control and no recurring costs

### Hybrid Approach (Future)

**Phase 1 (Now):** Start with Duo free tier (<10 users)
**Phase 2 (6-12 months):** Evaluate privacyIDEA if costs grow
**Phase 3 (As needed):** Add YubiKeys for highest-privilege accounts

---

## Implementation Priority

### Immediate (Week 1)
1. Sign up for Duo trial (30 days)
2. Test with admin account
3. Document user experience
4. Make final decision

### Short-term (Month 1)
1. Deploy chosen solution to admins group
2. Create user documentation
3. Train users on enrollment
4. Monitor for issues

### Medium-term (Month 2-3)
1. Expand to remote_access group
2. Integrate with VPN (pfSense + RADIUS)
3. Require for all privileged accounts

### Long-term (Month 6+)
1. Consider YubiKeys for top admins
2. Evaluate expanding to all users
3. Review costs and consider privacyIDEA migration if needed

---

## Questions to Consider

Before deciding, think about:

1. **Budget Authority**
   - Can you approve $500-1600/year for Duo?
   - Is one-time hardware cost ($1350-1950) easier to justify?
   - Must solution be $0?

2. **User Base**
   - How remote is your workforce?
   - How technically sophisticated are users?
   - Can users handle hardware tokens?

3. **IT Resources**
   - How much time for initial setup?
   - Who will maintain the solution?
   - What's your troubleshooting capability?

4. **Compliance Timeline**
   - When is next audit?
   - How soon must MFA be operational?
   - Can you afford lengthy implementation?

5. **Risk Tolerance**
   - Is phishing a major concern?
   - Can you accept cloud dependencies?
   - How critical is offline access?

---

## Next Steps

When ready to proceed:

1. **If choosing Duo:**
   - Sign up: https://signup.duo.com/
   - Read deployment guide
   - Schedule 2-hour implementation window

2. **If choosing privacyIDEA:**
   - Review documentation: https://privacyidea.readthedocs.io/
   - Provision VM (2 CPU, 4GB RAM)
   - Schedule 8-hour implementation day

3. **If choosing YubiKey:**
   - Order keys from Yubico
   - Plan key distribution
   - Schedule training sessions

4. **If choosing FreeIPA native:**
   - Document concatenation method clearly
   - Create user guide
   - Test with admin account

---

## Resources

### Documentation
- FreeIPA OTP: https://www.freeipa.org/page/V4/OTP
- privacyIDEA: https://privacyidea.readthedocs.io/
- Duo Unix: https://duo.com/docs/duounix
- YubiKey PAM: https://developers.yubico.com/pam-u2f/

### NIST Guidance
- NIST 800-63B (Digital Identity): https://pages.nist.gov/800-63-3/sp800-63b.html
- NIST 800-171 Rev 2: https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final

### Community Support
- FreeIPA Users Mailing List: https://lists.fedoraproject.org/archives/list/freeipa-users@lists.fedorahosted.org/
- privacyIDEA Community: https://community.privacyidea.org/
- r/FreeIPA: https://reddit.com/r/FreeIPA

---

**Document Version:** 1.0
**Last Updated:** December 11, 2025
**Next Review:** After MFA solution selection
