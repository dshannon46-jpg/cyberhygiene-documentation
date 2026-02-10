# Chapter 30: Certificate Management

## 30.1 Certificate Authority Overview

### Internal CA Structure

**Certificate Authority:** dc1.cyberinabox.net (FreeIPA CA)

**CA Hierarchy:**

```
Root CA: CyberHygiene Root CA
  └── Issuing CA: IPA CA (FreeIPA integrated CA)
      ├── Server Certificates (SSL/TLS)
      ├── User Certificates (client auth)
      ├── Service Certificates (Kerberos, LDAP, etc.)
      └── Sub-CAs (if needed)

Certificate Details:
  Root CA:
    Subject: CN=Certificate Authority, O=CYBERINABOX.NET
    Validity: 20 years
    Key Size: 4096-bit RSA
    Serial: 1

  Issuing CA:
    Subject: CN=Certificate Authority, O=IPA.CYBERINABOX.NET
    Validity: 20 years (renewed automatically)
    Key Size: 4096-bit RSA
```

### Certificate Types

**Server Certificates (HTTPS/TLS):**
```
Issued for:
  - dc1.cyberinabox.net (FreeIPA Web UI)
  - dms.cyberinabox.net (File server)
  - graylog.cyberinabox.net (Graylog Web UI)
  - proxy.cyberinabox.net (Proxy services)
  - monitoring.cyberinabox.net (Grafana)
  - wazuh.cyberinabox.net (Wazuh Dashboard)
  - grafana.cyberinabox.net (Grafana external)
  - mail.cyberinabox.net (Roundcube webmail)

Validity: 2 years (auto-renewal at 30 days before expiration)
Key Size: 2048-bit RSA minimum
Usage: Server Authentication, Digital Signature
```

**Service Certificates:**
```
Issued for:
  - HTTP/dc1.cyberinabox.net (Web services)
  - LDAP/dc1.cyberinabox.net (Directory services)
  - host/dc1.cyberinabox.net (Kerberos host principal)
  - PostgreSQL/wazuh.cyberinabox.net (Database TLS)
  - MongoDB/graylog.cyberinabox.net (Database TLS)

Validity: 2 years
Auto-renewed: Yes
Stored in: /etc/pki/nssdb/ or service-specific location
```

**User Certificates (Optional - Phase II):**
```
For:
  - VPN client authentication
  - Email signing/encryption (S/MIME)
  - SSH certificate authentication
  - Smart card authentication

Status: Available but not yet deployed
Validity: 1 year
Distribution: User self-service via FreeIPA Web UI
```

## 30.2 Certificate Lifecycle

### Certificate Issuance

**Request Server Certificate (Web UI):**

```
1. Login to FreeIPA: https://dc1.cyberinabox.net
2. Navigate: Identity → Services
3. Click: "+ Add"
4. Service: HTTP
5. Host: newserver.cyberinabox.net
6. Click: "Add and Edit"

7. Actions → "New Certificate"
8. Select: "Request certificate using CSR"
9. Generate CSR on server first:

   ssh admin@newserver.cyberinabox.net
   sudo openssl req -new -newkey rsa:2048 -nodes \
     -keyout /etc/pki/tls/private/server.key \
     -out /tmp/server.csr \
     -subj "/CN=newserver.cyberinabox.net/O=CYBERINABOX.NET"

10. Copy CSR content
11. Paste into FreeIPA "Certificate Request" field
12. Click: "Issue"
13. Certificate issued - copy to server

14. On server:
    sudo vi /etc/pki/tls/certs/server.crt
    [Paste certificate]

    # Set permissions
    sudo chmod 644 /etc/pki/tls/certs/server.crt
    sudo chmod 600 /etc/pki/tls/private/server.key

15. Configure service to use certificate
```

**Request Certificate (CLI - Faster):**

