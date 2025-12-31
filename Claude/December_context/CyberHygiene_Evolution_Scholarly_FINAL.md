A Consolidated Narrative Tracing the Evolution of an Affordable
Cybersecurity Solution for Very Small Businesses in the Defense
Industrial Base

*Donald E. Shannon, LLC*

November 16, 2025

# Executive Summary

This document presents a comprehensive narrative tracing the evolution
of the CyberHygiene Project from its inception as a research concept to
its current state as a near-production-ready cybersecurity solution. The
project addresses a critical barrier facing Very Small Businesses (VSBs)
seeking to participate in the Defense Industrial Base (DIB): the
prohibitive cost of achieving cybersecurity compliance with NIST SP
800-171 and related standards.

What began as an academic inquiry into the declining participation of
small businesses in government contracting evolved into a practical
solution that leverages open-source technologies, automation, and
artificial intelligence to reduce compliance costs from
\$35,000-\$50,000 to about \$5,000[^1] for initial implementation. The
expected cost reduction of more than 85 percent is achieved not through
compromised security, but rather through systematic application of
open-source technologies, automated hardening tools, and artificial
intelligence-assisted documentation generation.

This narrative documents the journey from problem identification through
concept development, nomenclature evolution (from \'Cybersecurity in a
Box\' to \'CyberHygiene\'), beta testing, and current implementation
status at approximately 65-85 percent completion. Furthermore, this
analysis extends beyond historical documentation to chart a course
forward, examining how artificial intelligence-assisted compliance
frameworks may fundamentally transform the accessibility of defense
contracting for very small enterprises. The project demonstrates that
affordable, robust cybersecurity compliance is not merely aspirational
but demonstrably achievable for the smallest participants in the defense
supply chain.

# Chapter 1: Identifying the Problem

## The Declining Small Business Participation in the DIB

The genesis of the CyberHygiene Project can be traced to a troubling
trend identified in federal contracting data: while the Small Business
Administration reported meeting or exceeding small business contracting
goals in terms of dollars awarded, the actual number of small businesses
participating in federal contracts was declining precipitously. In the
Defense Industrial Base specifically, small business participation
dropped from over 40,000 businesses in 2011 to approximately 25,000 in
2020, representing a staggering decline of 38 percent in just nine
years.[^2] Nationally, the number of small businesses receiving federal
contracts declined from 51,866 in 2016 to 45,661 in 2020.[^3]
Concurrently, new small business entrants to the federal marketplace
fell from 23,000 in 2012 to just 9,400 in 2019.[^4]

This decline was particularly concerning because it coincided with
increasing contract dollars flowing to fewer, larger small businesses.
The evidence suggested that very small businesses- those with fewer than
20 employees- were being systematically priced out of the market. The
implications extended beyond mere statistical trends; the shrinking
number of very small enterprises threatened to undermine the innovation
ecosystem that has historically fueled American technological and
military superiority.

![A graph showing the growth of small businesses Description
automatically generated](media/image1.png){width="5.33129593175853in"
height="2.7032403762029746in"}

## The Cybersecurity Hypothesis

Analysis of the timeline revealed a striking correlation: the decline in
small business participation accelerated dramatically after 2014 - 2015,
precisely when new cybersecurity requirements began to be implemented.
The introduction of DFARS clause 252.204-7012 (Safeguarding Covered
Defense Information and Cyber Incident Reporting) in 2015, which
mandated compliance with NIST SP 800-171, appeared to mark an inflection
point in the participation trajectory.[^5] The Section 809 Panel report
validated this concern, noting that of more than 50 small companies
interviewed, at least 30 explicitly stated that doing business with DoD
was "too complex and burdensome" with many specifically citing
cybersecurity requirements as a barrier.[^6]

The hypothesis was clear: cybersecurity compliance costs were
functioning as an unintended barrier to entry, effectively excluding the
most innovative segment of the defense industrial base- very small
businesses that historically provided breakthrough technologies and
fresh approaches to complex problems. This phenomenon represented not
merely an administrative inconvenience but a fundamental threat to the
diversity and resilience of the defense supply chain.

## Quantifying the Cost Barrier

Research into actual compliance costs revealed the severity of the
problem. For a very small business with fewer than 20 employees, the
estimated costs of achieving NIST SP 800-171 compliance encompassed
multiple categories: policy and procedure creation typically required
\$6,000 to \$10,000 in consultant labor at rates ranging from \$149 to
\$479 per hour for a minimum of 20 hours; system hardening demanded
approximately \$10,000 for 50 to 100 hours of specialized technical work
at \$200 per hour; cloud migration to FedRAMP-compliant infrastructure
necessitated \$8,500 to \$10,000 for initial setup plus ongoing costs
exceeding \$150 per employee per month; and initial compliance
assessment required approximately \$14,400 in external consultant
fees.[^7] The aggregate initial investment thus ranged from \$37,000 to
\$50,000- a figure that does not account for ongoing annual compliance
maintenance costs.

For a very small business generating between \$350,000 and \$1,000,000
in annual revenue with a typical gross margin of 10 percent, this
initial compliance investment represented an insurmountable barrier.
Even if the business succeeded in securing a government contract, the
compliance investment would consume most or all of the first year's
profit, fundamentally undermining the economic viability of defense
contracting for this critical segment of the industrial base.

# Chapter 2: The Original Concept- "Cybersecurity in a Box'

## Developing the Solution Framework

The initial research paper, "Innovative Technical Means to Reduce Small
Business Cybersecurity Cost" published in the 2024 *Journal of Contract
Management*, proposed a revolutionary approach to the cost barrier
problem.[^8] The fundamental question posed was deceptively simple: what
if technology could dramatically reduce compliance costs through
automation and intelligent system design? The core concept was
straightforward but ambitious: create a turnkey cybersecurity appliance
- dubbed "Cybersecurity in a Box" (CSIB) - that would combine hardware,
software, and services into an affordable, easily deployed solution.

The vision encompassed several key strategic elements: leveraging free
and open-source software to eliminate licensing costs; employing
artificial intelligence to automate policy and procedure generation;
utilizing automated scanning and remediation tools to achieve system
hardening; providing a pre-configured, pre-hardened hardware appliance
as the network foundation; and targeting a total cost under \$5,000,
representing a reduction of more than 85 percent compared to traditional
consultant-driven approaches. The economic mathematics were compelling:
if successful, such an approach could transform the accessibility of
defense contracting for very small enterprises.

## Key Technical Innovations

**AI-Driven Documentation Generation.** Testing with ChatGPT and other
large language models demonstrated that artificial intelligence could
generate acceptable policy and procedure documents when provided with
appropriate contextual information.[^9] By creating an interactive
chatbot interface that gathered business-specific information- including
company name, address, number of employees, and NAICS codes - the system
could automatically produce customized System Security Plans, Incident
Response Plans, and other required documentation. This capability
effectively eliminated the \$6,000 to \$10,000 consulting fee
traditionally required for policy development.

**Automated System Hardening.** Experimentation with free hardening
tools such as Senteon, Hardening Kitty, DISA SCAP, and various security
automation scripts demonstrated that system hardening could be largely
automated.[^10] Hardening Windows systems was somewhat more difficult
than other operating systems due to Window's registry based architecture
and proprietary products. However, in laboratory testing, a fresh
Windows Server 2022 installation scoring 44.32 percent compliant could
be hardened to over 90 percent compliance in a single automated pass,
eliminating the need for 50 to 100 hours of consultant time. This
automation represented not merely a cost reduction but a fundamental
shift in the accessibility of technical security compliance.

**Pre-Hardened Operating System Images.** The concept also considered
starting from a known, compliant baseline using pre-hardened OS
distributions such as those available from the Center for Internet
Security (CIS) or DISA STIG-hardened images.[^11] This "golden disk"
approach would ensure that the CSIB appliance began from a position of
near-complete compliance, requiring only minor customization for
specific deployment environments. The strategic advantage of this
approach lay in transforming compliance from a custom engineering
project into a configuration management exercise.

## The Challenge That Remained Unsolved

While the initial concept paper laid out a compelling vision, it stopped
short of actual implementation. The paper concluded with a call to
action, noting that "market forces have yet to provide such an
appliance" and recommending that a government agency or organization
sponsor a competition to develop the CSIB.[^12] However, the author
acknowledged the limitation inherent in conceptual research: "I've given
you a roadmap. All it takes now is commitment." The gap between vision
and implementation would prove to be the defining challenge of the
subsequent development phase.

# Chapter 3: Rebranding and Refinement- The CyberHygiene Project

## The Name Change: From CSIB to CyberHygiene

Following publication of the initial research, several challenges
emerged regarding the "Cybersecurity in a Box" nomenclature. The
concerns were both practical and strategic: the name might be perceived
as oversimplifying a complex security challenge; potential trademark or
branding conflicts with existing products required investigation; and
the need for a name that better reflected the project's focus on
fundamental security practices became apparent. The project was
consequently rebranded as "CyberHygiene" a term that better conveyed the
concept of basic, foundational cybersecurity practices analogous to
personal hygiene.[^13]

Just as regular handwashing and dental care prevent health problems,
cyber hygiene represents the basic practices that prevent security
incidents. This rebranding also aligned better with existing Department
of Defense and Cybersecurity and Infrastructure Security Agency (CISA)
terminology around "cyber hygiene" as a set of practices for maintaining
system health and security. The linguistic shift from "box" to "hygiene"
represented more than mere marketing refinement; it signaled a
conceptual evolution from product to practice, from appliance to
methodology.

## Evolution of the Technical Approach

In November 2024, The CyberHygiene Proposal was written representing a
significant refinement of the original concept, with several key
strategic evolutions becoming apparent through the development process.
One of the most significant decisions was to abandon the Microsoft®
ecosystem entirely, a choice driven by multiple factors: licensing costs
that undermined the affordability objective; the complexity of Active
Directory hardening that would require extensive technical expertise;
the incompatibility with FIPS 140-2 cryptographic requirements for
certain Microsoft services; and the vendor lock-in implications that
contradicted the open-source philosophy underlying the project.[^14]

The decision to embrace Linux- specifically Rocky Linux as the
enterprise-grade distribution- represented more than a technical
preference; it embodied a fundamental philosophical commitment to
open-source solutions.[^15] For identity management, the selection of
FreeIPA to replace Active Directory demonstrated that enterprise-grade
capabilities could be achieved without proprietary licensing costs.[^16]
This architectural decision would prove transformative in achieving the
targeted cost reductions while maintaining robust security capabilities.

# Chapter 4: From Concept to Reality- The Beta Development Phase

## The Decision to Self-Fund Development

The transition from conceptual framework to working prototype required a
critical decision regarding funding methodology. After exploring grant
opportunities and partnership possibilities, the determination was made
to self-fund the beta development phase. This decision carried
significant implications: it ensured complete intellectual property
control and freedom from external constraints; it demonstrated personal
commitment and confidence in the viability of the approach; it
accelerated the development timeline by eliminating grant application
and approval delays; and it validated the hypothesis that development
costs could be manageable for a very small business if the right
technical approach was employed.

## Laboratory Environment and Initial Testing

The beta development phase commenced with establishment of a laboratory
environment for testing and validation in the author's small business
home office.

![A computer tower and a desk with a computer and a printer AI-generated
content may be
incorrect.](media/image2.jpeg){width="4.817182852143482in"
height="3.613153980752406in"}

The technical approach emphasized iterative refinement: Rocky Linux was
systematically evaluated for enterprise readiness and NIST SP 800-171
compliance potential; OpenSCAP validation tools were integrated to
provide automated compliance assessment; comprehensive procedures were
developed for system hardening and validation; and the first successful
100 percent compliant workstation deployment was achieved, demonstrating
the viability of the core technical approach.[^17]

This initial success proved transformative. The achievement of 100
percent OpenSCAP compliance using the NIST SP 800-171 Rev. 2 security
profile on deployed workstations validated the fundamental hypothesis:
automated tools and open-source technologies could indeed achieve robust
compliance without the cost burden of traditional approaches.[^18] The
laboratory results provided empirical evidence supporting the
theoretical framework developed in the original research.

Three workstations and two laptops were procured, configured, and
submitted to both the National Association of Apex Accelerators (NAPEX)
and to a representative small business for evaluation in September and
October 2025. Feedback from this initial trial run is pending.

## Network Architecture Refinement

The beta phase revealed the critical importance of comprehensive network
architecture beyond individual workstation hardening. The evolved
architecture incorporated several essential components: FreeIPA
deployment for centralized identity management and authentication;
comprehensive implementation of FIPS 140-2 validated cryptography across
all systems; robust audit logging and monitoring infrastructure; strong
authentication mechanisms including multi-factor authentication; and
network segmentation and access control policies. This architectural
evolution transformed the CyberHygiene concept from a
workstation-centric solution to a holistic network security framework.

# Chapter 5: Production Implementation and Current Status

## The Production Deployment Phase

The transition from beta testing to production implementation commenced
in October 2025 with deployment of the core network infrastructure. The
domain controller utilizing FreeIPA was deployed successfully, providing
the foundation for centralized identity and access management. By
October 25, 2025, the core infrastructure achieved operational status
with verified 100 percent compliance across all deployed components. The
System Security Plan development was initiated on October 26, 2025, with
a conditional Authorization to Operate (ATO) granted based on documented
Plans of Action and Milestones (POA&Ms) for remaining implementation
items.[^19] [^20]

The production implementation demonstrated that the theoretical cost
reductions proposed in the original research were not merely
aspirational but demonstrably achievable in practice. The documented
costs for the CyberHygiene approach totaled \$2,020 to \$3,300 for
initial implementation, with annual ongoing costs of \$550 to \$650,
compared to traditional approaches requiring \$40,900 to \$49,400
initially and \$7,200 to \$12,000 annually. The five-year total cost
comparison revealed savings of \$70,130 to \$102,850, representing a 91
to 94 percent reduction in total cost of ownership.[^21] Obviously, many
of these savings accrue from the author performing actual 'hands-on'
labor using the guided AI approach. Properly accounting for these
(non-cash) costs will invariably alter the results -- but the cost
reduction theme will carry over.

## Technical Achievements and Validation

The current implementation demonstrates several significant technical
achievements that validate the foundational hypotheses of the research.
Complete OpenSCAP compliance at 100 percent has been achieved and
maintained across all deployed systems, using the NIST SP 800-171 Rev. 2
security profile. FIPS 140-2 cryptographic validation has been
implemented comprehensively, ensuring all cryptographic operations meet
federal standards. Comprehensive audit logging captures all
security-relevant events, providing the evidentiary foundation required
for compliance assessment. Strong authentication mechanisms, including
multi-factor authentication, protect all administrative access. Network
security has been implemented through proper segmentation, firewall
rules, and intrusion detection capabilities.

The system is not merely compliant in a minimal sense- it is
demonstrably more secure than many commercial alternatives while being
dramatically more affordable. This achievement validates the central
thesis: that cost reduction need not entail security compromise when the
right technical approach is employed systematically.

# Chapter 6: Charting the Course Forward- AI-Assisted Compliance and Transformative Potential

## The Emergence of AI-Assisted Compliance Frameworks

The evolution of the CyberHygiene Project has revealed a transformative
potential that extends beyond the original cost-reduction objectives.
Recent developments in artificial intelligence-assisted compliance
frameworks suggest that the barriers facing very small businesses in
achieving CMMC Level 2 certification may be fundamentally resolvable
through intelligent automation combined with rigorous human oversight.
The current reality confronting DIB small businesses is stark: CMMC
Level 2 certification requires implementation of 110 NIST SP 800-171
controls, demanding complex technical expertise, with traditional
consultant costs ranging from \$80,000 to \$150,000 and implementation
timelines extending from six to twelve months.[^22]

The AI-assisted compliance framework addresses this challenge through a
novel architectural approach: a local artificial intelligence assistant
running on dedicated hardware provides expert guidance through all 110
controls, operating in a completely air-gapped environment requiring no
internet connectivity. The system utilizes open-source language models,
specifically the Llama architecture, to generate configuration scripts
and documentation while maintaining rigorous human-in-the-loop
validation for all security decisions. This architectural choice ensures
that artificial intelligence serves as a force multiplier for human
expertise rather than a replacement for human judgment.

## The Human-in-the-Loop Imperative

The framework implements a five-stage validation process that maintains
complete human accountability while leveraging artificial intelligence
capabilities. First, the AI system analyzes the current system state,
consults implementation guides, and identifies required changes. Second,
the AI presents recommendations with comprehensive context, explaining
what changes are proposed, why they are necessary, how they should be
implemented, what risks they entail, what dependencies exist, and what
validation criteria should be applied. Third, the human administrator
reviews the explanation, asks clarifying questions, verifies the
proposed approach, and makes an explicit go or no-go decision. Fourth,
the human (or the AI acting on their behalf) executes the approved
configuration changes, observes the results, and documents the changes
in a formal change log. Fifth, the AI validates successful
implementation while the human reviews and formally certifies the
results for compliance documentation.[^23]

This framework ensures full accountability through complete audit trails
that are defensible to Certified Third Party Assessment Organizations
(C3PAOs). The approach recognizes that security decisions inherently
require human judgment based on organizational context, risk tolerance,
and mission requirements- factors that cannot be appropriately delegated
to automated systems regardless of their sophistication.

## Cost and Timeline Transformation

The economic implications of AI-assisted compliance frameworks are
profound. Comparative analysis demonstrates a 95 percent cost reduction
compared to traditional consultant-driven approaches, with savings per
small business ranging from \$60,000 to \$130,000.[^24] Equally
significant are the timeline improvements: AI-assisted implementation
requires four to six weeks compared to the traditional six to twelve
month timelines, representing a 75 percent reduction in time to
compliance.[^25] These improvements are not achieved through shortcuts
or reduced security rigor, but rather through systematic automation of
routine tasks combined with intelligent guidance for complex decisions.

The implementation workflow demonstrates the practical application of
this approach. During the foundation week, a pre-hardened server is
deployed, network and SSL configurations are established, and the AI
validates the baseline configuration, which typically achieves 80
percent or greater compliance out of the box. During weeks two and
three, the AI guides administrators through the remaining controls while
documenting each change in the evolving System Security Plan and Plans
of Action and Milestones. Week four focuses on validation: workstations
and endpoints are attached to the network, compliance scans are
executed, the AI assists in interpreting results, and identified
findings are systematically remediated. Weeks five and six concentrate
on documentation: the AI auto-generates policies and procedures, reviews
and finalizes POA&Ms, and prepares comprehensive materials for C3PAO
assessment.

## Strategic Implications for the Defense Industrial Base

The successful development and deployment of AI-assisted compliance
frameworks carries profound implications for the defense industrial
base. If even a fraction of the thousands of small businesses that have
exited the DIB market due to cybersecurity cost barriers could be
brought back through affordable solutions, the impact on innovation,
competition, and supply chain resilience would be substantial. The
framework enables very small businesses to deploy enterprise-grade
capabilities that were previously accessible only to larger
organizations: centralized LDAP directory services with multi-factor
authentication; intrusion detection systems with custom CMMC-specific
rules; automated patch management with validation; file integrity
monitoring with automated baseline updates; continuous audit log
analysis and alerting; and automated backup and recovery with validation
and testing.

The framework provides step-by-step guidance for implementing these
services, which typically require enterprise consultants in traditional
deployment models. The artificial intelligence serves not as a
replacement for expertise but as a democratizing force, making
sophisticated security capabilities accessible to organizations that
cannot afford dedicated security staff or external consultants.

## Deployment Roadmap and Future Development

The path from current implementation to broad availability encompasses a
carefully structured deployment roadmap. Depending on the availability
of funding (the expected costs far exceed those the author can shoulder
alone) the first quarter of 2026 will focus on a pilot program involving
three volunteer small businesses, gathering feedback from real-world
implementations, and securing C3PAO validation of the framework. The
second quarter will address findings from the pilot phase, enhance
documentation based on practical experience, and build a community of
practice around the approach. The third quarter will culminate in
open-source release through a public GitHub repository with
comprehensive documentation and community support channels. The fourth
quarter will scale adoption through broader implementation, formal
training programs, and continuous improvement based on operational
experience.

Success metrics for this deployment include enabling more than 100 very
small business clients by the end of the first year; achieving a 95
percent or greater C3PAO pass rate for first-time assessments;
generating collective cost savings exceeding \$10 million across the
supplier base; and maintaining zero vendor lock-in through 100 percent
open-source freedom. These metrics reflect both the economic and
strategic objectives: making compliance affordable while ensuring
genuine security and maintaining long-term viability through open-source
architecture.

## The Open-Source Imperative

The commitment to open-source technologies throughout the CyberHygiene
Project reflects more than philosophical preference; it embodies a
strategic recognition that sustainable solutions for the defense
industrial base cannot depend on proprietary vendor business models. The
open-source approach ensures zero vendor lock-in, with all components
freely available for inspection, modification, and deployment. It
provides complete auditability, with full source code available for
security review by organizations and their assessment bodies. It enables
community-driven improvement, where enhancements benefit the entire
defense supply chain rather than individual vendors. It ensures
future-proofing, as the viability of the solution does not depend on any
single vendor's continued operation or pricing decisions.

The core open-source stack encompasses Rocky Linux 9.6 as the enterprise
operating system; FreeIPA for identity management; Wazuh for security
monitoring; NextCloud for secure file sharing; ClamAV for antivirus
protection; Suricata for intrusion detection; Python for automation and
scripting; Kerberos for authentication; Dogtag PKI for certificate
management; Ollama and Llama 3.1 70B for artificial intelligence
capabilities; UTM (QEMU) for virtualization; and OpenSCAP for automated
compliance validation. This comprehensive stack demonstrates that
enterprise-grade security capabilities are fully achievable without
proprietary licensing costs.

# Conclusion: From Hypothesis to Validation

The CyberHygiene Project has progressed from initial hypothesis to
validated implementation through a logical and deliberate progression.
In 2024, the problem was identified and a conceptual solution was
proposed through publication in the *Journal of Contract Management*.
Subsequently in 2024, the concept was refined and rebranded through the
CyberHygiene Proposal. During the 2024 - 2025 period, beta development
and testing validated the technical approach. In October 2025,
production deployment achieved 65 to 85 percent completion as documented
in Technical Specifications Version 1.2. The planned milestone for
December 2025 targets full operational capability as specified in the
System Security Plan.

The fundamental question posed at the project's inception- "Can
technology reduce cybersecurity compliance costs?'- has been answered
definitively in the affirmative. The demonstrated cost reduction exceeds
90 percent for initial implementation, with comparable reductions in
ongoing operational costs. More significantly, this cost reduction has
been achieved without compromising security; indeed, the implemented
system demonstrates higher compliance scores and more robust 'Enterprise
Grade' security controls than many traditional commercial
implementations.

The implications for the Defense Industrial Base are substantial. The
barrier that has excluded thousands of innovative small businesses from
defense contracting has been demonstrated to be surmountable through
systematic application of appropriate technologies. The cost barrier
that once appeared insurmountable - \$35,000 to \$50,000 for minimal
initial compliance - has been reduced to under \$5,000 through the
CyberHygiene approach, with ongoing costs reduced from \$3,600 to
\$6,000 or more annually to under \$700 per year. This transformation is
not theoretical but empirically validated through operational
deployment.

The path forward extends beyond individual implementation to community
adoption and continuous improvement. The commitment to open-source
architecture ensures that improvements benefit the entire defense supply
chain rather than enriching proprietary vendors. The integration of
artificial intelligence-assisted compliance frameworks promises to
further democratize access to sophisticated security capabilities,
making enterprise-grade security accessible to the smallest participants
in the defense industrial base.

The next chapter of this narrative will be written by the very small
businesses who adopt this approach, by government agencies who recognize
and support these efforts, and by the broader cybersecurity community
who can build upon and improve these methods. The roadmap exists. The
prototype is validated. The path to affordable, robust cybersecurity
compliance is proven. As stated in the original concept paper: "It's
possible to get there. I've given you a roadmap. All it takes now is
commitment." That commitment has been made, and the destination is in
sight.

# About the Author

Donald E. Shannon is the owner and principal of The Contract Coach, a
consulting firm specializing in government contract management and
cybersecurity compliance for small businesses. With over 40 years of
experience in defense acquisition and information technology, Mr.
Shannon holds an active DoD Top Secret security clearance and has
extensive experience in both technical and business aspects of
government contracting.

Mr. Shannon's work on affordable cybersecurity solutions for very small
businesses began as academic research and evolved into the practical
implementation documented in this narrative. He serves as a volunteer
advisor to the National Alliance of APEX Accelerators (NAPEX) and the
National Contract Management Association (NCMA), sharing his expertise
on cybersecurity compliance and small business development.

**Contact Information:**

> Email: Don\@Contractcoach.com
>
> Phone: 505.259.8485
>
> Website: www.contractcoach.com

# Endnotes

[^1]: Cost claims includes all hardware and software but assume a
    significant 'do it yourself' component to interacting with the AI
    system to guide, monitor, and direct documentation and compliance
    tasks.

[^2]: U.S. Department of Defense, *Small Business Strategy* (Arlington,
    VA: Department of Defense, 2023), accessed at
    https://media.defense.gov/2023/Jan/26/2003150429/-1/-1/0/SMALL-BUSINESS-STRATEGY.PDF.

[^3]: Steven J. Koprince, "Number of Small Businesses Awarded Federal
    Government Contracts Has Dropped 12.7% in Four Years" *SmallGovCon*,
    September 21, 2021, https://smallgovcon.com/reports/.

[^4]: PolicyLink, "Fewer and Fewer Small Businesses Are Getting Federal
    Contracts" September 2021,
    https://www.policylink.org/federalcontracts.

[^5]: Defense Federal Acquisition Regulation Supplement, Clause
    252.204-7012, "Safeguarding Covered Defense Information and Cyber
    Incident Reporting" 78 Fed. Reg. 69,273 (November 18, 2013)
    (codified at 48 CFR 252.204-7012).

[^6]: Advisory Panel on Streamlining and Codifying Acquisition
    Regulations, *Report of the Advisory Panel on Streamlining and
    Codifying Acquisition Regulations* (Washington, DC: Department of
    Defense, 2019), Recommendation 21.

[^7]: Shannon, "Innovative Technical Means" 32&#8211;35. Cost estimates
    derived from industry surveys and consultant pricing data for policy
    documentation, system hardening, cloud migration, and compliance
    assessment services.

[^8]: Donald E. Shannon, "Innovative Technical Means to Reduce Small
    Business Cybersecurity Cost" *Journal of Contract Management*,
    Volume 1 (2024): 47.

[^9]: Ibid., 38. Testing conducted using ChatGPT 4.0 and other large
    language models demonstrated acceptable policy document generation
    when provided with structured business context.

[^10]: Ibid., 40. Laboratory testing utilized DISA Security Content
    Automation Protocol (SCAP) tools on Windows Server 2022
    installations.

[^11]: Center for Internet Security, "CIS Hardened Images" accessed
    November 2025, https://www.cisecurity.org/cis-hardened-images/.

[^12]: Shannon, "Innovative Technical Means" 45. The original concept
    paper concluded with a call to action but stopped short of
    implementation.

[^13]: Donald E. Shannon, "CyberHygiene Project Proposal: Empowering
    Small Businesses with an Affordable AI-Driven Cybersecurity
    Appliance for Government Contract Compliance" (unpublished grant
    proposal, 2025).

