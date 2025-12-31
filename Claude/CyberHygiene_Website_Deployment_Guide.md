# CyberHygiene Project Public Website - Deployment Guide

**Date:** November 13, 2025
**System:** dc1.cyberinabox.net (192.168.1.10)
**Domain:** cyberinabox.net
**Classification:** PUBLIC INFORMATION

---

## Overview

The CyberHygiene Project public website has been deployed on dc1.cyberinabox.net to showcase the project's achievements in building affordable NIST 800-171 compliant infrastructure for small defense contractors.

**Key Features:**
- Professional single-page design
- Privacy-protected (no personal information exposed)
- Business information from The Contract Coach capability statement
- Technical achievements and compliance metrics
- Responsive design for mobile/desktop

---

## Website Components

### Files Deployed

**Location:** `/var/www/cyberhygiene/`

1. **index.html** (25KB) - Main HTML structure
2. **styles.css** (14KB) - Professional CSS styling
3. **script.js** (6KB) - Interactive JavaScript features

**Ownership:** `apache:apache`
**Permissions:** `755` (directories), `644` (files)

### Apache Configuration

**Configuration File:** `/etc/httpd/conf.d/cyberhygiene.conf`

**Virtual Hosts:**
- **HTTPS (Port 443):** Serves cyberinabox.net and www.cyberinabox.net
- **HTTP (Port 80):** Redirects all traffic to HTTPS

**SSL Configuration:**
- Uses existing wildcard certificate: `*.cyberinabox.net`
- Certificate: `/var/lib/ipa/certs/httpd.crt`
- Private Key: `/var/lib/ipa/private/httpd.key`
- Protocols: TLS 1.2, TLS 1.3 only (FIPS compliant)
- HSTS enabled (31536000 seconds / 1 year)

**Security Headers:**
- `Strict-Transport-Security`
- `X-Frame-Options: SAMEORIGIN`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`

---

## Testing Performed

### Internal Testing (Completed)

```bash
# Test HTTPS connectivity
curl -k -I https://localhost/

# Result: 200 OK with proper security headers
```

**Verified:**
- ✅ Apache syntax OK
- ✅ HTTPS serving correctly on port 443
- ✅ Security headers applied
- ✅ SSL certificate valid
- ✅ Content loading properly
- ✅ All CSS and JS files accessible

### Logs Created

- `/var/log/httpd/cyberhygiene-access.log` - Access log
- `/var/log/httpd/cyberhygiene-error.log` - Error log
- `/var/log/httpd/cyberhygiene-ssl.log` - SSL protocol/cipher log
- `/var/log/httpd/cyberhygiene-redirect-access.log` - HTTP redirect log
- `/var/log/httpd/cyberhygiene-redirect-error.log` - HTTP redirect errors

---

## pfSense Port Forwarding Configuration

To make the website publicly accessible, configure port forwarding on your pfSense firewall.

### Prerequisites

1. **Public IP Address:** Your ISP-assigned public IP
2. **DNS Configuration:** A records pointing to your public IP:
   - `cyberinabox.net` → YOUR_PUBLIC_IP
   - `www.cyberinabox.net` → YOUR_PUBLIC_IP
3. **pfSense Admin Access:** Access to pfSense web interface

### Port Forwarding Rules

#### Rule 1: HTTPS (Port 443)

**Navigate to:** Firewall → NAT → Port Forward

**Add New Rule:**
```
Interface:               WAN
Protocol:                TCP
Source:                  Any
Source Port Range:       Any
Destination:             WAN Address
Destination Port Range:  HTTPS (443)
Redirect Target IP:      192.168.1.10 (dc1)
Redirect Target Port:    HTTPS (443)
Description:             CyberHygiene Website - HTTPS
NAT Reflection:          Use system default
Filter rule association: Add associated filter rule
```

**Click:** Save, Apply Changes

#### Rule 2: HTTP (Port 80) - Optional but Recommended

**Purpose:** Allow HTTP connections that will be redirected to HTTPS

```
Interface:               WAN
Protocol:                TCP
Source:                  Any
Source Port Range:       Any
Destination:             WAN Address
Destination Port Range:  HTTP (80)
Redirect Target IP:      192.168.1.10 (dc1)
Redirect Target Port:    HTTP (80)
Description:             CyberHygiene Website - HTTP Redirect
NAT Reflection:          Use system default
Filter rule association: Add associated filter rule
```

**Click:** Save, Apply Changes

### Firewall Rules

The port forward rules should automatically create associated firewall rules on the WAN interface. Verify:

**Navigate to:** Firewall → Rules → WAN

**Expected Rules:**
- **NAT HTTP:** Allow TCP from Any to 192.168.1.10 port 80
- **NAT HTTPS:** Allow TCP from Any to 192.168.1.10 port 443

### Security Considerations

**Recommendations:**
1. **Keep port 443 open** - Required for website access
2. **Keep port 80 open** - Allows automatic HTTPS redirect
3. **Monitor logs** - Watch `/var/log/httpd/cyberhygiene-*.log` for suspicious activity
4. **Update regularly** - Keep Apache and Rocky Linux updated
5. **Use Suricata** - Enable IDS/IPS rules on pfSense for HTTP/HTTPS traffic
6. **Rate Limiting** - Consider adding pfSense limiters for DoS protection

**Already Protected By:**
- ✅ Static read-only website (no databases, no forms)
- ✅ SELinux enforcing mode
- ✅ FIPS-compliant SSL/TLS
- ✅ Security headers prevent XSS, clickjacking, etc.
- ✅ No user input accepted
- ✅ No server-side scripts (pure HTML/CSS/JS)

---

## DNS Configuration

### Required DNS Records

Update your DNS provider (or pfSense DNS forwarder) with:

```
# A Records
cyberinabox.net.        A       YOUR_PUBLIC_IP
www.cyberinabox.net.    A       YOUR_PUBLIC_IP

