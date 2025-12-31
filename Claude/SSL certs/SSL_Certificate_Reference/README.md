# SSL Certificate Reference
**Created:** December 2, 2025
**Certificate Type:** SSL.com Wildcard Certificate
**Domain:** *.cyberinabox.net

## Files in This Directory

### 1. wildcard_cyberinabox_net.crt
**Description:** SSL.com wildcard certificate for *.cyberinabox.net
**Type:** Server certificate (PEM format)
**Covers:** *.cyberinabox.net and cyberinabox.net
**Expires:** October 28, 2026
**Issuer:** SSL.com RSA SSL subCA

### 2. wildcard_cyberinabox_net.key
**Description:** Private key for the wildcard certificate
**Type:** RSA private key (PEM format)
**Security:** KEEP SECURE - Do not share or expose publicly
**Permissions:** 600 (owner read/write only)

### 3. ssl_com_chain.pem
**Description:** SSL.com certificate chain (Intermediate + Root CA)
**Type:** Certificate chain file (PEM format)
**Contains:**
- SSL.com RSA SSL subCA (Intermediate)
- SSL.com Root Certification Authority RSA (Root)

## Installation History

### Latest Installation: December 10, 2025
**Method Used:** FreeIPA Native Installation (ipa-server-certinstall)
**Status:** ✅ Successfully Installed
**Installed On:** dc1.cyberinabox.net (FreeIPA 4.12.2)

**Installation Steps Performed:**
1. Created PKCS12 bundle: `/tmp/wildcard_ipa.p12`
2. Installed SSL.com CA chain to IPA trust store: `ipa-cacert-manage install`
3. Updated certificate databases: `ipa-certupdate`
4. Installed wildcard certificate: `ipa-server-certinstall -w -d`
5. Restarted IPA services: `ipactl restart`

**Certificate Now Active For:**
- FreeIPA Web UI (https://dc1.cyberinabox.net/ipa/ui/)
- All FreeIPA web services

## Current Deployment Locations

These files are actively used in the following locations:

### FreeIPA-Managed Certificates
**Installed via:** `ipa-server-certinstall` (December 10, 2025)
- Managed by: FreeIPA certmonger
- Certificate tracking: Active
- Auto-renewal: Not configured (manual renewal required before October 2026)

### Apache/HTTPD
- Certificate: Managed by IPA in NSS database
- Private Key: Managed by IPA in NSS database
- Chain File: Installed in IPA trust store via `ipa-cacert-manage`

### Virtual Hosts Using This Certificate
- FreeIPA Web UI (https://dc1.cyberinabox.net/ipa/ui/)
- Roundcube Webmail (https://webmail.cyberinabox.net/) - To Be Configured
- CyberHygiene Website (https://cyberinabox.net/) - To Be Configured
- Redmine Projects (https://projects.cyberinabox.net/) - To Be Configured

## Backup Locations

**Primary Backup:** `/root/cert-backup-20251114/`
- httpd.crt.commercial
- httpd.key.commercial

**Reference Copy:** `/home/dshannon/Documents/Claude/SSL_Certificate_Reference/` (this directory)

## Certificate Details

```bash
# View certificate information
openssl x509 -in wildcard_cyberinabox_net.crt -text -noout

# Verify certificate and key match
openssl x509 -noout -modulus -in wildcard_cyberinabox_net.crt | openssl sha256
openssl rsa -noout -modulus -in wildcard_cyberinabox_net.key | openssl sha256
# (These should produce identical hash values)

# Check certificate expiration
openssl x509 -in wildcard_cyberinabox_net.crt -noout -dates
```

## Certificate Installation (For Future Reference)

### Method 1: Manual Installation (Current Method)
```bash
# Copy files to FreeIPA locations
sudo cp wildcard_cyberinabox_net.crt /var/lib/ipa/certs/httpd.crt
sudo cp wildcard_cyberinabox_net.key /var/lib/ipa/private/httpd.key
sudo cp ssl_com_chain.pem /etc/pki/ca-trust/source/anchors/ssl.com-chain.pem

# Set proper permissions
sudo chown root:root /var/lib/ipa/certs/httpd.crt
sudo chown root:dovecot /var/lib/ipa/private/httpd.key
sudo chmod 644 /var/lib/ipa/certs/httpd.crt
sudo chmod 640 /var/lib/ipa/private/httpd.key

# Update system trust store
sudo update-ca-trust extract

# Restart Apache
sudo systemctl restart httpd
```

### Method 2: FreeIPA Native Installation (Recommended for Future Renewals)
```bash
# Create PKCS12 bundle
openssl pkcs12 -export -in wildcard_cyberinabox_net.crt \
  -inkey wildcard_cyberinabox_net.key \
  -in ssl_com_chain.pem \
  -out wildcard.p12 -name "dc1.cyberinabox.net" \
  -passout pass:temppassword

# Install via IPA
ipa-server-certinstall -w -d --pin=temppassword wildcard.p12
# (Enter Directory Manager password when prompted)
```

## Renewal Information

**Renewal Date:** ~September 2026 (30 days before expiration)
**Renewal Process:**
1. Log into SSL.com account
2. Reissue or renew certificate
3. Download new certificate files
4. Backup current certificate
5. Install new certificate using Method 2 above
6. Test all virtual hosts
7. Update this reference directory

## Security Notes

⚠️ **IMPORTANT:**
- The private key file is **SENSITIVE** - keep secure
- Do NOT commit to version control
- Do NOT share via email or insecure channels
- Maintain backups in multiple secure locations
- Only root and authorized admins should have access

## Troubleshooting

### Certificate/Key Mismatch Error
If you get "certificate and private key do not match" error:
```bash
# Verify they match
openssl x509 -noout -modulus -in wildcard_cyberinabox_net.crt | openssl sha256
openssl rsa -noout -modulus -in wildcard_cyberinabox_net.key | openssl sha256
```

### Apache Won't Start After Certificate Change
```bash
# Test Apache configuration
sudo httpd -t

# Check Apache error logs
sudo tail -50 /var/log/httpd/error_log

# Verify certificate paths in configs
sudo grep -r "SSLCertificate" /etc/httpd/conf.d/
```

## Related Documentation

- Certificate Installation Guide: `/root/CERTIFICATE-INSTALLATION-GUIDE.md`
- System Security Plan: `/home/dshannon/Documents/Claude/Artifacts/System_Security_Plan_v1.5.docx`
- Apache Configuration: `/etc/httpd/conf.d/ssl.conf`

---

**Last Updated:** December 10, 2025
**Maintainer:** Donald E. Shannon
**System:** dc1.cyberinabox.net
**Certificate Installation Date:** December 10, 2025
