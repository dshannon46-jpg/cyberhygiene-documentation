# CyberHygiene Server Restoration Guide
## Post-Reboot Steps for dc1.cyberinabox.net

### Server Configuration
- **Hostname:** dc1.cyberinabox.net
- **Domain:** cyberinabox.net
- **Realm:** CYBERINABOX.NET
- **IP Address:** 192.168.1.10

---

## 1. Verify FIPS Mode After Reboot
```bash
fips-mode-setup --check
# Should show: FIPS mode is enabled
```

---

## 2. Mount Old Server Partitions
```bash
# The old server root should already be mounted at /mnt/oldroot
# Mount the old var partition:
sudo cryptsetup open /dev/rl_ds1/var oldvar
# Password: 11668252
sudo mount /dev/mapper/oldvar /mnt/oldvar
```

---

## 3. Install FreeIPA Server

### FreeIPA Configuration:
- Host: dc1.cyberinabox.net
- Domain: cyberinabox.net
- Realm: CYBERINABOX.NET
- Directory Manager Password: JWspsImmjYt4CLPwpP80y46HjfFJolteifgCkbiZ
- Admin Password: 65oiycLtYzEekTbqZ9bh+rSmqbdMKxvI

### Installation Command:
```bash
sudo dnf install -y freeipa-server freeipa-server-dns

sudo ipa-server-install \
    --realm=CYBERINABOX.NET \
    --domain=cyberinabox.net \
    --ds-password='JWspsImmjYt4CLPwpP80y46HjfFJolteifgCkbiZ' \
    --admin-password='65oiycLtYzEekTbqZ9bh+rSmqbdMKxvI' \
    --hostname=dc1.cyberinabox.net \
    --ip-address=192.168.1.10 \
    --setup-dns \
    --no-forwarders \
    --no-ntp \
    --unattended
```

### Restore FreeIPA Data (after fresh install):
```bash
# The backup is at: /mnt/oldvar/lib/ipa/backup/ipa-data-2025-12-18-13-52-07/
sudo ipa-restore /mnt/oldvar/lib/ipa/backup/ipa-data-2025-12-18-13-52-07/
```

---

## 4. Install Samba

```bash
sudo dnf install -y samba samba-client

# Create shared directory
sudo mkdir -p /srv/samba/shared
sudo chown root:root /srv/samba/shared
sudo chmod 2770 /srv/samba/shared

# Copy configuration
sudo cp /mnt/oldroot/etc/samba/smb.conf /etc/samba/

# Enable and start
sudo systemctl enable --now smb nmb
```

---

## 5. Install Suricata IDS

```bash
sudo dnf install -y suricata

# Copy configuration
sudo cp /mnt/oldroot/etc/suricata/suricata.yaml /etc/suricata/
sudo cp -r /mnt/oldroot/etc/suricata/rules /etc/suricata/

sudo systemctl enable --now suricata
```

---

## 6. Install Prometheus

```bash
# Install from EPEL or download binary
sudo dnf install -y prometheus2 || {
    # Manual install if not in repos
    cd /tmp
    curl -LO https://github.com/prometheus/prometheus/releases/download/v2.48.0/prometheus-2.48.0.linux-amd64.tar.gz
    tar xzf prometheus-2.48.0.linux-amd64.tar.gz
    sudo cp prometheus-2.48.0.linux-amd64/prometheus /usr/local/bin/
    sudo cp prometheus-2.48.0.linux-amd64/promtool /usr/local/bin/
}

# Copy configuration from old server
sudo cp /mnt/oldroot/etc/prometheus/prometheus.yml /etc/prometheus/

sudo systemctl enable --now prometheus
```

---

## 7. Install Grafana

```bash
# Add Grafana repo
sudo tee /etc/yum.repos.d/grafana.repo <<EOF
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
EOF

sudo dnf install -y grafana
sudo systemctl enable --now grafana-server
```

---

## 8. Install Graylog

```bash
# Graylog requires MongoDB and OpenSearch/Elasticsearch
# Copy configuration from old server after installing base packages

sudo dnf install -y mongodb-org graylog-server

# Copy configuration
sudo cp /mnt/oldroot/etc/graylog/server/server.conf /etc/graylog/server/

sudo systemctl enable --now graylog-server
```

---

## 9. Install Wazuh

### Wazuh Credentials:
- Admin: admin / e?CEvKPO?D?39LPuzVBbUVy7B3NOM2j6
- API: wazuh / Qa*wblhcqTolEK07ew2WA4WSX1CUSXFI

```bash
# Follow Wazuh installation guide or restore from config
# Configuration files are in /mnt/oldroot/etc/wazuh-*
# and /mnt/oldvar/ossec/

sudo systemctl enable --now wazuh-manager wazuh-indexer
```

---

## 10. Website (Already Restored)
The cyberinabox.net website has been restored to:
- Document root: /var/www/cyberhygiene/
- Config: /etc/httpd/conf.d/cyberhygiene.conf
- SSL certs: /etc/pki/tls/certs/commercial/

---

## Important Credentials Reference

### LUKS Encryption:
- General volumes: 11668252
- /Data only: !@#AFITgrad1986!@#

### FreeIPA:
- Directory Manager: JWspsImmjYt4CLPwpP80y46HjfFJolteifgCkbiZ
- Admin: 65oiycLtYzEekTbqZ9bh+rSmqbdMKxvI

### Backup Encryption Key:
mlP9X364SNPHCHxrJMc5JKyITfHpjwmRZ2apSzezAsw=

---

## Old Server Boot Issue Analysis
The old server failed to boot due to:
1. /boot/efi mount failure (likely partition or disk issue)
2. RPCSEC_GSS kernel module failure
3. RPC Bind failure (cascading from above)

FIPS mode was working correctly on the old server.
