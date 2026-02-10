# YARA False Positives - Fixed

## Summary

Fixed YARA false positives on legitimate system binaries (`/usr/bin/node` and `/usr/sbin/dkms`) by:
1. Creating hash-based whitelist for known-good binaries
2. Making malware detection rules more specific
3. Increasing indicator thresholds to reduce false positives

**Date:** December 30, 2025
**Status:** ✅ Complete - False positives eliminated

---

## Problem

YARA was triggering false positives on legitimate system binaries:

### `/usr/bin/node` (Node.js)
**False Alerts:**
- Ransomware_Generic (8 matches)
- Backdoor_Generic (8 matches)
- Trojan_Generic (8 matches)
- Linux_Exploit_Generic (8 matches)
- Linux_Backdoor_Bind_Shell (8 matches)
- Windows_Ransomware_Patterns (8 matches)
- Windows_Credential_Stealer (8 matches)
- Windows_Backdoor_Remote_Desktop (8 matches)

### `/usr/sbin/dkms` (Dynamic Kernel Module Support)
**False Alerts:**
- Backdoor_Generic (1 match)

### Root Cause

The original YARA rules were **too generic** and triggered on common strings:
- `"/bin/bash"` and `"/bin/sh"` - Present in any binary that can execute shell commands
- `"POST"` - HTTP method in Node.js networking
- `"AES"` and `"RSA"` - Crypto algorithms used in Node.js
- `"Remote Desktop"`, `"terminal"` - Terms in Node.js documentation/strings

---

## Solution Implemented

### 1. Created Hash-Based Whitelist

**File:** `/var/ossec/ruleset/yara/rules/00_whitelist.yar`

```yara
import "hash"

rule Whitelist_NodeJS
{
    meta:
        description = "Whitelist for Node.js binary"
        author = "CyberInABox Security"
        severity = "whitelist"

    condition:
        hash.sha256(0, filesize) == "eaeb6e005bb3c20643893ca60d88fb63533ac439c1d19097a124a5a600c9b6e1"
}

rule Whitelist_DKMS
{
    meta:
        description = "Whitelist for DKMS binary"
        author = "CyberInABox Security"
        severity = "whitelist"

    condition:
        hash.sha256(0, filesize) == "89dc2803c949ebcfc5e4ae20206a20a4aa266ddfb690ca71be266f9579baf40f"
}
```

**Whitelisted Binaries:**
- Node.js: `eaeb6e005bb3c20643893ca60d88fb63533ac439c1d19097a124a5a600c9b6e1`
- DKMS: `89dc2803c949ebcfc5e4ae20206a20a4aa266ddfb690ca71be266f9579baf40f`

### 2. Updated Malware Rules

**Files Modified:**
- `/var/ossec/ruleset/yara/rules/malware_common.yar`
- `/var/ossec/ruleset/yara/rules/linux_malware.yar`
- `/var/ossec/ruleset/yara/rules/windows_malware.yar`

**Changes Made:**

#### Before (Overly Broad):
```yara
rule Backdoor_Generic
{
    strings:
        $net4 = "/bin/sh" nocase
        $net5 = "/bin/bash" nocase

    condition:
        2 of them  // Too easy to trigger
}
```

#### After (More Specific):
```yara
rule Backdoor_Generic
{
    strings:
        $net1 = "reverse_tcp" nocase
        $net2 = "bind_tcp" nocase
        $net3 = "reverse shell" nocase
        $backdoor1 = "backdoor" nocase
        $backdoor2 = "c2 server" nocase
        $tool1 = "meterpreter" nocase

    condition:
        not (
            hash.sha256(0, filesize) == "eaeb6e005bb3c20643893ca60d88fb63533ac439c1d19097a124a5a600c9b6e1" or
            hash.sha256(0, filesize) == "89dc2803c949ebcfc5e4ae20206a20a4aa266ddfb690ca71be266f9579baf40f"
        ) and
        (
            3 of ($backdoor*) or
            (1 of ($net*) and 2 of ($backdoor*)) or
            1 of ($tool*)
        )
}
```

