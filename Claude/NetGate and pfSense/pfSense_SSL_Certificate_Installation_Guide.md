# pfSense Wildcard SSL Certificate Installation Guide

**Certificate:** `*.cyberinabox.net`
**Issued by:** SSL.com RSA SSL subCA
**Valid:** October 28, 2025 - October 28, 2026
**Installation Date:** October 31, 2025
**Firewall IP:** 192.168.1.1

---

## STEP-BY-STEP INSTALLATION

### Step 1: Access pfSense Web Interface

1. Open web browser
2. Navigate to: **https://192.168.1.1**
3. Login with admin credentials
4. You may see a certificate warning (this is normal with the default self-signed cert)

### Step 2: Navigate to Certificate Manager

1. Click **System** in top menu
2. Click **Cert. Manager**
3. Click **Certificates** tab
4. Click **+ Add/Sign** button (top right)

### Step 3: Configure Certificate Import

Fill in the following fields:

**Method:**
- Select: **Import an existing Certificate**

**Descriptive name:**
```
Wildcard_cyberinabox_net_2025
```

**Certificate data:**

Copy and paste the **entire** certificate chain below (including all BEGIN/END lines):

```
-----BEGIN CERTIFICATE-----
MIIHIjCCBQqgAwIBAgIQM9kFGsqyk/R0I8/M7+wNjzANBgkqhkiG9w0BAQsFADBp
MQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24x
GDAWBgNVBAoMD1NTTCBDb3Jwb3JhdGlvbjEeMBwGA1UEAwwVU1NMLmNvbSBSU0Eg
U1NMIHN1YkNBMB4XDTI1MTAyODE2MzgxM1oXDTI2MTAyODE2MzgxM1owHDEaMBgG
A1UEAwwRKi5jeWJlcmluYWJveC5uZXQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQCAwCkzEPyAeYEgXO+zRNEvJCwWXkrAwLb5jzSXrJqPfkqfeRGGy8mG
wIr3JhTeizGWBL0tUtRy+oIABmOIkvfdoWT5eKnAgrmEdFCuXzyyLnUJ9GaUCFmt
2a9mDdbAc+gavpZHXCfeFg2EtS6CiDaOlA+svfGDW7zcWEOLlvCGODOigvhs6MgW
LFr2GMGod8Ii8pStsbwdxyMZe3AKl/RQth98svBpqi87uv6Ipuesdvqn+BPlt8bB
6+lPRb4/m1K+qU+6JO1ZxOKlRLyb2wmb9eZM48/tr3DSkDYQkmGG2DxwMMvHX8nM
3+l4JS886ZuRAfb2cLzbXyexlSyiujYJAgMBAAGjggMRMIIDDTAMBgNVHRMBAf8E
AjAAMB8GA1UdIwQYMBaAFCYUfuDc16b34tQEJ99h8cLs5zLKMHIGCCsGAQUFBwEB
BGYwZDBABggrBgEFBQcwAoY0aHR0cDovL2NlcnQuc3NsLmNvbS9TU0xjb20tU3Vi
Q0EtU1NMLVJTQS00MDk2LVIxLmNlcjAgBggrBgEFBQcwAYYUaHR0cDovL29jc3Bz
LnNzbC5jb20wLQYDVR0RBCYwJIIRKi5jeWJlcmluYWJveC5uZXSCD2N5YmVyaW5h
Ym94Lm5ldDAjBgNVHSAEHDAaMAgGBmeBDAECATAOBgwrBgEEAYKpMAEDAQEwHQYD
VR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMBMEUGA1UdHwQ+MDwwOqA4oDaGNGh0
dHA6Ly9jcmxzLnNzbC5jb20vU1NMY29tLVN1YkNBLVNTTC1SU0EtNDA5Ni1SMS5j
cmwwHQYDVR0OBBYEFDVrPdT6qtAN+eNSZCgiMOWqRDN5MA4GA1UdDwEB/wQEAwIF
oDCCAX0GCisGAQQB1nkCBAIEggFtBIIBaQFnAHYAwjF+V0UZo0XufzjespBB68fC
IVoiv3/Vta12mtkOUs0AAAGaK7hhGQAABAMARzBFAiAex+CWngVt6tetNO02Itb7
ybd2zl62US19SZSLRRuZlgIhAJQNHdHWLo62m0w6MOIehzJ8DztW+O/ZPfw5J6ai
pOsjAHYAyzj3FYl8hKFEX1vB3fvJbvKaWc1HCmkFhbDLFMMUWOcAAAGaK7hhDgAA
BAMARzBFAiBmq0sw0Y8KrJMVguzsuI5Ej2Z1hGBnt644N7Awx7AHfwIhAK+ihyH6
InRrEs07a36SJfymxnL/QywgarsccS2bFUEkAHUA2AlVO5RPev/IFhlvlE+Fq7D4
/F6HVSYPFdEucrtFSxQAAAGaK7hhLgAABAMARjBEAiA1Sin0MzVle8NfISHz7QVZ
4zxwKXh8WDIAaTIiMe6bQgIgCpBDgKXGqRF1m4dYtQpl3hruwZmRyVDMdkKqkHzn
JgMwDQYJKoZIhvcNAQELBQADggIBAF/hjWHc0gYWR+5OwxCEn5YAXvrOpg5JTzJh
yE4RGa0tKWkM2R9a4nwJLZsnLHIqcbaJghLgCIGIC4To96mLBoHv70BZwT8a3CjZ
nxf8oriVILsfjoNt2mVYW80SAlbD3hTrdFihDjkL/7REnsxFOq8JEGTjUfSdhNtG
TihAWJlDo4qs7BImbqVxku01mzZjIJLeBApe59W13g9j/Co8KLb7zcHanMNF5fpv
flZLd2IdpPfaRO+re5UI8exWIAAY5wYxtOpX4Bc/dSiEROqIzQuzxoOHP+N7XdpU
1Cjcxy9pNjAICAHEWFQl7/rRbAghQipKakwZKkLWSnKOU0x97BCNqluK30xaetwj
qqaZRBYg5HV7ayUDgUAPaZGVfIRhxGG0eKNeLuoVIWr6CoYsHZUraKN3avPraDLJ
XCoK0kyFQ8RD2qFSeWDKExR+FfIlZxCRcN27zhWs1aaWXCjjsaRtlL4RzQa7t1Wv
ftuO1pSwkPDMo03wuosbe2fiXOCoJ69QXorcRz7mqQ90m7/cdF6nDK6bUZTq05TH
NZuU8G6cckeaMwbcg2wlQnhV/NFco0Hh+zFBm9fXJ7yGZCyncsrY688yKEVnlhBM
k+dkH9gY2wJ0z1Wz4/Ke0JvIJH/W8B49MR5J3o+sl9X3Xyplj3N29hRevsnFpRAY
HGn22JAq
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
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
y702dmPTKEdEfwhgLx0LxJr/Aw==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIF3TCCA8WgAwIBAgIIeyyb0xaAMpkwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UE
BhMCVVMxDjAMBgNVBAgMBVRleGFzMRAwDgYDVQQHDAdIb3VzdG9uMRgwFgYDVQQK
DA9TU0wgQ29ycG9yYXRpb24xMTAvBgNVBAMMKFNTTC5jb20gUm9vdCBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eSBSU0EwHhcNMTYwMjEyMTczOTM5WhcNNDEwMjEyMTcz
OTM5WjB8MQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hv
dXN0b24xGDAWBgNVBAoMD1NTTCBDb3Jwb3JhdGlvbjExMC8GA1UEAwwoU1NMLmNv
bSBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5IFJTQTCCAiIwDQYJKoZIhvcN
AQEBBQADggIPADCCAgoCggIBAPkP3aMrfcvQKv7sZ4Wm5y4bunfh4/WvpOz6Sl2R
xFdHaxh3a3by/ZPkPQ/CFp4LZsNWlJ4Xg4XOVu/yFv0AYvUiCVToZRdOQbngT0aX
qhvIuG5iXmmxX9sqAn78bMrzQdjt0Oj8P2FI7bADFB0QDksZ4LtO7IZl/zbzXmcC
C52GVWH9ejjt/uIZALdvoVBidXQ8oPrIJZK0bnoix/geoeOy3ZExqysdBP+lSgQ3
6YWkMyv94tZVNHwZpEpox7Ko07fKoZOI68GXvIz5HdkihCR0xwQ9aqkpk8zruFvh
/l8lqjRYyMEjVJ0bmBHDOJx+PYZspQ9AhnwC9FwCTyjLrnGfDzrIM/4RJTXq/LrF
YD3ZfBjVsqnTdXgDciLKOsMf7yzlLqn6niy2UUb9rwPW6mBo6oUWNmuF6R7As93E
JNyAKoFBbZQ+yODJgUEAnl6/f8UImKIYLEJAs/lvOCdLToD0PYFH4Ih86hzOtXVc
US4cK38acijnALXRdMbX5J+tB5O2UzU1/Dfkw/ZdFr4hc96SCvigY2q8lpJqPvi8
ZVWb3vUNiSYE/CUapiVpy8JtynziWV+XrOvvLsi81xtZPCvM8hnIk2snYxnP/Okm
+Mpxm3+T/jRnhE6Z6/yzeAkzcLpmpnbtG3PrGqUNxCITIJRWCk4sbE6x/c+cCbqi
M+2HAgMBAAGjYzBhMB0GA1UdDgQWBBTdBAkHovV6fVJTEpKV7jiAJQ2mWTAPBgNV
HRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFN0ECQei9Xp9UlMSkpXuOIAlDaZZMA4G
A1UdDwEB/wQEAwIBhjANBgkqhkiG9w0BAQsFAAOCAgEAIBgRlCn7Jp0cHh5wYfGV
cpNxJK1ok1iOMq8bs3AD/CUrdIWQPXhq9LmLpZc7tRiRux6n+UBbkflVma8eEdBc
Hadm47GUBwwyOabqG7B52B2ccETjit3E+ZUfijhDPwGFpUenPUayvOUiaPd7nNgs
PgohyC0zrL/FgZkxdMF1ccW+sfAjRfSda/wZY52jvATGGAslu1OJD7OAUN5F7kR/
q5R4ZJjT9ijdh9hwZXT7DrkT66cPYakylszeu+1jTBi7qUD3oFRuIIhxdRjqerQ0
cuAjJ3dctpDqhiVAq+8zD8ufgr6iIPv2tS0a5sKFsXQP+8hlAqRSAUfdSSLBv9jr
a6x+3uxjMxW3IwiPxg+NQVrdjsW5j+VFP3jbutIbQLH+cU0/4IGiul607BXgk90I
H37hVZkLId6Tngr75qNJvTYw/ud3sqB1l7UtgYgXZSD32pAAn8lSzDLKNXz1PQ/Y
K9f1JmzJBjSWFupwWRoyeXkLtoh/D1JIPb9s2KJELtFOt3JY04kTlf5Eq/jXixtu
nLwsoFvVagCvXzfh1foQC5ichucmj87w7G6KVwuA406ywKBjYZC6VWg3dGq2ktuf
oYYitmUnDuy2n0Jg5GfCtdpBC8TTi2EbvPofkSvXRAdeuims2cXp71NIWuuA8ShY
Ic2wBlX7Jz9TkHCpBB5XJ7k=
-----END CERTIFICATE-----
```

