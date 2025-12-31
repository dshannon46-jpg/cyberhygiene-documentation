# SSP v1.6 Update Requirements
**Date:** December 26, 2025
**Source:** System_Security_Plan_v1.5.docx (December 2, 2025)
**Target:** System_Security_Plan_v1.6.docx

---

## Updates Required

### 1. Document Control
- [ ] Update version from 1.5 to 1.6
- [ ] Update date from December 2, 2025 to December 26, 2025
- [ ] Add revision history entry:
  ```
  Version 1.6 | December 26, 2025 | D. Shannon | Added AI server, updated SPRS score, infrastructure totals
  ```

### 2. Executive Summary (Section 1)

#### 1.2 System Overview
- [ ] Update total systems: **4 → 5 systems** (added AI server)
- [ ] Update total CPU cores: **16 → 28 cores** (mix of x86-64 and ARM64)
- [ ] Update total RAM: **128 GB → 192 GB**
- [ ] Update total storage: **~9 TB → ~13 TB**

#### 1.4 Key Findings
- [ ] Update SPRS score: **Previous → 105/110 points (97.6%)**
- [ ] Update compliance status: **96% → 97.6% compliant**
- [ ] Add note: "SPRS assessment completed December 25, 2025"

### 3. System Description (Section 3)

#### 3.2 General System Description
Add new subsection between Domain Controller and Network Security:

```markdown
#### 2. AI Server (ai.cyberinabox.net - 192.168.1.7)

**System Information:**
- Hostname: ai.cyberinabox.net
- IP Address: 192.168.1.7/24
- Role: AI/ML Infrastructure Server, Local LLM Hosting
- OS: macOS Sequoia
- Security Status: ✓ Hardened with appropriate access controls

**Hardware Platform:**
- Model: Apple Mac Mini (2024)
- Chip: Apple M4 Pro System on Chip (SoC)
- CPU: 12-core (8 performance + 4 efficiency cores)
- GPU: 16-core integrated GPU
- Neural Engine: 16-core for ML acceleration
- RAM: 64 GB unified memory (LPDDR5X)
- Storage: 512GB - 2TB NVMe SSD with hardware encryption
- Architecture: ARM64 (Apple Silicon)

**Security Features:**
- ✓ Apple T2/M4 Secure Enclave with hardware encryption
- ✓ FileVault full-disk encryption enabled
- ✓ System Integrity Protection (SIP) enabled
- ✓ No external network access (air-gapped from internet)
- ✓ All communications proxied through HTTPS on dc1
- ✓ Firewall configured to block all inbound except from dc1

**AI/ML Capabilities:**
- Local large language model hosting (Ollama platform)
- Code Llama 7B model (3.8GB)
- Hardware-accelerated inference via Neural Engine
- HTTP API on port 11434 (localhost only, proxied via HTTPS)
- No external API dependencies (fully air-gapped)

**Service Architecture:**
```
User Browser (HTTPS)
    ↓
dc1.cyberinabox.net:443 (Apache HTTPS Proxy)
    ↓ (Internal HTTP)
ai.cyberinabox.net:11434 (Ollama API)
    ↓
Code Llama 7B Model
    ↓
Apple M4 Pro Neural Engine
```

**Use Cases:**
- Interactive system troubleshooting assistance
- Security log analysis
- Configuration guidance
- Compliance assistance
- Network diagnostics
```

#### 3.3 Network Topology
- [ ] Add AI server (192.168.1.7) to network diagram
- [ ] Add Ollama API port 11434 to service port matrix
- [ ] Add HTTPS proxy route from dc1 to AI server

### 4. Security Controls Assessment

#### Update Infrastructure References
Throughout all 14 control families, update references to:
- [ ] Total systems: 4 → 5
- [ ] Heterogeneous architecture: Note mix of x86-64 (Intel/AMD) and ARM64 (Apple Silicon)

#### SC-13: Cryptographic Protection
Add to evidence:
- [ ] "Apple T2/M4 Secure Enclave hardware encryption on AI server"
- [ ] "Hardware-accelerated encryption on Apple Silicon"

#### SC-28: Protection of Information at Rest
Add to evidence:
- [ ] "Hardware encryption: Apple T2/M4 Secure Enclave (AI server)"
- [ ] "FileVault full-disk encryption on macOS AI server"

### 5. Assessment Results

#### SPRS Score (if there's a section)
- [ ] Update current score: **→ 105 / 110 points (97.6%)**
- [ ] Update assessment date: **→ December 25, 2025**
- [ ] Update point breakdown:
  - Total possible: 226 points
  - Achieved: 220.5 points
  - SPRS normalized: 105/110

#### POA&M Summary
- [ ] Update to reflect 3 current gaps:
  1. IA-8: MFA for Non-Org Users (-3 points) - Target: Q1 2026
  2. IR-3: Incident Response Testing (-0.5 points) - Target: Q2 2026
  3. SI-8: Spam Protection (-2 points) - Target: Q1 2026

### 6. Appendices

#### Appendix A: System Inventory
- [ ] Add AI server to inventory table with full specifications

#### Appendix B: Network Diagram
- [ ] Update diagram to include AI server at 192.168.1.7
- [ ] Show HTTPS proxy connection from dc1 to AI server

#### Appendix C: Service Port Matrix
Add entries:
- [ ] Ollama API: 11434/TCP (localhost only)
- [ ] AI API Proxy: 443/TCP (HTTPS on dc1)

### 7. Data Classification

#### CUI Processing Systems
- [ ] Confirm whether AI server processes CUI (currently configured for administrative assistance only)
- [ ] Note: AI conversations may reference CUI systems, treat as CUI-adjacent

---

## Verification Checklist

After updates:
- [ ] All section numbers and cross-references updated
- [ ] Table of contents regenerated (Right-click → Update Field in Word)
- [ ] Page numbers correct
- [ ] No broken references
- [ ] Consistent terminology (e.g., "AI server" vs "AI/ML server")
- [ ] Version number in header/footer updated to 1.6
- [ ] Date updated throughout document
- [ ] Spell check completed
- [ ] Document saved as System_Security_Plan_v1.6.docx

---

## Notes

**Source Documents for Reference:**
- CyberHygiene Technical Specifications v1.3 (December 25, 2025)
- CyberHygiene SPRS Assessment v1.0 (December 25, 2025)
- Original SSP v1.5 (December 2, 2025)

**Major Changes:**
1. Added AI server infrastructure (heterogeneous x86/ARM environment)
2. Updated SPRS compliance score from ~96% to 97.6%
3. Updated infrastructure totals (systems, cores, RAM, storage)
4. Updated security controls evidence for Apple Silicon
5. Updated POA&M to reflect current 3 gaps

**Next Review:** March 31, 2026 (quarterly review cycle)