```bash
# On the target server
ssh admin@newserver.cyberinabox.net

# Request certificate via ipa-getcert
sudo ipa-getcert request \
  -f /etc/pki/tls/certs/server.crt \
  -k /etc/pki/tls/private/server.key \
  -N CN=newserver.cyberinabox.net \
  -D newserver.cyberinabox.net \
  -K host/newserver.cyberinabox.net@CYBERINABOX.NET \
  -U id-kp-serverAuth

# Check request status
sudo ipa-getcert list

# Output:
Number of certificates and requests being tracked: 1.
Request ID '20251231120000':
        status: MONITORING
        stuck: no
        key pair storage: type=FILE,location='/etc/pki/tls/private/server.key'
        certificate: type=FILE,location='/etc/pki/tls/certs/server.crt'
        CA: IPA
        issuer: CN=Certificate Authority,O=IPA.CYBERINABOX.NET
        subject: CN=newserver.cyberinabox.net,O=CYBERINABOX.NET
        expires: 2027-12-31 12:00:00 UTC
        dns: newserver.cyberinabox.net
        principal name: host/newserver.cyberinabox.net@CYBERINABOX.NET
        key usage: digitalSignature,keyEncipherment
        eku: id-kp-serverAuth
        pre-save command:
        post-save command:
        track: yes
        auto-renew: yes
```

### Certificate Renewal

**Automatic Renewal:**

```
FreeIPA Certmonger handles automatic renewal:
  - Monitoring: Checks certificates daily
  - Renewal trigger: 30 days before expiration
  - Process: Automatic CSR generation and submission
  - Service reload: Configured per service
  - Notification: Email if renewal fails

Check auto-renewal status:
sudo ipa-getcert list | grep -A 20 "Request ID"

Auto-renewal enabled: track: yes, auto-renew: yes
```

**Manual Renewal:**

```bash
# Force immediate renewal
sudo ipa-getcert resubmit -i <Request ID>

# Or by certificate path
sudo ipa-getcert resubmit -f /etc/pki/tls/certs/server.crt

# Verify renewal
sudo ipa-getcert list -f /etc/pki/tls/certs/server.crt

# Reload service after renewal
sudo systemctl reload httpd  # or appropriate service
```

**Post-Renewal Service Reload:**

```bash
# Configure automatic service reload after renewal
sudo ipa-getcert request \
  -f /etc/pki/tls/certs/server.crt \
  -k /etc/pki/tls/private/server.key \
  -N CN=newserver.cyberinabox.net \
  -D newserver.cyberinabox.net \
  -K host/newserver.cyberinabox.net@CYBERINABOX.NET \
  -U id-kp-serverAuth \
  -C "systemctl reload httpd"  # Post-save command

# Certmonger will run this command after successful renewal
```

### Certificate Revocation

**Revoke Compromised Certificate:**

```bash
# Web UI Method
1. Login to FreeIPA
2. Identity → Services
3. Select service with certificate
4. Actions → Certificate → "Revoke"
5. Reason: Key Compromise (or appropriate reason)
6. Confirm revocation

# CLI Method
# Get certificate serial number
sudo ipa-getcert list -f /etc/pki/tls/certs/server.crt | grep serial

# Revoke certificate
ipa cert-revoke <serial_number> --revocation-reason=4

# Revocation reasons:
# 0: unspecified
# 1: keyCompromise
# 2: cACompromise
# 3: affiliationChanged
# 4: superseded
# 5: cessationOfOperation
# 6: certificateHold

# Remove from certmonger tracking
sudo ipa-getcert stop-tracking -f /etc/pki/tls/certs/server.crt

# Delete certificate files
sudo rm /etc/pki/tls/certs/server.crt
sudo rm /etc/pki/tls/private/server.key

# Request new certificate
sudo ipa-getcert request [...]
```

## 30.3 Certificate Distribution

### CA Certificate Distribution

**Export Root CA Certificate:**

```bash
# From dc1.cyberinabox.net
ssh admin@dc1.cyberinabox.net

# Export CA certificate
sudo ipa-getcert list-cas
sudo ipa-cacert-manage list

# Get CA certificate in PEM format
openssl s_client -connect dc1.cyberinabox.net:443 -showcerts < /dev/null 2>/dev/null | \
  openssl x509 -outform PEM > /tmp/cyberhygiene-ca.crt

# Or directly from IPA
ipa ca-show ipa --chain | grep -A 50 "Certificate:" > /tmp/cyberhygiene-ca.crt
```

**Install CA on Client Systems:**