**Private key data:**

Copy and paste the entire private key below (including BEGIN/END lines):

```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCd3TP8rbyBYLzM
9v0m13n8bfxBcbajgX2U4uPS3ZRMibk+1HFx7tH4zmqR28ZosOV+U6iRn9gRDTxn
PLtKZ9K7SM6HVOnPHOKnzNULGgQyEE6acvNMv7mZa1U7KGprSXuYq0ZY4+Np2Exx
SN0NH795ZDJcCWxAxy6+YYS9kiI9eA3zTHAYzwKnBBdHQGrzoZJMLziSxR3LDKfd
R1D1kB2QMzPQ5nDlb7o5YanuJpirADzxNi8tASGYdi7OevSN4hRyOKO8QQU5j5iw
PX2l8Zb2l+6OYamWCua9hKwDsJutqTo43VNG3Yb0Rx7U3Z/JBfUVShi3y4qJcvQ7
6ZvOd8Q9AgMBAAECggEAB0Eit3TgbxhGn4CmJ4J1bPU88gugt1N8YDrWT1q2tZcK
opQuq8FWzYE8LScVWhBEVjwlSJ6OK6fDuSwgSzi0MBPAxz/5XUwthO/ecRvT9N0C
T7StRj9KmdNF378UDN7GmuscA3pizqVi9ehsSBhyZciwoRbJw7xOLe+F+GmJFfFQ
6FIGSc11oyhGgvoEwL1VCjzKhixvgG6J1eRnon8mzuS0dkLamRk/z4COObsAKatf
djUZo8jxRh1RqiVPYhXnU3mLkn2o8kBgBHnuSn3Lkv5CL27zsb19Uof5s7s8k7Mk
iKMU2aTjpT8oZE3fzhKGjlt79PLh6EIFwtrw2MO4XQKBgQDVdIzvbGuO2eIFSM9k
9xD5JIi5fi4UJ2/NduwIo06GwKyo8XsLUvw1GYfNTFz7L/2sOThzpDya6oRR3bDQ
uDp1nrv/ust97UA//0ao/ztsPSuKzs0pRlxYF3/dHZT34449ZjI9PqebzrsD0O0f
pF/xyOotL6fVaROL4rnh1OBh0wKBgQC9VCOcy7DhfMjYdDXT6YRZJ/K1HepW8jyi
tvm2EXlTM4e7CznLotdn7tR5IEfhtYgJbhNzF+QkYhJo2A5S67sqFczLVKD0wsbH
4zSIvHcIWDHHe5gzv/u0wZ6O8e22TBH1GzyZBC5UJFE6teJhfXLCbD9PFwOzueTG
fDReysNnrwKBgQCvfPrBfGmRMCBaJ9oaL+WMbzTZC5vmheWtDjBPibNtpcpNuvpl
/PvMzAiSCE4JVRNBHGoE6OnKkzPl+lT7w/qL6My3GmNiTEOeWclF91BrVH8Px6V0
YZxZ8Df3GfL3OeYfJH35TCGQPw4RvRq2APXAWmXscFmTYqfnQaeAuvsecQKBgDp3
FyA+TnrzW9pr2It+Gx6lFXAUst7yowLkWix9LOgii5GZH9ngiYBQ4lAdRdVPh5jR
4zOxdwQ9PM4fmhzFKuEOJlXL5oBu/Y+QfBKVkHSFN6oQYqnoaUQiXmJqFywqRYlZ
RddC0UOui18D98p/QMcFQm+b/cqsZxdcF5gGKV2FAoGAYwFeB/iVzGGyugg6Mdja
QWvZrpAYkzaIe0P0/XaDnBpsm2rYoprxObQh/NZgG1Zc2DSWNW0TVpov2ERHw0Db
SxIxVPeHLJ0djRSzYW1E1RvuwO4fMKILnVMo4D6Y6Bl1DpBOH7/Ig4PpTNXovyEL
lKluCjYr6dr2gRNUrRYJR88=
-----END PRIVATE KEY-----
```