# Optional but recommended
# CAA Record (restrict SSL certificate issuance)
cyberinabox.net.        CAA     0 issue "ssl.com"
```

### DNS Verification

After DNS propagation (up to 48 hours), verify:

```bash
# Check A record resolution
dig cyberinabox.net +short
nslookup cyberinabox.net

# Check web access
curl -I https://cyberinabox.net
```

---

## Testing External Access

### Before Going Live

1. **Test from internal network first:**
   ```bash
   curl -k https://192.168.1.10/
   ```

2. **Test via domain (internal):**
   ```bash
   curl -I https://cyberinabox.net
   ```

3. **Check SSL certificate:**
   ```bash
   openssl s_client -connect cyberinabox.net:443 -servername cyberinabox.net
   ```

### After Port Forwarding

1. **Test from external network** (use phone on cellular, VPN, or ask colleague):
   ```
   https://cyberinabox.net
   https://www.cyberinabox.net
   http://cyberinabox.net (should redirect to HTTPS)
   ```

2. **Online testing tools:**
   - SSL Labs: https://www.ssllabs.com/ssltest/analyze.html?d=cyberinabox.net
   - Security Headers: https://securityheaders.com/?q=cyberinabox.net
   - DNS Propagation: https://www.whatsmydns.net/#A/cyberinabox.net

---

## Monitoring and Maintenance

### Daily Checks

```bash
# Check Apache status
sudo systemctl status httpd

# Check recent access (last 20 entries)
sudo tail -20 /var/log/httpd/cyberhygiene-access.log

# Check for errors
sudo tail -20 /var/log/httpd/cyberhygiene-error.log
```

### Weekly Checks

```bash
# Check disk space
df -h /var/www

# Review SSL cipher usage
sudo tail -50 /var/log/httpd/cyberhygiene-ssl.log | awk '{print $4}' | sort | uniq -c

