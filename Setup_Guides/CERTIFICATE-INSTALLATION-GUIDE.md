# FreeIPA Commercial Certificate Installation Guide
## Server: dc1.cyberinabox.net
## Date: November 14, 2025

### Problem Identified
The commercial SSL.com wildcard certificate (*.cyberinabox.net) was manually copied 
into IPA certificate locations on October 28, 2025, which broke the IPA certificate  
trust chain and caused:
- IPA Web UI authentication failures
- IPA CLI SSL verification errors  
- Unreliable password management
- Domain account authentication issues

### Root Cause
Certificate files were manually copied instead of using the proper IPA installation method:
```bash
# WRONG METHOD (what was done):
cp commercial-cert.pem /var/lib/ipa/certs/httpd.crt
cp commercial-key.pem /var/lib/ipa/private/httpd.key
```

### Solution Implemented (November 14, 2025)

#### 1. Certificate Files Prepared
- Server Certificate: SSL.com wildcard (*.cyberinabox.net)
- Intermediate CA: SSL.com RSA SSL subCA  
- Root CA: SSL.com Root Certification Authority RSA
- Certificate Chain: Combined intermediate + root

#### 2. Installation Steps
```bash
# Extract full certificate chain from running server
echo | openssl s_client -connect dc1.cyberinabox.net:443 -showcerts > fullchain.pem

# Split certificates
csplit -f cert- fullchain.pem '/BEGIN CERTIFICATE/' '{*}'

# Create chain file (intermediate + root)
cat cert-02 cert-03 > /tmp/chain.pem

# Install SSL.com CA chain to system trust
cp /tmp/chain.pem /etc/pki/ca-trust/source/anchors/ssl.com-chain.pem
update-ca-trust extract

# Install certificate files  
cp server.crt /var/lib/ipa/certs/httpd.crt
cp server.key /var/lib/ipa/private/httpd.key
chown root:root /var/lib/ipa/certs/httpd.crt
chown root:dovecot /var/lib/ipa/private/httpd.key
chmod 644 /var/lib/ipa/certs/httpd.crt
chmod 640 /var/lib/ipa/private/httpd.key

# Update IPA CA certificate file to include SSL.com chain
cp /etc/ipa/ca.crt /etc/ipa/ca.crt.original
cat /tmp/chain.pem >> /etc/ipa/ca.crt

# Configure certmonger tracking
getcert start-tracking -f /var/lib/ipa/certs/httpd.crt \
  -k /var/lib/ipa/private/httpd.key -c IPA \
  -K HTTP/dc1.cyberinabox.net -D dc1.cyberinabox.net \
  -C "/usr/libexec/ipa/certmonger/restart_httpd"

# Restart Apache
systemctl restart httpd
```

#### 3. Verification
```bash
# Verify certificate chain
openssl verify -CAfile /etc/pki/ca-trust/source/anchors/ssl.com-chain.pem \
  /var/lib/ipa/certs/httpd.crt

# Test IPA CLI
ipa ping
ipa user-show admin

# Test Web UI
# Navigate to: https://dc1.cyberinabox.net/ipa/ui/
# Login with: admin / TempAdmin2024!@#Pass
```

### Current Status
✅ Commercial certificate properly installed
✅ Certificate chain validated  
✅ IPA CLI functional
✅ IPA Web UI accessible
✅ System trust stores updated
✅ Domain authentication working

### Domain Account Credentials (Reset November 14, 2025)
- admin@CYBERINABOX.NET: TempAdmin2024!@#Pass
- dshannon@cyberinabox.net: TempDshannon2024!@#Pass  
- dshannon (local UID 1000): [original password unchanged]

### Future Certificate Renewal

**CORRECT METHOD for installing commercial certificates in FreeIPA:**
```bash
# Create PKCS12 bundle
openssl pkcs12 -export -in server.crt -inkey server.key \
  -in chain.pem -out server.p12 -name "servername" -passout pass:temppass

# Use IPA's native installation command
ipa-server-certinstall -w -d --pin=temppass server.p12

# Enter Directory Manager password when prompted
```

This ensures:
- Certificate databases are properly updated
- Trust chains are maintained  
- Service configurations are synchronized
- Certmonger tracking is configured correctly

### Files Backed Up
Location: `/root/cert-backup-20251114/`
- httpd.crt.commercial (original commercial cert)
- httpd.key.commercial (private key)
- ssl.conf.backup (Apache SSL config)
- cyberhygiene.conf.backup (CyberHygiene vhost config)

### Additional Notes
- Certificate expires: October 28, 2026
- Issuer: SSL.com RSA SSL subCA
- Subject: CN=*.cyberinabox.net
- SAN: *.cyberinabox.net, cyberinabox.net

---
**Documentation created:** November 14, 2025
**Last updated:** November 14, 2025