Click **Save**

### Step 4: Configure webConfigurator to Use the New Certificate

1. Go to: **System → Advanced**
2. Click **Admin Access** tab
3. Under **webConfigurator** section:
   - **Protocol:** Select `HTTPS`
   - **SSL/TLS Certificate:** Select `Wildcard_cyberinabox_net_2025` from dropdown
   - **TCP Port:** Leave as `443` (default HTTPS port)
4. Scroll to bottom and click **Save**

### Step 5: Accept Browser Warning and Reconnect

1. You will see a warning that your session will be interrupted
2. Click OK
3. Wait 5-10 seconds for pfSense to apply the new certificate
4. Your browser may show "Connection Reset" or "Unable to Connect"
5. Refresh the page or navigate to https://192.168.1.1 again
6. You should now see a valid SSL certificate!

### Step 6: Verify the Certificate

1. Click the padlock icon in your browser's address bar
2. Click "Connection is secure" → "Certificate is valid"
3. Verify:
   - **Issued to:** `*.cyberinabox.net`
   - **Issued by:** `SSL.com RSA SSL subCA`
   - **Valid from:** October 28, 2025
   - **Valid until:** October 28, 2026
   - **Subject Alternative Names:**
     - `*.cyberinabox.net`
     - `cyberinabox.net`

