# Clear Browser Cache for AI Dashboard

## Problem
The AI Dashboard is showing the old IP address (192.168.1.7) because your browser cached the old version.

## Solution Applied (Server-Side) ✅

**Updated Apache Configuration:**
- Added no-cache headers for ai-dashboard.html
- Apache restarted successfully
- Server now sends: `Cache-Control: no-cache, no-store, must-revalidate`

**Server files confirmed updated:**
- File: `/var/www/cyberhygiene/ai-dashboard.html`
- Modified: Dec 23 09:54 (today)
- API URL: `http://ai.cyberinabox.net:11434` ✅

## Action Required: Clear Your Browser Cache

### Method 1: Hard Refresh (Quickest)

Press the appropriate key combination for your browser:

| Browser | Windows/Linux | Mac |
|---------|---------------|-----|
| **Chrome/Edge** | `Ctrl + Shift + R` | `Cmd + Shift + R` |
| **Firefox** | `Ctrl + Shift + R` | `Cmd + Shift + R` |
| **Safari** | N/A | `Cmd + Option + R` |

### Method 2: Empty Cache and Hard Reload (Chrome/Edge)

1. Open https://cyberinabox.net/ai-dashboard.html
2. Open Developer Tools (`F12`)
3. **Right-click** the refresh button (while DevTools is open)
4. Select **"Empty Cache and Hard Reload"**

### Method 3: Clear Specific Site Data (Chrome)

1. Open https://cyberinabox.net/ai-dashboard.html
2. Click the **lock icon** in address bar
3. Click **"Site settings"**
4. Scroll down and click **"Clear data"**
5. Refresh the page

### Method 4: Clear All Browser Cache

**Chrome:**
1. Settings → Privacy and Security → Clear browsing data
2. Select **"Cached images and files"**
3. Time range: **"Last hour"** (or "All time" if needed)
4. Click **"Clear data"**

**Firefox:**
1. Settings → Privacy & Security
2. Cookies and Site Data → **"Clear Data"**
3. Select **"Cached Web Content"**
4. Click **"Clear"**

**Edge:**
1. Settings → Privacy, search, and services
2. Clear browsing data → **"Choose what to clear"**
3. Select **"Cached images and files"**
4. Click **"Clear now"**

## Verification Steps

After clearing cache, the dashboard should show:

### ✅ Correct Version Indicators:

1. **Subtitle should read:**
   ```
   Local AI Assistant powered by Code Llama 7B on ai.cyberinabox.net (192.168.1.7)
   ```
   ❌ Old version said: `...on 192.168.1.7`

2. **Status bar should show:**
   - Green background with "✅ AI Server Online"
   - Model info displayed

3. **In browser DevTools (F12) → Console:**
   - Check for errors
   - Should show successful API calls to `ai.cyberinabox.net:11434`

4. **In browser DevTools → Network tab:**
   - Refresh page
   - Click on `ai-dashboard.html` request
   - Check Response Headers - should show:
     ```
     Cache-Control: no-cache, no-store, must-revalidate
     ```

## Quick Test Commands

**From terminal (to verify server is serving correct version):**

```bash
# Test server is serving updated version
curl -s https://cyberinabox.net/ai-dashboard.html | grep "ai.cyberinabox.net"

# Should return: ai.cyberinabox.net (192.168.1.7)
```

**Test AI API directly:**

```bash
# Test the new hostname works
curl http://ai.cyberinabox.net:11434/api/version

# Should return: {"version":"0.13.5"}
```

## Still Showing Old Version?

If after clearing cache you still see the old IP:

### 1. Check Browser Cache is Really Cleared

Open DevTools (F12) → Network tab:
- Check **"Disable cache"** checkbox
- Refresh the page (`F5`)

### 2. Try Incognito/Private Mode

- Chrome: `Ctrl + Shift + N`
- Firefox: `Ctrl + Shift + P`
- Edge: `Ctrl + Shift + N`

Open: https://cyberinabox.net/ai-dashboard.html

If it works in incognito, your normal browser has stubborn cache.

### 3. Force Reload from Server

Add a query parameter to force new download:
```
https://cyberinabox.net/ai-dashboard.html?v=20251223
```

### 4. Check Browser Extensions

Some ad-blockers or privacy extensions cache aggressively:
- Disable extensions temporarily
- Test the page again

## Technical Details

**Update Applied:** December 23, 2025, 09:54
**Apache Config:** `/etc/httpd/conf.d/cyberhygiene.conf`
**Server Files:**
- `/var/www/cyberhygiene/ai-dashboard.html` - Updated ✅
- `/var/www/html/ai-dashboard.html` - Updated ✅

**Cache Headers Now Sent:**
```http
Cache-Control: no-cache, no-store, must-revalidate
Pragma: no-cache
Expires: 0
```

This ensures browsers will **always** fetch the latest version going forward.

## Support

If issues persist after trying all methods:
- **ISSO:** Donald E. Shannon
- **Email:** Don@contractcoach.com
- **Phone:** 505.259.8485