**Linux (Rocky/RHEL):**
```bash
# Copy CA certificate
sudo cp cyberhygiene-ca.crt /etc/pki/ca-trust/source/anchors/

# Update CA trust
sudo update-ca-trust

# Verify
openssl s_client -connect dc1.cyberinabox.net:443 -CApath /etc/pki/ca-trust/extracted/

# Should show: Verify return code: 0 (ok)
```

**Windows:**
```
1. Download cyberhygiene-ca.crt
2. Right-click → Install Certificate
3. Store Location: Local Machine
4. Certificate Store: Trusted Root Certification Authorities
5. Next → Finish

Or via Group Policy (if AD integrated):
  Computer Configuration → Windows Settings → Security Settings
  → Public Key Policies → Trusted Root Certification Authorities
```

**macOS:**
```
1. Download cyberhygiene-ca.crt
2. Open with Keychain Access
3. Select: System keychain
4. Double-click certificate
5. Trust section: Always Trust

Or command line:
sudo security add-trusted-cert -d -r trustRoot \
  -k /Library/Keychains/System.keychain cyberhygiene-ca.crt
```

**Firefox (All Platforms):**
```
1. Preferences → Privacy & Security
2. Security → Certificates → View Certificates
3. Authorities tab
4. Import cyberhygiene-ca.crt
5. Trust for: Websites, Email
6. OK
```

### Service Certificate Deployment

**Apache/HTTPD:**

```bash
# Certificate and key already in place via ipa-getcert

# Configure Apache
sudo vi /etc/httpd/conf.d/ssl.conf

# Update:
SSLEngine on
SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite HIGH:!aNULL:!MD5
SSLHonorCipherOrder on

SSLCertificateFile /etc/pki/tls/certs/server.crt
SSLCertificateKeyFile /etc/pki/tls/private/server.key
SSLCertificateChainFile /etc/ipa/ca.crt

# Test configuration
sudo httpd -t

# Reload Apache
sudo systemctl reload httpd

# Verify certificate
echo | openssl s_client -connect localhost:443 -servername $(hostname -f) 2>/dev/null | \
  openssl x509 -noout -dates -subject
```

**Nginx:**

```bash
# Configure Nginx
sudo vi /etc/nginx/nginx.conf

# Add to server block:
server {
    listen 443 ssl http2;
    server_name grafana.cyberinabox.net;

    ssl_certificate /etc/pki/tls/certs/server.crt;
    ssl_certificate_key /etc/pki/tls/private/server.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:...';
    ssl_prefer_server_ciphers on;

    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

**PostgreSQL:**

```bash
# On wazuh.cyberinabox.net
sudo vi /var/lib/pgsql/data/postgresql.conf

# Enable SSL
ssl = on
ssl_cert_file = '/etc/pki/tls/certs/postgresql.crt'
ssl_key_file = '/etc/pki/tls/private/postgresql.key'
ssl_ca_file = '/etc/ipa/ca.crt'
ssl_ciphers = 'HIGH:MEDIUM:+3DES:!aNULL'
ssl_prefer_server_ciphers = on

# Copy certificates
sudo cp /etc/pki/tls/certs/server.crt /var/lib/pgsql/data/server.crt
sudo cp /etc/pki/tls/private/server.key /var/lib/pgsql/data/server.key
sudo chown postgres:postgres /var/lib/pgsql/data/server.*

# Restart PostgreSQL
sudo systemctl restart postgresql

# Verify SSL
psql "sslmode=require host=localhost user=postgres"
```

## 30.4 Certificate Monitoring

### Monitoring Certificate Expiration

**Automated Monitoring Script:**

**Location:** `/usr/local/bin/check-certificates.sh`

```bash
#!/bin/bash
#
# Check certificate expiration dates
# Alert if expiring within 30 days
#

WARN_DAYS=30
EMAIL_ALERT="admin@cyberinabox.net"
LOG_FILE="/var/log/certificate-check.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

log "========== Checking certificate expiration =========="

EXPIRING_CERTS=()