**Key Improvements:**
1. ✅ Added whitelist hash exclusions
2. ✅ Increased indicator count requirements (2→3 matches needed)
3. ✅ Made strings more specific ("reverse shell" instead of just "/bin/sh")
4. ✅ Added explicit malware tool names (meterpreter, etc.)

---

## Testing Results

### Before Fix:
```bash
yara rules/*.yar /usr/bin/node
# Result: 8 malware rules triggered (FALSE POSITIVES)

yara rules/*.yar /usr/sbin/dkms
# Result: 1 malware rule triggered (FALSE POSITIVE)
```

### After Fix:
```bash
yara rules/*.yar /usr/bin/node
# Result: Whitelist_NodeJS only ✅

yara rules/*.yar /usr/sbin/dkms
# Result: Whitelist_DKMS only ✅
```

### Malware Detection Still Works:
```bash
# Test with actual malware patterns
echo "reverse shell" > test.sh
echo "bind_tcp backdoor" >> test.sh
echo "meterpreter payload" >> test.sh

yara rules/malware_common.yar test.sh
# Result: Backdoor_Generic ✅ (Correctly detected)
```

---

## Backup Files Created

Before modifying rules, backups were created:

```bash
/var/ossec/ruleset/yara/rules/malware_common.yar.backup-20251230
/var/ossec/ruleset/yara/rules/linux_malware.yar.backup-20251230
/var/ossec/ruleset/yara/rules/windows_malware.yar.backup-20251230
```

**To restore original rules:**
```bash
sudo cp /var/ossec/ruleset/yara/rules/malware_common.yar.backup-20251230 /var/ossec/ruleset/yara/rules/malware_common.yar
sudo cp /var/ossec/ruleset/yara/rules/linux_malware.yar.backup-20251230 /var/ossec/ruleset/yara/rules/linux_malware.yar
sudo cp /var/ossec/ruleset/yara/rules/windows_malware.yar.backup-20251230 /var/ossec/ruleset/yara/rules/windows_malware.yar
```

---

## Rule Changes Summary

### Common Malware Rules (`malware_common.yar`)

| Rule Name | Before | After |
|-----------|---------|-------|
| Ransomware_Generic | Triggered on "AES", "RSA" | Requires 3+ ransom indicators or 2 ransom + crypto with context |
| Backdoor_Generic | Triggered on "/bin/bash" | Requires explicit backdoor language + network indicators |
| Trojan_Generic | Triggered on "POST" | Requires 2+ explicit trojan indicators |
| Webshell_Generic | Moderate specificity | Tightened to require eval + decode + exec + input method |
| Cryptocurrency_Miner | 2 indicators | Now requires 3 indicators |

### Linux Malware Rules (`linux_malware.yar`)

| Rule Name | Before | After |
|-----------|---------|-------|
| Linux_Backdoor_Bind_Shell | Triggered on bind()+listen()+"/bin/bash" | Requires all bind functions + shell + dup2() + execve |
| Linux_Reverse_Shell | Triggered on socket()+connect()+shell | Requires socket+connect+dup2+shell+exec OR explicit "reverse shell" |
| Linux_Exploit_Generic | Triggered on "exploit"+"/bin/sh" | Requires 3+ exploit indicators |
| Linux_Rootkit_Generic | 2 indicators | Now requires 3 indicators |

### Windows Malware Rules (`windows_malware.yar`)

| Rule Name | Before | After |
|-----------|---------|-------|
| Windows_Ransomware_Patterns | 2 indicators | Now requires 3 ransom indicators or specific combinations |
| Windows_Credential_Stealer | Triggered on "lsass", "SAM" alone | Requires 2+ specific credential theft indicators |
| Windows_Backdoor_Remote_Desktop | Triggered on "Remote Desktop" string | Requires 2+ RDP backdoor specific indicators |

---

## Adding More Binaries to Whitelist

If you encounter false positives on other legitimate binaries:

### 1. Get the file hash:
```bash
sha256sum /path/to/binary
```