---

## TROUBLESHOOTING

### Certificate Shows as Invalid

**Problem:** Browser shows "Not Secure" or certificate error

**Causes & Solutions:**

1. **Wrong certificate selected:**
   - Go to System → Advanced → Admin Access
   - Verify `Wildcard_cyberinabox_net_2025` is selected
   - Click Save and refresh browser

2. **Missing intermediate certificates:**
   - Verify you pasted **all three** certificate blocks (your cert + 2 intermediate certs)
   - The certificate chain should be ~6.8 KB

3. **Hostname mismatch:**
   - Access pfSense using: `https://pfsense.cyberinabox.net` or `https://firewall.cyberinabox.net`
   - NOT by IP address (192.168.1.1) - wildcard certs don't cover IPs
   - Add DNS entry in pfSense: Services → DNS Resolver → Host Overrides
     - Host: `pfsense` or `firewall`
     - Domain: `cyberinabox.net`
     - IP: `192.168.1.1`

### Can't Access pfSense After Certificate Change

**Problem:** Connection refused or timeout

**Solution:**

1. Wait 30 seconds and try again (pfSense is restarting web server)
2. Clear browser cache: Ctrl+Shift+Delete
3. Try incognito/private browsing mode
4. If still can't connect, reset from console:
   - Physical or serial console access required
   - Option 4: Reset webConfigurator password
   - Option 16: Restore recent configuration backup