# Check for suspicious access patterns
sudo grep -v "200\|301\|304" /var/log/httpd/cyberhygiene-access.log
```

### Monthly Tasks

- Review access logs for unusual patterns
- Verify SSL certificate expiration date
- Test website functionality from external network
- Check for Apache security updates
- Rotate log files if needed

### Log Rotation

Logs are automatically rotated by logrotate. Configuration:

```bash
# View logrotate config
cat /etc/logrotate.d/httpd
```

---

## Content Updates

### Updating the Website

To update website content:

1. **Edit files directly:**
   ```bash
   sudo vi /var/www/cyberhygiene/index.html
   ```

2. **Test changes:**
   ```bash
   sudo httpd -t
   ```

3. **No reload needed** - Static files are served immediately

4. **Clear browser cache** if changes don't appear

### Best Practices

- Always backup before changes: `sudo cp /var/www/cyberhygiene/index.html /var/www/cyberhygiene/index.html.bak`
- Test in browser with Ctrl+F5 (hard refresh)
- Maintain version history in git (optional)
- Document significant changes

---

## Troubleshooting

### Website Not Accessible Externally

**Check:**
1. pfSense port forward rules are active
2. pfSense firewall rules allow WAN → 192.168.1.10:443
3. DNS A records are correct and propagated
4. Apache is running: `sudo systemctl status httpd`
5. Firewalld allows HTTPS: `sudo firewall-cmd --list-all`

### SSL Certificate Errors

**Check:**
1. Certificate is valid: `sudo openssl x509 -in /var/lib/ipa/certs/httpd.crt -noout -dates`
2. Certificate matches domain: `sudo openssl x509 -in /var/lib/ipa/certs/httpd.crt -noout -text | grep DNS`
3. Private key matches certificate: Compare modulus values

### 403 Forbidden Errors

**Check:**
1. File permissions: `ls -la /var/www/cyberhygiene/`
2. SELinux contexts: `ls -Z /var/www/cyberhygiene/`
3. Apache error log: `sudo tail -50 /var/log/httpd/cyberhygiene-error.log`

### Fix SELinux Contexts

```bash
sudo restorecon -Rv /var/www/cyberhygiene/
sudo chown -R apache:apache /var/www/cyberhygiene/
sudo chmod -R 755 /var/www/cyberhygiene/
```

---

## Security Incident Response

### If Website is Compromised

1. **Immediately disable port forwarding** on pfSense
2. **Stop Apache:** `sudo systemctl stop httpd`
3. **Preserve evidence:** Copy logs before investigation
4. **Investigate:** Check logs, file integrity, system state
5. **Restore from backup** if files were modified
6. **Update and patch** before re-enabling
7. **Review Wazuh alerts** for compromise indicators
8. **Document incident** per Incident Response Plan

### Early Warning Signs

- Unexpected high traffic
- Unusual access patterns in logs
- File modification alerts from Wazuh FIM
- SELinux denials
- Apache error log entries

---

## Backup Procedures

### Website Files Backup

Website files are included in daily automated backups:

```bash
# Included in: /usr/local/bin/backup-critical-files.sh
# Backup location: /backup/daily/
# Retention: 30 days
```

### Manual Backup

```bash
# Create manual backup
sudo tar -czf /backup/website-backup-$(date +%Y%m%d).tar.gz /var/www/cyberhygiene/

# Restore from backup
sudo tar -xzf /backup/website-backup-20251113.tar.gz -C /
```

---

## Performance Optimization

### Current Configuration

- ✅ Compression enabled (mod_deflate)
- ✅ Cache headers set (static: 30 days, HTML: 1 hour)
- ✅ Keep-Alive enabled
- ✅ Minimal file sizes (44KB total)

### Future Enhancements (Optional)

- Add CDN (Cloudflare) for global distribution
- Implement Brotli compression
- Add HTTP/2 support (already enabled in Apache 2.4)
- Optimize images (convert to WebP format)

---

## Contact Information

**Website Administrator:** Donald E. Shannon
**Business Email:** Don@Contract-coach.com
**System Owner:** The Contract Coach (Donald E. Shannon LLC)

**For Technical Issues:**
- Check logs first
- Review this documentation
- Consult CLAUDE.md for system architecture

---

## Document Control

**Document Version:** 1.0
**Created:** November 13, 2025
**Last Updated:** November 13, 2025
**Next Review:** December 13, 2025
**Classification:** Internal Use / Public Reference
**Author:** System Administrator

---

**END OF DEPLOYMENT GUIDE**
