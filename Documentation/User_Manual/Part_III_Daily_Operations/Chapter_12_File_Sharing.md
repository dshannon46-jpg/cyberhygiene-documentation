# Chapter 12: File Sharing & Collaboration

## 12.1 Samba File Shares

### Samba Overview

**Samba** provides Windows-compatible file sharing on the CyberHygiene network, allowing seamless file access across different operating systems.

**Server:** dms.cyberinabox.net (192.168.1.20)

**Authentication:**
- Kerberos SSO (automatically uses your login)
- Username/password (fallback)

**Available Shares:**

| Share Name | Path | Purpose | Access |
|------------|------|---------|--------|
| **shared** | \\dms.cyberinabox.net\shared | Common files, collaboration | All users |
| **homes** | \\dms.cyberinabox.net\username | Personal files | Individual users |
| **engineering** | \\dms.cyberinabox.net\engineering | Engineering team files | Engineering group |
| **operations** | \\dms.cyberinabox.net\operations | IT operations files | Operations group |
| **backups** | \\dms.cyberinabox.net\backups | Backup storage | Administrators only |

### Accessing Samba Shares on Windows

**Method 1: Map Network Drive (Recommended)**

1. Open File Explorer
2. Click "This PC" in left panel
3. Click "Map network drive" (ribbon or right-click menu)
4. Configure:
   - **Drive letter:** Z: (or any available)
   - **Folder:** `\\dms.cyberinabox.net\shared`
   - ☑ **Reconnect at sign-in**
   - ☑ **Connect using different credentials** (if needed)
5. Click "Finish"
6. If prompted for credentials:
   - **Username:** `CYBERINABOX\your_username`
   - **Password:** [your password]
7. Drive appears in This PC

**Method 2: Direct Access (Quick Access)**

1. Open File Explorer
2. In address bar, type: `\\dms.cyberinabox.net\shared`
3. Press Enter
4. Enter credentials if prompted
5. Share opens in File Explorer

**Method 3: Add to Quick Access**

1. Access share using Method 2
2. Right-click the folder
3. Select "Pin to Quick access"
4. Share appears in left panel for easy access

**PowerShell Access:**
```powershell
# List available shares
net view \\dms.cyberinabox.net

# Map drive via PowerShell
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\dms.cyberinabox.net\shared" -Persist

# Access via UNC path
cd \\dms.cyberinabox.net\shared
```

### Accessing Samba Shares on Linux

**Method 1: Command Line Mount**

```bash
# Create mount point
sudo mkdir -p /mnt/shared

# Mount with Kerberos authentication
sudo mount -t cifs //dms.cyberinabox.net/shared /mnt/shared \
  -o sec=krb5,vers=3.0

# Or mount with username/password
sudo mount -t cifs //dms.cyberinabox.net/shared /mnt/shared \
  -o username=your_username,domain=CYBERINABOX

# Verify mount
df -h | grep shared
```

**Method 2: Auto-mount via /etc/fstab**

Create credentials file:
```bash
sudo nano /etc/samba/credentials
```

Add:
```
username=your_username
password=your_password
domain=CYBERINABOX
```

Secure it:
```bash
sudo chmod 600 /etc/samba/credentials
```

Add to `/etc/fstab`:
```bash
//dms.cyberinabox.net/shared  /mnt/shared  cifs  credentials=/etc/samba/credentials,uid=1000,gid=1000  0  0
```

Mount all:
```bash
sudo mount -a
```

**Method 3: File Manager (GUI)**

**Nautilus (GNOME):**
1. Open Files
2. Click "Other Locations"
3. In "Connect to Server" at bottom, enter: `smb://dms.cyberinabox.net/shared`
4. Click "Connect"
5. Select "Registered User"
6. Enter credentials
7. Share appears in sidebar

**Dolphin (KDE):**
1. Open Dolphin
2. In location bar, type: `smb://dms.cyberinabox.net/shared`
3. Press Enter
4. Enter credentials when prompted

### Accessing Samba Shares on macOS

**Method 1: Finder (GUI)**

1. Open Finder
2. Press `Cmd+K` (or Go → Connect to Server)
3. Enter: `smb://dms.cyberinabox.net/shared`
4. Click "Connect"
5. Select "Registered User"
6. Enter:
   - **Name:** `your_username`
   - **Password:** [your password]