### Certificate Shows Self-Signed

**Problem:** Browser shows "Self-signed certificate" warning

**Solution:**

1. Verify you pasted the **entire certificate chain** (all 3 blocks)
2. Verify no extra spaces or characters in the certificate data
3. Check that certificate is selected in Admin Access settings

---

## ADDITIONAL SERVICES TO SECURE

Once the wildcard certificate is installed, you can use it for other pfSense services:

### Captive Portal

If using Captive Portal:
1. Services → Captive Portal → [Zone Name]
2. HTTPS Options section
3. HTTPS server name: `portal.cyberinabox.net`
4. SSL/TLS Certificate: `Wildcard_cyberinabox_net_2025`

### OpenVPN Server

If using OpenVPN:
1. VPN → OpenVPN → Servers → Edit server
2. TLS Configuration section
3. Server certificate: `Wildcard_cyberinabox_net_2025`
4. Click Save

### IPsec VPN

If using IPsec:
1. VPN → IPsec → Mobile Clients
2. Certificate: `Wildcard_cyberinabox_net_2025`

---

## COMPLIANCE NOTES

**NIST 800-171 SC-8:** Transmission Confidentiality

This wildcard certificate ensures:
- ✅ TLS 1.2/1.3 encryption for web management interface
- ✅ Valid commercial certificate from trusted CA (SSL.com)
- ✅ Protection of CUI during administrative access
- ✅ Browser validation without security warnings

**Security Benefits:**
- Eliminates man-in-the-middle attack risks on management interface
- Enables secure remote administration
- Meets DoD/NIST requirements for encrypted administrative access
- Valid for all subdomains (*.cyberinabox.net)

**Certificate Renewal:**
- Expiration: October 28, 2026
- Renewal reminder: Set calendar alert for October 1, 2026
- Renewal process: Reissue from SSL.com, repeat this installation

---

## BACKUP RECOMMENDATION

After successful installation, backup your pfSense configuration:

1. Diagnostics → Backup & Restore
2. Backup area: `ALL`
3. Click **Download configuration as XML**
4. Save file as: `pfsense-config-backup-2025-10-31-ssl-cert.xml`
5. Store in secure location: `/home/dshannon/Documents/Claude/Backups/`

This backup includes the installed certificate and can be restored if needed.

---

## POST-INSTALLATION CHECKLIST

- [ ] Certificate installed successfully
- [ ] webConfigurator accessible via HTTPS
- [ ] Browser shows valid certificate (green padlock)
- [ ] Certificate details verified (*.cyberinabox.net)
- [ ] Configuration backup created
- [ ] DNS hostname configured (optional: pfsense.cyberinabox.net)
- [ ] Document updated in SSP/POA&M

---

## SUPPORT RESOURCES

**pfSense Documentation:**
- Certificate Manager: https://docs.netgate.com/pfsense/en/latest/certificates/index.html
- Web Interface: https://docs.netgate.com/pfsense/en/latest/config/advanced-admin.html

**SSL.com Support:**
- Support portal: https://www.ssl.com/support/
- Certificate reissue: https://www.ssl.com/how-to/reissue-ssl-certificate/

**Local Certificate Files:**
- Certificate: `/home/dshannon/Documents/Claude/STAR_cyberinabox_net.chained.crt`
- Private Key: `/home/dshannon/Documents/Claude/star_cyberinabox_net_correct.key`

---

**Installation Guide Created:** October 31, 2025
**Author:** Claude Code Assistant
**Status:** Ready for Implementation
