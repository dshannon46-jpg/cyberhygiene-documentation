# CyberHygiene Project Website - Quick Start

**Status:** ✅ DEPLOYED AND TESTED
**Date:** November 13, 2025
**URL:** https://cyberinabox.net (internal access working)

---

## What's Been Done

✅ **Professional website created** showcasing the CyberHygiene Project
✅ **Privacy protected** - No personal information exposed beyond business details
✅ **Apache configured** with SSL/TLS and security headers
✅ **Tested internally** - Website working perfectly on dc1
✅ **Documentation complete** - Full deployment guide created

---

## Website Highlights

### Content Sections
1. **Hero** - Eye-catching stats (95% complete, 100% compliance, 110 controls)
2. **About** - Project background, challenge, and solution
3. **Architecture** - System design with 3 main components
4. **Compliance** - NIST 800-171, DFARS, FAR achievements
5. **Technology** - Complete tech stack breakdown
6. **Results** - Implementation metrics and lessons learned
7. **Contact** - The Contract Coach business information

### Key Features
- **Responsive design** - Works on desktop, tablet, mobile
- **Modern styling** - Professional government/compliance theme
- **Animated elements** - Numbers count up, cards fade in
- **Security hardened** - All security headers, HTTPS only
- **Fast loading** - Only 44KB total (optimized)

---

## What You Can Do Now

### Option 1: Keep It Internal Only
The website is accessible right now on your internal network at:
- https://dc1.cyberinabox.net
- https://192.168.1.10

**No action needed** - It's ready to show colleagues, take screenshots, etc.

### Option 2: Make It Public
To expose the website to the internet, you need to:

1. **Configure pfSense Port Forwarding:**
   - Forward WAN port 443 → 192.168.1.10:443 (HTTPS)
   - Forward WAN port 80 → 192.168.1.10:80 (HTTP redirect)

2. **Set up DNS A records** (at your DNS provider):
   - cyberinabox.net → YOUR_PUBLIC_IP
   - www.cyberinabox.net → YOUR_PUBLIC_IP

3. **Wait for DNS propagation** (up to 48 hours)

**Detailed instructions in:**
`/home/dshannon/Documents/Claude/CyberHygiene_Website_Deployment_Guide.md`

---

## Testing the Website

### Internal Access (Working Now)
```bash
# Test from dc1
curl -I https://localhost

# Test from any workstation on your network
https://cyberinabox.net
https://dc1.cyberinabox.net
```

### What Traffic Will Hit the Website

When you configure port forwarding, incoming requests to ports 80/443 on your public IP will be directed to **dc1 (192.168.1.10)**, which is now serving the CyberHygiene website.

**Traffic Flow:**
```
Internet → Your Public IP:443 → pfSense → dc1:443 → Apache → Website
```

**Other Services on dc1:**
- FreeIPA Web UI: https://dc1.cyberinabox.net/ipa/ui (subdomain, separate virtual host)
- Main domain (cyberinabox.net) → CyberHygiene public website

---

## Security Considerations

### What's Protected ✅
- Static website only (no databases, no user input)
- FIPS-compliant SSL/TLS
- Security headers prevent XSS, clickjacking
- SELinux enforcing mode
- No sensitive information exposed
- Apache hardened configuration

### What to Monitor ⚠️
- Watch Apache access logs: `/var/log/httpd/cyberhygiene-access.log`
- Enable Suricata IDS/IPS rules on pfSense
- Consider rate limiting for DoS protection
- Keep Apache and Rocky Linux updated

### Privacy Compliance ✅
**Information Displayed:**
- ✅ Business name: The Contract Coach (Donald E. Shannon LLC)
- ✅ Business email: Don@Contract-coach.com
- ✅ Business phone: 505.259.8485
- ✅ Website: contract-coach.com
- ✅ Certifications, CAGE code, DUNS number

**Information Protected:**
- ❌ No home address
- ❌ No system IP addresses (uses 192.168.x.x notation)
- ❌ No passwords, keys, certificates
- ❌ No detailed security configurations
- ❌ No personal identifiers beyond business owner

---

## Quick Commands

### Check Website Status
```bash
# Is Apache running?
sudo systemctl status httpd

# Test local access
curl -I https://localhost

# Check recent visitors
sudo tail -20 /var/log/httpd/cyberhygiene-access.log
```

### Update Website Content
```bash
# Edit main page
sudo vi /var/www/cyberhygiene/index.html

# Edit styles
sudo vi /var/www/cyberhygiene/styles.css

# No reload needed - changes are immediate!
```

### Backup Website
```bash
# Manual backup
sudo tar -czf ~/website-backup-$(date +%Y%m%d).tar.gz /var/www/cyberhygiene

# Restore
sudo tar -xzf ~/website-backup-20251113.tar.gz -C /
```

---

## File Locations

**Website Files:** `/var/www/cyberhygiene/`
- index.html (main page)
- styles.css (styling)
- script.js (interactivity)

**Apache Config:** `/etc/httpd/conf.d/cyberhygiene.conf`

**Logs:** `/var/log/httpd/cyberhygiene-*.log`

**Documentation:**
- Full Guide: `/home/dshannon/Documents/Claude/CyberHygiene_Website_Deployment_Guide.md`
- This Quick Start: `/home/dshannon/Documents/Claude/Website_Quick_Start.md`

---

## Next Steps (Your Choice)

### If You Want to Go Public:
1. Read the full deployment guide
2. Configure pfSense port forwarding
3. Set up DNS records
4. Test from external network
5. Monitor traffic

### If You Want to Keep it Internal:
1. Nothing more to do!
2. Use it to brief colleagues
3. Take screenshots for presentations
4. Update content as needed

### If You Want to Enhance:
1. Add network diagram image (pending)
2. Add more detailed case studies
3. Include compliance scan reports
4. Add testimonials or references

---

## Support

**Questions?** Check the full deployment guide:
`/home/dshannon/Documents/Claude/CyberHygiene_Website_Deployment_Guide.md`

**Issues?** Look at:
- Apache error log: `/var/log/httpd/cyberhygiene-error.log`
- Apache access log: `/var/log/httpd/cyberhygiene-access.log`
- System architecture: `/home/dshannon/Documents/Claude/CLAUDE.md`

---

## Success! 🎉

You now have a professional, secure, public-facing website ready to showcase your CyberHygiene Project achievements. The site demonstrates that NIST 800-171 compliance is achievable for small businesses at a fraction of traditional costs.

**Website is production-ready** whenever you decide to make it public!

---

**Created:** November 13, 2025
**Status:** Deployment Complete