7. Click "Connect"
8. Share mounts and appears on desktop

**Method 2: Command Line**

```bash
# Create mount point
mkdir -p ~/mnt/shared

# Mount share
mount_smbfs //username@dms.cyberinabox.net/shared ~/mnt/shared

# Unmount
umount ~/mnt/shared
```

**Add to Login Items (Auto-mount):**
1. System Preferences → Users & Groups
2. Select your user → Login Items
3. Click "+" and add the mounted share
4. Share auto-mounts on login

## 12.2 NFS Mounts

### NFS Overview

**Network File System (NFS)** is the native Unix/Linux file sharing protocol, providing high-performance file access with Kerberos security.

**Server:** dms.cyberinabox.net (192.168.1.20)

**Available Exports:**

| Export Path | Purpose | Mount Point | Access |
|-------------|---------|-------------|--------|
| /exports/home | User home directories | /home | All users (auto) |
| /exports/shared | Shared workspace | /mnt/shared | All users |
| /exports/engineering | Engineering files | /mnt/engineering | Engineering group |
| /exports/backups | Backup storage | /mnt/backups | Administrators |

### Mounting NFS Shares

**List Available Exports:**
```bash
showmount -e dms.cyberinabox.net
```

Output:
```
Export list for dms.cyberinabox.net:
/exports/shared      192.168.1.0/24
/exports/home        192.168.1.0/24
/exports/engineering 192.168.1.0/24
/exports/backups     192.168.1.0/24
```

**Manual Mount (Kerberos):**

```bash
# Ensure you have a valid Kerberos ticket
kinit your_username
klist  # Verify ticket

# Create mount point
sudo mkdir -p /mnt/shared

# Mount with Kerberos security
sudo mount -t nfs -o sec=krb5 dms.cyberinabox.net:/exports/shared /mnt/shared

# Verify mount
df -h | grep shared
mount | grep shared
```

**Auto-mount via /etc/fstab:**

Add to `/etc/fstab`:
```bash
dms.cyberinabox.net:/exports/shared  /mnt/shared  nfs  sec=krb5,_netdev,rw  0  0
```

Explanation:
- `sec=krb5`: Use Kerberos authentication
- `_netdev`: Wait for network before mounting
- `rw`: Read-write access
- `0 0`: No dump, no fsck

Mount all:
```bash
sudo mount -a
```

**Unmount NFS Share:**
```bash
sudo umount /mnt/shared

# Force unmount if busy
sudo umount -f /mnt/shared

# Or lazy unmount
sudo umount -l /mnt/shared
```

### NFS Performance Options

**For Better Performance:**
```bash
sudo mount -t nfs -o sec=krb5,rsize=32768,wsize=32768,hard,intr \
  dms.cyberinabox.net:/exports/shared /mnt/shared
```

Options explained:
- `rsize=32768`: Read buffer size (32KB)
- `wsize=32768`: Write buffer size (32KB)
- `hard`: Keep trying if server unavailable
- `intr`: Allow interruption of NFS operations

**For Reliability:**
```bash
sudo mount -t nfs -o sec=krb5,hard,intr,timeo=600,retrans=2 \
  dms.cyberinabox.net:/exports/shared /mnt/shared
```

Options:
- `timeo=600`: Timeout after 60 seconds (600 deciseconds)
- `retrans=2`: Retry 2 times before timeout

## 12.3 File Permissions

### Unix/Linux Permissions

**Permission Types:**
- **r (read):** View file contents or list directory
- **w (write):** Modify file or create/delete files in directory
- **x (execute):** Run file as program or access directory

**Permission Groups:**
- **User (u):** File owner
- **Group (g):** Group members
- **Others (o):** Everyone else

**View Permissions:**
```bash
ls -l filename

# Output:
-rw-r--r--  1 jsmith engineering 1024 Dec 31 10:00 document.txt
│││││││││
│││││││└┴─ Other permissions (r--)
││││││└──── Group permissions (r--)
│││││└───── User permissions (rw-)
││││└────── Number of hard links
│││└─────── Group owner (engineering)
││└──────── File owner (jsmith)
│└───────── File type (- = regular file)
```

