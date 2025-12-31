# FreeIPA System Status Report
**Date:** December 11, 2025
**System:** dc1.cyberinabox.net
**FreeIPA Version:** 4.12.2
**Rocky Linux:** 9.6
**FIPS Mode:** Enabled

## Summary

This document provides a comprehensive status report of the FreeIPA domain controller following fresh installation on December 10, 2025, and commercial SSL certificate installation.

## Installation Status

### FreeIPA 4.12.2 Installation
- **Date:** December 10, 2025
- **Status:** ✅ Successfully Installed
- **Installation Log:** `/home/dshannon/ipa-install-4.12.2.log`
- **Realm:** CYBERINABOX.NET
- **Domain:** cyberinabox.net
- **Hostname:** dc1.cyberinabox.net (192.168.1.10)

### Services Status
All FreeIPA services are running correctly:
```
Directory Service: RUNNING
krb5kdc Service: RUNNING
kadmin Service: RUNNING
named Service: RUNNING
httpd Service: RUNNING
ipa-custodia Service: RUNNING
pki-tomcatd Service: RUNNING
ipa-otpd Service: RUNNING
ipa-dnskeysyncd Service: RUNNING
```

## Authentication Configuration

### Admin Account
- **Username:** admin
- **Password:** TestPass2025!
- **Kerberos Authentication:** ✅ Working
- **IPA CLI Access:** ✅ Working (via kinit)
- **Web Form Login:** ❌ Broken (ipa-pwd-extop bug)