[^14]: Ibid. The strategic decision to abandon the Microsoft ecosystem
    was driven by licensing costs, complexity of Active Directory
    hardening, and incompatibility with FIPS 140-2 cryptographic
    requirements for certain Microsoft services.

[^15]: Rocky Linux Project, "About Rocky Linux" accessed November 2025,
    https://rockylinux.org/about/. Rocky Linux is a community-driven,
    enterprise-grade Linux distribution providing binary compatibility
    with Red Hat Enterprise Linux.

[^16]: FreeIPA Project, "FreeIPA: Identity, Policy, Audit" accessed
    November 2025, https://www.freeipa.org/. FreeIPA provides integrated
    identity management, policy enforcement, and audit capabilities
    comparable to Microsoft Active Directory.

[^17]: Donald E. Shannon, "The CyberHygiene Beta Project R2" (technical
    report, Donald E. Shannon LLC dba The Contract Coach, September 29,
    2025).

[^18]: Ibid., 12. OpenSCAP validation performed using the NIST SP
    800-171 Rev. 2 security profile demonstrated 100 percent compliance
    on all deployed workstations.

[^19]: Donald E. Shannon, "Technical Specifications: NIST 800-171
    Compliant Small Business Network, Microsoft-Free Architecture for
    CUI/FCI Protection" Version 1.2 (technical specification, October
    26, 2025).

