# Certificate Chronology and Root Cause Analysis
**Date:** December 6, 2025
**Analyst:** Claude Code
**Purpose:** Identify root cause of cascading authentication and certificate issues

## Executive Summary

**ROOT CAUSE IDENTIFIED:** FreeIPA's httpd.crt is being used for TWO INCOMPATIBLE purposes:
1. **Internal FreeIPA Operations** - Requires IPA CA-signed certificate
2. **Public Web Services** - Requires commercial CA-signed certificate

This architectural conflict has created a cascading series of "fixes" that break other functionality.

---

## Certificate Chronology

### Initial State (Pre-November 2025)
- **httpd.crt:** Self-signed IPA CA certificate
- **Issuer:** CN=Certificate Authority, O=CYBERINABOX.NET
- **Purpose:** FreeIPA web UI and internal operations
- **Status:** ✅ FreeIPA working, ❌ Browser warnings on public site

### Change #1: Commercial Certificate Installation (November 2025)
**Action:** Installed SSL.com wildcard certificate to `/var/lib/ipa/certs/httpd.crt`

**Intent:** Eliminate browser warnings on public websites

**Files Affected:**
- `/var/lib/ipa/certs/httpd.crt` → SSL.com wildcard cert
- `/var/lib/ipa/private/httpd.key` → SSL.com private key
- `/etc/pki/ca-trust/source/anchors/ssl.com-chain.pem` → SSL.com chain

**Immediate Results:**
- ✅ cyberinabox.net - No browser warnings
- ✅ webmail.cyberinabox.net - Trusted certificate
- ✅ projects.cyberinabox.net - Trusted certificate
- ✅ FreeIPA web UI - Trusted certificate (initially)

**Hidden Breakage:** FreeIPA client enrollment broken (not discovered yet)

### Change #2: Lab Rat Domain Join Attempt (December 6, 2025)
**Action:** Attempted to join labrat.cyberinabox.net to FreeIPA domain

**Failure Mode:**
```
SSL certificate error: [SSL: CERTIFICATE_VERIFY_FAILED]
```

**Root Cause Discovery:** FreeIPA clients expect to validate against IPA's own CA, not SSL.com CA

**Impact:** Cannot enroll new workstations to domain

### Change #3: Emergency Revert to IPA CA (December 6, 2025)
**Action:** Ran `getcert resubmit` to restore IPA CA-signed certificate

**Command:**
```bash
sudo getcert resubmit -i '20251201230107' -f /var/lib/ipa/certs/httpd.crt
sudo systemctl restart httpd
```

**Immediate Results:**
- ✅ Lab Rat enrollment succeeded
- ✅ FreeIPA operations restored
- ❌ cyberinabox.net - Browser warnings returned
- ❌ webmail.cyberinabox.net - Untrusted certificate
- ❌ projects.cyberinabox.net - Untrusted certificate

**Current State (as of December 6, 2025):**
- **httpd.crt:** IPA CA-signed certificate
- **Issuer:** CN=Certificate Authority, O=CYBERINABOX.NET
- **Public websites:** Self-signed cert warnings
- **FreeIPA:** Fully operational

---

## Architecture Analysis

### The Fundamental Conflict

FreeIPA's httpd.crt serves **dual, incompatible purposes**:

#### Purpose #1: FreeIPA Internal PKI Operations
- **Requirement:** Certificate signed by FreeIPA's internal CA
- **Validation:** Clients validate against IPA CA trust anchor
- **Critical for:**
  - Client enrollment (`ipa-client-install`)
  - Kerberos ticket operations
  - Certificate issuance
  - Trust relationship establishment

#### Purpose #2: Public Web Services
- **Requirement:** Certificate signed by publicly-trusted CA
- **Validation:** Browsers validate against system trust store
- **Critical for:**
  - Public website (cyberinabox.net)
  - Webmail (webmail.cyberinabox.net)
  - Project management (projects.cyberinabox.net)
  - Professional appearance / trust

### Why the "Single Certificate" Approach Fails

**FreeIPA's Design Assumption:**
- FreeIPA expects `/var/lib/ipa/certs/httpd.crt` to be issued by its own CA
- Client enrollment process validates the server's cert against IPA CA
- Replacing with commercial cert breaks the PKI trust chain

**Web Services Requirement:**
- Commercial CA required to avoid browser warnings
- Users expect trusted HTTPS on public sites
- NIST 800-171 requires encryption in transit (SC-8)

**The Conflict:**
- Can't use IPA CA cert → browsers show warnings
- Can't use commercial cert → FreeIPA breaks
- Current approach: whack-a-mole between the two

---

## Cascading Failure Map

```
SSL.com Cert Installed
         ↓
cyberinabox.net works ✅
         ↓
FreeIPA client enrollment breaks ❌
         ↓
Cannot join Lab Rat to domain ❌
         ↓
Revert to IPA CA cert
         ↓
Lab Rat enrollment works ✅
         ↓
cyberinabox.net shows warnings ❌
         ↓
Professional appearance degraded ❌
         ↓
User frustration: "One fix breaks another"
```