**Numeric Permissions:**
```
r = 4
w = 2
x = 1

Examples:
755 = rwxr-xr-x  (Owner: rwx, Group: r-x, Others: r-x)
644 = rw-r--r--  (Owner: rw-, Group: r--, Others: r--)
600 = rw-------  (Owner: rw-, Group: ---, Others: ---)
```

**Setting Permissions:**
```bash
# Numeric method
chmod 644 file.txt         # rw-r--r--
chmod 755 script.sh        # rwxr-xr-x
chmod 700 private_dir/     # rwx------

# Symbolic method
chmod u+x script.sh        # Add execute for user
chmod g+w file.txt         # Add write for group
chmod o-r secret.txt       # Remove read for others
chmod a+r public.txt       # Add read for all

# Recursive
chmod -R 755 /path/to/directory
```

**Changing Ownership:**
```bash
# Change owner
sudo chown newowner file.txt

# Change owner and group
sudo chown newowner:newgroup file.txt

# Change group only
sudo chgrp newgroup file.txt

# Recursive
sudo chown -R jsmith:engineering /path/to/directory
```

### Samba/Windows Permissions

**When accessing via Samba:**
- Unix permissions still apply
- Windows ACLs are translated to Unix permissions
- Group membership controls access

**Common Permission Issues:**

**Issue:** "Access Denied" on Samba share
**Causes:**
- Not in required group
- File permissions too restrictive
- No Kerberos ticket

**Solutions:**
```bash
# Check your groups
groups

# Request group membership (email admin)
# Get Kerberos ticket
kinit your_username

# Check file permissions on server
ls -l /path/to/file
```

### Group-Based Access Control

**Common Groups:**
- **users:** All regular users
- **engineering:** Engineering team
- **operations:** IT operations
- **admins:** System administrators

**Check Your Group Membership:**
```bash
# List your groups
groups

# Detailed group info
id

# Output:
uid=1001(jsmith) gid=1001(jsmith) groups=1001(jsmith),1000(users),1010(engineering)
```

**Request Group Access:**
Email administrator:
```
To: dshannon@cyberinabox.net
Subject: Access Request: Engineering Group

User: jsmith
Requested Group: engineering
Business Justification: Working on Project X, need access to shared engineering files
Manager Approval: [CC your manager]
```

## 12.4 Collaborative Workspaces

### Shared Workspace Structure

**Recommended Directory Structure:**

```
/mnt/shared/
├── Projects/           # Active project files
│   ├── ProjectA/
│   ├── ProjectB/
│   └── ProjectC/
├── Documentation/      # Shared documentation
├── Templates/          # Document templates
├── Archives/           # Completed projects
└── Incoming/           # File drop area
```

**Best Practices:**

**1. Organize by Project:**
```bash
/mnt/shared/Projects/ProjectName/
├── Documents/
├── Spreadsheets/
├── Presentations/
└── Resources/
```

**2. Use Clear Naming:**
```
Good: 2025-12-31_Project_Status_Report_v2.docx
Bad:  report.docx, final.docx, final_FINAL.docx
```

**3. Version Control:**
```
Naming: DocumentName_v1.0.docx, DocumentName_v1.1.docx
Or use: Git for text files, proper version control
```

### File Locking

**What is File Locking?**
Prevents multiple users from editing the same file simultaneously.

**Samba File Locking:**
- Automatic in Windows applications (Word, Excel)
- Shows "[filename] is locked for editing by [user]"
- Can open read-only or wait for lock release

**NFS File Locking:**
- Uses NFSv4 locking protocol
- Most applications respect locks
- Some legacy apps may not

**Manual Lock Check:**
```bash
# On server (admin only)
sudo smbstatus

# Shows:
# - Connected users
# - Open files
# - File locks
```

### Conflict Resolution

**Simultaneous Edits:**

**Scenario:** Two users edit the same file

**Samba/Windows:**
1. First user opens file (acquires lock)
2. Second user sees "File is locked"
3. Options:
   - Open read-only
   - Save as different filename
   - Wait for first user to close