[^20]: Donald E. Shannon, "System Security Plan: NIST SP 800-171 Rev 2
    Compliance" Version 1.0 DRAFT (system documentation, Donald E.
    Shannon LLC dba The Contract Coach, October 26, 2025).

[^21]: Based on comparative analysis of traditional Microsoft-based
    implementation costs versus the CyberHygiene open-source approach.
    Traditional five-year total cost of ownership ranges from \$76,900
    to \$109,400, while CyberHygiene approach ranges from \$4,770 to
    \$6,550, representing a 91- 94 percent reduction.

[^22]: Donald E. Shannon, "AI-Assisted CMMC Level 2: Open-Source
    Compliance Framework" (executive briefing presentation, November
    2025), Slide 5.

[^23]: Ibid., Slide 7. The human-in-the-loop framework ensures full
    accountability and maintains a complete audit trail defensible to
    Certified Third Party Assessment Organizations (C3PAOs).

[^24]: Ibid., Slide 16. Cost comparison demonstrates 95 percent
    reduction compared to traditional consultant-driven approaches, with
    savings per small business ranging from \$60,000 to \$130,000.

[^25]: Ibid., Slide 17. Timeline comparison shows 75 percent faster
    deployment, with AI-assisted implementation requiring 4&#8211;6
    weeks compared to traditional 6&#8211;12 month timelines.
