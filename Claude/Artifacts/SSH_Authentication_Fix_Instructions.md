# SSH Authentication Fix: Lab Rat → DC1
**Date:** December 7, 2025
**Issue:** Lab Rat cannot SSH to DC1
**Status:** Ready to fix (post-certificate stabilization)

## Root Cause

The SSH authentication failure from Lab Rat to DC1 was caused by:

1. **Certificate Changes:** When httpd.crt was changed between IPA CA and commercial SSL.com certificates, it invalidated Kerberos tickets
2. **Invalid Kerberos Tickets:** FreeIPA uses GSSAPI (Kerberos) for SSH authentication
3. **Failed GSSAPI:** SSH falls back to trying multiple SSH keys
4. **Too Many Attempts:** Multiple key attempts trigger "too many authentication failures"

## Current Status

✅ **Certificates now stabilized:**
- FreeIPA (dc1.cyberinabox.net): IPA CA certificate (stable, won't change)
- Public sites: Commercial SSL.com certificate (separate)

✅ **Ready to fix SSH**

## Solution

Run the fix script on **Lab Rat** to:
1. Clear old Kerberos tickets
2. Obtain fresh Kerberos ticket
3. Clear old SSH known_hosts entries
4. Add current DC1 host key
5. Test SSH connection

## Instructions for Lab Rat

### Option 1: Automated Fix Script

```bash
# Copy the fix script to Lab Rat (if not already there)
# Then run on Lab Rat:
bash /tmp/fix-ssh-labrat-to-dc1.sh
```

### Option 2: Manual Fix Steps

Run these commands on **Lab Rat**:

```bash
# 1. Clear old Kerberos tickets
kdestroy

# 2. Get fresh ticket
kinit donald.shannon@CYBERINABOX.NET
# Enter password: CyberHygiene2025!

# 3. Verify ticket
klist

# 4. Clear old SSH host keys
ssh-keygen -R dc1.cyberinabox.net
ssh-keygen -R 192.168.1.10

# 5. Add current host key
ssh-keyscan -H dc1.cyberinabox.net >> ~/.ssh/known_hosts

# 6. Test SSH connection
ssh dc1.cyberinabox.net "hostname"
# Should output: dc1
```

## Verification

After running the fix, verify SSH works:

```bash
# On Lab Rat, test SSH to DC1
ssh dc1.cyberinabox.net "hostname && date"

# Expected output:
# dc1
# Sat Dec  7 12:30:00 MST 2025
```

## Why This Works Now

Before the certificate split:
- ❌ Certificates kept changing between IPA CA and commercial
- ❌ Each change invalidated Kerberos tickets
- ❌ SSH authentication kept breaking

After the certificate split:
- ✅ IPA CA certificate stable (won't change again)
- ✅ Kerberos tickets remain valid
- ✅ SSH authentication will stay working

## OpenSCAP Report Collection

Once SSH is fixed, the automated report collection will work:

**On DC1 (Sundays 06:30 MST):**
```bash
/usr/local/bin/collect-openscap-reports.sh
```

This script will:
1. SSH from DC1 → Lab Rat (this direction already works)
2. Use rsync to pull reports from Lab Rat:/var/log/openscap/reports/
3. Store in DC1:/var/log/openscap/collected-reports/labrat/

**No SSH from Lab Rat → DC1 required for report collection!**

## Alternative: SSH Key Authentication (Backup Method)

If Kerberos authentication continues to have issues, set up SSH keys:

### On Lab Rat:
```bash
# Generate SSH key if needed
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "donald.shannon@labrat"

# Copy public key
cat ~/.ssh/id_ed25519.pub
```

### On DC1:
```bash
# Add Lab Rat's public key to authorized_keys
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat >> ~/.ssh/authorized_keys << 'EOF'
[paste Lab Rat's public key here]
EOF
chmod 600 ~/.ssh/authorized_keys
```

### Test from Lab Rat:
```bash
ssh -i ~/.ssh/id_ed25519 dc1.cyberinabox.net "hostname"
```

## Important Notes

1. **Report Collection Works Without This Fix**
   - DC1 → Lab Rat SSH already works
   - Collection script runs on DC1 and pulls from Lab Rat
   - This fix is for user convenience, not required for automation

2. **Certificate Stability**
   - `/var/lib/ipa/certs/httpd.crt` must NEVER be changed again
   - It must always remain IPA CA-signed
   - Public sites now use `/etc/pki/tls/certs/commercial/wildcard.crt`

3. **Kerberos Ticket Renewal**
   - Kerberos tickets expire after 24 hours by default
   - Run `kinit` again if SSH stops working after a day
   - Consider adding automatic ticket renewal if needed

## Troubleshooting

### SSH Still Fails After Running Fix

```bash
# Check Kerberos ticket status
klist
# Should show valid ticket for donald.shannon@CYBERINABOX.NET

# Check SSH with verbose output
ssh -vvv dc1.cyberinabox.net

# Look for GSSAPI authentication attempt
# Should see: "Offering GSSAPI proposal"

# Check FreeIPA user status
ipa user-show donald.shannon
```

### GSSAPI Authentication Not Working

```bash
# Verify SSH GSSAPI is enabled
grep -i gssapi /etc/ssh/ssh_config

# Should have:
#   GSSAPIAuthentication yes
#   GSSAPIDelegateCredentials yes
```

### Kerberos Ticket Issues

```bash
# Check Kerberos configuration
cat /etc/krb5.conf

# Verify realm
# Should show: CYBERINABOX.NET

# Check KDC connectivity
ping dc1.cyberinabox.net
nslookup dc1.cyberinabox.net
```

---

**Document Status:** READY FOR IMPLEMENTATION
**Next Step:** Run fix script on Lab Rat
**Expected Time:** 2-3 minutes
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
