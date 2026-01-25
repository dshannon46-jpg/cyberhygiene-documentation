# CyberInaBox Credentials
## Updated: 2026-01-18

**CONFIDENTIAL - Store Securely**

---

## FreeIPA (Identity Management)

| Service | Username | Password |
|---------|----------|----------|
| Directory Manager | cn=Directory Manager | JWspsImmjYt4CLPwpP80y46HjfFJolteifgCkbiZ |
| Admin (Kerberos) | admin | *Password needs reset - documented password not working* |

**URL:** https://dc1.cyberinabox.net/ipa/ui

---

## Grafana (Metrics Dashboard)

| Service | Username | Password |
|---------|----------|----------|
| Admin | admin | admin123 |

**URL:** http://dc1.cyberinabox.net:3000

---

## Wazuh (Security Monitoring)

### Wazuh Indexer Users

| Username | Password | Purpose |
|----------|----------|---------|
| admin | e?CEvKPO?D?39LPuzVBbUVy7B3NOM2j6 | Web UI and indexer admin |
| anomalyadmin | l6Z28a3cMGGFOdNcaQ9Z.*uAlmzCWjHv | Anomaly detection |
| kibanaserver | +PWtix.x2ognm2+IszLaEG9A.OafEEJP | Dashboard-indexer connection |
| kibanaro | j4rG5fAwr?1ee?+n4b6jW6FfiGkqe?wH | Read-only dashboard user |
| logstash | .7KMuStVP.ZvHaxk7mj?mT329Qh8w0tE | Filebeat CRUD operations |
| readall | m8mJgaVZkAW0*krN99Bytky5k1sgNqXt | Read access to all indices |
| snapshotrestore | 19d+D+d5ZX5oanK11pI1aNC24aklfuzp | Snapshot/restore operations |

### Wazuh API Users

| Username | Password | Purpose |
|----------|----------|---------|
| wazuh | Qa*wblhcqTolEK07ew2WA4WSX1CUSXFI | API access |
| wazuh-wui | a*NJOp4AEejIvZE1*Pi9vhpoV.rJusVE | Web UI API access |

---

## Backup Encryption

| Purpose | Key |
|---------|-----|
| Backup Encryption Key | mlP9X364SNPHCHxrJMc5JKyITfHpjwmRZ2apSzezAsw= |

---

## Service URLs

| Service | URL |
|---------|-----|
| FreeIPA | https://dc1.cyberinabox.net/ipa/ui |
| Grafana | http://dc1.cyberinabox.net:3000 |
| Prometheus | http://dc1.cyberinabox.net:9091 |
| Internal Dashboards | https://dc1.cyberinabox.net/dashboard/ |
| Public Website | https://cyberinabox.net |
| Webmail | https://webmail.cyberinabox.net |

---

## Notes

- FreeIPA admin Kerberos password may need to be reset via Directory Manager
- Grafana password was reset on 2026-01-18
- Internal dashboards restricted to 192.168.1.0/24 network
- AI Server: ai.cyberinabox.net (192.168.1.7) - DNS record added 2026-01-18