**NFS/Linux:**
1. Both users can open (no automatic lock)
2. Last save wins (overwrites previous)
3. **Risk:** Data loss

**Solution:** Use version control (Git) for important files

### Collaborative Tools

**For Real-Time Collaboration:**

**Office Documents:**
- Consider: LibreOffice Online, OnlyOffice (if deployed)
- Alternative: Share via cloud with edit tracking
- Current: Sequential editing with file locks

**Text Files / Code:**
- Use Git repository for version control
- Multiple users can work on different files
- Merge changes systematically

**Large Files:**
- Use shared network drive
- Coordinate edits via chat/email
- Use version numbering

## 12.5 File Versioning

### Manual Versioning

**Version Naming Convention:**
```
DocumentName_vX.Y.docx

Where:
X = Major version (significant changes)
Y = Minor version (small edits)

Examples:
Project_Proposal_v1.0.docx  (Initial draft)
Project_Proposal_v1.1.docx  (Minor edits)
Project_Proposal_v2.0.docx  (Major revision)
```

**Date-Based Versioning:**
```
YYYY-MM-DD_DocumentName_Description.ext

Examples:
2025-12-31_Status_Report_Draft.docx
2025-12-31_Status_Report_Final.docx
```

### Backup and Recovery

**Automatic Backups:**
- File server backed up daily at 2:00 AM
- 30-day retention
- Stored encrypted off-site

**Recover Deleted File:**

**Method 1: From Backups (Contact Admin)**
```
Email: dshannon@cyberinabox.net
Subject: File Recovery Request

File: /mnt/shared/Projects/ProjectA/important.docx
Deleted: Approximately Dec 30, 2025
User: jsmith
Reason: Accidentally deleted, need to recover
```

**Method 2: Shadow Copies (Windows, if enabled)**
1. Navigate to share in File Explorer
2. Right-click file or folder
3. Select "Restore previous versions"
4. Select version and restore

**Method 3: Check Recycle Bin**
- Local deletes go to Recycle Bin
- Network deletes may bypass Recycle Bin
- Check immediately if accidentally deleted

### Version Control with Git

**For Text-Based Files:**
- Source code
- Configuration files
- Markdown documentation
- Scripts

**Setup Git Repository on Shared Drive:**
```bash
# Create repository
cd /mnt/shared/Projects/ProjectA
git init

# Add files
git add .
git commit -m "Initial commit"

# Create .gitignore for large files
cat > .gitignore <<EOF
*.tmp
*.bak
~$*
*.swp
EOF
```

**Daily Workflow:**
```bash
# Start work
cd /mnt/shared/Projects/ProjectA
git pull  # Get latest changes

# Make changes to files

# Commit changes
git add modified_file.txt
git commit -m "Updated documentation"

# Push changes
git push
```

---

**File Sharing Summary:**

| Protocol | Best For | Platform Support | Authentication |
|----------|----------|------------------|----------------|
| **Samba** | Windows users, Office files | Windows, Linux, macOS | Kerberos/Password |
| **NFS** | Linux users, performance | Linux, macOS (limited) | Kerberos |

**Share Locations:**

| Share | Windows Path | Linux Path | Purpose |
|-------|-------------|------------|---------|
| Shared | \\dms.cyberinabox.net\shared | /mnt/shared | Common files |
| Home | \\dms.cyberinabox.net\username | /home/username | Personal files |
| Engineering | \\dms.cyberinabox.net\engineering | /mnt/engineering | Team files |

**Common Tasks:**

```bash
# Mount NFS share
sudo mount -t nfs -o sec=krb5 dms.cyberinabox.net:/exports/shared /mnt/shared

# Check permissions
ls -l filename

# Change permissions
chmod 644 filename

# Check your groups
groups

# Unmount share
sudo umount /mnt/shared
```

---

**Related Chapters:**
- Chapter 7: Password & Authentication (Kerberos)
- Chapter 11: Accessing the Network
- Chapter 13: Email & Communication
- Appendix C: Command Reference

**For Help:**
- Cannot access share: Check Kerberos ticket (`klist`)
- Permission denied: Contact admin for group membership
- File recovery: Email dshannon@cyberinabox.net
- Questions: Use AI assistant (llama/ai command)