### 2. Add to whitelist:
Edit `/var/ossec/ruleset/yara/rules/00_whitelist.yar`:

```yara
rule Whitelist_BinaryName
{
    meta:
        description = "Whitelist for BinaryName"
        author = "CyberInABox Security"
        severity = "whitelist"

    condition:
        hash.sha256(0, filesize) == "YOUR_HASH_HERE"
}
```

### 3. Update malware rules:
Add the hash to the exclusion condition in each malware rule:

```yara
condition:
    not (
        hash.sha256(0, filesize) == "node_hash" or
        hash.sha256(0, filesize) == "dkms_hash" or
        hash.sha256(0, filesize) == "YOUR_HASH_HERE"  // ← Add here
    ) and
    ... rest of condition ...
```

### 4. Test:
```bash
yara -r /var/ossec/ruleset/yara/rules/*.yar /path/to/binary
```

---

## Integration with Wazuh

YARA scans are automatically triggered by Wazuh File Integrity Monitoring (FIM):

**Trigger Rules:**
- Rule 550: Integrity checksum changed
- Rule 554: File added to the system

**Workflow:**
```
File Changed → Wazuh FIM → Active Response → YARA Scan →
    ↓ (if whitelisted)
    Log: "Whitelist detected" (no alert)
    ↓ (if malware)
    Alert + Log to Graylog + Email (if level 10+)
```

**YARA Log:** `/var/log/yara.log`
**Wazuh Alerts:** `/var/ossec/logs/alerts/alerts.json`

---

## Verification

### Check YARA is working:
```bash
# Should show no false positives
yara -r /var/ossec/ruleset/yara/rules/*.yar /usr/bin/node

# Should detect EICAR test
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' | yara /var/ossec/ruleset/yara/rules/malware_common.yar -
```

### Check recent YARA activity:
```bash
sudo tail -50 /var/log/yara.log
```

### Search Graylog for YARA alerts:
```
source:dc1 AND message:*YARA_DETECTION*
```

---

## Performance Impact

**Before:**
- 8 false positive alerts on Node.js binary
- 1 false positive alert on DKMS
- Frequent false positive emails (if configured)

**After:**
- 0 false positive alerts on whitelisted binaries
- Whitelist rules execute quickly (hash comparison)
- No performance degradation
- More specific rules reduce CPU overhead (fewer partial matches)

---

## Maintenance

### When to Update Whitelist:

1. **After system updates:** If Node.js or DKMS is updated, their hashes will change
   ```bash
   # Check if hash changed
   sha256sum /usr/bin/node
   # If different, update whitelist
   ```

2. **New false positives:** When YARA flags a known-good binary
   - Add its hash to whitelist
   - Update malware rule conditions

3. **New installations:** When installing new system tools that might trigger rules

### Monitoring:

Check for false positives weekly:
```bash
# Review YARA alerts in Graylog
# Look for patterns of alerts on system binaries
# Add persistent offenders to whitelist
```

---

## Files Modified

| File | Purpose | Status |
|------|---------|--------|
| `/var/ossec/ruleset/yara/rules/00_whitelist.yar` | Hash whitelist | Created |
| `/var/ossec/ruleset/yara/rules/malware_common.yar` | Generic malware rules | Updated |
| `/var/ossec/ruleset/yara/rules/linux_malware.yar` | Linux malware rules | Updated |
| `/var/ossec/ruleset/yara/rules/windows_malware.yar` | Windows malware rules | Updated |

**Backup Locations:**
- `/var/ossec/ruleset/yara/rules/*.backup-20251230`

---

## Summary

✅ **False positives eliminated** on Node.js and DKMS binaries
✅ **Malware detection still working** (tested with backdoor patterns)
✅ **Rules more specific** (higher thresholds, better indicators)
✅ **Hash-based whitelist** for known-good binaries
✅ **Backups created** for all modified files
✅ **No performance impact** from whitelist checks
✅ **Easy to extend** whitelist for additional binaries

**Result:** YARA now provides accurate malware detection without false positives on legitimate system binaries.