---

## SSH Authentication Issues

### Current SSH Problem
- **Symptom:** Lab Rat cannot SSH to DC1
- **Error:** "Permission denied" / "Too many authentication failures"
- **Working:** DC1 can SSH to Lab Rat

### Likely Root Causes

#### 1. SSH Host Key Trust Issues
When cert was changed, SSH host keys may have changed:
```bash
# Check if host key changed
ssh-keygen -F dc1.cyberinabox.net
```

#### 2. Kerberos Ticket Issues
If FreeIPA cert was recently changed, Kerberos tickets may be invalid:
```bash
# Check Kerberos ticket
klist
# Ticket may reference old cert
```

#### 3. GSSAPI Authentication Failure
FreeIPA uses GSSAPI for SSH, which depends on valid Kerberos tickets:
- Invalid ticket → GSSAPI fails
- Falls back to key auth
- Multiple key attempts → "too many authentication failures"

#### 4. Certificate-Based SSH Authentication
If using certificate-based SSH (FreeIPA feature):
- User certs signed by old IPA CA
- New cert doesn't validate
- Authentication rejected

---

## Solution Architecture

### Recommended Approach: Split Certificate Management

#### Solution: Use SEPARATE certificates for different purposes

**For FreeIPA Operations (REQUIRED: IPA CA):**
- Location: `/var/lib/ipa/certs/httpd.crt`
- Purpose: FreeIPA web UI, client enrollment, internal PKI
- Certificate: IPA CA-signed
- VirtualHosts: https://dc1.cyberinabox.net/ipa/ui/

**For Public Web Services (RECOMMENDED: Commercial CA):**
- Location: `/etc/pki/tls/certs/wildcard-cyberinabox.crt`
- Purpose: Public websites, webmail, projects
- Certificate: SSL.com wildcard
- VirtualHosts:
  - https://cyberinabox.net/
  - https://webmail.cyberinabox.net/
  - https://projects.cyberinabox.net/

### Implementation Steps

#### Step 1: Install Commercial Cert to Alternate Location
```bash
# Create dedicated directory
sudo mkdir -p /etc/pki/tls/certs/commercial
sudo mkdir -p /etc/pki/tls/private/commercial

# Install commercial cert
sudo cp ~/Documents/Claude/SSL_Certificate_Reference/wildcard_cyberinabox_net.crt \
    /etc/pki/tls/certs/commercial/wildcard.crt

sudo cp ~/Documents/Claude/SSL_Certificate_Reference/wildcard_cyberinabox_net.key \
    /etc/pki/tls/private/commercial/wildcard.key

sudo cp ~/Documents/Claude/SSL_Certificate_Reference/ssl_com_chain.pem \
    /etc/pki/tls/certs/commercial/chain.pem

# Set permissions
sudo chmod 644 /etc/pki/tls/certs/commercial/*
sudo chmod 600 /etc/pki/tls/private/commercial/wildcard.key
```

#### Step 2: Update Public Website VirtualHosts
```apache
# /etc/httpd/conf.d/cyberhygiene.conf
<VirtualHost *:443>
    ServerName cyberinabox.net
    ServerAlias www.cyberinabox.net

    # USE COMMERCIAL CERT
    SSLCertificateFile /etc/pki/tls/certs/commercial/wildcard.crt
    SSLCertificateKeyFile /etc/pki/tls/private/commercial/wildcard.key
    SSLCertificateChainFile /etc/pki/tls/certs/commercial/chain.pem
    ...
</VirtualHost>
```

```apache
# /etc/httpd/conf.d/roundcube.conf
<VirtualHost *:443>
    ServerName webmail.cyberinabox.net

    # USE COMMERCIAL CERT
    SSLCertificateFile /etc/pki/tls/certs/commercial/wildcard.crt
    SSLCertificateKeyFile /etc/pki/tls/private/commercial/wildcard.key
    SSLCertificateChainFile /etc/pki/tls/certs/commercial/chain.pem
    ...
</VirtualHost>
```

```apache
# /etc/httpd/conf.d/redmine.conf
<VirtualHost *:443>
    ServerName projects.cyberinabox.net

    # USE COMMERCIAL CERT
    SSLCertificateFile /etc/pki/tls/certs/commercial/wildcard.crt
    SSLCertificateKeyFile /etc/pki/tls/private/commercial/wildcard.key
    SSLCertificateChainFile /etc/pki/tls/certs/commercial/chain.pem
    ...
</VirtualHost>
```