# Check all tracked certificates
while IFS= read -r cert; do
    CERT_FILE=$(echo "${cert}" | grep "location=" | sed "s/.*location='\([^']*\)'.*/\1/")

    if [ -f "${CERT_FILE}" ]; then
        # Get expiration date
        EXPIRY=$(openssl x509 -in "${CERT_FILE}" -noout -enddate | cut -d= -f2)
        EXPIRY_EPOCH=$(date -d "${EXPIRY}" +%s)
        NOW_EPOCH=$(date +%s)
        DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

        SUBJECT=$(openssl x509 -in "${CERT_FILE}" -noout -subject | sed 's/subject=//')

        log "Certificate: ${SUBJECT}"
        log "  File: ${CERT_FILE}"
        log "  Expires: ${EXPIRY}"
        log "  Days remaining: ${DAYS_LEFT}"

        if [ ${DAYS_LEFT} -lt ${WARN_DAYS} ]; then
            log "  WARNING: Expires in ${DAYS_LEFT} days!"
            EXPIRING_CERTS+=("${SUBJECT}|${CERT_FILE}|${DAYS_LEFT}")
        fi
    fi
done < <(ipa-getcert list)

# Send alert if certificates expiring soon
if [ ${#EXPIRING_CERTS[@]} -gt 0 ]; then
    {
        echo "The following certificates are expiring within ${WARN_DAYS} days:"
        echo ""
        for cert in "${EXPIRING_CERTS[@]}"; do
            IFS='|' read -r subject file days <<< "${cert}"
            echo "Subject: ${subject}"
            echo "File: ${file}"
            echo "Days remaining: ${days}"
            echo "---"
        done
        echo ""
        echo "Please verify automatic renewal is working or renew manually."
    } | mail -s "[CERTIFICATE ALERT] Certificates Expiring Soon" "${EMAIL_ALERT}"

    log "Alert sent: ${#EXPIRING_CERTS[@]} certificates expiring soon"
else
    log "All certificates OK (no expiration within ${WARN_DAYS} days)"
fi

log "========== Certificate check complete =========="
exit 0
```

**Schedule Daily Check:**

```bash
# Add to cron
sudo crontab -e

# Add line:
0 8 * * * /usr/local/bin/check-certificates.sh
```

### Certificate Inventory

**Generate Certificate Report:**

```bash
#!/bin/bash
#
# Generate certificate inventory report
#

REPORT_FILE="/tmp/certificate-inventory-$(date +%Y%m%d).txt"

{
    echo "=========================================="
    echo "Certificate Inventory Report"
    echo "Generated: $(date)"
    echo "=========================================="
    echo ""

    # FreeIPA tracked certificates
    echo "=== FreeIPA Tracked Certificates ==="
    ipa-getcert list | grep -E "(Request ID|status|subject|expires|auto-renew)" | \
        sed 's/^[[:space:]]*//'

    echo ""
    echo "=== Certificate Authority ==="
    ipa ca-show ipa

    echo ""
    echo "=== Service Certificates ==="
    ipa service-find --all | grep -E "(Service|Certificate)"

} > "${REPORT_FILE}"

echo "Certificate inventory saved to: ${REPORT_FILE}"
cat "${REPORT_FILE}"
```

## 30.5 Troubleshooting Certificates

### Common Certificate Issues

**Issue: Certificate Renewal Failed**

```bash
# Check certmonger status
sudo systemctl status certmonger

# Check renewal logs
sudo journalctl -u certmonger -n 100

# Check specific certificate
sudo ipa-getcert list -f /etc/pki/tls/certs/server.crt

# Look for errors in status
# Common issues:
# - "CA_UNREACHABLE" - Cannot contact FreeIPA CA
# - "NEED_KEYINFO_READ_PIN" - Permission issue
# - "NEED_CA_CERT" - CA certificate missing

# Solutions:

# 1. CA unreachable
ping dc1.cyberinabox.net
kinit admin  # Get Kerberos ticket
ipa-getcert resubmit -i <request_id>

# 2. Permission issue
sudo chown root:root /etc/pki/tls/private/server.key
sudo chmod 600 /etc/pki/tls/private/server.key
ipa-getcert resubmit -i <request_id>

# 3. CA certificate issue
sudo cp /etc/ipa/ca.crt /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
ipa-getcert resubmit -i <request_id>
```

**Issue: Browser Certificate Warning**

```bash
# Verify certificate is valid
openssl s_client -connect dc1.cyberinabox.net:443 -servername dc1.cyberinabox.net

# Check:
# - Verify return code: Should be 0 (ok)
# - Subject matches hostname
# - Issuer is your CA
# - Dates are valid

# If certificate is valid but browser still warns:
# - Install CA certificate in browser (see Section 30.3)
# - Verify hostname matches (not using IP address)
# - Check for clock skew on client

# Check server certificate
echo | openssl s_client -connect dc1.cyberinabox.net:443 -servername dc1.cyberinabox.net 2>/dev/null | \
    openssl x509 -noout -text
```

**Issue: Certificate-Key Mismatch**

```bash
# Check if certificate and key match
CERT_MODULUS=$(openssl x509 -noout -modulus -in /etc/pki/tls/certs/server.crt | openssl md5)
KEY_MODULUS=$(openssl rsa -noout -modulus -in /etc/pki/tls/private/server.key | openssl md5)

if [ "${CERT_MODULUS}" = "${KEY_MODULUS}" ]; then
    echo "Certificate and key match"
else
    echo "ERROR: Certificate and key do not match"
    echo "Need to request new certificate for this key, or find matching certificate"
fi
```

**Issue: Service Not Using Certificate**

```bash
# Verify service configuration
# Apache:
sudo httpd -t -D DUMP_VHOSTS | grep 443
sudo grep -r "SSLCertificateFile" /etc/httpd/conf.d/

# Nginx:
sudo nginx -T | grep ssl_certificate

# Check service is listening on SSL port
sudo ss -tlnp | grep :443

# Test SSL connection
openssl s_client -connect localhost:443 -servername $(hostname -f)

# Common issues:
# - Wrong certificate path in config
# - Service not reloaded after certificate update
# - Firewall blocking port 443
# - SELinux preventing access to certificate

# Solutions:
sudo systemctl reload httpd  # or nginx
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --reload
sudo restorecon -Rv /etc/pki/tls/
```

---

**Certificate Management Quick Reference:**

**Request New Certificate:**
```bash
# Automated (recommended)
sudo ipa-getcert request \
  -f /etc/pki/tls/certs/server.crt \
  -k /etc/pki/tls/private/server.key \
  -N CN=$(hostname -f) \
  -D $(hostname -f) \
  -K host/$(hostname -f)@CYBERINABOX.NET \
  -U id-kp-serverAuth \
  -C "systemctl reload httpd"

# Check status
sudo ipa-getcert list
```

**Renew Certificate:**
```bash
# Force renewal
sudo ipa-getcert resubmit -f /etc/pki/tls/certs/server.crt

# Check auto-renewal
sudo ipa-getcert list | grep -A 5 auto-renew
```

**Revoke Certificate:**
```bash
# Get serial number
sudo ipa-getcert list -f /etc/pki/tls/certs/server.crt | grep serial

# Revoke
ipa cert-revoke <serial> --revocation-reason=4

# Stop tracking
sudo ipa-getcert stop-tracking -f /etc/pki/tls/certs/server.crt
```

**Check Certificate:**
```bash
# View certificate details
openssl x509 -in /etc/pki/tls/certs/server.crt -noout -text

# Check expiration
openssl x509 -in /etc/pki/tls/certs/server.crt -noout -dates

# Test SSL connection
openssl s_client -connect dc1.cyberinabox.net:443 -servername dc1.cyberinabox.net
```

**Export CA Certificate:**
```bash
# PEM format
openssl s_client -connect dc1.cyberinabox.net:443 -showcerts < /dev/null 2>/dev/null | \
  openssl x509 -outform PEM > cyberhygiene-ca.crt

# Install on client
sudo cp cyberhygiene-ca.crt /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
```

**Monitor Certificates:**
```bash
# Check expiration dates
/usr/local/bin/check-certificates.sh

# List all tracked certificates
sudo ipa-getcert list

# Generate inventory report
ipa service-find --all | grep Certificate
```

---

**Related Chapters:**
- Chapter 3: System Architecture
- Chapter 27: User Management (FreeIPA)
- Chapter 31: Security Updates & Patching
- Appendix C: Command Reference
- Appendix D: Troubleshooting Guide

**For Help:**
- FreeIPA CA Docs: https://www.freeipa.org/page/PKI
- Certmonger Docs: https://pagure.io/certmonger
- OpenSSL Commands: https://www.openssl.org/docs/
- Administrator: dshannon@cyberinabox.net