### Directory Manager Account
- **Username:** cn=Directory Manager
- **Password:** 8Bu_K_%;Nn{UU4VoN,@(BMb5Rb8R>zrVQ}^Zhj?_2
- **Status:** ✅ Working
- **Usage:** LDAP administrative operations, CA certificate management

## Known Issues

### ipa-pwd-extop Plugin Bug (FreeIPA 4.12.2)

**Symptom:** Web interface form-based login fails with "Password incorrect" error despite correct credentials.

**Root Cause:** Password synchronization failure between Kerberos and LDAP in FreeIPA 4.12.2.

**Impact:**
- Web form login: NOT WORKING
- Kerberos authentication (kinit): WORKING
- IPA CLI tools: WORKING (after kinit)

**Workaround:**
```bash
# Method 1: Use Kerberos authentication
kinit admin  # Enter: TestPass2025!
# Then access web interface - browser will use SPNEGO/Negotiate authentication

# Method 2: Use IPA CLI tools
kinit admin
ipa user-show admin
ipa user-add username --first=First --last=Last
```

**Status:** No permanent fix available in FreeIPA 4.12.2. Consider upgrading when newer version is available.

## SSL Certificate Configuration

### Commercial Wildcard Certificate

**Certificate Details:**
- **Type:** SSL.com Wildcard Certificate
- **Common Name:** *.cyberinabox.net
- **Issuer:** SSL.com RSA SSL subCA
- **Valid From:** October 28, 2025
- **Valid Until:** October 28, 2026 (338 days remaining)
- **Installation Date:** December 10, 2025

**Certificate Locations:**
- IPA Web Server: `/var/lib/ipa/certs/httpd.crt`
- Private Key: `/var/lib/ipa/private/httpd.key`
- Commercial Copy: `/etc/pki/tls/certs/commercial/wildcard.crt`
- Private Key Copy: `/etc/pki/tls/private/commercial/wildcard.key`
- CA Chain: `/etc/pki/tls/certs/commercial/chain.pem`
- Reference Files: `/home/dshannon/Documents/Claude/SSL_Certificate_Reference/`

**Installation Method:**
1. Created PKCS12 bundle from certificate files
2. Installed SSL.com CA chain to IPA trust store via `ipa-cacert-manage`
3. Updated certificate databases via `ipa-certupdate`
4. Installed wildcard certificate via `ipa-server-certinstall -w -d`
5. Restarted IPA services via `ipactl restart`

**Verification:**
```bash
# Test certificate from web server
openssl s_client -connect dc1.cyberinabox.net:443 -servername dc1.cyberinabox.net </dev/null 2>&1 | openssl x509 -noout -subject -issuer -dates

# Output:
# subject=CN=*.cyberinabox.net
# issuer=C=US, ST=Texas, L=Houston, O=SSL Corporation, CN=SSL.com RSA SSL subCA
# notBefore=Oct 28 16:38:13 2025 GMT
# notAfter=Oct 28 16:38:13 2026 GMT
```

### Certificate Tracking

**Certmonger Status:**
- IPA-issued certificates: ✅ Tracked and auto-renewing
- Commercial wildcard certificate: ⚠️ NOT tracked by certmonger
- Manual renewal required before October 28, 2026

**IPA-Managed Certificates (Auto-Renewing):**
- IPA CA Certificate (expires 2045)
- IPA RA Agent Certificate (expires 2027)
- PKI Tomcat Server Certificate (expires 2027)
- KDC PKINIT Certificate (expires 2027)
- Various CA subsystem certificates (expires 2027)

## Virtual Host Configuration

The following Apache virtual hosts are configured to use the commercial wildcard certificate:

### Active Configuration
- **FreeIPA Web UI:** `/var/lib/ipa/certs/httpd.crt` ✅ Active
  - URL: https://dc1.cyberinabox.net/ipa/ui/

### Configured (To Be Enabled)
- **Roundcube Webmail:** `/etc/pki/tls/certs/commercial/wildcard.crt`
  - Config: `/etc/httpd/conf.d/roundcube.conf`
  - URL: https://webmail.cyberinabox.net/

- **Redmine Projects:** `/etc/pki/tls/certs/commercial/wildcard.crt`
  - Config: `/etc/httpd/conf.d/redmine.conf`
  - URL: https://projects.cyberinabox.net/

- **CyberHygiene Website:** `/etc/pki/tls/certs/commercial/wildcard.crt`
  - Config: `/etc/httpd/conf.d/cyberhygiene.conf`
  - URL: https://cyberinabox.net/

## Security Compliance

### FIPS Mode
```bash
# Verification
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled  # Returns: 1
```

**Status:** ✅ FIPS 140-2 mode active

### Password Policy (NIST 800-171 Compliant)
- Minimum length: 14 characters
- Minimum character classes: 3 (upper, lower, number, special)
- Password expiration: 90 days
- Password history: 24
- Failed login attempts: 5 (30-minute lockout)

### Encrypted Storage
- `/home`: LUKS encrypted ✅
- `/var`: LUKS encrypted ✅
- `/var/log`: LUKS encrypted ✅
- `/var/log/audit`: LUKS encrypted ✅
- `/tmp`: LUKS encrypted ✅
- `/data`: LUKS encrypted ✅
- `/backup`: LUKS encrypted ✅
- RAID array (`/srv/samba`): LUKS encrypted ✅

## Maintenance Requirements

### Immediate Actions Required
1. ✅ Document passwords and system credentials (COMPLETED)
2. ✅ Update system documentation (COMPLETED)
3. ⚠️ Configure certmonger to track commercial certificate renewal (OPTIONAL)
4. ⚠️ Test other virtual hosts (roundcube, redmine, cyberhygiene) when services are deployed

### Certificate Renewal (Before October 28, 2026)
1. Log into SSL.com account ~30 days before expiration
2. Reissue/renew wildcard certificate
3. Download new certificate files
4. Backup current certificate
5. Install new certificate using documented procedure
6. Test all virtual hosts
7. Update documentation

### Regular Maintenance Schedule
- **Daily:** Review IDS/IPS alerts, monitor logs, verify backups
- **Weekly:** Review user access logs, perform full server backup
- **Monthly:** Apply security patches, review user accounts, rotate offsite backup
- **Quarterly:** Run OpenSCAP compliance scan, test disaster recovery
- **Annually:** Security assessment/audit, penetration testing

## Documentation Updates

The following documentation has been updated to reflect current system state:

1. **CLAUDE.md** (`/home/dshannon/Documents/Claude/CLAUDE.md`)
   - Added current passwords and dates
   - Documented ipa-pwd-extop bug and workarounds
   - Added commercial certificate information
   - Updated security notes

2. **SSL Certificate Reference README** (`/home/dshannon/Documents/Claude/SSL_Certificate_Reference/README.md`)
   - Added installation history section
   - Documented December 10, 2025 installation
   - Updated certificate deployment locations
   - Added FreeIPA-specific installation details

3. **System Status Report** (this document)
   - Created: `/home/dshannon/Documents/Claude/System_Status_2025-12-11.md`

## Backup Information

### Critical Files to Backup
- IPA CA Certificate: `/root/cacert.p12` (password: Directory Manager password)
- FreeIPA Configuration: `/etc/ipa/`
- Directory Server Config: `/etc/dirsrv/`
- Kerberos Config: `/etc/krb5.conf`
- Commercial Certificate: `/home/dshannon/Documents/Claude/SSL_Certificate_Reference/`
- LUKS Keys: `/root/samba-luks.key`
- RAID Config: `/etc/mdadm.conf`

### Automated Backups
- FreeIPA backup command: `ipa-backup`
- Backup location: `/var/lib/ipa/backup/`
- Restore command: `ipa-restore /var/lib/ipa/backup/ipa-full-YYYY-MM-DD-HH-MM-SS`

## Access Instructions

### Kerberos Authentication (CLI)
```bash
# Get Kerberos ticket
kinit admin
# Enter password: TestPass2025!

# Verify ticket
klist

# Use IPA commands
ipa user-show admin
ipa group-show admins
```

### Web Interface Access
```bash
# Method 1: SPNEGO/Negotiate (Recommended)
kinit admin  # Get ticket first
# Then open browser to: https://dc1.cyberinabox.net

# Method 2: Form login (Currently broken - see Known Issues)
```

### LDAP Administrative Access
```bash
# Using Directory Manager credentials
ldapsearch -x -D "cn=Directory Manager" -W \
  -H ldapi://%2frun%2fslapd-CYBERINABOX-NET.socket \
  -b "dc=cyberinabox,dc=net"
```

## System Health Dashboard

| Component | Status | Notes |
|-----------|--------|-------|
| FreeIPA Installation | ✅ Operational | Version 4.12.2 |
| Directory Server (LDAP) | ✅ Running | Port 389/636 |
| Kerberos KDC | ✅ Running | Port 88/464 |
| DNS Server (BIND) | ✅ Running | Port 53 |
| Web Server (httpd) | ✅ Running | Port 80/443 |
| Certificate Authority | ✅ Running | Dogtag CA |
| Commercial SSL Cert | ✅ Installed | Valid until Oct 2026 |
| Kerberos Authentication | ✅ Working | Admin password verified |
| Web Form Login | ❌ Broken | ipa-pwd-extop bug |
| IPA CLI Tools | ✅ Working | Via kinit |
| FIPS Mode | ✅ Enabled | FIPS 140-2 |
| SELinux | ✅ Enforcing | No denials |
| Encrypted Storage | ✅ Mounted | All partitions encrypted |

## Support Information

**System Administrator:** Donald E. Shannon
**Documentation Location:** `/home/dshannon/Documents/Claude/`
**Installation Logs:** `/home/dshannon/ipa-install-*.log`
**System Logs:** `/var/log/ipaserver-install.log`

**Related Documentation:**
- CLAUDE.md: System architecture and operations guide
- SSL_Certificate_Reference/README.md: Certificate management
- pfSense_SSL_Certificate_Installation_Guide.md: Network certificate deployment

---

**Report Generated:** December 11, 2025
**Next Review Date:** January 11, 2026 (Monthly maintenance)
**Certificate Renewal Due:** September 28, 2026 (30 days before expiration)