#### Step 3: Keep IPA CA Cert for FreeIPA
```apache
# /etc/httpd/conf.d/ssl.conf (FreeIPA web UI)
<VirtualHost *:443>
    ServerName dc1.cyberinabox.net

    # KEEP IPA CA CERT - DO NOT CHANGE
    SSLCertificateFile /var/lib/ipa/certs/httpd.crt
    SSLCertificateKeyFile /var/lib/ipa/private/httpd.key
    ...
</VirtualHost>
```

#### Step 4: Restart Apache
```bash
# Test configuration
sudo httpd -t

# Restart
sudo systemctl restart httpd
```

#### Step 5: Verify Certificate Split
```bash
# Public site should use SSL.com
echo | openssl s_client -connect cyberinabox.net:443 -servername cyberinabox.net 2>/dev/null | \
    openssl x509 -noout -issuer
# Expected: issuer=C=US, ST=Texas, L=Houston, O=SSL Corporation, CN=SSL.com RSA SSL subCA

# FreeIPA should use IPA CA
echo | openssl s_client -connect dc1.cyberinabox.net:443 -servername dc1.cyberinabox.net 2>/dev/null | \
    openssl x509 -noout -issuer
# Expected: issuer=O=CYBERINABOX.NET, CN=Certificate Authority
```

---

## SSH Authentication Fix

### Once Certificates Are Stabilized:

#### Option 1: Re-initialize Kerberos Tickets on Lab Rat
```bash
# On Lab Rat
kdestroy
kinit donald.shannon@CYBERINABOX.NET
ssh dc1.cyberinabox.net
```

#### Option 2: Use SSH Keys (Workaround)
```bash
# On Lab Rat, generate SSH key if needed
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# Copy to DC1
ssh-copy-id dshannon@dc1.cyberinabox.net
```

#### Option 3: Rebuild SSH Known Hosts
```bash
# On Lab Rat
ssh-keygen -R dc1.cyberinabox.net
ssh-keyscan -H dc1.cyberinabox.net >> ~/.ssh/known_hosts
```

---

## Long-Term Prevention

### Policy Recommendations

1. **Never Replace IPA CA Certificates**
   - `/var/lib/ipa/certs/httpd.crt` must ALWAYS be IPA CA-signed
   - Document this as a critical operational constraint
   - Add to SSP as a security control baseline requirement

2. **Use Separate Certificates for Public Services**
   - Public-facing sites: `/etc/pki/tls/certs/commercial/`
   - FreeIPA services: `/var/lib/ipa/certs/` (IPA CA only)

3. **Document Certificate Purposes**
   - Maintain certificate inventory
   - Label each cert with its purpose and constraints
   - Include renewal procedures that preserve purpose

4. **Test Domain Operations After Certificate Changes**
   - Always test `ipa-client-install` after cert changes
   - Verify Kerberos ticket issuance
   - Check SSH authentication

5. **Backup Before Certificate Changes**
   - Backup current cert before replacing
   - Document rollback procedure
   - Test restoration process

---

## Immediate Action Items

### Critical Path (Fix Today)

1. ✅ **Stabilize FreeIPA**
   - Current state: IPA CA cert in place
   - Status: STABLE - Do not touch

2. ⏳ **Implement Certificate Split**
   - Install commercial cert to `/etc/pki/tls/certs/commercial/`
   - Update public VirtualHost configs
   - Leave FreeIPA cert unchanged
   - Estimated time: 30 minutes

3. ⏳ **Fix SSH Authentication**
   - Clear Kerberos tickets on Lab Rat
   - Re-initialize with `kinit`
   - Test SSH connectivity
   - Estimated time: 10 minutes

4. ⏳ **Update SSP Documentation**
   - Document split certificate architecture
   - Add operational constraint for IPA cert
   - Update security controls
   - Estimated time: 20 minutes

---

## Risk Assessment

### Current Risks

**High Priority:**
- ❌ Public website shows browser warnings (reputational risk)
- ⚠️ SSH authentication unreliable (operational risk)
- ⚠️ Certificate management process unclear (procedural risk)

**Medium Priority:**
- ⚠️ No clear rollback procedure
- ⚠️ Certificate changes not tested before deployment
- ⚠️ Operational documentation incomplete

**Mitigated:**
- ✅ FreeIPA stable and operational
- ✅ Lab Rat successfully domain-joined
- ✅ Compliance scanning operational

---

## Conclusion

The root cause of cascading failures is **architectural**: attempting to use a single certificate for incompatible purposes (FreeIPA internal PKI + public web services).

**Solution:** Implement certificate split architecture with:
- IPA CA certificate for FreeIPA operations (never change)
- Commercial CA certificate for public web services (update VirtualHost configs)

This architectural fix will:
- ✅ Eliminate browser warnings on public sites
- ✅ Maintain FreeIPA stability
- ✅ Prevent future "fix one, break another" cycles
- ✅ Provide clear operational procedures

**Recommendation:** Implement certificate split immediately to restore full functionality.

---

**Document Status:** DRAFT - Pending Implementation
**Next Review:** After certificate split implementation
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
