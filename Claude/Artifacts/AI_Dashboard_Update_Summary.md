# AI Dashboard Update - DNS Migration

## Changes Made

Updated the CyberHygiene AI System Administration Dashboard to use the new DNS hostname for the AI server.

### Files Updated

1. **`/var/www/cyberhygiene/ai-dashboard.html`**
   - Updated subtitle to show: `ai.cyberinabox.net (192.168.1.7)`
   - Changed `OLLAMA_HOST` constant from `http://192.168.1.7:11434` to `http://ai.cyberinabox.net:11434`

2. **`/var/www/html/ai-dashboard.html`**
   - Updated subtitle to show: `ai.cyberinabox.net (192.168.1.7)`
   - Changed `OLLAMA_HOST` constant from `http://192.168.1.7:11434` to `http://ai.cyberinabox.net:11434`

### What Changed

**Before:**
```javascript
const OLLAMA_HOST = 'http://192.168.1.7:11434';
```

**After:**
```javascript
const OLLAMA_HOST = 'http://ai.cyberinabox.net:11434';
```

### Access URLs

The dashboard is now available at:
- https://cyberinabox.net/ai-dashboard.html
- https://www.cyberinabox.net/ai-dashboard.html
- https://dc1.cyberinabox.net/ai-dashboard.html

### Benefits

1. **More User-Friendly:** Use hostname instead of IP address
2. **Better Maintainability:** If IP changes, only DNS needs updating
3. **Professional:** Branded hostname (ai.cyberinabox.net)
4. **Consistent:** Matches other cyberinabox.net services

### API Endpoint

The dashboard now connects to:
```
http://ai.cyberinabox.net:11434/api/tags
http://ai.cyberinabox.net:11434/api/generate
```

### Testing

To verify the dashboard works:

1. **Open in browser:**
   ```
   https://cyberinabox.net/ai-dashboard.html
   ```

2. **Check status bar:**
   - Should show green "✅ AI Server Online"
   - Should display model info

3. **Test AI interaction:**
   - Click "Code Review" or "Security Analysis"
   - Enter a question or code snippet
   - Verify response from Code Llama

### Troubleshooting

If the dashboard shows "❌ AI Server Offline":

1. **Check DNS resolution:**
   ```bash
   host ai.cyberinabox.net
   # Should return: 192.168.1.7
   ```

2. **Check Ollama service:**
   ```bash
   curl http://ai.cyberinabox.net:11434/api/version
   # Should return: {"version":"0.13.5"}
   ```

3. **Check browser console:**
   - Open Developer Tools (F12)
   - Look for CORS or network errors

### Technical Details

**Update Date:** December 23, 2025
**Updated By:** System Administrator
**DNS Record:** ai.cyberinabox.net → 192.168.1.7
**Service:** Ollama v0.13.5
**Models:** codellama:7b, nomic-embed-text

### Related Changes

- **DNS Record Added:** `ipa dnsrecord-add cyberinabox.net ai --a-rec=192.168.1.7`
- **Verification:** DNS, ping, and API tests all passing
- **No service restart required:** Changes are client-side JavaScript only

