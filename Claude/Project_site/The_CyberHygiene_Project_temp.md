![A wireframe of a person AI-generated content may be
incorrect.](./media/image1.jpg){width="6.5in" height="4.875in"}

![A logo of a river and mountains AI-generated content may be
incorrect.](./media/image2.png){width="3.732946194225722in"
height="1.2038965441819773in"}

Donald E. Shannon LLC dba The Contract Coach

Albuquerque NM, 87120

September 29, 2025

## Foreword

This document is a compilation of writings made across the past two
years edited and revised where needed to reflect the current project's
direction and progress. The CyberHygeine Project is an ongoing effort,
and I fully expect some of the below to need a second or third revision
before I finally 'Get it Right".

Kudos to my friends and colleagues in the National Contract Management
Association (NCMA) and the National Alliance of Apex Accelerators
(NAPEX) for their encouragement and moral support these past two plus
years.

Much of what I describe or discuss in the following may be more
technical than many readers are comfortable with. That is to be expected
when diving into a very nuanced and technically detailed discussion --
but there are countless tools -- including AI -- that will parse what is
said into more human friendly terms if need be.

Cost is a major factor in doing this project -- if cost was not an issue
most small businesses would simply write a check and be done with it.
That is assuredly one approach. I take a different tack -- I look for
equally effective solutions that are free but may require a bit of my
time or brain power to implement. In many cases this project is the
heavy lifting for cyber compliance so follow the breadcrumbs.

When I consider cost, I also consider space and electrical consumption.
The products and solutions I offer are all selected with that as a
significant factor -- because we don't all have a server rack in our
office.

## AI Disclaimer

Portions of this article (especially tabular data) have been obtained
from Grok, ChatGPT and Llama LLM AI's. All AI material was obtained with
references to government data sources or published works and the below
is therefore copiously documented with the applicable footnotes and
references which -- in turn -- have been vetted by the author. AI
content has been Validated by reference checking, edited for
readability, and supplemented with commentary by the author to provide
added context.

# Table of Contents {#table-of-contents .TOC-Heading}

[Foreword 2](#foreword)

[AI Disclaimer 2](#ai-disclaimer)

[Chapter 1. Background 6](#background)

[Chapter 2. Profile of a Typical DIB Very Small Business
7](#profile-of-a-typical-dib-very-small-business)

[The VSB Price Tag for the Traditional Cybersecurity Approach
7](#the-vsb-price-tag-for-the-traditional-cybersecurity-approach)

[What is a Very Small Business? 7](#what-is-a-very-small-business)

[DIB VSB Services or Products 8](#dib-vsb-services-or-products)

[VSB Work Environment 9](#vsb-work-environment)

[VSB Staffing 11](#vsb-staffing)

[Financial Profile of Very Small Businesses
12](#financial-profile-of-very-small-businesses)

[VSB Average Annual Revenue 12](#vsb-average-annual-revenue)

[VSB Average Annual Operating Costs
12](#vsb-average-annual-operating-costs)

[VSB Average Annual Profit: 13](#vsb-average-annual-profit)

[VSB IT and Cybersecurity Expenses
14](#vsb-it-and-cybersecurity-expenses)

[Total Estimated Costs for Cybersecurity Controls
16](#total-estimated-costs-for-cybersecurity-controls)

[Section Summary 17](#section-summary)

[Chapter 3. Typical DIB VSB Network 19](#typical-dib-vsb-network)

[VSB Network Description and Typology
19](#vsb-network-description-and-typology)

[VSB Network Infrastructure 19](#vsb-network-infrastructure)

[Hardware and Operating Systems 20](#hardware-and-operating-systems)

[Typology - Domain vs. Workgroup
22](#network-typology---domain-vs.-workgroup)

[VSB Security Practices 23](#vsb-security-practices)

[Anti-Malware and Endpoint Management
23](#anti-malware-and-endpoint-management)

[Cloud-Based Services 24](#cloud-based-services)

[Backup and Recovery 24](#backup-and-recovery)

[Choosing a Network Typology -- the Pros and Cons 24](#_Toc210634866)

[On Premises or Virtual Server 24](#on-premises-or-virtual-server)

[Monthly Subscription Fees vs. Long-Term Maintenance
26](#monthly-subscription-fees-vs.-long-term-maintenance)

[Scalability and Flexibility 26](#scalability-and-flexibility)

[Virtual Device (or Desktop) Interfaces (VDI)
27](#virtual-device-or-desktop-interfaces-vdi)

[Chapter 4. Building a VSB Cyber Compliant Workstation
29](#building-a-vsb-cyber-compliant-workstation)

[Ditching Microsoft for Open-Source Solutions
29](#ditching-microsoft-for-open-source-solutions)

[If not Windows, then what? 30](#if-not-windows-then-what)

[Selecting the Hardware and Software
32](#selecting-the-hardware-and-software)

[No Microsoft Windows. 32](#no-microsoft-windows.)

[Choosing the Right Linux Distribution
33](#choosing-the-right-linux-distribution)

[Building the Beta Systems 33](#building-the-beta-systems)

[Beta System Hardware 33](#beta-system-hardware)

[Software 35](#software)

[End Point Configuration and Hardening
36](#end-point-configuration-and-hardening)

[The origin of vulnerabilities. 37](#the-origin-of-vulnerabilities.)

[Endpoint Hardening 38](#endpoint-hardening)

[Basic Input-Output Systems (BIOS) 38](#basic-input-output-systems-bios)

[Operating Systems -- Microsoft Windows
38](#operating-systems-microsoft-windows)

[Hardening Kitty 39](#hardening-kitty)

[Windows Debloat. 39](#windows-debloat.)

[Senteon 39](#senteon)

[Linux 40](#linux)

[Linux Application Hardening 40](#linux-application-hardening)

[Correcting Vulnerabilities and Misconfigurations.
41](#correcting-vulnerabilities-and-misconfigurations.)

[Baseline Maintenance 41](#baseline-maintenance)

[Patching 42](#patching)

[Vulnerability Scanning 43](#vulnerability-scanning)

[Chapter 5. Level 1 (Foundational) Network Approach
45](#level-1-foundational-network-approach)

[Level 1 Domain Controller 45](#level-1-domain-controller)

[Level 1 Components and Services 46](#level-1-components-and-services)

[Network Hardening Overview 46](#network-hardening-overview)

[Level 1 Compliance 47](#level-1-compliance)

[Chapter 6. Level 1 Laboratory Implementation
49](#level-1-laboratory-implementation)

[Server 49](#server)

[Connectivity 51](#connectivity)

[Firewall / Router 52](#firewall-router)

[Network Switch 52](#network-switch)

[Chapter 7. Designing a Representative Level 1 Lab Network
53](#designing-a-representative-level-1-lab-network)

[Network architecture and design considerations
53](#network-architecture-and-design-considerations)

[Firewall/Router 54](#firewallrouter)

[Switches 55](#switches)

[Domain Controller 56](#domain-controller)

[Option 1 -- Synology NAS 56](#option-1-synology-nas)

[Option 2 -- Linux Server 57](#option-2-linux-server)

[The Essential Nature of Third-Party Service Providers
57](#the-essential-nature-of-third-party-service-providers)

[Endpoint Management Software/Services
57](#endpoint-management-softwareservices)

[BitDefender Gravity Zone 58](#bitdefender-gravity-zone)

[Open VPN 59](#open-vpn)

[Cloudflare 59](#cloudflare)

[User Authentication and Multi-Factor Identification
61](#user-authentication-and-multi-factor-identification)

[pfSense 61](#pfsense)

[Suricata 62](#suricata)

[Summary of Third Party Software and Services
62](#summary-of-third-party-software-and-services)

[Chapter 8. Level 2 Authentication Upgrade
64](#level-2-authentication-upgrade)

[Network Hardening Overview 64](#network-hardening-overview-1)

[How Hardening Enhances Identity Management
64](#how-hardening-enhances-identity-management)

[Updated Gaps and Targeted Actions for Level 2 IA Compliance
65](#updated-gaps-and-targeted-actions-for-level-2-ia-compliance)

[Implementation Roadmap and Compliance Tips
65](#implementation-roadmap-and-compliance-tips)

[Chapter 9. Rocky Linux Installation and Configuration
67](#rocky-linux-installation-and-configuration)

[Installing Rocky Linux 9.6 67](#installing-rocky-linux-9.6)

[Post Installation 75](#post-installation)

[Chapter 10. Performing a Client Level 1 (Foundational) Cyber Assessment
78](#performing-a-client-level-1-foundational-cyber-assessment)

[Chapter 11. Building Out the Level 1 Network: Going Beyond the
Solopreneur
79](#building-out-the-level-1-network-going-beyond-the-solopreneur)

[Chapter 12. Domain Controller (Identity and Access Management
80](#domain-controller-identity-and-access-management)

[Primary Recommendation: 80](#primary-recommendation)

[Overview 82](#overview)

[Scope and Inventory Assets 82](#scope-and-inventory-assets)

[Compliance with FAR 52.204-21 82](#compliance-with-far-52.204-21)

[Roles and Responsibilities: 83](#roles-and-responsibilities)

[Attachments 84](#attachments)

[Certification of Compliance 84](#certification-of-compliance)

# Background {#background .Chapter}

The CyberHygiene project is a private research effort being conducted by
Donald E. Shannon LLC dba The Contract Coach. It began with the creation
and publication of an article created for Volume 1 of the Journal of
Contract Management published in 2024. In that article, *[Technical Ways
to Lower Cybersecurity Costs for Small Businesses]{.ul}* I examined the
trend of decreasing participation by very small businesses [^1](VSB) in
the government contracting market and surmised that there appeared to be
a correlation between increasingly more stringent (and likely to be
implemented) cybersecurity measures and the decline in VSB
participation.

In that article I stated the situation could be improved significantly
should a commercial entity choose to preconfigure and market a 'turnkey'
solution at an affordable price point. Such a system would leverage
existing tools and technologies -- many of them free and open source --
to produce a dedicated secure environment for the small business. Much
of the effort was seen as being accomplished by automated tools to
properly configure the hardware and produce the necessary policies and
procedures from standardized templates. This approach was deemed
possible by virtue of a very narrowly defined segment of users with many
common attributes, environments, and needs.

The project has been briefed to the national leadership of the National
Apex Accelerator Alliance (NAPEX) and the National Contract Management
Association (NCMA). At present the effort is focused on Solopreneurs
(one person companies) with an interest in contracting with the Federal
Government who need to meet the security requirements for Federal
Contract Information (FCI).

Ultimately this core effort will be enhanced and expanded to cover VSBs
at the FCI level and ultimately to prepare the same entities for
Controlled Unclassified Information (CUI) and CMMC requirements.

# Profile of a Typical DIB Very Small Business {#profile-of-a-typical-dib-very-small-business .Chapter}

A recent survey I conducted[^2] of Defense Industrial Base (DIB)
participants showed that the majority of the contractors (about 78
percent) were very small businesses (VSBs) with 10-20 employees. I also
determined that VSB participation in the DIB was declining, new entrants
to the market were declining, and a potential factor in that decline was
a cost barrier in the form of cybersecurity compliance requirements.

The Defense Federal Acquisition Regulations (DFARS) clause 252.204-7020
requires a summary score for a self-conducted 'Basic Assessment' to be
posted in the Supplier Performance Risk System (SPRS) to be eligible to
propose for-let alone be awarded- a government contract.

## The VSB Price Tag for the Traditional Cybersecurity Approach 

I conducted a study of the estimated cybersecurity costs for new
entrants to the DIB, in fall 2022 using AI and other related research
tools. This paper provides an overview of the typical DIB small business
profile for companies with less than 20 employees, including
demographics, revenue, employee size, and cybersecurity maturity based
on that study. My conclusion was meeting the basic assessment
requirement using the existing methods would cost somewhere around
\$38,000 to \$50,000 and constituted a major barrier to VSB
participation in the DIB. I also surmised:

"The first step is defining a narrow use case for the Cyberhygiene
Project through assumptions and requirements definitions. This will lead
to creating a consensus SB office and network configuration that can
comply with the government's cybersecurity requirements."

This paper addresses the above requirement by identifying the target
audience (i.e., VSBs) and then proposing a system architecture and other
products needed to prepare them for the DFARS basic cybersecurity
assessment on a budget of +/- \$5,000 vs a more traditional approach
costing \$35,000 to \$50,000.

## What is a Very Small Business? 

The issue concerning cybersecurity cost is driven by not only the
overall cost, but also by the fact that the costs are largely one-time
expense that must be met before the VSB is eligible for their first
contract. The nature of the business (small size, modest contract value,
modest profit margins) means the initial expenses will likely need to be
considered a capital investment as opposed to a recoverable contract
expense. Consequently, lowering the cost of entry to the DIB is likely
to have a significant impact on VSB participation.

The target audience for the Cyberhygiene project is provided in the
below:

  -----------------------------------------------------------------------
  Category               Typical Small Business Profile
  ---------------------- ------------------------------------------------
  Number of Employees    0 -10 employees typical. maximum of 15

  Annual Net Revenue     Less than \$1.5 million

  Industry               Various industries supporting the DoD and
                         government agencies

  Ownership              Primarily Sole Proprietorship or Partnership
                         [^3], [^4]

  Legal Structure        Limited Liability Corporation or S-Corporation
                         [^5]

  IT Infrastructure      Typically, local area network using Wi-Fi
                         connections. Progressing from an ad-hoc
                         workgroup to a domain-controlled network as size
                         increases. Predominately cloud-based management
                         or third-party managed by MSP. Some on-premises
                         servers especially where concerns for security
                         and confidentiality ate paramount.

  OT Infrastructure      Little OT infrastructure evident in
                         knowledge-based entities (engineering, R&D, and
                         consulting) although some OT assets may exist in
                         engineering (prototyping) and manufacturing.
  -----------------------------------------------------------------------

  : Table Summary of Very Small Business Characteristics

### DIB VSB Services or Products

Many DIB contractors provide commercial off-the-shelf products that are
not covered by the cybersecurity requirements of the FAR (52.204-21) or
DFARS (252.204-7012) and are consequently not of interest. The DIB
Contractors of primary interest[^6], are:

1\. [Engineering and technical services]{.ul}: These businesses may
provide a range of engineering and technical services to support
military and defense programs, such as systems integration, testing, and
evaluation.

2\. [Software development]{.ul}: Many small DIB businesses specialize in
software development for military applications, including data analytics
tools, cybersecurity solutions, and other advanced technology systems.

3\. [Research and development]{.ul}: These businesses may engage in
research and development of new technologies and innovations to meet the
needs of the defense sector, such as advanced materials, sensors, or
communication systems. [^7], [^8]

4\. [Consulting services]{.ul}: Some small DIB businesses may offer
consulting services related to defense industry best practices,
regulatory compliance, or other specialized areas of expertise.

The above data was cross-checked and verified with the results of a
recent DAU study[^9] of small business awards in the defense industry.
The following is a list of the top NAICS (North American Industry
Classification System) codes for contracts awarded to small businesses
noted by DAU and a strong correlation between the two studies is noted.

  --------------------------------------------------------------------------
  NAICS Code  Description                      Number of Small Total Award
                                               Business        Value
                                               Contracts       (2022-2023)
                                               (2022-2023)     
  ----------- -------------------------------- --------------- -------------
  541330      Engineering Services             1,250+          \$2.1 billion

  541715      R&D in Physical, Engineering,    900+            \$1.5 billion
              and Life Sciences                                

  561210      Facilities Support Services      700+ \$         1.2 billion

  541512      Computer Systems Design Services 650+            \$1.1 billion

  236220      Commercial & Institutional       600+            \$950 million
              Building Construction                            

  541519      Other Computer Related Services  550+            \$850 million

  541611      Admin. & General Management      500+            \$800 million
              Consulting                                       
  --------------------------------------------------------------------------

  : Table Most Common DIB Small Business NAICS

NAICS codes in the preceding study represent areas where small
businesses play a prominent role as prime or subcontractors in
supporting defense operations. Engineering services, R&D, and systems
design are highly sought after due to their impact on innovation and
national security priorities.

Another factor to consider is the amount of capital investment required
may act as a barrier for VSBs to enter specific industries. Studies
indicate that capital investment requirements generally correlate with
industry type, as represented by NAICS codes, and this impacts both
entry barriers and success rates. Industries with high capital
requirements (e.g., manufacturing, construction) exhibit slower growth
and have fewer VSBs due to the significant upfront costs, whereas
industries like professional services with lower capital requirements
see higher levels of entry and growth potential for small businesses
(Bartik, 2018; SBA, 2021)[^10].

### VSB Work Environment

The dominant VSB environment appears to be highly leveraged off the
work-at-home concept that gained prominence during COVID-19 has led to a
substantial transformation in work conditions. The work environment
typically emphasizes flexibility, and cost-effectiveness.

Many VSBs operate from home offices, co-working spaces, or small rented
spaces, where physical settings support a collaborative and often
informal work culture. This environment allows VSBs to maintain low
overhead costs while fostering close relationships among team members.
Given their size, many VSBs also prioritize flexible work arrangements,
like remote work and adaptable schedules, which are attractive for
employee retention and can help manage work-life balance effectively.
This is particularly common in professional services, construction, and
retail sectors, which constitute a large share of VSBs in the U.S.

Studies highlight that VSBs' productivity and longevity can benefit
significantly from an environment where employees feel supported and
have opportunities to contribute meaningfully, rather than purely
hierarchical structures more common in larger businesses (McKinsey,
2024; Rocket Lawyer, 2023) [^11]^,^ [^12]^,^ [^13]

While most sole proprietors work from a home office, the prevailing
environment for small businesses with employees is a hybrid combining
the following elements in various combinations:

1.  [Home office]{.ul}: Numerous professional services and
    knowledge-intensive firms function from home offices, with the
    owner/CEO and other personnel working remotely using Virtual Private
    Networks (VPN) or Virtual Device Interfaces (VDI) to connect to
    cloud services or clients. This can reduce overhead expenses and
    offers an economical environment. flexibility. Home offices are
    dominant with sole proprietorship VSBs.

![A computer room with a desk and computer equipment AI-generated
content may be
incorrect.](./media/image3.jpeg){width="4.485148731408574in"
height="3.3638615485564305in"}

Figure Home Office/Lab used by the Author

2.  [Compact office space]{.ul}: Numerous DIB enterprises may lease (or
    share) a compact office space situated in office parks or facilities
    near government installations to create a professional setting for
    meetings and customer engagements. Often these facilities are part
    of an 'accelerator' environment with several STEM related VSBs
    clustered together. Such an arrangement is often conducive to
    synergy and collaborative efforts.

3.  [Virtual team]{.ul}: With advancements in communication technology,
    some small DIB enterprises have implemented virtual team frameworks,
    wherein employees operate remotely from various places and primarily
    interact through video conferencing, instant messaging, and other
    digital tools. This technique is often used when team members are
    geographically dispersed and facilitates international
    participation.

4.  [Flexible work arrangements]{.ul}: To meet the requirements of its
    staff and clients, small DIB enterprises may provide flexible work
    options like as telecommuting, part-time schedules, or reduced
    workweeks. This is a common work/life balancing tactic to attract or
    retain highly sought-after talent.

5.  [Facilities offered by the customer]{.ul}. To meet customer or
    governmental security mandates, some small enterprises engaged in
    classified or sensitive projects utilize secure premises provided by
    the prime contractor or government for conducting sensitive or
    classified work.

6.  Virtual offices created in apps such as MS Teams, Zoom or other
    conferencing apps that include instant messaging and collaboration
    via impromptu meetings.

### VSB Staffing

Small DIB entities in this study are sparely staffed with a very heavy
representation by revenue earning staff and a relatively small
administrative or overhead team. According to Forbes[^14] sole
proprietors dominate the small business landscape and "The professional
and business services industry now leads in job openings, a shift from
the previous trend where education and health services were more in
demand. This change signals a strong need for skilled workers in areas
such as management, administration and consulting."

The numbers in the DIB are different with approximately 50% (4,928 of
9,336) having 0 -- 5 employees (referred to in my article as 'nano'
small businesses)

Directionally, these data point to many sole proprietors

![A blue pie chart with numbers and a few different pies Description
automatically generated](./media/image4.png){width="4.549668635170604in"
height="2.5203029308836395in"}

Figure Distribution of Small businesses by number of employees.[^15]

Typical staffing for VSBs with employees includes:

1.  Owner/CEO: The owner/CEO is typically actively involved in VSB
    management, responsible for managing the day-to-day operations of
    the business, securing government contracts, and overseeing the
    development of new technologies and products.

```{=html}
<!-- -->
```
7.  Engineers and Technical Staff: These employees may have backgrounds
    in engineering, computer science, or other relevant fields and are
    responsible for developing and testing new technologies and
    products.

8.  Business Development: These functions, i.e., marketing materials,
    writing proposals, and identifying potential government contract
    opportunities are frequently performed by the owner/CEO and
    Engineers with some specialized assistance such as costs or pricing
    provided by CPA's or outside consultants.

9.  Administrative staff: This may include an office manager,
    accountant, and other support personnel who handle tasks such as
    bookkeeping, payroll, and human resources management. [^16]

Figure Notional Organization Chart for Very Small Business

## Financial Profile of Very Small Businesses

The average annual revenue, costs, and profit for a small defense
industrial base business can vary widely depending on factors such as
the specific products or services offered, the size of the company, and
the geographic area. However, here are some general estimates based on
industry studies and reports:

### VSB Average Annual Revenue

According to a report by Deloitte,[^17] the average annual revenue for
small and medium-sized defense companies is around \$10 million to \$50
million (Deloitte, 2019). A second report by the National Defense
Industrial Association (NDIA) found that the average annual revenue for
small defense companies was around \$25 million (NDIA, 2020). However,
these numbers are averages for all small businesses (including some with
250 or more employees) and the revenue for very small businesses (VSBs)
is significantly less as shown in Table 2.

### VSB Average Annual Operating Costs

For small businesses working with the government, the Defense Contract
Audit Agency (DCAA) focuses heavily on accurately categorizing and
reporting costs. The DCAA\'s guidance on cost accounting includes
several essential categories that small businesses should track,
especially when operating under government contracts. Here's a general
breakdown of cost categories suitable for businesses with 0-5, 6-10, and
10-20 employees:

  -----------------------------------------------------------------------------------------------------
  Business Size Components of       Direct Costs (Annual) Indirect Cost  Indirect Cost    Indirect
  (Employees)   Direct Costs                              (Overhead)     (G&A)            Costs\
                                                                                          (Annual)
  ------------- ------------------- --------------------- -------------- ---------------- -------------
  0-5           Labor, materials,   \$20,000 - \$100,000  Overheads such Executive        \$10,000 -
                and any direct                            as small-scale salaries,        \$50,000
                contract-specific                         utilities,     accounting,      (utilities,
                travel                                    facility costs small marketing  small rent,
                                                          (if            expenses, and    etc.
                                                          applicable),   office supplies  
                                                          and minor                       
                                                          indirect labor                  

  6-10          Similar to above,   \$100,000-\$500,000   Higher         Increased G&A    \$50,000 -
                including                                 facility       due to           \$200,000
                specialized                               overheads,     additional       (expanded
                materials for                             fringe         administrative   facility &
                specific projects                         benefits,      support or       benefits)
                                                          increased      expanded         
                                                          utilities,     marketing        
                                                          material       efforts          
                                                          handling                        

  10-20         Expanded to include \$500,000 -           Larger pools   Additional G&A   \$200,000 -
                direct labor for    \$1,000,000           for employee   for compliance,  \$500,000
                specific project                          benefits, more higher-level     (benefits,
                teams, and more                           substantial    staffing, and    facility
                travel expenses per                       facility       increased        overhead)
                project                                   overheads, and executive        
                                                          depreciation   support and      
                                                                         legal or         
                                                                         financial        
                                                                         services         
  -----------------------------------------------------------------------------------------------------

  : Table Estimated Business Costs (exclusive of IT and Cybersecurity)
  for Very Small Businesses [^18]^,^ [^19]^.^[^20]

Note that while cybersecurity costs are an important factor in business
profitability and can serve as a challenge to entering the DIB, they are
technically one-time costs related to compliance with the applicable
standard(s) required by the industry -- be that financial, health care,
or government contracts. Those costs are not included in the above
analysis. However, IT costs such as annual service and support fees,
Managed Service Providers, etc. are included. Tri-annual cybersecurity
recertification assessment is a potential outlier in the above as it is
likely to add as much as \$5,000 to \$15,000 in General and
Administrative costs annually to the budget.

### VSB Average Annual Profit:

A GAO study found that the average annual profit for small defense
companies was on average 5% to 10% of their total revenue[^21]. A report
by the consulting firm McKinsey & Company found that the average annual
profit margin for small defense companies was around 7% to 10%. [^22]^,^
[^23]^,^ [^24] ^,^[^25]

  --------------------------------------------------------------------------
  Employee Count Average Annual   Average Annual   Estimated       Average
                 Revenue          Cost             Profit          Profit
                                                                   Margin
                                                                   (%)
  -------------- ---------------- ---------------- --------------- ---------
  0--5 Employees \$47,794 -       \$43,000 -       \$4,794 --      7% - 10%
                 \$400,000        \$370,000        \$30,000        

  6--10          \$500,000 -      \$450,000 -      \$50,000 -      7% - 10%
  Employees      \$1,000,000      \$900,000        \$100,000       

  11--20         \$1,000,000 -    \$900,000 -      \$100,000 --    7% - 10%
  Employees      \$1,800,000      \$1,590,000      \$210,000       
  --------------------------------------------------------------------------

  : Table Average annual revenue and profit for VSBs

These data are echoed by a study in Forbes Advisor where the range of
salaries was between 32,000 and \$147,000 with a mean of \$69,000/year.

![A screenshot of a phone AI-generated content may be
incorrect.](./media/image5.png){width="6.5in"
height="1.6298611111111112in"}

Figure Average small business owner salary [^26]

These estimates are based on industry-wide averages and may not reflect
the specific financial performance of any individual small DIB business.
Additionally, the profit margins for these companies can vary widely
depending on factors such as the type of products or services offered,
the size of the company, and the target markets served.

According to a report by the Small Business Administration (SBA) and as
reported in my journal article[^27], most (approximately 72 -- 78
percent) of small DIB with employees only have a few, typically less
than 20. These companies have a lean organizational structure and may
outsource specialized functions or services such as IT, accounting, or
legal to supplement in-house staff.

Larger DIB companies may have employee numbers ranging from 50 to
several hundred employees with more complex organizational structures
and may offer a wider range of products and/or services to their
customers.

Revenue (and profit) are a somewhat linear function and correlate well
with the number of employees -- especially in knowledge-based
businesses. Consequently, the SBA reported average annual revenue of
\$10 million for small DIB businesses is likely based on an unweighted
average including companies ranging from 20 to 500 employees (or
larger). The data is somewhat skewed by the award size for businesses
close to the size limit for the NAICS code.

## VSB IT and Cybersecurity Expenses

IT and cybersecurity spending depend on industry, data sensitivity, and
compliance requirements, especially for government contractors who face
strict cybersecurity mandates. Hence, these costs are tracked
separately.

For small businesses, annual IT and cybersecurity spending are estimated
to represent about 10-12% of their overall IT budget[^28]. However, the
IT expense per person varies widely depending not only on employee count
but also the nature of the industry (Financial, Legal, Retail, Health
Services, or Government Contracting) as each of these industries has
specific security requirement they must meet.

Since larger businesses have more people to spread the cost over, their
per person costs tend to flatten out once a certain size is attained.
Those at the low end of the size spectrum will have significantly higher
per-person costs. On average, a 10 -- 20 person very small businesses
may spend around \$4,500 (\$300 per user) per month on IT including
equipment purchase or lease, internet access, help desk services, etc.
This figure assumes the business can find a provider willing to take on
a client with so few employees which is a significant issue for many
VSBs

To the IT costs we now add add cybersecurity, SaaS, or other support
costs that may range from \$300 to \$500 monthly, or approximately
\$3,600 to \$6,000 annually for a very small business. This includes
essential services like end-point management, network security, incident
response, employee refresher training, and vulnerability scanning &
monitoring. Total IT and cybersecurity could approach 50K for a
10-person office.

For government contractors, the costs can be higher due to compliance
needs with frameworks like NIST SP 800-171 and DFARS regulations.
Cybersecurity costs may represent 15-20% of IT spending for these
businesses, reflecting the added requirements for compliance with
federal standards and cyber risk mitigation efforts. Small businesses
could expect annual cybersecurity expenses between \$7,200 and
\$12,000[^29] when including advanced security measures, FedRamp
approved storage or email, and regular compliance assessments.

  -------------------------------------------------------------------------
  Business Size     IT Managed        Cybersecurity     Cybersecurity
                    Services          (Monthly)         (Annually)
                    (Monthly)                           
  ----------------- ----------------- ----------------- -------------------
  0--5 Employee     \$1,500           \$300--\$400      \$3,600--\$4,800

  6--10 Employee    \$3,000           \$500--\$600      \$6,000--\$7,20

  10--20 Employee   \$5,000           \$750--\$1,000    \$9,000--\$12,000
  -------------------------------------------------------------------------

  : Table : IT and Cybersecurity Costs for VSBs [^30]^,^[^31]^,^[^32]

Note: These estimates are generalized in nature. Exact costs may vary
based on the specific industry and risk level of the business.
Compliance-heavy sectors like financial, healthcare, or government
contracting will generally have higher cybersecurity expenses due to
stricter regulatory requirements. A more detailed analysis of the costs
is included in Level 1 (Foundational) Approach below.

Investments in cybersecurity are often categorized into these areas:

-   Hardware (servers, desktops, and laptops)

-   Software (productivity, security, specialized tools)

-   Network infrastructure (routers, switches, firewalls)

-   IT or consultant support

The estimated annual cybersecurity costs for very small DIB businesses
should also include an allowance for:

-   Cybersecurity software (antivirus, intrusion detection)

-   Cybersecurity services (incident response, penetration testing)

-   Employee training and awareness programs

-   An allowance for assessment services such as CMMC (triennial) or
    when the system is modified

The total cost of NIST SP 800-171 compliance for low and moderate
threats VSBs is the subject of my ongoing study. In my JCM article[^33]
I estimated these costs saying: "The total cost based on this analysis
for a company of 20 or fewer employees is in the range of \$37,000 to
\$50,000 with a midpoint of about \$44,000 excluding annual costs for
other IT services such as Office 365, GCC, etc. This figure does not
include labor costs for the business to support or manage the
(compliance) effort"

Recently, the Federal Register published a proposed rule **Federal
Acquisition Regulation: Controlled Unclassified Information**[^34]
pegged the estimated cost at: "The total estimated labor cost for a
small business in the initial year is approximately \$148,200 (average
of 1,560 hours \* \$95), with a recurring annual labor cost of
approximately \$98,800 (1,040 hours \* \$95). ... Businesses may also
need to install software and/or hardware to implement NIST SP 800-171
Revision 2. .... The Government estimates that a small business, on
average, may spend \$27,500 on hardware and software during initial
implementation and \$5,000 annually thereafter to maintain compliance."

The above cost estimates only address NIST SP 800-171 Moderate
compliance (i.e., DFARS 52.204-7012) **[without any third-party
assessment]{.ul}**. Adding a third-party assessment was seen as adding
another \$15,000 -- \$50,000 or more to the initial costs. Also, the
assessment is a recurring requirement so a portion of that cost would
need to be set-aside each year to pay for the tri-annual recertification
under CMMC.

### Total Estimated Costs for Cybersecurity Controls

Cybersecurity costs include the software, hardware, and services needed
to provide either a level of cyber hygiene (e.g., FIPS 199 and 200 as
'Low Impact') primarily protecting Federal Contract Information (FCI) or
alternately 'adequate security' (Typically associated with Moderate or
High Impact) protecting Controlled Unclassified Information.

The impact of these costs is best expressed by the National Defense
Industry Association:

"... Therefore, understanding the costs to contractors to safeguard
information is an essential element to ensure that companies, especially
small businesses and start-up companies, are not regulated out of their
ability to support the Department and its missions."[^35]

Implementation is typically performed in a staged manner with Low Impact
typically accomplished first, followed by Moderate Impact. High impact
is viewed by the author as extremely rare (but not impossible) for VSBs.

The below chart summarizes hypothetical implementation costs:

  -----------------------------------------------------------------------
  Category                                    Estimated Cost Range\
                                              (10 to 20 employees
  ------------------------------------------- ---------------------------
  Initial Hardware, Equipment, and start-up   \$5,000
  (Greenfield)                                

  Gap Analysis and Remediation                \$5,000 to \$15,000 [^36]

  Policy and Procedures Manual                \$ 5,000 to \$12,000

  Cybersecurity training for employees        \$ 3,000 to \$5,000 [^37]

  Incident response planning and training     \$3,000 to \$7,000

  Penetration testing and vulnerability       \$7,000 to \$15,000
  assessment                                  

  Total (self-assessment only)                **\$16,000 to \$39,000**

  Total with Third-Party assessment (CMMC)    **\$23,000 to \$57,000**
  -----------------------------------------------------------------------

  : Table Estimated Cybersecurity Implementation Costs for a notional 10
  - 20-person company

While the above data somewhat aligns with what I reported in my JCM
article, there are some differences -- especially at the low end of the
range.

As noted in the JCM article, this effort is very dependent on skilled
technicians performing the work and the cost for such services can vary
widely by geographic region. Sample data in the below illustrates the
likely range.

*Note: The data presented below is at odds with the US Government
estimate of \$76 per hour.*

  -----------------------------------------------------------------------
  Region                   Typical Hourly      Typical Premium Service
                           Standard Rates      Rate (e.g., for NIST
                                               Compliance)
  ------------------------ ------------------- --------------------------
  Western                  \$150 -\$250        \$200 - \$300

  U.S. Region              Typical Standard IT Typical Premium IT
                           Rate per Hour       (Cybersecurity) rate per
                                               Hour

  Western                  \$150 - \$250       \$200 - \$300

  Eastern                  \$125 - \$200       \$180 - \$280

  Midwest                  \$100 - \$125       \$159 - \$250

  Southwest                \$110 - \$190       \$170 - \$260

  Southeast                \$100 - 175         \$160 - \$240

                                               
  -----------------------------------------------------------------------

  : Table Sample of Cybersecurity Technician Labor rates by region[^38]

The above describes the Cyberhygiene Project target audience and is a
significant driver of the strategy, design assumptions, and system
architecture discussed in the remainder of this document.

### Section Summary 

The following conclusions or inferences may be drawn from the above:

1.  Small businesses form a significant part of the U.S. economy and the
    DIB. The predominant small business is in the 0-5 employee range and
    that a significant majority of small businesses reside in the 0 --
    20 Very Small Business (VSB) employee range.

2.  For these VSBs to compete in the DIB marketplace they must meet the
    same cybersecurity criteria as their larger brethren albeit scaled
    somewhat to match their work environment and diminutive size.
    However, the costs for cybersecurity compliance do not scale in a
    linear manner and the cost of compliance for a VSB (\< 20 employees)
    or a nano SB (0-5) employees is proportionately larger.

3.  Given the relatively small size and revenue of these VSBs the cost
    of admission to the DIB and government contracts is prohibitive and
    acts as a significant deterrent to their participation -- a topic
    well documented in my 2023 -- 2024 Journal of Contract Management
    article.

> Given the reduced numbers of small business in and/or entering the DIB
> the conclusion is -- as I said in that article

"My study indicates technologies such as automation and AI can play a
significant role in two compliance areas. One is producing documentation
such as policy and procedures, training literature, and other
(documentation) products." I went on to note: "Based on the above I
propose the creation of Cybersecurity in a Box (CSIB), i.e., a
cybersecurity appliance combining hardware, software, and services in an
affordable and easily deployed solution for basic cybersecurity
compliance. The low cost and targeted nature of this device will improve
compliance at an affordable price and may lower cybersecurity as a
roadblock limiting VSB entry into the DIB."

In the remaining chapters of this paper, I will elaborate on the above
points, expand on the CSIB (now renamed the Cybehygiene Project)
approach, provide a detailed description of a proposed prototype, and
document my attempts to build such an appliance in a laboratory
environment.

# Typical DIB VSB Network {#typical-dib-vsb-network .Chapter}

## VSB Network Description and Typology

A typical VSB computer network infrastructure i.e., that in a small
business with fewer than 15 employees, is generally a simple but
functional layout that focuses on cost-efficiency and ease of
use/management. Many times, the network is ad-hoc in nature, constructed
without prior planning, tends to grow from a single computer and
internet connection into a workgroup, and then finally matures into a
more formalized network.

*Entrepreneurs want to spend their time developing their products,
selling their products, and growing their business. They are not
expected to be -- nor are they likely to be interested in performing --
IT services or managing networks. Consequently, they should not be
expected to have a deep knowledge of computer security or network
design. For many, cybersecurity is a cost of doing business -- one to be
paid and then put aside so they can focus on other things -- computers
are a tool and all they know -- or want to know -- is enough to get
their work done.*

Frequently the VSB network is comprised of the owner's personal
equipment and that of the business partners or employees in an eclectic
'Bring Your Own Device' (BYOD) collection of hardware, operating
systems, and software with little initial organization or forethought.
The below identify the main characteristics and elements of such a
setup^:^[^39]^,^ [^40]^,^ [^41]^,^ [^42]^,^ [^43]

In such an environment the VSB tends to self-regulate the network and
only intercedes when something breaks, an unauthorized someone accesses
the network and does mischief, or a solid business requirement arises
(like CMMC) that pushes them to make changes. Hopefully, the suggestions
proposed in this document addresses the latter and prevents the former.

### VSB Network Infrastructure 

VSBs typically have a single connection to a Wide Area Network (WAN) and
if there are multiple people in the office they may share a local area
network (LAN) to connect all devices, including desktops, laptops,
printers, and possibly phones, to a single router for internet access.
Wireless connectivity is commonly prioritized for flexibility, typically
using a Wi-Fi router that also serves as the primary network access
point (Dawson, 2022).

A recent study reported a 72% preference for wireless over Wi-Fi
Networks.[^44] The same survey reported 55% of respondents expressed
concerns over the security vulnerabilities associated with wireless
networks. Although the wired network is more expensive and burdensome to
set-up it does offer some advantages with respect to network speed,
bandwidth, and security.

Given that Wi-Fi is the dominant architecture, companies with data
intensive operations or large file sizes frequently opt in higher
capacity (2.5, 5, or 10 Gb) local area networks and faster (often
Gigabit class) internet service to reduce latency and improve
productivity. Another approach is using hybrid networks combining wired
networks and wireless networks to achieve a balanced 'performance vs
risk' configuration.

### Hardware and Operating Systems 

Small businesses with fewer than 20 employees typically start with an
eclectic mix of desktop computers and laptops from various manufactures
which essentially co-exist on a network -- albeit with certain
limitations. They often mix hardware, software and operating systems
making security challenging since many products lack cross-platform
operability.

#### Operating System

While Microsoft Windows is the dominant operating system[^45] accounting
for 73.4% of desktops with OS X (Apple) comprising 15.4% and Linux 4.3%.
it is not uncommon to see a mixture of brands and operating systems in
use until the business grows to a point where it transitions from being
ad-hoc to a higher organizational maturity level. At that point policies
and procedures enter the picture, and some degree of standardization
tends to occur. Typically, this is the point where company procured
computers supplant the BYOD 'wild west' environment ensuring some degree
of conformity.

![A graph of a number of people AI-generated content may be
incorrect.](./media/image6.png){width="5.50632874015748in"
height="3.0973097112860892in"}

Figure Market Share of Desktop Operating Systems

#### Hardware

These VSBs initially rely on consumer-grade (or prosumer) equipment to
save on costs. Frequently the router/firewall is a consumer-grade device
provided to home networks with limited functionality. One early upgrade
made to security is replacing or supplementing the consumer grade device
with a more robust device that supports more features and in-depth
protection.^.^[^46] ^,^[^47]

  ------------------------------------------------------------------------
  Feature                  Consumer-Grade          Low-End Commercial
                           Modem/Routers           Grade (e.g., Sophos
                                                   X85)
  ------------------------ ----------------------- -----------------------
  Firewall Protection      Basic NAT firewalls;    Advanced stateful
                           limited rule            firewalls with deep
                           customization           packet inspection

  Intrusion                Generally absent or     Integrated IDS/IPS for
  Detection/Prevention     very basic              real-time threat
                                                   detection

  *VPN Support*            *Simple VPN             *Full VPN support
                           pass-through (e.g.,     including SSL VPNs and
                           PPTP, L2TP/IPSec)*      site-to-site IPSec*

  Antivirus/Anti-malware   Rarely included         Built-in threat
                                                   protection capabilities
                                                   with updates

  Web Filtering            Minimal parental        Advanced web filtering
                           controls                with customizable
                                                   categories

  User Management          Limited user roles and  Comprehensive user and
                           device tracking         device management with
                                                   logging

  QoS and Bandwidth        Basic QoS; not highly   Enhanced QoS with
  Control                  customizable            traffic shaping and
                                                   detailed policies

  Secure Remote Access     May allow basic remote  Secure remote admin
                           management; lacks       access with
                           security                multi-factor
                                                   authentication (MFA)

  Software/Update Support  Sporadic updates, often Regular,
                           vendor-dependent        security-focused
                                                   firmware updates
  ------------------------------------------------------------------------

  : Table Comparison of Consumer and Commercial Grade Routers

Wired networks also include network switches providing from 4 to 36
connections each (or more) to interconnect wired connections as needed.
Such devices at this level are typically unmanaged and do not attempt to
regulate the data flow through the device.

Some offices may use either direct attached storage (DAS) or a
Network-Attached Storage (NAS) device for file sharing and backup if a
dedicated server is too costly (Tyson, 2023).

One underrated capability of NAS devices is that some (e.g., Synology)
provide a host of added capabilities and services such as automated
back-up, redundant array of inexpensive drives (RAID) providing fault
tolerance, and the ability to perform as a low-end domain server with
DNS, DHCP, user authentication, and virtual machine (VM) hosting. While
a NAS provides excellent capability for their modest cost, their primary
limitation is they may not be capable of supporting large domains
because most lack two major requirements: FIPS 140 encryption and a
Security Technical Implementation Guide (STIG). More on this later.

### Network Typology - Domain vs. Workgroup

Initially VSB network users tend to rely on unmanaged peer-to-peer
workgroups[^48]. They then progress to managed domains once a certain
size is reached -- typically in the range of 10 -- 20 endpoints or
users. At that point a transition to a domain typology is common -
sometimes with a central server for shared file storage. The storage can
be located on either the domain server, cloud storage, or a network
attached storage appliance/file server.

![A diagram of a computer network AI-generated content may be
incorrect.](./media/image7.png){width="3.217470472440945in"
height="3.6608694225721785in"}![A diagram of a computer network
AI-generated content may be
incorrect.](./media/image8.png){width="3.173620953630796in"
height="3.678261154855643in"}

Figure Domain vs. Workgroup

Domains are preferred over workgroups in offices with 10 or more users
as they offer centralized management, the ability to use common account
credentials across the network, granular permissions for file access or
other operations, easier patch management, and enhanced security.

Domains may be controlled by a physical server such as an on-premises
device or through a virtual domain server such as provided as part of
the Microsoft 365 enterprise suite. The controller -- as the name
implies -- manages such activities as identity verification and
permissions for users, enforcing network or business policies, and
providing multiple services needed for network operation such as
translating domain names to addresses or managing a pool of assignable
network addresses.

  -----------------------------------------------------------------------
  Server Type                    Percentage of Small Businesses (0--20
                                 employees) Utilizing
  ------------------------------ ----------------------------------------
  Cloud Servers (e.g., SaaS like \~42% of small businesses use
  MS 365)                        cloud-based services to manage
                                 operations and reduce costs. This
                                 includes software, storage, and
                                 computing resources. The trend is
                                 projected to grow as more businesses
                                 migrate their workloads to the cloud.

  On-Premises Servers            \~20% of smaller businesses still rely
                                 on on-premises servers. This choice is
                                 often due to data security concerns,
                                 legacy systems, or specific industry
                                 requirements. However, there is a steady
                                 shift toward cloud solutions.

  Hybrid Solutions               \~34% of small businesses use a
                                 combination of cloud and on-premises
                                 infrastructure. This model allows them
                                 to leverage the flexibility and
                                 scalability of cloud services while
                                 maintaining certain data or processes
                                 locally.
  -----------------------------------------------------------------------

  : Table Server typologies common to very small businesses i.e., \< 20
  employees

## VSB Security Practices 

Security in VSBs begins as a limited ad hoc capability characterized by
basic measures such as firewalls (often embedded in the router),
antivirus software, complex passwords, and occasionally a virtual
private network (VPN) for remote access. Smaller businesses may not have
specialized IT staff and often outsource cybersecurity or rely on
managed service providers for periodic support (Small Business
Administration, 2022).

### Anti-Malware and Endpoint Management

There are a multitude of anti-malware and security management software
as a service providers at various price points.

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image9.png){width="4.044303368328959in"
height="2.449482720909886in"}

The choice of a product is often based on brand loyalty or personal
preferences with zero-cost products offering adequate protection
(especially considering the Linux OS preference in the CyberHygiene
configuration) but some of these products offer added value such as
end-point management, vulnerability assessments etc. My two recommended
choices for VSBs interested in CMMC compliance are BitDefender Gravity
Zone and Sophos Business. For lesser requirements any of the listed
products will suffice.

One important side note is that products from Kaspersky are expressly
forbidden by federal regulation on systems used by government
contractors!

### Cloud-Based Services 

To reduce the need for extensive on-site infrastructure, many small
businesses use cloud-based applications for email, file storage, and
collaboration. Services like Microsoft 365, Proton Mail, or Google
Workspace are popular as they offer secure, scalable options without
significant upfront costs (O'Brien & Marakas, 2021).

One significant factor when choosing such cloud-based services is the
question of "where will your FCI or Controlled Unclassified Information
(CUI) reside"? If the answer involves cloud-based services then the
standard commercial offering will not meet standards. To be compliant
the service must be a Federal Risk and Authorization Management Program
(FedRamp) approved cloud provider from the FedRamp Marketplace.[^49]
This includes email and cloud back-up. Such services are very
expensive[^50] and generally require an existing government contract
with CUI requirements to qualify for on-boarding. Consequently, some
VSBs choose to work around such cloud-based solutions via self-hosting
and limiting CUI or FCI transfers to using government or prime
contractor provided secure portals.

### Backup and Recovery

Small businesses often use basic backup solutions, such as external hard
drives or cloud backups, for data protection. While some adopt automated
solutions, others rely on manual processes due to budget limitations
(Delgado, 2022). The wide availability and low cost of network attached
storage appliances (NAS) many of which are bundled with automated
back-up software is an economical choice as a primary backup and may be
combined with cloud or direct attached storage devices (e.g., USB
drives) or server-based storage to provide a robust back-up solution.

Again, while many of these solutions are more than adequate for
commercial requirements, as we will see, they may not pass muster when
FCI or CUI are required. More on that later

## Choosing a Network Typology -- the Pros and Cons

### On Premises or Virtual Server

For very small businesses with fewer than 20 employees, on-premises
servers are relatively uncommon, with adoption rates estimated between
10% and 25%[^51]. This trend is largely due to the growing availability
of cloud-based services that minimize the need for physical servers by
offering scalable and cost-effective cloud-based solutions.

Cloud-based platforms like Microsoft 365, Google Workspace, JumpCloud,
and other virtual domain services products are popular among small
businesses due to their flexibility, lower upfront costs, and minimal
maintenance requirements. These services reduce the dependency on
physical servers, making them attractive to very small businesses with
limited IT budgets and technical expertise (Delgado, 2022; Teal
Technology Services, 2024). As stated above, if these services are to be
used for government contracts, especially at Level 2, the must be
FedRamp approved which eliminates JumpCloud.

Some small businesses do maintain a server -- often for specific
reasons, such as data security, regulatory compliance (as would be the
case with FCI or CUI), or the need for local data access. Sectors
handling sensitive information, like healthcare, government contracts,
or finance, may prioritize physical servers to meet regulatory
requirements and ensure a higher level of data control (Cloudwards,
2023)[^52]. For others, the high initial cost and ongoing maintenance of
physical servers often outweigh the perceived benefits, making cloud
services the preferred alternative (O'Brien & Marakas, 2021)[^53].

For very small businesses considering a transition to a cloud-based
solution like Microsoft 365 E5 or Government GCC High versus an
on-premises server, a financial analysis of initial and ongoing costs is
essential. Each option has distinct financial implications, including
setup costs, migration expenses, and recurring fees, with cloud
solutions typically offering better scalability but potentially higher
long-term expenses.

#### On-Premises Server: 

Establishing an on-premises server can involve significant initial costs
for hardware, software, installation, and configuration. However, there
are strategies available to limit these costs such as a Linux server
based on older or low end technology and open-source software. This is a
viable solution for those willing to break with the Microsoft ecosystem
-- and one that has been adapted enthusiastically by the CyberHygiene
Project in its lab environment.

Small businesses may also need to budget for licensing fees and IT
support to manage and maintain the server, which can add up
substantially over time (SBA, 2022; Teal Technology Services,
2024)[^54]. These expenses are one-time in nature may be amortized over
several years, reducing their annual financial impact. Low-cost options
are available including the afore mentioned Synology NAS (if NIST
compliance is not a factor) or a Linux device scaled for the entity's
requirements.

#### Cloud-Based Domain Servers

Migrating to a cloud-based domain services such as Microsoft 365 GCC
High ostensibly requires a smaller initial investment since there's no
hardware to purchase. However, businesses may incur significant start-up
and migration costs, especially if data transfer, account setup, and
system integration require professional services. Microsoft and
third-party providers may charge setup fees, though these are claimed to
be lower than those for physical infrastructure (Microsoft, 2022).

One noted issue with the Microsoft cloud approach is the multiple
offerings, SKUs, and somewhat obscure product names that tend to channel
potential clients into consultants who then prescribe the correct items,
quantities, and SKUs to purchase and then charge a hefty fee to
configure the product and on-board the client tenant. Since much of this
information is very esoteric, the consultants tend to stay on as managed
service providers. This situation tends to breed vendor lock-in making
the client dependent long-term on the consultant.

One possible solution for very small businesses is to use a
non-Microsoft virtual domain controller such as Keeper or Jump Cloud for
domain management services, however these services will need to be
FedRamp compliant should CUI be present (Level 2) which limits cloices
and elevates the cost significantly.[^55]

### Monthly Subscription Fees vs. Long-Term Maintenance

#### On-Premises Server: 

While an on-premises server doesn't incur ongoing subscription fees, it
does require regular maintenance, updates, and potential future
upgrades. The choice of operating system and open source vs commercial
solutions will be a significant factor in these recurring costs with
Open Source solutions tending to be either free or inexpensive and
commercial services priced on a monthly or annual basis.The cost of
electricity and cooling for the server room also adds to operational
expenses (Delgado, 2022).

#### Cloud-Based Solutions: 

Cloud services like Microsoft 365 E5 offer predictable monthly fees,
covering software updates, IT support, and infrastructure maintenance.
This can simplify budgeting for very small businesses that prefer
predictable expenses and managed services. However, long-term
subscription costs can be substantial.

### Scalability and Flexibility

#### On-Premises Server: 

Expanding on-premises server capacity could require purchasing
additional hardware and possibly increased licensing costs. This can
limit growth or add unexpected expenses for a growing small business
(Cloudwards, 2023). For example, RedHat Enterprise Linux (RHEL) has a
basic license fee of \$383.00 per year exclusive of technical support.
Standard support costs start at \$878.00/year and go up to
\$1813.90/year per server.[^56] Total cost per year/server is on the
order of \$1,250 to \$2,200. However, essentially the same product as
RHEL is available for free through open-source software branded as
CentOS or Rocky Linux limiting cost to support services only. [^57]

Support for open-source products is generally via community support or
via a locally retained MSP. Some providers do offer paid support
although pricing is not advertised. One interesting development is the
role of AI in this respect. Using services such as Grok or ChatGPT as a
DIT solution to resolve minor technical glitches is reasonably effective
and free or low cost depending on licensing agreements with the AI host.

#### Cloud-Based Solutions: 

Microsoft 365 E5 is highly scalable, allowing businesses to add users or
services without purchasing additional hardware. This flexibility is
beneficial for growing businesses, as it provides IT resources on demand
and minimizes capital expenditure risks. However, 365E5 does not meet
NIS 800-171 Level 2 requirements. Cost is on the order of \$30 to
\$50/per user per month or \$360 to \$600/year exclusive of support
services. Typically, such packages include a minimum user count

## Virtual Device (or Desktop) Interfaces (VDI)[^58]

One promising scenario for VSBs needing limited access to CUI is to
implement a dedicated virtual desktop or connection to a secure platform
and limit all CUI to that device. This is possible as a virtual desktop
hosted on a CMMC compliant cloud-based network but there are certain
limitations to the approach that must be factored into the decision.

A VDI provides a user with the ability to connect to a secure host over
an encrypted (typically VPN or similar) connection. Once connected they
have a web-based interface to a remote desktop in a secure enclave. They
can have a separate email account that is secured to permit transmitting
or receiving CUI or other sensitive material, access to various shared
services such as SharePoint or shared file systems, and the ability to
work in browser-based editions of common office products like Word,
Excel, etc.

In this environment CUI is never allowed off the remote platform onto
the local machine thus preserving the security of the protected content.
Therefore, the local user cannot usually save to their desktop, print,
or email documents to prohibited external accounts.

Although a VDI offers a secure environment it comes with some
limitations. Here is a cost estimator from one VDI provider that
illustrates their pricing for a VDI meeting DFARS requirements of
\$2,500/month or \$3,000/year for a single user.[^59] Such estimates
tend to be subject to minimum user requirements such that a \$500 per
user per month rate becomes a \$4,000 per month or 48,000 per year rate
once the minimum of 5 users is factored into the cost.

![A screenshot of a computer Description automatically
generated](./media/image10.png){width="4.791020341207349in"
height="3.2861482939632545in"}

Figure Estimated Monthly Cost for Viirtual Desktop

One of the principal limitations for VDIs occurs in the scientific and
engineering community where specialized software products are used for
simulation and analysis. The software suite supported by the VDIs may be
limited to a defined set of tools and if those tools are not supported
the user is constrained in their ability to work on projects that
generate or process CUI. Similar issues arise in other areas where
specialty software is common including desktop publishing, video
production, and proposal generation.

Those applications that use a back-end database will find the VDI
environment difficult unless the database is hosted behind the VDI
firewall i.e., inside the protected domain. That is just not
commercially practical for VDI solutions such as the one illustrated
above. It also raises the specter of having FCI or CUI outside of the
defined system scope and requiring the cloud based provider to be both
FedRamp and CMMC certified. Finally, the cost per seat can be
prohibitive for a VSB should they need to provide multiple users access
to the service.

# Building a VSB Cyber Compliant Workstation {#building-a-vsb-cyber-compliant-workstation .Chapter}

Workstations are the building blocks of a business network. They can be
either a desktop system or a portable (laptop) computer that is
configured for a specific type of work -- be that CAD, video editing, or
general office tasks. More importantly, this can be the only device in a
VSB with a single proprietor -- something I call a solopreneur.
Nonemployer firms---defined as businesses without paid employees and
generally operated by a single person---comprise 81.9% of all U.S. small
businesses overall.[^60] Some 32,679[^61] unique small businesses
received one or more contracts from the DoD in 2024. Of these, roughly
25,000 are under 15 employees and more than 20,000 are believed to be
solopreneurs -- or in SBA terms "nonemployers"[^62]

Consequently the solopreneur segment is fertile ground for a low-cost
cyber compliant workstation since such a device would fulfill the
majority of Level 1 Cyberhygiene requirements for over 60% (12,000) of
the one-person companies in the DIB and countless more in other
Government Contracting domains. The remaining 13,000 small business will
lokely need more than this bare-bones solution, but the good news is the
same workstation can be used in conjunction with other hardware, as a
nucleus of a larger or more secure (Level 2) aapplication.

## Ditching Microsoft for Open-Source Solutions

While there is a strong presence of Microsoft products in the government
business sectors the typology of a typical Microsoft network with a
network server/domain controller and various windows-based PCs is
becoming a challenge to operate and maintain. The plethora of Microsoft
products and services combined with their business practices is
alienating a significant portion of their user base.

Setting up a turn-key network environment using Microsoft products and
services -- especially when such a network must be secured to NIST SP
800-171 standards to process government CUI is expensive and time
consuming. Microsoft's reliance on the Government Computing Cloud (GCC)
High creates a significant financial drain for the intended
Cybersecurity In a Box implementation.

Per a recent AI Search:

Windows 11 has been a focal point for privacy discussions since its 2021
launch, with criticisms echoing those of Windows 10 but amplified by new
AI integrations and stricter account requirements.

Microsoft positions the OS as \"privacy by design,\" compliant with
standards like GDPR, and emphasizes user controls. However, experts,
users, and regulators argue that default settings favor data collection
for personalization, ads, and AI training, often making it hard for
average users to fully opt out.

As of August 2025, concerns persist despite updates, including the
controversial Recall AI feature, which screenshots your screen every few
seconds for searchable history. Independent tests show it can still
capture sensitive data like passwords or credit card numbers, even with
filters. These issues aren\'t unique to Microsoft---Apple and Google
face similar scrutiny---but Windows 11\'s mandatory online features and
telemetry (data sent to Microsoft for diagnostics) make it more
intrusive by default. Public sentiment on platforms like X (formerly
Twitter) and Reddit often labels it \"spyware,\" with users citing
forced Microsoft accounts and persistent tracking. Recent X discussions
(e.g., from August 2025) highlight Recall\'s rollout as a \"privacy
nightmare,\" prompting apps like Signal and Brave to block it."

## If not Windows, then what?

To someone who cut their teeth on a Vic 20 back in 1982 the idea of
using a 'different' operating system comes naturally. While I still have
Widows installed on my work computer and use it as a VM on my 'primary'
(Apple) computer; operating systems are just another piece of software.
I have learned, used, and forgotten many of them including Commodore 64,
CPM, Unix, TPM, VMS, RSX, DOS, OS2, Windows, Windows 386, Windows for
Workstations, Windows NT, Windows Server etc. The idea that there might
be a better tool in the toolbox than Windows 10/11/Server 20XX is not
foreign.

From a user perspective, the Graphical User Interface (GUI) has tamed
many of the objections to using other operating systems---especially
Linux-based products like Ubuntu or Red Hat. For those already familiar
with the environment, please bear with me during this brief segway.

What we know today as "modern" operating systems with a mouse and GUI
started back at Xerox's Palo Alto Research Center (PARC) when the mouse
(invented by Douglas Engelbart) was combined with a bit mapped screen to
create a GUI for the Xerox Alto computer circa 1973. *The
modern [WIMP](https://en.wikipedia.org/wiki/WIMP_(computing)) (windows
icons, menus, and pointer) GUI was first developed at Xerox PARC
by [Alan Kay](https://en.wikipedia.org/wiki/Alan_Kay), [Larry
Tesler](https://en.wikipedia.org/wiki/Larry_Tesler), [Dan
Ingalls](https://en.wikipedia.org/wiki/Dan_Ingalls), [David
Smith](https://en.wikipedia.org/wiki/David_Canfield_Smith), [Clarence
Ellis](https://en.wikipedia.org/wiki/Clarence_Ellis_(computer_scientist)) and
a number of other researchers. This was introduced in
the [Smalltalk](https://en.wikipedia.org/wiki/Smalltalk) programming
environment. It
used [windows](https://en.wikipedia.org/wiki/Windowing_system), [icons](https://en.wikipedia.org/wiki/Icon_(computing)),
and [menus](https://en.wikipedia.org/wiki/Menu_(computing)) (including
the first fixed drop-down menu) to support commands such as opening
files, deleting files, moving files, etc* [^63]

Microsoft and Apple essentially cloned the Xerox concept when developing
the Lisa (Apple 1978) and Windows (1985). Many others jumped on the
bandwagon (including Amiga, Tandy, IBM, Epson, and Digital Research) and
marketed their own incarnations of the GUI over the coming years.
Consequently, computers morphed from character-based to GUI interfaces
to the extent that very few character-based operating systems remain --
or at least exist without an optional GUI.

So, the primary differentiator that made Windows what it is today (the
GUI) is no longer a rarity -- it is *de rigueur*. But that's like saying
every car has turn signals and a steering wheel. What we ignore then is
what's under the hood -- Linux vs. Windows. And it is here that the
security mavens align with my selection of Linux.

Linux is often considered more secure than Windows by design due to:

-   Open-Source Model: Linux\'s code is publicly accessible, allowing
    global scrutiny and rapid patching of vulnerabilities

-   User Permissions: Linux enforces strict user privilege separation,
    with most processes running as non-root, limiting potential damage.

-   Diverse Ecosystem: Varied distributions and configurations make it
    harder for attackers to target a uniform system.

-   Smaller Attack Surface: Linux often ships with minimal software,
    reducing exploitable entry points compared to Windows\' broader
    default installations.

-   Community-Driven Updates: Frequent, decentralized updates from the
    open-source community address security issues quickly.

Linux is common than Windows in government and high-security systems,
especially for servers, critical infrastructure, and privacy-focused
applications. Its open-source model, strict security features, and
customization make it the go-to choice for secure environments, while
Windows is primarily used in desktop settings or where proprietary
software is necessary. Linux's strict user privilege model, modular
architecture, and features like SELinux, AppArmor, and seccomp make it a
preferred choice for high-security environments. Its open-source nature
enables rapid vulnerability identification and patching, critical for
secure systems. Linux powers most of the world's supercomputers and
high-value devices, where security is paramount. However, both systems
require proper configuration and maintenance to maximize security, as
misconfigured Linux systems can still be vulnerable.[^64]

OpenSCAP plays a critical role in hardening Linux systems and ensuring
system security by providing a standardized, automated framework for
assessing, configuring, and maintaining compliance with security
policies. OpenSCAP provides automated compliance checking, vulnerability
scanning, and remediation to meet rigorous standards. Its role is
especially critical in government and high-security environments, where
Linux's prevalence demands robust tools to maintain a secure posture.
Compared to Windows, OpenSCAP benefits from Linux's open-source
ecosystem, offering greater transparency and flexibility for securing
systems. For implementation, organizations can access OpenSCAP's free
resources or integrate it with enterprise Linux distributions like Red
Hat, which often include built-in OpenSCAP support.[^65]

From a strictly pragmatic point of view Linux is the operating system of
choice when dealing with secure enterprise environment. However, this
viewpoint is often at odds with many users who prefer the familiar
cocoon of the Windows and Microsoft 365 environment -- especially when
it comes to playing games.

The 'playing games' opens pandora's box -- alluding to the tendency to
mix personal and business usage on a single computer. That is a horrible
practice and one that has many security implications. Better have two
systems -- one for work, one for personal use.

It is here that another Linux attribute arises. Linux runs on very
modest hardware -- often flourishing on the cast-aways created by the
ever-increasing baseline requirements for Windows. From Grok AI[^66]

**Business Use Considerations**:

-   **Performance**: Linux is highly efficient, running well on older or
    low-spec hardware. Lightweight distributions (e.g., Xubuntu, Linux
    Mint) can handle office tasks (LibreOffice, Thunderbird) on systems
    with 4 GB RAM and dual-core CPUs. Modern distributions like Ubuntu
    or Fedora benefit from 8-16 GB RAM and SSDs for multitasking and
    enterprise tools (e.g., Google Workspace, Nextcloud).

-   **Compatibility**: Linux supports a broad range of hardware,
    including legacy systems unsupported by Windows 11, making it ideal
    for businesses with diverse or older fleets. ARM support (e.g.,
    Raspberry Pi, Apple M1 via Asahi Linux) adds flexibility for modern
    devices.

-   **Cost**: Linux runs on inexpensive hardware (e.g., \$300-\$500 PCs
    or refurbished systems), and free distributions reduce software
    costs. Enterprise versions like RHEL require subscriptions (pricing
    at [https://www.redhat.com](https://www.redhat.com/)), but
    open-source alternatives (e.g., CentOS Stream, Rocky Linux) are
    free.

-   **Software Demands**: Open-source office suites (e.g., LibreOffice,
    OnlyOffice) and email clients (e.g., Thunderbird, Evolution) are
    lightweight, requiring less RAM and storage than Microsoft 365.
    Browser-based tools (e.g., Google Docs) have similar requirements
    across OSes.

-   **Security**: Linux's modular design and strict privilege separation
    (as discussed previously) reduce resource demands for security
    tools. OpenSCAP and SELinux, common in CMMC environments, run
    efficiently on modest hardware (e.g., 4-8 GB RAM), unlike Windows'
    heavier endpoint protection suites.

## Selecting the Hardware and Software

In the 18 months since that article was published, I have drilled down
into the problem and narrowed the scope to a near laser focus for my
first (hopefully of many) release of a beta product. The focus of this
product is a sole proprietor, consultant, or solopreneur. Their
characteristics include a one-person operation that is frequently home
based. Consequently their cybersecurity needs are relatively modest
since their scope typically is limited to a single easily secured room
or office, a single computer device, and a WAN connection.

Thus, I began development on a single-user workstation (or possibly one
that could be shared) with the following characteristics:

### No Microsoft Windows.

Microsoft Windows and the Microsoft ecosystem were rejected because (as
described above) the hardware requirement limited Windows 11 to more
expensive modern equipment and because of a number of privacy concerns
expressed by knowledgeable IT professionals in various blogs. This led
to the decision to look elsewhere, and that led me to Linux. The chief
characteristics of Linux that made it attractive were modest hardware
requirements, large library of free and open-source software, and no
license costs.

### Choosing the Right Linux Distribution

Linux is a very popular operating system for engineers and STEM
communities and is widely used in business enterprises due to its
perceived ruggedness, reliability, and inherent security. While no
operating system is immune to security breaches, Linux has a much better
track record than Windows and is even slightly better than Mac OS (which
has a common parentage). The Linux marketplace is populated by various
distributions such as RedHat, Ubuntu, CentOS, Fedora, Debian, end
others. This made the choice of a distribution problematic.

Eventually I settled on a rather new distribution known as Rocky Linux a
"free, open-source operating system that is a binary-compatible fork of
Red Hat Enterprise Linux (RHEL). It was created as a community-supported
alternative to CentOS after Red Hat discontinued it, aiming to provide a
stable and production-ready environment for servers and desktops."[^67]
Rocky Linux **is** an open-source enterprise operating system that is
100% bug-for-bug compatible with Red Hat Enterprise Linux®. It offers
stability, updates, support, and migration tools for free, and is backed
by a community of sponsors and partners.[^68]

Rocky's main claim to fame is that it is a near perfect duplication of
segment leader Red Hat Enterprise Linux^®^ (RHEL). This means many of
the security tools and adaptations present in RHEL are directly portable
to Rocky. The second factor that raised it above runner-up Ubuntu (which
also has a tremendous library of security-enhancing features) was the
installer program for Rocky is much more user-friendly and robust than
the equivalent installer in Ubuntu and better supported the complex disk
partitioning scheme needed for NIST compliance.

## Building the Beta Systems

Building the beta systems was divided between selecting and obtaining
the required hardware and then loading and configuring the software.

### Beta System Hardware

Unlike personal systems that often are built for gaming or other fun
activities, business workstations tend to be bland.

Business owners should have at least two computer systems -- one for
work only and a second for personal or recreational purposes. Sharing a
single computer for both business and work introduces significant risks
and is likely to be in contravention of corporate security policies.

As said earlier, Linux has very modest hardware demands -- especially
when used for work. Consequently, when I shopped for a desktop system I
looked for low-end desktops 1 to 2 generations old with enough
performance to meet the recommended specs without breaking the bank.

I opted for what is known as a 1 liter (that's about its volume) small
form factor computer that was not made in mainland China and that was
available in quantity in the used market (eBay). My Choice: The Hewlitt
Packard (HP) EliteDesk 800 G4.

![A close-up of a computer AI-generated content may be
incorrect.](./media/image11.png){width="5.227847769028871in"
height="2.8926312335958007in"}

Figure , HP EliteDesk 800 G4 (Typical)

![A back of a computer AI-generated content may be
incorrect.](./media/image12.png){width="4.6065234033245845in"
height="3.6448622047244092in"}

Figure HP EliteDesk 800 G4 Connectivity

Here's how the 800 G4 stacks up to the equipment requirements:

+------------+-----------------+-----------------+--------------------+
| Component  | Minimum         | Recommended for | Beta System        |
|            | Requirement     | Workstation     |                    |
+============+=================+=================+====================+
| Ar         | 64-bit (x86_64, | x86_64          | x86_64 (AMD/Intel) |
| chitecture | ARM64, ppc64le, | (AMD/Intel) for |                    |
|            | or s390x)       | broad           |                    |
|            |                 | compatibility   |                    |
+------------+-----------------+-----------------+--------------------+
| CPU        | 64-bit          | Multi-core      | 64 Bit Intel Core  |
|            | processor (no   | (e.g., 2+       | i5 or i7 processor |
|            | specific speed  | cores) at 2     | 8^th^ Generation 6 |
|            | listed; 1 GHz+  | GHz+            | or 8 Cores 3 GHz   |
|            | typically       |                 | with               |
|            | sufficient)     |                 | Hyperthreading     |
+------------+-----------------+-----------------+--------------------+
| RAM        | 1.5 GiB (for    | 4 GiB+ (8 GiB+  | 16 GiB minimum /   |
|            | local media     | for heavy GUI   | 32 GiB DDR 4       |
|            | install; 3 GiB  | use or          |                    |
|            | for network)    | virtualization) |                    |
+------------+-----------------+-----------------+--------------------+
| Storage    | 10 GiB          | 40 GiB+ (SSD    | 256 GiB SSD        |
|            | available disk  | preferred for   | Minimum, 512 GiB   |
|            | space           | performance)    | or 2 TB Optional   |
|            | (unpartitioned  |                 |                    |
|            | or resizable    |                 |                    |
|            | partitions)     |                 |                    |
+------------+-----------------+-----------------+--------------------+
| Graphics   | 800 x 600       | 1024 x 768 or   | Intel UHD 630      |
|            | resolution      | higher;         | supporting         |
|            | support         | dedicated GPU   |                    |
|            |                 | optional for    | 4K (UHD): 3840 x   |
|            |                 | advanced        | 2160               |
|            |                 | graphics        |                    |
|            |                 |                 | 2K (QHD): 2560 x   |
|            |                 |                 | 1440               |
|            |                 |                 |                    |
|            |                 |                 | Full HD (FHD):     |
|            |                 |                 | 1920 x 1080        |
|            |                 |                 |                    |
|            |                 |                 | HD: 1280 x 720     |
+------------+-----------------+-----------------+--------------------+

: Table , Beta System Hardware vs. Minimum Requirements

Another obvious benefit of these small systems is they are easily
mounted on a wall, under a desk, or attached to the back of a monitor.
They are also very power thrifty with electricity consuming roughly the
same power as a desk lamp and producing about as much heat.

### Software

This is where weeks turned to months as I tried various software and
operating systems -- finally arriving at my preferred choices:

  -----------------------------------------------------------------------
  Product                  Price         Use Case
  ------------------------ ------------- --------------------------------
  OnlyOffice or Libre      Free          General office productivity,
  Office                                 including word processing,
                                         spreadsheet, and presentations.
                                         Highly compatible with MS Office

  ProjectLibre             Free          Replacement for MS Project

  Thunderbird              Free          Full featured email client

  SCAP Workbench           Free          Security configuration and
                                         testing application to identify
                                         and remediate system
                                         vulnerabilities

  Rocky Linux 9.6          Free          Latest stable release of Rocky.
                                         Version 10 is available by 9.6
                                         was selected based on support by
                                         SCAP Workbench and others.
  -----------------------------------------------------------------------

  : Table Beta System Software Stack

For a detailed description of the installation process see Chapter 10
Rocky Linux Installation and Configuration. My strategy was to create a
master duplication (Golden) disk which could then be used to set up
additional systems by just duplicating the disk (see below)

![A computer hard drive and a hard drive AI-generated content may be
incorrect.](./media/image13.png){width="4.7088604549431325in"
height="3.113079615048119in"}

Figure , Ub-hooded HP EliteDesktop 800 G4 and WavLink Disk Duplicator

This method has been used by businesses for many years and consists of
an installation disk or image that is properly configured with all the
appropriate settings, updates, and choices pre-made for the user. This
(golden) disk is the master for everyone using a particular hardware
device or configuration and is maintained under strict configuration
management by the administrator. If a computer has a corrupted disk, a
virus infection, or a hardware failure the golden disk may be used to
get the system back to a known starting place. Following that the system
can be customized and specific applications loaded completing the
initial or recovery system configuration.

Once the disk was duplicated it was largely plug and play -- the common
hardware being a blessing. I built three HP Desktops and two Dell
Laptops using the same configuration for Beta Testers. I also retained
two of the HP desktops for use in my Home Lab

## End Point Configuration and Hardening

Correctly configuring and hardening the various devices attached to the
network is probably the most technical and time-consuming chores in the
entire cybersecurity process.

Much of the effort is associated with hunting down and correcting (also
known as remediating) various security flaws (or vulnerabilities) that
exist in the system. Fortunately, there are several automated tools
available that will assist the administrator or technician in performing
this chore.

**WARNING**

System hardening involves making very detailed technical changes to the
operating system or software -- changes that are potentially damaging to
the network or the system. These settings and their adjustment can
result in system performance issues, system failure, and potentially
loss of data. Consequently, these adjustments should only be done by a
competent technician and should be preceded by a complete backup of the
equipment to be configured to permit recovery should the configuration
have undesired effects.\
\
You Have Been Warned!

## The origin of "vulnerabilities".

Operating systems (OS) and commercial software are provided for the
masses. As such they include several functions, features, and
capabilities that are geared towards improving the user experience and
driving advertising revenue to the software publisher. Such features
often include convenient widgets or tools that display the news feed
(sponsored by the software company who derives revenue from views and
clicks), weather apps (same story), advertisements in browsers or
software etc. Commercial operating systems and software also harvest
vast amounts of data from users which generates added revenue streams.

Simply installing Windows 11 on a system may result in user data being
generated and linked to a (mandatory) Microsoft account. There are ways
to bypass such data collection attempts, but they do nothing to halt the
OS from 'phoning home' every time you access certain functions. All this
is under the guise of product improvement.

The unspoken price paid for these 'bonus' products or features is loss
of privacy and potential for exploits by cyber criminals. So, the first
task facing a business user who wants to improve security is removing
these eavesdropping services or software from the system that just
arrived from a retailer. There are two methods for accomplishing this
cleanup described below.

A second source of vulnerabilities known as Common Vulnerabilities and
Exposures (CVEs) which are tracked by MITRE Corp as a part of the CVE
Program. MITRE describes it as: "The mission of the CVE^®^ Program is to
identify, define, and catalog publicly disclosed
cybersecurity **v**ulnerabilities[^69]. There is one [**CVE
Record**](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryRecord) for
each vulnerability in the catalog. The vulnerabilities are discovered
then assigned and published by organizations from around the world that
have partnered with the CVE
Program. [**Partners**](https://www.cve.org/PartnerInformation/ListofPartners) publish
CVE Records to communicate consistent descriptions of vulnerabilities.
Information technology and cybersecurity professionals use CVE Records
to ensure they are discussing the same issue, and to coordinate their
efforts to prioritize and address the vulnerabilities."[^70]

Securing systems then becomes an exercise in finding and correcting the
various CVEs present on a network device. Although simple in concept the
exercise often turns into a game of 'Whack-a-Mole' as CVEs are being
discovered or retired daily. Consequently, there are a plethora of
services and software that search out and remediate CVEs -- or at least
the ones that can be automatically fixed. More on that later.

## Endpoint Hardening 

Endpoints are devices that connect to the network such as workstations,
printers, network attached storage, routers, etc. They are the primary
risk when assessing the network as they represent doorways into the
system.

### Basic Input-Output Systems (BIOS)

The low-level software that provides the infrastructure tor computer
operation is comprised of the Basic Input-Output System (BIOS).
Traditional BIOS is what is known as 'firmware' and resides in a
read-only memory device in the system's hardware. Generally speaking the
BIOS is a 'set-it and forget-it' proposition needing little attention
other than the occasional upgrade. This is true as well for other
devices such as printers, routers, storage devices, etc.

Modern systems implement specific security provisions starting at this
foundational level by encrypting portions of this code and then
comparing that copy with the copy attempting to start the system. This
is called a 'secure boot' and relies on a 'core root of trust' and is a
feature that can be toggled on-or off through system settings.[^71]

During system hardening a vendor specific checklist is often run by a
technician to assure critical security settings and features such as
this are enabled by default in the system BIOS.

### Operating Systems -- Microsoft Windows

Although not used on the CyberHygiene Project in its current form, I did
a significant amount of research on how to harden Windows 10/11 before I
made the Linux decision. This information is included as a reference for
those who wish to travel that path.

Microsoft Windows is a very popular (75% + market share) operating
system and is widely used in commercial applications and offices. The
Windows product is available in multiple versions and editions. The most
common being Windows 10 or 11 in either the Home, Professional, or
server editions. The home editions lack many of the features and tools
needed for use in a NIST environment and are thus not considered here.
The server and professional versions are similar with the server edition
have some additional features aligned with using it in a role such as a
domain controller.

Hardening Windows using the available free tools is possible but
technically convoluted. No single tool seems to do 100 percent of the
required hardening task and novices (myself included) have found
themselves locked out of their system and having to resort to wiping the
disk and restarting the process following what seemed to be a casual
mistake.

Windows hardening is also dependent on setting the contents of specific
values in a database called the Registry using a very tech-oriented tool
called the registry editor or Regedit. This is not a task for the novice
as mistakes ate often impactful and immediate. Consequently, some
automated tools (described below) are used frequently to manage critical
settings. But even these are not without peril.

If you are considering a DIY project -- be sure to back everything up
and be prepared for potential loss of data, system corruption, or an
unresponsive system.

YOU HAVE BEEN WARNED.

### Hardening Kitty

The free program Hardening Kitty (see
<https://github.com/scipag/HardeningKitty>) has long been a staple in my
toolkit and is key to creating a secure windows dwployment as it locks
in a number of important security settings -- some of which are not
addressed by other tools. This tool is recommended for experts only as
it is very powerful and is only usable from a command line interface
i.e., PowerShell interface. The Cyberhygiene implications and use of
this tool is to use it to create windows installation where initial
hardening settings are applied.

### Windows Debloat.

Windows 11 -- as distributed by Microsoft -- is aimed at a specific user
demographic. As a result, it has several features or functions
configured for user convenience at the price of user security. This is
not to say windows is inherently insecure -- but it is configured in
such a manner that consumer oriented and information sharing
capabilities have been prioritized for "ease of use" or "customer
experience" whereas our intent is to have a lean and highly secure
implementation. Getting there requires disabling or removing many of the
'convenience' features in Windows 11. This is accomplished by windows
debloat (see: <https://github.com/Raphire/Win11Debloat>) to produce a
minimalistic version of the product. Similar images are available
through CIS (<https://www.cisecurity.org/cis-hardened-image-list>) for
virtual machines.

Another tool usable for debloating windows (and many other uses as well)
is Chris Titus winutil (see <https://github.com/ChrisTitusTech/winutil>)
which will remove the non-essential windows components from an installed
image.

### Senteon

One service that has been used -but is not recommended because of
duplication with another service -- was the Senteon Hardening Software
-- an agent-based product that deployed and installed policies via
registry or other settings to establish and maintain a secure
configuration aligned with a chosen cybersecurity framework.

Although the product is highly effective in not only initially forcing
compliance with a standard, it also monitors 'drift' of those setting
from the baseline. The security standard used is not NIST SP 800-171
however, but CIS 8.0. Although the two are closely aligned, there are
some differences as reported by Grok AI :

"... while both frameworks aim to enhance cybersecurity, NIST SP 800-171
is more rigid with specific settings for CUI protection in regulated
environments, whereas CIS Controls v8 provide a broader, more adaptable
set of guidelines for general cybersecurity across diverse sectors. "

From a practical standpoint some 82 percent of the NIST SP 800-171
controls may be directly mapped to CIS 8.0 so there is a good degree of
overlap between the two. However, the NIST requirements based on
Security Technical Implementation Guidelines (STIGs) are best
implemented by having the settings aligned with the comparable CIS STIG
Benchmark and the precise hardware and software where it is installed.

Informal testing conducted by the author using a combination of the
Senteon benchmarks and other products achieved very compliant results
when evaluated by the DISA STIG Compliance Checker and scored 100% for
windows 10/11 and the Windows Firewall (which have separate STIGS). The
downside of Senteon is cost and coverage.

1.  [Cost]{.ul}. The product is priced at \$24/endpoint per year
    (\$2/month) but has a minimum license quantity of 50 endpoints
    (\$1,200/year). If the service is brokered by an MSP then it is
    probably a good deal. If not, the similar service bundled in
    BitDefender Gravity Zone (about 500+ for 20 endpoints/year plus
    extras) is a better deal.

2.  [Coverage.]{.ul} In the windows environment there are multiple STIGS
    that need to be reun against a system such as Adobe Acrobat, Google
    Chrome, MS 365, etc. Senteon does not yet offer 100 percent coverage
    for all the various STIGS that need to be addressed whereas Linux
    avoids this complication through system design and OpenSourcing of
    software code.

### Linux 

Linux hardening is considerably faster, easier, and less expensive than
the comparable Windows workstation or server. This is because of the
efforts of OpenScap[^72] which provides security policies for multiple
releases of Linux. For example, RHEL 9 (and by extension Rocky Linux 9)
supports the following security guides:

-   [\[DRAFT\] Unclassified Information in Non-federal Information
    Systems and Organizations (NIST
    800-171)](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-cui.html)

-   [PCI-DSS v3.2.1 Control Baseline for Red Hat Enterprise Linux
    9](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-pci-dss.html)

-   [\[DRAFT\] DISA STIG for Red Hat Enterprise Linux
    9](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-stig.html)

-   [\[DRAFT\] DISA STIG with GUI for Red Hat Enterprise Linux
    9](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-stig_gui.html)

-   [CIS Red Hat Enterprise Linux 9 Benchmark for Level 2 --
    Server](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-cis.html)

-   [CIS Red Hat Enterprise Linux 9 Benchmark for Level 1 --
    Server](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-cis_server_l1.html)

-   [CIS Red Hat Enterprise Linux 9 Benchmark for Level 1 --
    Workstation](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-cis_workstation_l1.html)

-   [Australian Cyber Security Centre (ACSC) Essential
    Eight](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-e8.html)

-   [Health Insurance Portability and Accountability Act
    (HIPAA)](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-hipaa.html)

-   [Australian Cyber Security Centre (ACSC) ISM
    Official](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-ism_o.html)

-   [CIS Red Hat Enterprise Linux 9 Benchmark for Level 2 --
    Workstation](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-cis_workstation_l2.html)

-   [Protection Profile for General Purpose Operating
    Systems](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-ospp.html)

-   [ANSSI-BP-028
    (enhanced)](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-anssi_bp28_enhanced.html)

-   [ANSSI-BP-028
    (high)](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-anssi_bp28_high.html)

-   [ANSSI-BP-028
    (intermediary)](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-anssi_bp28_intermediary.html)

-   [ANSSI-BP-028
    (minimal)](http://static.open-scap.org/ssg-guides/ssg-rhel9-guide-anssi_bp28_minimal.html)

All an administrator need do is install the OpenSCAP workbench app
(free) and select the appropriate security guide (RHEL 9) and profile
"Unclassified Information in Non-federal Information Systems and
Organizations (NIST 800-171)" and the workbench does the heavy lifting.

The OpenSCAP Workbench uses the Security Guide and profile to scan the
target system, identify misconfigured settings, and make immediate
remediations for the vast majority of problems. Those that cannot be
fixed on the spot can be corrected with explicit instructions or
snippets of code provided by the tool. Done.

### Linux Application Hardening

Application hardening is typically covered by the frequent updates and
patches to apps by the open-source community and enhanced by tools such
as security enhanced Linux (SELinux) and AppArmor. Both provide
Mandatory Access Control (MAC) mechanism but are mutually exclusive --
one or the other may be used -- but not both.

MAC is a security model that enforces strict, centralized policies to
regulate access to resources, such as files, directories, or network
services. MAC) enhances security by enforcing strict, system-wide
policies that confine applications - regardless of their source or
intent - to predefined boundaries. The appropriate package (AppArmor or
SELinux) is installed as a part of the OS hardening using OpenSCAP.

Should a third-party app (e.g., a downloaded utility, plugin, or
service) attempt to \"misbehave\" (such as accessing sensitive files,
escalating privileges, or exfiltrating data due to a vulnerability or
malice), MAC intervenes at the kernel level to prevent and/or log these
actions. This is a proactive defense, assuming the app can\'t be fully
trusted. Unlike more flexible models, MAC does not allow individual
users or resource owners to override these policies - access decisions
are made solely by the system administrator or a central authority based
on predefined rules, often tied to security classifications like
sensitivity levels.

## Correcting Vulnerabilities and Misconfigurations.

Cyber criminals are opportunists -- if they see an open door they will
walk in and create mischief -- or worse. As noted earlier, these 'open
doors' are cataloged as CVEs and the correction process for closing off
these various attack vectors is called 'Hardening'.

A quick study of the below chart will identify the source or systems
affected by known vulnerabilities (key exploited vulnerabilities) and
should provide a basis of comparison when evaluating potential suppliers
or software/hardware providers.

![A computer screen shot of a computer screen Description automatically
generated with medium
confidence](./media/image14.jpg){width="5.854557086614173in"
height="3.892404855643045in"}

Figure Defense Information Security Agency - Key Exploited
Vulnerabilities (October 2023)

## Baseline Maintenance

No discussion of end-point hardening and system configuration would be
complete without acknowledging the dynamic nature of cybersecurity. It's
very much like the arcade game of "Whack-a-Mole" where every time you
hit a mole another pops up in its place. Such is the nature of the
cybersecurity task with new threats emerging daily and software
developers releasing new versions of products as well as security
updates (i.e., 'patches') on a near continuous basis.

New or emerging vulnerabilities are cataloged (as mentioned earlier) as
CVEs. Here is a representative view of the volume of activity with
respect to CVEs.

![A screenshot of a phone Description automatically
generated](./media/image15.png){width="2.3178226159230095in"
height="2.6962029746281715in"}\
Figure 12 CVE Activity for November 30, 2024 [^73]

This leads to a situation where not only must a system be hardened to a
specific baseline, it must also be consistently monitored and updated to
kept at a desired level of protection. Hence the issue of software (and
baseline) maintenance and management.

## Patching

Software vendors release updates to their products in several ways. New
versions i.e., version 3.0 vs. version 2.0 are referred to as major
releases and are often sold as a separate product. Minor releases i.e.,
version 3.1 vs version 3.0, are more frequent releases and usually
correct issues to the previous release or incrementally add new
functions or features. Patches, on the other hand are released much more
frequently and are specifically aimed at remediating a security or
functional flaw in the product.

Managing the multitude of patches in the global software environment is
a big job -- one best managed by software services such as Tenable,
CrowdStrike, etc. The solution included in the CyberHygiene is provided
as a component in the anti-malware and endpoint management suite called
Gravity Zone from BitDefender.

Like most similar products the patch manager starts with an inventory of
the software (both operating system and applications) installed on an
endpoint and then monitors various sources for changes to those
products.[^74]

Solutions range from user initiated manual checks and updates to more
fully automated patch management applications (or services) that
automatically find and install patches on a daily (or more frequent)
basis.

## Vulnerability Scanning 

Working hand-in-hand with patching services we find vulnerability
management products that monitor for new CVEs, assess the impact on your
network or endpoint based on the installed software, and notify the
system administrator of the threat. Vulnerabilities can be of two types:

1.  Non-conformances to a system baseline i.e., drift or

2.  New CVEs affecting your system or network.

The software generally advises of the vulnerability existing and then
offers advice on either remediation (fixing) or mitigation (reducing the
impacts of an attack.

Irrespective of the checklist used the requirements are the same: find
and fix a long list of possible misconfigurations and then monitor the
now hardened system to ensure the settings are not undone by users or
subsequent software updates i.e., 'drifting' off the desired
configuration.

Much of the heavy lifting for hardening the system to NIST SP 800-171
has been done via the preceding steps. The final step is to use the SCAP
Workbench tool which we downloaded earlier to identify and remediate
issues.

What we are looking for is the following report:

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image17.png){width="6.044303368328959in"
height="4.705645231846019in"}

Figure , Sample OpenScap System Scorecard Report

Getting that 100 percent score is straightforward provided you followed
the preceding steps to partition your drive and select the appropriate
security profile during installation. The remaining steps are covered
below.

# Level 1 (Foundational) Network Approach {#level-1-foundational-network-approach .Chapter}

The below network architecture was developed for CMMC Level 1 compliance
with NIST SP 800-171 (Foundational) using off-the shelf components and
services with a maximum budget of \$5,000.

![A diagram of a network diagram Description automatically
generated](./media/image18.png){width="5.538670166229221in"
height="3.488888888888889in"}

Figure Notional CMMC Level 1 Compliant Network

## Level 1 Domain Controller

The level 1 DC solution selected was value driven to provide the needed
functionality at an affordable price. The DC comprises the following
equipment and services. Where possible retail price estimates are
included:

1.  Donain Controller Hardware

    a.  HPE Microserver Gen 10/11 (diskless) = \$ 666.00

    b.  16 GB RAM (generic) \*= \$ 35.00

    c.  iLo 5 Enablement Kit\* = \$174.00

    d.  TPM Module\* = \$123.00

    e.  4 x 4TB HDD @ \$149 ea [= \$596.00]{.ul}

> **Total \$1,594.00**

Items marked with \* are included in Gen 11's price of \$1,159 along
with additional improvements.

2.  BitDefender Gravity Zone 10 endpoints with patch management and
    device encryption options \$500/year

3.  Cloudflare DNS and network monitoring service -- Free

4.  SSL Certificate - Free

5.  Domain Name (Cyberinabox.net) \$30/year

### Level 1 Components and Services

Other network components include a Firewall/router such as the Netgate
4100 (\$549.00) and a 16 port switch such as the Netgear GS316EP (
\$239) which can be used in either a managed or unmanaged role. Total
cost for hardware and software is just over \$3,100 plus installation
and set-up. Well within the \$5,000 budget established for Cybersecurity
in a Box in my 2024 Journal of Contract Management article.

  ------------------------------------------------------------------------------------
  Feature or Capability BitDefender              Synology NAS  Cloudflare   Firewall
                        Gravity Zone             / DSM[^75]^,^              
                                                 [^76]                      
  --------------------- ------------- ---------- ------------- ------------ ----------
  Cost per Year         \$400/10      \$0        \$0[^77]      \$0[^78]     \$0
                        users                                               

  AntiMalware           √                                                   √

  Patch Management      √                                                   

  Endpoint Management   √                                                   
  (Policy Enforcement)                                                      

  User authentication                 √                                     
  and rights management                                                     

  Lightweight Directory               √          √                          
  Access Protocol                                                           
  (LDAP)                                                                    

  Multifactor                         √                                     
  Authentication                                                            

  Full Drive Encryption √                        √                          

  Network Traffic                                √             √            √
  Encryption -Transport                                                     
  Layer Security TLS                                                        

  Network traffic       √                                      √            √
  monitoring and                                                            
  Intrusion                                                                 
  detection/reporting                                                       

  Dedicated Denial of                                          √            
  Service protection                                                        

  Free SSL Certificate                                         √            

  Virtual Private                     √                                     √
  Network (VPN) support                                                     

  Secure File Sharing                 √                        √            
  and network traffic                                                       
  ------------------------------------------------------------------------------------

  : Table Level 1 System Summary of Features and Capabilities

## Network Hardening Overview

The first step is to identify and correct known vulnerabilities by
performing a complete scan of every endpoint on the network -- including
the Router, Switches, Computers (or servers) and virtual machines for an
exhaustive list of possible vulnerabilities.

The list of vulnerabilities is called (among other names) a Security
Technical Implementation Guide (STIG) which is "a configuration standard
consisting of cybersecurity requirements for a specific product"[^79] A
repository of STIGs is maintained at the National Institute of Standards
and Technology (NIST) at https://ncp.nist.gov/repository . An alternate
source is the Center for Internet Security (CIS) who publish a series of
CIS Benchmarks which are mapped (cross referenced) to the DISA STIGs and
are acceptable for use for government systems ("While the use of STIGs
and SRGs by CSPs is preferable, industry-standard baselines such as
those provided by the Center for Internet Security (CIS) Benchmarks are
an acceptable alternative to the STIGs and SRGs.")[^80]

## Level 1 Compliance

Once installed and set-up the network can be easily configured with the
aid of policy templates into compliance with NIST SP 800-171 Level 1. It
is important to note that the specified solution not only meets but
exceeds the basic requirements in several areas. I would classify it as
Level 1+ and approaching Level 2 requirements.

  -----------------------------------------------------------------------------------
  NIST SP   Family           Description            Method, Tool or  Comments
  800-171                                           Product used for 
  Control                                           Compliance       
  --------- ---------------- ---------------------- ---------------- ----------------
  3.1.1     Access Control   Limit system access to Synology C2      C2 provides
                             authorized users,      Identity         robust LDAP user
                             processes acting on    Management       authentication
                             behalf of authorized                    and rights
                             users, and devices                      management.
                             (including other                        
                             systems).                               

  3.1.2     Access Control   Limit system access to Synology C2      C2 provides
                             the types of           Identity         robust LDAP user
                             transactions and       Management       authentication
                             functions that                          and rights
                             authorized users are                    management.
                             permitted to execute.                   

  3.1.20    Access Control   Verify and             BitDefender      
                             control/limit          Endpoint         
                             connections to and use Management and   
                             of external systems.   Firewall rules   

  3.1.21    Access Control   Limit use of           BitDefender      
                             organizational         Gravity Zone     
                             portable storage       Endpoint         
                             devices on external    Management       
                             systems.                                

  3.5.1     Identification   Identify system users, Synology C2      
            and              processes acting on    Identity         
            Authentication   behalf of users, and   Management       
                             devices.                                

  3.5.2     Identification   Authenticate (or       Synology C2      Includes
            and              verify) the identities Identity         multifactor
            Authentication   of users, processes,   Management       authentication
                             or devices, as a                        
                             prerequisite to                         
                             allowing access to                      
                             organizational systems                  

  3.8.3     Media Protection Sanitize or destroy    Written Policy   
                             system media                            
                             containing CUI before                   
                             disposal or release                     
                             for reuse.                              

  3.10.1    Personnel        Limit physical access  Written Policy   
            Security         to organizational                       
                             systems, equipment,                     
                             and the respective                      
                             operating environments                  
                             to authorized                           
                             individuals.                            

  3.10.3    Personnel        Escort visitors and    Written Policy   
            Security         monitor visitor                         
                             activity.                               

  3.10.4    Personnel        Maintain audit logs of Written Policy   
            Security         physical access.                        

  3.10.5    Personnel        Control and manage     Written Policy   
            Security         physical access                         
                             devices.                                

  3.13.1    System and       Monitor, control, and  Synology C2      
            Communications   protect communications Identity         
            Protection       (i.e., information     Management,      
                             transmitted or         BitDefender      
                             received by            Gravity Zone     
                             organizational         Endpoint         
                             systems) at the        Management, and  
                             external boundaries    Firewall rules   
                             and key internal                        
                             boundaries of                           
                             organizational                          
                             systems.                                

  3.13.5    System and       Implement subnetworks  BitDefender      
            Communications   for publicly           Gravity Zone     
            Protection       accessible system      Endpoint         
                             components that are    Management, and  
                             physically or          Firewall rules   
                             logically separated                     
                             from internal                           
                             networks.                               

  3.14.1    System and       Identify, report, and  Written Policy   
            Information      correct system flaws                    
            Integrity        in a timely manner.                     

  3.14.2    System and       Provide protection     BitDefender      
            Information      from malicious code at Gravity Zone     
            Integrity        designated locations   Endpoint         
                             within organizational  Management       
                             systems.                                

  3.14.4    System and       Update malicious code  BitDefender      Automatic
            Information      protection mechanisms  GravityZone      updates to
            Integrity        when new releases are                   security
                             available.                              software plus
                                                                     patch management
                                                                     of applications

  3.14.5    System and       Perform periodic scans BitDefender      Scan frequency
            Information      of organizational      Gravity Zone     is set as a
            Integrity        systems and real-time  Endpoint         software
                             scans of files from    Management and   function and
                             external sources as    Cloudflare       then
                             files are downloaded,                   accomplished
                             opened, or executed.                    automatically on
                                                                     access of the
                                                                     data and
                                                                     systemwide on a
                                                                     time based
                                                                     function
                                                                     specified by the
                                                                     administrator.
  -----------------------------------------------------------------------------------

  : Table Level 1 System Compliance with NIST SP 800-171 Controls
  (pending update)

# Level 1 Laboratory Implementation  {#level-1-laboratory-implementation .Chapter}

The choices made in the notional system were made using a cost focused
approach that would provide the best results without reliance on paid
services. Consequently, with the exception of the anti-malware/endpoint
management solution from BitDefender Gravity Zone, all products and
services are either included in the initial purchase price or are free.
This fits well with cost conscious VSB owners and avoids potentially
pay-as-you-go monthly fees from SaaS providers including Microsoft 365.

The choice of hardware components was intentionally limited to brands
manufactured outside China in deference to FAR 52.204-25 Prohibition on
Contracting for Certain Telecommunications and Video Surveillance
Services or Equipment.

# Server

Hardware was the easy part for me. I have built dozens of computers
since becoming interested in them in 1982. As I said earlier Linux is
quite capable of running on very modest hardware with many experimenters
and home lab enthusiasts successfully running servers on little more
than a nano PC or a Raspberry Pi. I splurged and opted for an existing
HP MicroServer Gen 10+. Were I to start anew I would opt for the
slightly more modern Gen 11 with its more modern processor, faster
memory, and other enhancements.

![A black rectangular electronic device AI-generated content may be
incorrect.](./media/image19.jpeg){width="4.385518372703412in"
height="2.670200131233596in"}

Figure , HP MicroServer Gen 10 Plus v2

Although lesser hardware such as the HP Elite Destop 800 series would
easily handle the task I elected to upgrade to the more capable
MicoServer, A list and comparison of their pertinent specifications is
below.

  --------------------------------------------------------------------------
  Feature           HPE ProLiant MicroServer   HPE ProLiant MicroServer
                    Gen10 Plus v2              Gen11
  ----------------- -------------------------- -----------------------------
  Form Factor       Ultra Micro Tower          Ultra Micro Tower

  Processor Options Intel® Xeon® E-2300 Series Intel® Xeon® 6300-series (up
                    and 10th Gen Pentium® G    to 8 cores), Xeon® E-2400,
                    processors (up to 4        Pentium® processors; Chipset:
                    cores); Chipset: Intel®    Intel® C262
                    C252                       

  Memory            2 DIMM slots; DDR4 UDIMM   4 DIMM slots; DDR5 UDIMM ECC;
                    ECC; Max 64 GB (2 x 32 GB  Max 128 GB (4 x 32 GB @ 4400
                    @ 3200 MT/s)               MT/s)

  Storage           4x non-hot plug 3.5\" SATA 4x non-hot plug 3.5\" SATA
                    bays; Max 16 TB HDD or     bays; Max 16 TB HDD or 3.84
                    3.84 TB SSD; Intel VROC    TB SSD; Intel VROC SATA
                    SATA Hybrid RAID           Hybrid RAID

  Networking        Embedded Intel i350 AM4    Embedded Broadcom BCM5719
                    1Gb 4-port                 1GbE 4-port

  Expansion Slots   1x PCIe 4.0 x16            1x PCIe 5.0 x16 low-profile;
                    low-profile                1x PCIe 4.0 x4 (x8 connector)
                                               low-profile

  Power Supply      180W external              180W or 330W external
                    non-redundant              non-redundant

  Dimensions (H x W 4.68 x 9.65 x 9.65 in      6.06 x 10.28 x 9.82 in (15.4
  x D)              (11.89 x 24.5 x 24.5 cm)   x 26.1 x 24.9 cm)

  Weight (Max)      15.87 lb (7.2 kg)          19.07 lb (8.65 kg)

  Management        HPE iLO 5 (requires        HPE iLO 6 (embedded)
                    enablement kit)            

  TPM 2.0           Embedded, enabled by       Embedded, enabled by default
                    default (disabled for      (disabled for China)
                    China)                     

  FIPS 140 Support  Yes (FIPS 140-2 validation Yes (FIPS 140-2 validation
                    via iLO 5)                 via iLO 6)

  Other Security    UEFI Secure Boot & Secure  UEFI Secure Boot & Secure
  Features          Start; Immutable Silicon   Start; Immutable Silicon Root
  (NIST-relevant)   Root of Trust; Common      of Trust; Common Criteria
                    Criteria certification;    certification; Firmware
                    Firmware rollback; Secure  rollback; Secure erase;
                    erase; Configurable for    Configurable for PCI DSS;
                    PCI DSS                    Server Configuration Lock
  --------------------------------------------------------------------------

  : Table MPE Microserver Gen 10 vs Gen 11 Comparison

A quick review shows both systems are equally capable in a very small
office environment with the Gen 11 having an advantage in terms of being
more future-proof. Using the Microserver also allows access to a number
of server only features in the hardware (like error correcting memory
(ECC)) and a more robust BIOS.

  --------------------------------------------------------------------------
  Feature Category  HPE MicroServer Gen10     HP Z Workstation / Laptop BIOS
                    Plus v2 / Gen11 BIOS      (Commercial UEFI Setup)
                    (UEFI System Utilities)   
  ----------------- ------------------------- ------------------------------
  Boot Modes        UEFI Mode (default) and   UEFI Mode (default); Legacy
                    Legacy BIOS Mode (Gen10); BIOS Mode supported on most
                    Gen11 primarily UEFI,     models. Secure Boot available.
                    Legacy support varies by  
                    model. Secure Boot and    
                    Secure Start enabled.     

  Interface &       Graphical UEFI interface  Graphical UEFI interface with
  Navigation        with menus: System        tabs: Main, Security,
                    Configuration             Advanced, UEFI Drivers.
                    (BIOS/Platform Config -   Mouse/keyboard navigation;
                    RBSU), One-Time Boot      simpler, more user-friendly
                    Menu, Embedded UEFI       for non-IT users.
                    Shell, Boot Order,        
                    Network Options.          
                    Text-based options        
                    available.                

  Security Features UEFI Secure Boot, Secure  Secure Boot, TPM Embedded
                    Start, Immutable Silicon  Security (with TPM Guard on
                    Root of Trust, TPM 2.0    newer models), BIOS Sure
                    configuration, FIPS 140   Start, Power-On/Administrator
                    support via iLO, firmware passwords, DriveLock, Secure
                    rollback, Common Criteria Erase (NIST 800-88 compliant),
                    certification. BIOS Sure  Virtualization Based
                    Start equivalent via iLO  Protection. Pluton Security
                    integration.              Processor on select AMD/Intel
                                              models.

  Management        Deep integration with HPE Intel AMT (Active Management
  Integration       iLO (Gen10 requires kit,  Technology) for remote
                    Gen11 embedded) for       management on Intel models;
                    remote BIOS access,       USB Key Provisioning, Watchdog
                    configuration, and        Timers. Less integrated than
                    updates. Supports mass    iLO; focuses on vPro/AMT for
                    deployment tools.         enterprise desktops.

  Hardware          Extensive: Processor      Processor (performance modes,
  Configuration     (hyper-threading, power   hyper-threading), Memory
                    profiles), Memory (ECC    (non-ECC typical), Storage
                    support), Storage         (SATA/AHCI/RAID basic),
                    (RAID/SATA options,       Built-in Devices (USB/ports
                    VROC), Network (embedded  disable), PCIe/M.2 slots,
                    NIC config), PCIe slots,  Thunderbolt options. More
                    Fan/Power profiles        focus on graphics/GPU tuning
                    optimized for server      in workstations.
                    reliability.              

  Power Management  Server-oriented:          Workstation/Laptop:
                    Static/Dynamic power      Performance/Balanced/Thermal
                    capping, OS Control Mode, modes, Runtime Power
                    redundant PSU support,    Management, Modern Standby,
                    thermal profiles for 24/7 Battery Health Manager
                    operation.                (laptops), After Power Loss
                                              options (desktops).
                                              Laptop-specific: Lid open
                                              wake, hibernate.

  Other Notable     Embedded applications     HP Sure Recover, Remote
  Features          (diagnostics, licensing), Diagnostics scheduling, MAC
                    HTTP boot, PXE support,   Address Pass Through
                    compliance for NIST/PCI   (laptops), RFID Reader
                    DSS via firmware. No      settings (select models),
                    overclocking.             Performance Control Modes.
                                              Overclocking limited or
                                              absent; more consumer-friendly
                                              diagnostics.
  --------------------------------------------------------------------------

  : Table HP Server vs Workstation BIOS comparison

### Connectivity

![The back of a computer AI-generated content may be
incorrect.](./media/image20.png){width="7.00632874015748in"
height="3.8452471566054243in"}

Figure HPE Microserver Gen 10 Plus V2 Rear Panel connections.

Servers are designed with network connectivity in mind and the HP
Microserver Gen 10 is no exception providing 4 x 1Gb RJ45 ethernet
connections, a total of 6 USB Type A connectors, and two expansion card
slots 1 dedicated for the iLO enablement card and one for a range of
expansion cards such as high-speed (2.5 Gb or 10 Gb), a hardware RAID
card or a graphics card. Also, with an eye towards NIST compliance, the
case has a locking front faceplate to limit access to the drive bays and
a padlock hasp on the rear to secure the case. These features add tamper
resistance to the unit improving its security and compliance with NIST.

## Firewall / Router

The Netgate SG 2100 firewall and router was selected for its
price/performance trade-off, small size, and features. The device
selected could have just as easily been any of a number of alternate
choices including the Sophos XG86 or XGS88. It came down to a choice
based on money. The Netgate 2100 at \$369.00 is less expensive than the
Sophos (\$521.45) and several others initially but is also less
expensive in the long run. This savings comes from the licensing and
support costs. For example, the Sophos XGS costs \$1,773.18 for the
hardware and a 5-year subscription to the Sophos XStream software. The
Netgate products use the open source pfSense+ software which is free for
the life of the product. Netgate Support is priced at: Free (software
updates and initial setup), \$399/year (with 24 hour response) or
\$799/year (adds 4 hour response and telephone support). Pricing for
Sophos is more difficult to assess as their annual costs consist of
license fees for multiple products plus support fees.

From a set-up and configuration perspective the Netgate is more user
friendly than Sophos albeit at the cost of a centralized (web based)
management system geared towards enterprise systems. Either of the two
appliances will perform admirably and the choice of the Netgate could
have easily gone the other way should the VSB have multiple offices, a
high number of VPN clients etc.

One advantage of the Netgate appliance and its pfSense software is the
ability to install various add-on packages from a software store built
into the GUI to address specific needs. For example, the Suricata
open-source intrusion prevention system (IPS) is easily added to the
device with free (rules are delayed by up to 30 days) or paid (rules are
immediately available upon release) levels.

## Network Switch

The choice of the Netgear GS316EP network switch was driven by its rich
feature set, robust all metal construction, 32Gb/sec thruput, and 16
Power over Ethernet (PoE) ports. The PoE capability makes installation
of surveillance cameras or other devices much easier as no additional
power adapter is required. From a pricing standpoint the \$279.00 price
is very affordable for a managed switch.

The GS316EP has a SFP port to connect with the router plus 15 additional
PoE (RJ-45) connections for network devices. The browser-based
management interface allows the administrator to assign ports to a
Virtual LAN (VLAN), impose Quality of Service limitations, port
mirroring, and port aggregation to increase thruput to selected devices.
Many of these feature fall into the 'nice to have' category but are
useful for growth or expansion.

# 

# Designing a Representative Level 1 Lab Network {#designing-a-representative-level-1-lab-network .Chapter}

Once the secure workstation and single-person company needs have been
met, the next task is combining two or more of the workstations with
other supporting equipment and software to form a low-cost, cybersecure,
Level 1 Network.

The below diagram is a notional representation of a core network for a
Very Small Business (VSB) that the author created to test various
software and network settings to achieve baseline compliance with the
FAR 52.204-21 / NIST 800-171 Low requirements. With minor modifications,
it could easily expand to provide additional capabilities, add users,
and become NIST 800-171 Moderate (Level 2) compliant.

![A diagram of a computer network Description automatically
generated](./media/image21.png){width="6.185430883639545in"
height="3.3346412948381454in"}

Figure Notional VSB Network Layout

### Network architecture and design considerations

The below considerations are based on a variety of source information
and personal experience with a laboratory system over the past 4 years.
The overall design is based on the needs of the typical very small
business as described in Chapter 1 one of this paper.

The lab network is based on a wired network approach since all the
equipment is located in a small area. Additionally, wired connections
are perceived as being slightly more secure and with a potential speed
advantage over all but the newest WiFi 6 equipment. While some experts
say things like "modern Wi-Fi is now firmly positioned as a genuine
alternative to an Ethernet connection for both consumers and businesses
with a wealth of devices now at their disposal."[^81] Although the
newest Wi-Fi 6 holds a slight advantage over the standard 1GB/sec
ethernet, newer wired technologies are also available providing 2.5, 5,
and 10GB/sec transfer rates easily trumping Wi-Fi technologies while
still providing the security of a point-to-point wired as opposed to
radio) connection. When designing the network the type of work likely to
be performed, the size of files created, and the number of users all
pointed to the conclusion that a high-speed network (i.e., faster than
the 'standard' 1Gb ethernet) was likely unnecessary and would add
expense with little payoff.

True, encrypted Wi-Fi is reasonably secure but it's hard to dismiss the
security advantage offered by a wired approach that requires physical
access (or VPN) to the network for a connection.

### Firewall/Router

A hardware router/firewall should stand at the entry to the network as
the gatekeeper. The router assigns incoming traffic to a particular
network address, filters content, and applies various rules to correctly
route incoming and outgoing traffic. The firewall function serves to
block malicious content. While most computers attached to the network
will have some level of a software firewall enabled, the network
firewall is the doorman keeping the riff-raff outside and is the
ultimate decider of what gets in or what gets out of the network.

The recommended network configuration features a more configurable and
robust hardware router and firewall than typically provided by internet
service providers. The standard (consumer) device typically meets or
exceeds the needs of a homeowner but falls short of the robust
capabilities of a commercial or business-oriented device. PC Magazine
reports[^82] :

"What you will get in business-class routers at all price points is
stronger security features, more flexibility in giving you access to
your network from remote locations, and the ability to scale as your
business grows."

Here are some of the features typical of the business class devices:

-   Robust VPN for multiple users

-   SSL Portal and SSL Tunnel VPNs

-   Virtual Networks (VLANS) to segment the network into separate
    enclaves thus allowing sensitive information to be
    compartmentalized.

-   IPv6 Support for expanded network addressing

-   DMZ port for webserver or other device that needs direct internet
    access

-   Content Filtering: the ability to block access to certain Internet
    content by using keywords or blacklists (prohibited URLs), or by
    allowing clients to access only permitted sites through a whitelist.

-   Stateful Packet Inspection: [^83] "*a dynamic packet filtering
    technique for firewalls that, in contrast to static filtering
    techniques, includes the state of a data connection in the
    inspection of packets."*

-   [**Endpoint detection and
    response**](https://www.fortinet.com/products/endpoint-security/fortiedr) [^84]
    (EDR) can detect and block threats on your organizations endpoints
    and offer a variety of response options. It can analyze the nature
    of the threat and give your security team information regarding how
    it was initiated, where it has traveled to, what it is currently
    doing, and how to eliminate the attack altogether. 

This combined set of security upgrades is typically provided in a
hardware-based device (sometimes called a security appliance) or "Next
Generation Firewalls" and combine a hardware device with proprietary
software. A review of the products in this category is available from
recognized industry expert Gartner at
<https://www.gartner.com/reviews/market/network-firewalls> and shows a
number of very similarly rated products available from recognized names
like Cisco, Sophos, and SonicWall among others.

Those on a strict budget may find free or very reasonably priced open
source alternatives such as those offered by pfSense which can replace
the software in a consumer grade device with a more capable version or
offers a very low priced NetGate appliance based on the free pfSense
software (see <https://www.pfsense.org/products/>). In very small
organizations the firewall/router software can run on an old or obsolete
PC, as a virtual machine on an existing server, or on another network
device such as a Synology NAS device.

### Switches

Wired networks require a separate cable connection for each network
device (also called an endpoint) as shown in Figure 7 (above). These
connections are typically made using cables that meet certain industry
standards often referred to as Cat5, Cat 6, etc. and connect with a
slightly larger version of the connectors commonly used on telephones
called an RJ-45. Stringing and terminating cable is a chore best left
for technicians but once all the wired runs have been made (using
pre-manufactured cables or custom on-site wiring) they need to be
connected to the network -- and that's where the switch comes in.

Switches come in a variety of sizes (usually classed by the number of
ports or connections available) speed or bandwidth (typically ranging
from 1 gigabyte per second to 10 gigabytes per second) with older
(slower) technologies still in use in some instances, and their ability
to manage traffic. Connection types are typically wired (RJ-45)
connections on standard 1Gbps devices with fiber optic connections being
prevalent on higher speed (10Mbps) devices. Some switches feature a
single fiber optic 'uplink' to a high-speed device and then apportion
that bandwidth to multiple 1Gbps devices to improve overall performance.

This then leads into the second differentiating feature of switches
i.e., is the device managed or unmanaged. This distinction means that
the switch can use rules to control the network traffic it passes and
can assign priority to certain devices to balance network performance
and load. Such devices are typically not needed in VSB networks but may
be added as the business grows.

Managed switches, while more expensive than their unmanaged brothers, do
offer certain added feature sets that make them attractive in corporate
environments including quality of service (QAS), additional security and
monitoring features, and the ability to remotely manage the network.
Most of these features are unnecessary in a 10 to 20 endpoint
environment as found in a VSB so their extra expense is usually a
dealbreaker.

### Domain Controller

As discussed above, the Management of the network is performed by the
domain controller (DC). It can be one or more physical devices like a
server, a virtual device that provides a set of services, a cloud-based
function or some these. It's probably easier to think of the DC as a
function rather than a discrete device since the services of the DC
could be apportioned to more than one physical piece of hardware.

What's import is that when the network grows to a state where there are
multiple devices and multiple users some management device is needed to
perform the following functions including basic services:

-   User authentication -- assigning and checking credentials for users
    and the management of user groups.

-   Domain address management using tools such as Dynamic Host
    Configuration Protocol (DHCP)

-   Cryptological services such as device (disk) encryption,
    communications security via Transport Layer Security (TLS), and
    maintaining a secure archive of encryption keys such as for Payment
    Card Industry (PCI) Data Security Standard (DSS).

-   Translation of human readable addresses (xyz.com) into their
    Internet Protocol (IP) addresses using Domain Naming Service (DNS)

-   Rights management -- assigning and enforcing user roles, access
    rights to network devices or services, and privileges (authorization
    for restricted or potentially harmful functions)

-   Directory services -- maintaining a list of files and directories on
    the network and enforcing access controls on them

-   Network policy definition and enforcement to implement network
    security practices

The implementation strategy has been a difficult journey to define as
there are a wide variety of possible solutions and price points that
drive the decision. Consequently, the architecture of a compliant DC is
going to be an 'it depends' situation driven by the VSB size, budget,
individual preferences, and most importantly the level of cybersecurity
compliance required i.e., Level 1 comprising FAR 52.204-21 and or CMMC
Level 1 or Level 2 CMMC with or without third party assessment.

### Option 1 -- Synology NAS

As presently delivered, the Synology NAS lacks a hardware-based
encryption module compliant with FIPS 140-2 and a published STIG making
it a potential for a Level 1 DC but with some compliance risks. For use
outside of Government Contracting the Synology NAS is an excellent and
cost-effective choice providing all the necessary services (albeit some
are duplicative of those offered in a commercial firewall forcing a
choice between the two) along with a robust and captious (SHA 256
encrypted) storage capability for backups. The device even offers an
ability to host virtual devices or containers permitting the low cost
hosting of any number of Widows or Linux applications. As stated earlier
the major constraint is the lack of FIPS compliance thus limiting its
applicability to non-NIST 800-173 uses.

### Option 2 -- Linux Server

The better solution would be a low-cost server such as a HP MicroServer
Gen 11 running a Linux distribution such as Rocky Linux 9 (RL9) which is
a free distribution derived from the Red Hat Linux (RHL) product and
compatible with all the RHL tools such as OpenScap.

From a cost perspective the Microserver Gen 11 and the Synology DS 1821+
are competitive albeit the Microserver is limited to the number of
storage devices whereas the Synology starts with more (8 vs 4) and has
expansion modules readily available.

The major difference however is the Synology is designed for a specific
purpose (network attached file storage) and comes with a suite of
software and tools specific to that purpose and the HP Microserver Gen
11 (older Gen 10 or Gen 10+ devices are also acceptable) is built from
the ground up to be a network server offering such capabilities as
Integrated Lights Out Management (iLO 5) for remote management, a server
grade BIOS with additional security features etc.

While there are any number of devices that could fill this role, the HP
MicroServer Gen 11 was selected based on low cost[^85], small form
factor, quiet operation, and server-grade feature set.

In development work for the Level 1 Workstations the RL9 distribution
was installed with all FIPS 140 encryption algorithms and other security
requirements met in a 100 percent compliant manner. Using it as a base
for the server is a low cost and effective choice. When paired with the
HP MicroServer the four available drive bays would sufficient capacity
to establish a RAID for network storage and backup. The existence of
4x1Gb Ethernet ports, iLO, and available expansion slots add to the
utility of this device as the hub of an effective VSB network.

Consideration must also be given to scaling the solution for growth from
a Level 1 to a Level 2 when needed. Consequently, the CyberHygiene
Project DC selection was made to use the HP Microserver Gen 11 for entry
level requirements based on Level 1 compliance with the capability to
easily migrate to a more capable Level 2 system as the business grows.

## The Essential Nature of Third-Party Service Providers

Despite the many advances in automation and AI, the truth of the matter
is almost every VSB will need outside assistance to implement and
maintain a cybersecure environment. The key question is 'How much
outside assistance will be required and what will that cost?"

### Endpoint Management Software/Services

En point management products like those available from Sophos or
BitDefender are often used by managed service providers or environments
with a dedicated IT department to not only monitor the antimalware
installed on network assets but to also establish and enforce secure
configurations of the attached systems and manage the installation of
software updates (patches) as they are released.

Establishing a secure (hardened) network environment is important -- but
keeping that environment secure over time as new threats emerge is
essential!

Thus, endpoint management is essential to not only secure the network
initially, but to keep it secure as new threats emerge. Several products
are available including Microsoft's intune, Atera, Cisco Secure
Endpoints, Sophos, Crowdstrike, ManageEngine, and the afore mentioned
BitDefender.

Any of these endpoint management products combined with an antimalware
product (most are usually bundled as a package) will provide oversight
for a small business network. The real question then becomes a matter of
who is responsible for monitoring and acting on the data collected and
reported by the software -- the business owner, an employee, or a third
party 'managed service provider' (MSP).

In many -- if not most small businesses -- this role will be fulfilled
by a MSP. The typical solution is the MSP offers a package of software
and services including endpoint management, network monitoring (reported
intrusions, incidents, malware etc.) patch management, remediation, and
'break-fix' support at defined cost per user.

The proposed system bypasses this solution and self-installs and
monitors the end-point management process. Others may choose to source
this with a MSP but in doing so they should expect to pay a monthly fee
per user plus (in some cases) an initial set-up cost.

### BitDefender Gravity Zone

The BitDefender Gravity Zone (GZ) endpoint management software is a
Swiss Army knife in the CyberHygiene Project. Although it is a paid
product it offers some true value for the cost. GZ is a combination of
the BitDefender anti-malware product plus end-point management
capabilities, patch management, and full disk encryption. This product
secures each endpoint in the network against threats that either
originate within the network or come from an outside source using both
an Endpoint Detection and Response (EDR) solution and an Extended
Detection and Response (XDR) approach.

"GravityZone EDR is the only EDR on the market providing automatic
correlation of attacks across endpoints. By automatically consolidating
incidents to a unified larger incident, it accelerates response and
streamlines workflows."[^86]

GZ not only scans and neutralizes malware -- be they viruses, trojans,
or ransomware -- at an amazing 100 percent effectiveness in comparative
testing, it also monitors and reports system security compliance. GZ
looks for system misconfigurations and can actually remediate them.

This is a significant benefit for Windows based systems and obviates the
need for tother products such as Senteon.

GZ is effective with other OSs including Linux and Mac OS but it's
primary benefits come when Windows devices are addes to the network. The
compliance feature makes GZ a standout in a crowded field and earned it
a place in the CyberHygiene Project.

The endpoint management features in GZ also include detailed risk
management capabilities that identify and assist with mitigation of
specific vulnerabilities on network attached devices (endpoints).

![A screenshot of a computer Description automatically
generated](./media/image22.png){width="6.5in" height="3.31875in"}

Figure GravityZone Compliance Dashboard.

GravityZone's dashboard is web accessible via
<https://cloud.gravityzone.bitdefender.com> such that the VSB owner can
defer actual management of the service to a Managed Service Provider
(MSP) as a part of their contracted support service agreement.

### Open VPN

Other services include Virtual Private Network (VPN) services provided
by Open VPN (a free VPN system) to allow secure remote connections to
the network through an encrypted point to point connection. Open VPM
leverages the existing OpenSSL service to create secured connections
using FIPS 140-3 via OpenSSL 3.0.12+, and the FIPS Object Module 2.0.
Client connections automatically enforce FIPS crypto via their host
settings.

### Cloudflare 

Cloudflare offers a free version of their product including VPN and DNS
services for very small businesses that adds several important features
to enhance security. The first is Cloudflare operates one of the
premiere Domain Naming Services (DNS) located proximately at an IP
address of 1.1.1.1. The free service allows users to relocate their DNS
records from their hosting provider (like goDaddy etc.) onto Cloudflare
making domain name translation from a name to an IP address near
instantaneous.

![A screenshot of a computer Description automatically
generated](./media/image23.png){width="5.58196741032371in"
height="3.3533552055993in"}

Figure Cloudflare DNS Record

Cloudflare also provides an array of informational reports concerning
traffic and bandwidth consumed as shown below.

![A screenshot of a map Description automatically
generated](./media/image24.png){width="4.944753937007874in"
height="3.429630358705162in"}

Figure , Cloudflare Traffic Analysis Report

The service also provides detailed logging of wide area network (WAN)
traffic and how (or if) the traffic was routed. Cloudflare also provides
a defense mechanism against Dedicated Denial of Service (DDS) attacks
which try to overwhelm serves with massive amounts of incoming traffic.

Cloudflare also supports secure DNS lookups over TLS or HTTPS making it
near impossible for a 'man-in-the-middle' to monitor DNS requests.

![A diagram of a hacker Description automatically
generated](./media/image25.png){width="4.756893044619423in"
height="2.0277777777777777in"}

Figure Secure DNS SeRvice Prevents \'Man in the Middle\' Inspection

The secure lookup is provided via a free app (Warp) that creates a VPN
to their DNS server thus ensuring DNS information is not shared with
third parties such as governments or internet censoring programs.

### User Authentication and Multi-Factor Identification

One of the free services selected for the CyberHygiene Project system is
an identiy and access management (IAM) service provided by FreeIPA
installed on the

Centralizing this service offers some significant advantages including
off-loading the task to another service, access available from outside
the network for remote logon, and an application programming interface
(API) usable by other software to verify user identities via a Single
Sign On (SSO) capability. Bundled with this service is a multi-factor
authentication (MFA) service using an authenticator application on a
mobile phone or other device as an additional safeguard.

The combined LDAP and MFA services are essential for meeting the Access
Control requirements of the cybersecurity framework in NIST SP 800-171
and others. Being able to do this at no cost (other than setting it up)
is a significant benefit.

### pfSense

The NetGate firewall and router used by the CyberHygiene project is
operated by pfSense software.

"a [firewall](https://en.wikipedia.org/wiki/Firewall_(computing))/[router](https://en.wikipedia.org/wiki/Residential_gateway) computer
software distribution based
on [FreeBSD](https://en.wikipedia.org/wiki/FreeBSD). The [open
source](https://en.wikipedia.org/wiki/Open-source_software) pfSense
Community Edition (CE) and pfSense Plus is installed on a physical
computer or a [virtual
machine](https://en.wikipedia.org/wiki/Virtual_machine) to make a
dedicated firewall/router for a
network.[^\[3\]^](https://en.wikipedia.org/wiki/PfSense#cite_note-3) It
can be configured and upgraded through a web-based interface, and
requires no knowledge of the underlying FreeBSD system to
manage.^[\[4\]](https://en.wikipedia.org/wiki/PfSense#cite_note-Infoworld-4)[\[5\]](https://en.wikipedia.org/wiki/PfSense#cite_note-fsm-5)^"
[^87]

With respect to the CyberHygiene Project, the pfSense is hosted by a
hardware device (NetGate 2100) that is a 1.2GHz ARM Cortex powered
single-board computer dedicated to one purpose: running pfSense to route
and control network traffic with the Internet provider.

In the CyberHygiene Project Lab the Internet provider (Comcast Business
Systems) provides Wide Area Network (WAN) service to their own
router/firewall. But, as discussed above, their consumer grade device is
supplanted with the NetGate device to improve security.

pfSense, as a modern Linux product/distribution, offers a software store
built into the app allowing the administrator to select 'packages' of
open source software that can be added to expand the functionality of
the device.

### Suricata

Many of the features in GZ are also available in Suricata which installs
as an optional package in the pfSense app on the NetGate 2100
firewall/router. Suricata is an open source (free) intrusion detection
system (IDS) and intrusion prevention system (IPS). Suricata provides
traffic filtering and monitoring using a rules based approach to detect
common attack vectors such as port scanning, denial of service, and
brute force attacks.

Suricata monitors and logs HTTP and DNS queries and responses and
provides logging and analysis of TLS/SSL transactions. Its rule set
either allows the connection to occur and logs it or, if covered by a
rule, blocks or rejects the connection and logs that. Suricata also
interacts with other network monitoring software to provide detailed
network traffic analysis dashboards by reading and interpreting
Suricata's logs.

Suricata rules are either obtained from an archive e.g.,
<https://github.com/daffainfo/suricata-rules> or can be user created.
The GitHub archive is a community effort and is frequently updated to
address new and emerging common vulnerability and Exposures (CVEs)
reported or discovered by the community through association with
organizations like ProjectDiscovery.[^88]

### Summary of Third Party Software and Services

The above products are included as they are a component of the overall
cybersecurity solution. However, from a cost point of view they are more
of an IT expense than a cybersecurity expense as they are billed on a
monthly or annual basis whereas Cybersecurity costs are more of a
one-time investment. Once the network is up and running in a stable
manner, administration is relatively simple and consists of monitoring
automated alerts and ensuring appropriate software is installed.

The software stack (or suite of services) selected provides a robust and
highly sophisticated set of security tools from detecting and reporting
network intruders; to identifying and blocking malware, viruses, and
ransomware; managing software updates and security patches; to ensuring
only properly authorized and authenticated users access the network; and
providing sophisticated logging and routing services in a secure
environment.

Collectively these services are very low cost or outright free and are
all priced well within the reach of individual users or 'one-man bands'
like consultants - but have the power and flexibility needed to handle
much larger networks as the business frows and evolves.

The above products are capable of automating periodic scans for network
health and reporting anomalies. Many users with a STEM background may
elect to do many of these tasks themselves and save on the MSP costs.
Other businesses will avail themselves of the full set of features
offered by an MSP (albeit at a higher price[^89] ) in lieu of the
al-la-carte support of fixing something when it breaks and possible
down-time awaiting a technician to attend to their problem.

While the author has purchased and used many of these services to
support their own consulting practice, not everyone will share my
knowledge, ability, or interest in self-administering the resulting
network. Towards that end, there are a number of MSPs who specialize in
very small businesses and these tools were all selected based on an
ability for a MSP to perform some or all of the network administration
functions remotely. It's primarily an issue of time, talent, and money.

# Level 2 Authentication Upgrade  {#level-2-authentication-upgrade .Chapter}

With existing workstations and servers hardened via OpenSCAP to the
\"Unclassified Information in Non-Governmental Facilities\" profile on
Rocky 9.6, you\'re already establishing a strong foundation that aligns
well with NIST SP 800-171\'s system and communications protection (SC)
and configuration management (CM) families. This Rocky Linux hardening
profile (based on SCAP Security Guide) enforces controls like FIPS mode,
firewall rules, SELinux enforcement, and secure boot---many of which
directly support the identity management requirements for Level 2
compliance.

## Network Hardening Overview

The first step is to identify and correct known vulnerabilities by
performing a complete scan of every endpoint on the network -- including
the Router, Switches, Computers (or servers) and virtual machines for an
exhaustive list of possible vulnerabilities.

The list of vulnerabilities is called (among other names) a Security
Technical Implementation Guide (STIG) which is "a configuration standard
consisting of cybersecurity requirements for a specific product"[^90] A
repository of STIGs is maintained at the National Institute of Standards
and Technology (NIST) at https://ncp.nist.gov/repository . An alternate
source is the Center for Internet Security (CIS) who publish a series of
CIS Benchmarks which are mapped (cross referenced) to the DISA STIGs and
are acceptable for use for government systems ("While the use of STIGs
and SRGs by CSPs is preferable, industry-standard baselines such as
those provided by the Center for Internet Security (CIS) Benchmarks are
an acceptable alternative to the STIGs and SRGs.")[^91]

## How Hardening Enhances Identity Management

The OpenSCAP profile addresses several IA-adjacent controls
automatically, allowing you to focus on the remaining gaps from my
previous response. Here\'s a quick mapping:

  -------------------------------------------------------------------------
  Hardening Aspect  Relevant NIST SP       Impact on Your IA Setup
  (OpenSCAP Profile 800-171 Rev 3          
                    Control(s)             
  ----------------- ---------------------- --------------------------------
  FIPS              3.5.7 (Cryptographic   Ensures MFA (TOTP) and VPN
  Cryptographic     Module Authentication) crypto in pfSense uses validated
  Module                                   modules. Verify pfSense\'s
  Enforcement                              OpenSSL is FIPS-compatible or
  (e.g.,                                   configure it via FreeBSD\'s
  crypto-policies                          crypto settings.
  set to FIPS)                             

  Account           3.5.4 (Authenticator   Rocky enforces local password
  Management Rules  Management), 3.5.5     policies (e.g., min length 14
  (e.g., no guest   (Identifier            chars, no reuse)---sync these
  accounts,         Management)            with pfSense User Manager rules
  password                                 to avoid conflicts. Automates
  complexity via                           inactivity disabling (e.g.,
  PAM)                                     35-day lockout).

  Secure Session    3.5.11                 Supports pfSense\'s session
  Management (e.g., (Re-Authentication),   timeouts by requiring endpoint
  screen locks      3.5.10 (Adaptive IA)   re-auth, creating layered
  after 15 min, SSH                        protection. Enables risk-based
  key auth                                 prompts if integrated with tools
  preferred)                               like SSSD.

  Device/Endpoint   3.5.2 (Device          Prepares endpoints for
  Security (e.g.,   Identification and     certificate- or 802.1X-based
  802.1X supplicant Authentication)        auth via pfSense\'s RADIUS.
  config, MAC                              Rocky 9.6\'s wpa_supplicant is
  randomization                            hardened for this.
  disabled)                                

  Auditing and      Overarching IA policy  Logs local auth attempts, which
  Logging (e.g.,    (evidence collection)  correlate with pfSense\'s portal
  auditd rules for                         logs for full audit trails---key
  auth events)                             for 3.5.5 tracking.
  -------------------------------------------------------------------------

  : Table , Identy Management vs System Hardeneing

This hardening covers \~40-50% of the IA family\'s implementation
burden, as the profile includes 300+ rules mapped to SP 800-171. For
your 5-10 user team, it means less custom scripting and more reliance on
built-in Rocky tools like \`authselect\` for PAM and \`sssd\` for
centralized auth.

## Updated Gaps and Targeted Actions for Level 2 IA Compliance

Building on the previous table, here\'s a refined view of remaining
identity management requirements, prioritized by effort for your
hardened environment. Focus on integration between pfSense (network
layer) and Rocky endpoints (host layer).

  ---------------------------------------------------------------------------------
  Control Number  Key Remaining Gap     Targeted Action with This Effort Level (for
                                        Setup                     Small Team)
  --------------- --------------------- ------------------------- -----------------
  3.5.2\          No centralized device Configure pfSense         Medium (1-2 days)
  Device ID/Auth  certs or 802.1X       FreeRADIUS for 802.1X;\   
                  enforcement           on Rocky, enable wpa      
                                        supplicant with machine   
                                        certs (generate via       
                                        \`certmonger\`).\         
                                        Test with \`eapol_test\`. 

  3.5.4           Policies for          Document in your IA       Low (Policy doc +
  Authenticator   credential lifecycle  policy;\                  1 hr config)
  Mgmt            (e.g., revocation     Use Rocky\'s              
                  procedures)           \`authconfig\` to enforce 
                                        complexity.\              
                                        For pfSense MFA, add      
                                        admin procedures for TOTP 
                                        secret rotation.          

  3.5.5\          Formal                Integrate pfSense User    Low-Medium
  Identifier Mgmt assignment/tracking   Manager with LDAP if      (Script/policy)
                  processes; sync with  scaling, or script Rocky  
                  HR for offboarding    \`useradd\` with pfSense  
                                        API.\                     
                                        Set 90-day inactivity     
                                        disable via               
                                        \`pam_faillock\`.         

  3.5.6\          Captive Portal may    Customize pfSense portal  Low (30 min
  Auth Feedback   show partial feedback HTML to mask fields       tweak)
                                        (e.g.,                    
                                        \`type=\"password\"\`     
                                        everywhere);\             
                                        Rocky\'s login screens    
                                        already obscure.          

  3.5.7\          Confirm pfSense FIPS  Enable FIPS in pfSense    Low (Verify +
  Crypto Modules  compliance            (via System \> Advanced   enable)
                                        \> Cryptographic); aligns 
                                        with Rocky\'s mode.\      
                                        Test with \`openssl       
                                        fipsinstall\`.            

  3.5.8\          Guest access not      Add pfSense voucher       Low (If no guests
  Non-Org Users   defined               system for guests;\       needed)
                                        Rocky profile blocks      
                                        local guests---route them 
                                        via separate VLAN.        

  3.5.9\          API/script auth not   Use Rocky\'s \`sssd\` for Medium (If
  Service ID/Auth covered               Kerberos tickets; pfSense services exist)
                                        HAProxy for API cert      
                                        auth.                     

  3.5.10\         Static MFA only       Add pfSense GeoIP rules   Medium-High
  Adaptive IA                           for risk-based prompts,   (Optional
                                        or integrate Rocky\'s     enhancement)
                                        \`fail2ban\` with pfSense 
                                        logs.                     

  3.5.11\         No triggers for       Set pfSense idle timeouts Low (Config sync)
  Re-Auth         privilege changes     to 15 min (match Rocky    
                                        screen lock);\            
                                        Use sudo on Rocky for     
                                        re-auth on escalation.    
  ---------------------------------------------------------------------------------

  : Table Level 1 vs Level 2 Gaps

## Implementation Roadmap and Compliance Tips

1\. Integration Layer: Use LDAP (e.g., FreeIPA on a Rocky server) as a
bridge---pfSense authenticates against it, and Rocky joins via
\`realmd/sssd\`. This centralizes 3.5.5 management without replacing
your local setup. For 5-10 users, a single VM suffices.

2\. Automation and Evidence: Run periodic OpenSCAP scans (\`oscap xccdf
eval\`) to generate reports as IA evidence. Export pfSense configs via
Diagnostics \> Backup/Restore for audit snapshots.

3\. Policy Development: Create a single IA Policy document covering ODPs
(e.g., \"90-day inactivity period\"). Reference your OpenSCAP profile as
baseline compliance for host-level controls.

4\. Testing for Level 2: Simulate scenarios like device spoofing or user
termination. Use tools like \`nmap\` for 802.1X tests and review unified
logs (pfSense + Rocky\'s journalctl).

5\. Scalability Note: Your hardening ensures endpoints stay compliant
during updates (Rocky 9.6 STIGs auto-apply via \`dnf\` plugins), so
focus pfSense on network enforcement.

This positions you for efficient Level 2 attainment---your OpenSCAP work
likely satisfies 20+ non-IA controls too. If you share OpenSCAP scan
results or details on services/APIs in use, I can pinpoint exact
configs.

# Rocky Linux Installation and Configuration {#rocky-linux-installation-and-configuration .Chapter}

This is the 'secret sauce' of the entire project. I'll run through it at
a top level and will make my installation notebook available for others
on a 'by request' basis. Interested parties may find the video at
<https://www.youtube.com/watch?v=iHWVAYsG6Jk> helpful as an overview,
but be aware there are a couple of inaccuracies and omitted steps here
so it will get you close ... but not 100%! My approach, on the other
hand, will get you 100% the first time.

## Installing Rocky Linux 9.6

Rocky Linux is freely available for download at
<https://rockylinux.org/download> . Some care must be exercised as there
are multiple versions and options. I suggest rocky-9.6-aarch64-dvd.iso
for most use cases. This is the version for the Intel X86 family of
processors. The dvd version simply means that it contains additional
packages (a term you become familiar with in Linux) that allow
installation from the downloaded .iso file as opposed to having to visit
various sites to find add-ons.

The downloaded image will be saved to your local computer and will be
about 2.6 GB in size. This image will then be used to create a USB boot
media on a suitable usb drive by using an appropriate utility.
Personally, I downloaded to my Mac and used the diskutility to make the
copy. For the techies here's the commands:

-   Unmount the target disk with: *diskutil unmountDisk /dev/diskX*
    (replace X with your disk number)

-   Run *sudo dd if=/path/to/your.iso of=/dev/rdiskX bs=1m* to copy the
    ISO to the USB drive.

-   Wait for the process to complete -- it may take 15 -- 20 minutes or
    more.

With the newly made boot USB drive in hand the fun begins! The target
computer is powered on and the start-up process is interrupted by
pressing a specific key as soon as a logo appears. For HP computers that
will be the ESC key. For Dell Laptops it will likely be the F2 key. Make
sure the USB is plugged in before starting.

The next step is to use the BIOS on the targeted computer to select
booting from the USB drive then exiting the set-up program. That will
start the installation process using the GRUB bootloader.

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image26.png){width="6.5in"
height="1.9506944444444445in"}

***[If there is a secret to creating a secure installation -- this is
it!]{.ul}***

***[Press the up arrow key to highlight "Install Rocky Linux 9.6" and
then type the letter 'e' for edit. This feature is somewhat obscure so
it took a while to find it!]{.ul}***

![A screen shot of a computer AI-generated content may be
incorrect.](./media/image27.png){width="6.5in"
height="2.004861111111111in"}

Figure , GRUB Bootloader edits to impliment FIPS.

When you hit 'e' you will see this screen. Look carefully at the first
indented line ('linuxef1 /images/ ....). Use the up/down and left/right
arrows to move the cursor to the end of that line and then

type a space,

type fips=1

Press the TAB key to signal you have edited the text and

Press Control + x (hold the control key and type x) and the installation
will begin! This step is essential to override the default Linux
encryption and force it to use the government's approved FIPS-140-2 or
-3 encryption.

The installer will ask for language preference next and then take you to
the Intallation Menu

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image28.jpg){width="4.666434820647419in"
height="3.511292650918635in"}

Figure Rocky Linux Installation Menue

Most of this is standard like what keyboard do you use, what time zone
are you in and so forth so I'll assume that's not going to be of
concern. But I will advise you to be cautious when creating a user
account because if you forget to check the box to make yourself an
administrator you will have to start over.

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image29.png){width="3.74753280839895in"
height="2.010695538057743in"}

Figure Add User Dialog

Under the Software selection I recommend selecting Workstation as
opposed to Server. Here's my choices ... yours can differ.

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image30.png){width="6.5in"
height="2.9923611111111112in"}

Figure , Optional software selection based on Computer role

The Installation Destination is a second part of the secret sauce.

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image31.png){width="3.8342246281714787in"
height="2.6225109361329833in"}

Figure , Selecting the Installation drive

You must ensure the installation disk is checked and you must select
CUSTOM for the storage configuration. This is something I struggled with
for several weeks on various distributions of Linux before 'breaking the
code' so pay attention to the following:

To meet NIST SP 800-171 requirements the disk must be divided into
several "partitions" so as to segregate key data and operating system
files. This is very technical but here's an overview:

First it's easiest (but not essential) to start with a blank disk. If
your disk has an operating system installed I prefer to replace it
rather than doing a dual boot set-up.

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image32.png){width="3.8262029746281714in"
height="2.8831419510061242in"}

Figure Manual Partitioning of the Installation Drive

When you select the manual mode you will be shown a screen like this
listing the existing disk partitions.

WARNING

*The following procedure will irretrievably erase and reformat your
disk. You WILL lose all data stored on it. You should back-up everything
on the disk to a secure backup volume unless you are willing to lose it
forever.*

Moving on ... select each of the listed partitions (e.g., /home) by
clicking on it and then clicking on (or typing) the minus sign to
eliminate that partition. Confirm your choice and proceed to the next
partition until all have been eliminated. There may be an ISO9600
partition listed that cannot be eliminated. That's normal.

Once the existing partitions have been eliminated you can create the new
partition scheme.

  ------------------------------------------------------------------------
  Mount Point              Encrypted                 Size (250 GB Drive)
  ------------------------ ------------------------- ---------------------
  /                        No                        80 GB

  /boot                    No                        10 GB

  /boot/efi                No                        1 GB

  /home                    Yes                       100 GB

  /tmp                     Yes                       6 GB

  /svr/tmp                 Yes                       4 GB

  swap                     Yes                       16 GB

  /var                     Yes                       16 GB

  /var/log                 Yes                       8 GB

  /var/log/audit           Yes                       6 GB

                           Total                     247 GB
  ------------------------------------------------------------------------

  : Table Disk Partitioning Scheme

To add a partition click on the plus key in the lower left. This will
give you a selection/data entry as below:

![A screen shot of a computer AI-generated content may be
incorrect.](./media/image33.png){width="3.08709208223972in"
height="2.3262029746281714in"}

Many, but not all of the needed partitions are available via the drop
down box. If one is not listed (i.e., /svr/tmp) type it in being sure to
include the leading "/" character *FOR EVERYTHING EXCEPT SWAP.* The
desired capacity is manually keyed in with a space separating the number
and the unit (GB).

When all the partitions have been created, you must identify which
partitions to encrypt.

![A computer screen with a white screen AI-generated content may be
incorrect.](./media/image34.jpeg){width="5.738397856517936in"
height="4.303798118985127in"}

Select (click on) each partition in turn, and for those to be encrypted
check the Encrypt Box and then click update settings (arrow) to record
your choice. Click DONE (upper left corner) and you will be asked to
confirm your choices:

![A white paper with black text AI-generated content may be
incorrect.](./media/image35.jpeg){width="5.23306539807524in"
height="3.9247987751531057in"}

Next you will be prompted for an encryption passphrase. Be sure to use a
complex passphrase for security.

Accept the accept the passphrase and return to the main screen.

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image28.jpg){width="3.979232283464567in"
height="2.994202755905512in"}

Next step is Network & Host Name. If using a WiFi Connection select the
appropriate network and enter the network password.

Finally, we come to Security Profile. This is very important to get
right. For this installation we will be using the DRAFT Unclassified
Information in Non-Federal Information Systems and Organizations (NIST
800-171).

![A computer screen with a blue and white box AI-generated content may
be incorrect.](./media/image36.jpeg){width="4.14705927384077in"
height="3.110294181977253in"}

Avoid the temptation to use the DISA profiles offered as they will
assume you are working in a federal facility or connected to a
government information system and will impose added controls that are
not needed and may create issues (like connecting to the internet).

Click done.

A checklist will appear identifying the prerequisites for this security
profile and if your previous choices are aligned with the selected
profile. There should be no red text warning in this list if everything
was done correctly.

Back to the main screen and the "Begin Installation" button should be
illuminated. If not go to the Kdump selection and disable the Kernal
Dump feature and return.

You should be able to begin the installation.

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image28.jpg){width="4.104994531933508in"
height="3.0888331146106736in"}

Following installation, the system will prompt for a reboot. I'm not
sure if this is fact or myth but here's what I do:

1.  Press enter to start the reboot.

2.  Wait for the manufacturer's logo to appear

3.  Unplug the USB drive and allow the system to boot.

If all goes well, you will be greeted by a data entry field on a blank
screen with the padlock symbol. This is a prompt for the encryption
passphrase. Once entered the system will resume boot and present you
with the log-in screen.

## Post Installation 

To complete the configuration process a couple of simple tasks must be
done from Terminal.

In a new terminal window enter the following command "sudo
grub2-setpassword" and enter. You should see the below:

![A screenshot of a computer screen AI-generated content may be
incorrect.](./media/image37.jpeg){width="4.249553805774278in"
height="3.1871653543307086in"}

You will need to enter the superuser password to use the sudo (superuser
do) command ... this will be your administrator password. Next you will
be prompted to enter password". This will be your grub2 (boot loader)
password. Use a complex password, enter a second time, and you should be
returned to the terminal prompt \[yourname\@hostname\]\$.

Next. Enter "sudo yum install scap-workbench" and press enter. This will
start an installation process for the security guide (STIG) and security
evaluation program (SCAP). You will be asked to confirm a number of
choices by entering "Y" for yes. Accept them all. Wait for the process
to finish -- it could take a few minutes.

When you receive the terminal prompt (\$) again you are done and can
close Terminal.

# Performing a Client Level 1 (Foundational) Cyber Assessment {#performing-a-client-level-1-foundational-cyber-assessment .Chapter}

![A table with numbers and a number of levels Description automatically
generated with medium confidence](./media/image38.png){width="6.5in"
height="3.4270833333333335in"}

Figure , Summary of NIST SP 800-171 Controls Applicable to Level
1(Foundational)

# Building Out the Level 1 Network: Going Beyond the Solopreneur  {#building-out-the-level-1-network-going-beyond-the-solopreneur .Chapter}

![](./media/image39.emf){width="6.5in" height="5.022916666666666in"}

# Domain Controller (Identity and Access Management  {#domain-controller-identity-and-access-management .Chapter}

## Primary Recommendation: 

1.  FreeIPA (also known as IPA - Identity, Policy, Audit)\
    Why: FreeIPA provides centralized authentication, authorization, and
    account management via LDAP, Kerberos, and DNS integration. It\'s
    designed for Linux environments like yours, supports multi-factor
    authentication (MFA), role-based access control (RBAC), and
    auditing---key for CMMC controls like AC.2.007 (least privilege) and
    AU.2.041 (audit logs). It can manage your Rocky Linux workstations
    seamlessly with SSSD (System Security Services Daemon) for client
    integration. Unlike Samba, it\'s native to Red Hat ecosystems and
    avoids Windows AD emulation complexities for an all-Linux setup.\
    Alternatives to Consider: - Samba (if you need Windows compatibility
    later): Acts as an Active Directory-compatible DC but requires more
    configuration for full CMMC alignment. - OpenLDAP (with SSSD):
    Simpler for basic directory services, but lacks FreeIPA\'s built-in
    policy and audit tools.

2.  Mail Server\
    Primary Recommendation: Postfix (SMTP) + Dovecot (IMAP/POP3) +
    Roundcube (Webmail Interface)\
    Why: This stack is lightweight, secure, and standard for self-hosted
    email on RHEL-based distros. Postfix handles outgoing mail with
    strong TLS support; Dovecot manages incoming mail with encryption
    and authentication; Roundcube provides a user-friendly web
    interface. Add-ons like SpamAssassin (for spam filtering), ClamAV
    (for antivirus scanning), and Rspamd (for advanced
    anti-spam/DKIM/SPF) enhance security. It supports end-to-end
    encryption, MFA, and logging, aligning with CMMC controls like
    SC.2.178 (encrypt transmissions) and SI.2.216 (malware scanning).
    For a small company, this avoids the overhead of full suites like
    Zimbra.\
    Alternatives to Consider: - Exim (instead of Postfix): More flexible
    for complex routing but less straightforward to secure. -
    Mail-in-a-Box or Modoboa: All-in-one bundles, but they might
    introduce unnecessary components; use if you prefer easier initial
    setup.\
    3. Secure File Sharing -\
    Primary Recommendation: Nextcloud\
    Why: Nextcloud offers secure file storage, sharing, and
    collaboration with features like end-to-end encryption, access
    controls, versioning, and audit logging. It integrates well with
    OnlyOffice (which you already have on workstations) for document
    editing. For CMMC, it supports FIPS-compliant encryption (via
    server-side and client-side options), MFA, and compliance-friendly
    features like data retention policies. It\'s self-hosted, scalable
    for small teams, and can use Rocky Linux\'s built-in Apache/Nginx +
    MariaDB/PostgreSQL for the backend. Focus on enabling HTTPS with
    strong ciphers and integrating with your domain controller for
    auth. - Alternatives to Consider:\
    - Seafile: Faster for large files and emphasizes encryption, but has
    a less feature-rich interface than Nextcloud.\
    - ownCloud: Similar to Nextcloud (it\'s a fork), but Nextcloud has
    better community momentum and security updates.

3.  Integration and Security Overlaps\
    Use Apache or Nginx as the web server for any web-facing components
    (e.g., Roundcube, Nextcloud), with SELinux enforced and firewalld
    for network controls. Integrate everything with FreeIPA for unified
    auth to minimize credentials sprawl. Enable full-disk encryption
    (LUKS with FIPS) and regular backups with tools like Borg or Rsync.\
    Test compliance early with OpenSCAP scans tailored to STIGs for
    these apps. --

4.  Why These First? They are battle-tested on Rocky Linux, have low
    resource needs for your scale, and allow straightforward hardening
    to meet CMMC Level 2 (e.g., via configuration files for encryption
    and access logs). Avoid proprietary or cloud-dependent options to
    keep it fully self-hosted. --

5.  Next Steps: Once you confirm which apps you\'d like to prioritize
    (or if you have preferences), we can dive into installation (e.g.,
    via DNF/YUM), configuration details (like enabling FIPS mode, TLS
    certs from Let\'s Encrypt, and integration scripts), and post-setup
    SCAP validation. Let me know your thoughts or if you\'d like to
    adjust based on specific needs!

System Security Plan (SSP)

\<Company Name>\
\<Company Address>\
\<Point of Contact>, \<email>, \<Telephone>

# Overview 

This SSP will document how **\<Company Name \>,** a sole proprietor,
safeguards FCI per FAR 52.204-21. The covered system has been hardened
using the OpenSCAP "*Unclassified Information in Non-federal Systems*"
profile (xccdf_org.ssgproject.content_profile_cui) and CIS Level 2
benchmarks. Those checks are designed for NIST SP 800-171 compliance and
meet or exceed the 15 basic requirements in the Contract. This SSP will
formalize these details for contract compliance.

*Note: After a review of the contract requirements in contract number
\_\_\_\_\_\_\_\_\_\_\_\_\_, no CUI, DFARS, or CMMC requirements apply.
Additionally, no Supplier Performance Risk System (SPRS) scoring or
third-party audits are deemed necessary unless instructed to do so by
the Contracting Officer or additional contracts are obtained where the
client is the DoD*.

# Scope and Inventory Assets 

a.  This SSP covers the home office environment used by **\<Company
    Name >,** including a \<*[HP EliteDesk G3 running Rocky Linux
    9.6]{.ul}*,> used for creating and storing FCI (e.g., contract
    deliverables) with OnlyOffice and ProjectLibre software. FCI is
    stored locally in encrypted \`/home\` and emailed securely to the
    contracting officer."

b.  Cloud services (e.g., Google Workspace), confirm they're
    FedRAMP-authorized and include (list any). None

# Compliance with FAR 52.204-21

Open Scap Evaluation of Hardened System

![A screenshot of a computer AI-generated content may be
incorrect.](./media/image17.png){width="6.5in"
height="5.060416666666667in"}

See Attached Requirements Matrix for full explanation of How the
reqiorements are being met.

# Roles and Responsibilities:

1.  All cybersecurity tasks, including system administration, security
    monitoring, and incident reporting, are performed by \[Your Name\]."

2.  Annual training (e.g., free CISA Cyber Essentials or NIST Small
    Business Cybersecurity Corner).

3.  Incident Response and Monitoring

    a.  Incidents are logged via auditd, reported to \[Contracting
        Officer Email\], and

    b.  resolved using backups on encrypted USB,

    c.  tested monthly.

4.  This SSP shall be reviewed at least annually or after changes (e.g.,
    new software, additional contracts). A copy is stored securely
    (e.g., encrypted PDF in \`/home/Documents\` ).

5.  No SPRS or CMMC requirements are deemed to apply based on
    contractual requirements review,

# Attachments

1.  Network Diagram

2.  Acceptable Use Policy

3.  System security report from automated scanning tools (OpenScap)

4.  Level 1 Self-Assessment Checklist

5.  Training Documentation / Certification of Completion

# Certification of Compliance

I certify that the above information is true and correct and, based on
the foregoing, certify that I have met the requirements of FAR
52.204---21 for cybersecurity as required by Contract
\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_.

**FAR 52.204-21 Requirements Matrix for SSP Attachment**

+----+------------------+----------------------------------------------+
| *  | **FAR 52.204-21  | **How Met**                                  |
| *R | Requirement      |                                              |
| eq | Description**    |                                              |
| \# |                  |                                              |
| ** |                  |                                              |
+----+------------------+----------------------------------------------+
| 1  | Limit            | Single user (\[Your Name\]) with strong      |
|    | information      | password and LUKS-encrypted partitions       |
|    | system access to | (/home, /var, /tmp, /var/log,                |
|    | authorized       | /var/log/audit, /srv/log).\                  |
|    | users, processes | GRUB bootloader password-protected using     |
|    | acting on behalf | PBKDF2 hash (configured via                  |
|    | of authorized    | /etc/grub.d/40_custom, verified by OpenSCAP  |
|    | users, or        | \[MM/YYYY\]).\                               |
|    | devices          | Filesystem permissions restrict access       |
|    | (including other | (chmod/chown).                               |
|    | information      |                                              |
|    | systems).        |                                              |
+----+------------------+----------------------------------------------+
| 2  | Limit            | Role-based access via Linux user account     |
|    | information      | (\[Your Name\]) with sudo restrictions (CIS  |
|    | system access to | Level 2 rule                                 |
|    | the types of     | xccdf_or                                     |
|    | transactions and | g.ssgproject.content_rule_sudoers_no_root).\ |
|    | functions that   | OnlyOffice and ProjectLibre restricted to    |
|    | authorized users | user-level operations.\                      |
|    | are permitted to | No other users or processes access FCI.      |
|    | execute.         |                                              |
+----+------------------+----------------------------------------------+
| 3  | Control the flow | FCI stored in encrypted /home partition; no  |
|    | of FCI on the    | public-facing systems.\                      |
|    | system to        | Filesystem permissions prevent unauthorized  |
|    | prevent public   | access (CIS rule                             |
|    | disclosure.      | xccdf_org                                    |
|    |                  | .ssgproject.content_rule_file_permissions).\ |
|    |                  | No FCI shared on external platforms (e.g.,   |
|    |                  | X, public websites).                         |
+----+------------------+----------------------------------------------+
| 4  | Control physical | HP EliteDesk G3 in secure home office,       |
|    | access to        | locked when unattended.\                     |
|    | systems that     | Physical access restricted to \[Your         |
|    | process or store | Name\].\                                     |
|    | FCI.             | No external devices connect without          |
|    |                  | authentication.                              |
+----+------------------+----------------------------------------------+
| 5  | Monitor,         | Home office with locked doors; no visitors   |
|    | control, and     | access workstation.\                         |
|    | protect physical | Basic security (e.g., deadbolt) ensures      |
|    | access to the    | physical protection.                         |
|    | areas where FCI  |                                              |
|    | is processed or  |                                              |
|    | stored.          |                                              |
+----+------------------+----------------------------------------------+
| 6  | Escort visitors  | Not applicable: Solo home office with no     |
|    | and monitor      | visitors.                                    |
|    | visitor activity |                                              |
|    | in areas where   |                                              |
|    | FCI is processed |                                              |
|    | or stored.       |                                              |
+----+------------------+----------------------------------------------+
| 7  | Protect and      | FCI transmitted via TLS-encrypted email      |
|    | control          | (e.g., Proton with TLS 1.3, verified via     |
|    | electronic media | openssl s_client). External drives encrypted |
|    | containing FCI   | with LUKS (FIPS-compliant AES-CBC-256) for   |
|    | during transport | backups.                                     |
|    | outside of       |                                              |
|    | controlled       | No physical media leaves controlled area     |
|    | areas.           | without encryption.                          |
+----+------------------+----------------------------------------------+
| 8  | Sanitize or      | LUKS-encrypted partitions wiped with         |
|    | destroy digital  | cryptsetup luksErase or shred before         |
|    | and non-digital  | disposal.                                    |
|    | media containing |                                              |
|    | FCI before       | External backup drives sanitized using wipe  |
|    | disposal or      |                                              |
|    | release for      | (CIS rule                                    |
|    | reuse.           | xccdf_org.                                   |
|    |                  | ssgproject.content_rule_media_sanitization). |
+----+------------------+----------------------------------------------+
| 9  | Protect FCI      | FIPS-compliant LUKS encryption (AES-CBC-256) |
|    | against          | on /home, /var, /tmp, /var/log,              |
|    | unauthorized use | /var/log/audit, /srv/log (enabled via        |
|    | and disclosure.  | fips-mode-setup, verified \[MM/YYYY\]).      |
|    |                  |                                              |
|    |                  | Strong passwords and auditd logging enforce  |
|    |                  | access control.                              |
+----+------------------+----------------------------------------------+
| 10 | Control          | No FCI posted on public systems (e.g.,       |
|    | information      | websites, X).                                |
|    | posted or        |                                              |
|    | processed on     | OnlyOffice and ProjectLibre operate locally; |
|    | publicly         | no cloud-based public sharing.               |
|    | accessible       |                                              |
|    | systems.         |                                              |
+----+------------------+----------------------------------------------+
| 11 | Apply security   | Automated updates via dnf-automatic          |
|    | updates to       |                                              |
|    | software and     | (CIS rule                                    |
|    | firmware in a    | xccdf_org.ssgpr                              |
|    | timely manner.   | oject.content_rule_ensure_software_patched). |
|    |                  |                                              |
|    |                  | OpenSCAP scans monthly to verify patch       |
|    |                  | status (/var/log/ssg/logs).                  |
|    |                  |                                              |
|    |                  | Last update \[MM/YYYY\].                     |
+----+------------------+----------------------------------------------+
| 12 | Protect systems  | ClamAV installed, configured for daily scans |
|    | against          |                                              |
|    | malicious code   | (OpenSCAP rule                               |
|    | with             | xccdf_org                                    |
|    | anti-malware     | .ssgproject.content_rule_install_antivirus). |
|    | software.        | Logs at /var/log/clamav/.                    |
|    |                  |                                              |
|    |                  | Updated automatically via freshclam.         |
+----+------------------+----------------------------------------------+
| 13 | Provide security | Completed CISA Cyber Essentials training     |
|    | awareness        | \[MM/YYYY\] (certificate in SSP Appendix).   |
|    | training to all  |                                              |
|    | system users.    | Annual training scheduled via NIST Small     |
|    |                  | Business Cybersecurity Corner.               |
+----+------------------+----------------------------------------------+
| 14 | Control and      | Only authorized software (OnlyOffice,        |
|    | monitor          | ProjectLibre) installed by \[Your Name\].    |
|    | user-installed   |                                              |
|    | software and     | Package installations logged via             |
|    | system changes.  | dnf(/var/log/dnf.log).                       |
|    |                  |                                              |
|    |                  | OpenSCAP enforces software restrictions      |
|    |                  |                                              |
|    |                  | (CIS rule                                    |
|    |                  | xccdf_org                                    |
|    |                  | .ssgproject.content_rule_restrict_software). |
+----+------------------+----------------------------------------------+
| 15 | Identify,        | Auditd logs (/var/log/audit) monitor system  |
|    | report, and      | activity.                                    |
|    | correct          |                                              |
|    | information and  | Cyber incidents reported to contracting      |
|    | information      | officer within 24 hrs via email.             |
|    | system flaws in  |                                              |
|    | a timely manner. | OpenSCAP scans detect flaws                  |
|    |                  |                                              |
|    |                  | (rule                                        |
|    |                  | xccdf_                                       |
|    |                  | org.ssgproject.content_rule_auditd_enabled). |
|    |                  |                                              |
|    |                  | Backups on encrypted external drive, tested  |
|    |                  | monthly.                                     |
+----+------------------+----------------------------------------------+

[^1]: A very small business is not officially defined by the U.S.
    Government. In this document the term VSB will be used to identify
    solopreneurs and small business that generally have 10 -- 15
    employees with most having but 3 -5 total people.

[^2]: TECHNICAL WAYS TO LOWER CYBERSECURITY COSTS FOR SMALL BUSINESSES:
    Donald E. Shannon, CPCM, CFCM, PMP, Outstanding Fellow, Journal of
    Contract Management Volume 18, 2023-2024, pp8

[^3]: Internal Revenue Service. (2023). *Sole proprietorships and
    pass-through taxation.* Retrieved
    from [https://www.irs.gov](https://www.irs.gov/)

[^4]: U.S. Small Business Administration. (2022). *Types of business
    structures.* Retrieved
    from [https://www.sba.gov](https://www.sba.gov/)

[^5]: Bradley, D., & Cowdery, T. (2021). *Choosing a legal structure for
    small businesses.* Journal of Small Business Strategy, 12(4),
    185-193

[^6]: Deloitte. (2020). Defense Industry Outlook. Retrieved from
    <https://www2.deloitte.com/content/dam/Deloitte/us/Documents/manufacturing/us-manufacturing-midyear-2020-aerospace-and-defense-industry-outlook.pdf>

[^7]: Small Business Innovation Research (SBIR) and Small Business
    Technology Transfer (STTR) Programs\" (PDF). National Defense
    Industrial Association. 2020

[^8]: DoD\'s Small Business Innovation Research (SBIR) and Small
    Business Technology Transfer (STTR) Programs: An Overview\" (PDF).
    US Department of Defense. 2020

[^9]: Defense Acquisition University. (2023). *Analyzing the composition
    of the small business defense industrial base.*Retrieved
    from [https://www.dair.nps.edu](https://www.dair.nps.edu/)

[^10]: Bartik, A. W. (2018). *Capital requirements and small business
    outcomes: Insights from census data.* Journal of Business Economics,
    91(4), 620-638.

[^11]: McKinsey Global Institute. (2024). *A microscope on small
    businesses: Spotting opportunities to boost productivity*. Retrieved
    from https://www.mckinsey.com/industries/small-business

[^12]: Rocket Lawyer. (2023). *Small business work environment*.
    Retrieved
    from [https://www.rocketlawyer.com](https://www.rocketlawyer.com/)

[^13]: Pew Research Center. (2023). *U.S. small businesses: Key facts
    and public views about small firms*. Retrieved
    from [https://www.pewresearch.org](https://www.pewresearch.org/)

[^14]: Forbes Advisor, Small Business Statistics Of 2024 Accessed at
    https://www.forbes.com/advisor/business/small-business-statistics/

[^15]: Forbes Advisor, Small Business Statistics Of 2024 Accessed at
    <https://www.forbes.com/advisor/business/small-business-statistics/>

[^16]: Ibid 2

[^17]: Ibid 2

[^18]: Aberdeen Group. (2023). *2023 state of small business finance*.
    Retrieved from [https://www.aberdeen.com](https://www.aberdeen.com/)

[^19]: Small Business Administration (n.d.). *Small business profile*.
    Retrieved from [https://www.sba.gov](https://www.sba.gov/)

[^20]: U.S. Census Bureau. (2023). *Annual business survey*. Retrieved
    from [https://www.census.gov](https://www.census.gov/)

[^21]: GAO. (2018). Defense Industrial Base: Assessment of Small
    Businesses\' Access to the Department of Defense. Retrieved from
    Xxxxxxxxxx

[^22]: McKinsey & Company. (2019). Defense and Aerospace Industry
    Outlook. Retrieved from XXXXXXXX

[^23]: Aberdeen Group. (2023). 2023 state of small business finance.
    Retrieved from <https://www.aberdeen.com>

[^24]: Small Business Administration (n.d.). Small business profile.
    Retrieved from https://www.sba.gov

[^25]: U.S. Census Bureau. (2023). Annual business survey. Retrieved
    from https://www.census.gov

[^26]: Forbes Advisor, Small Business Statistics Of 2024 Accessed at
    https://www.forbes.com/advisor/business/small-business-statistics/

[^27]: Ibid 1.

[^28]: Business.com. (2023). *How much should your SMB budget for
    cybersecurity?* Retrieved
    from https://www.business.com/articles/smb-cybersecurity-budget/

[^29]: Cybersecurity Ventures. (2020). Cybersecurity Market Size, Share
    and Forecast to 2025. Retrieved from

[^30]:  Business.com. (2023). *How much should your SMB budget for
    cybersecurity?* Retrieved
    from <https://www.business.com/articles/smb-cybersecurity-budget/>

[^31]: Aberdeen Group. (2023). *2023 state of IT report*. Statista.
    Retrieved from [https://www.statista.com](https://www.statista.com/)

[^32]: DARPA. (n.d.). *Cybersecurity for small businesses*. Retrieved
    from <https://www.darpa.mil/work-with-us/for-small-businesses/cybersecurity>

[^33]: Ibid 1.

[^34]: See **Federal Acquisition Regulation: Controlled Unclassified
    Information at:**

    https://www.federalregister.gov/documents/2025/01/15/2024-30437/federal-acquisition-regulation-controlled-unclassified-information

[^35]: National Defense Industrial Association, NDIA Vital Signs 2024,
    April, 2024 pg. 26

[^36]: Kelser Corporation. (n.d.). *NIST 800-171 Compliance: How Much
    Does NIST Certification Cost?* Retrieved
    from [www.kelsercorp.com](http://www.kelsercorp.com/)

[^37]: GoldSky Security. (n.d.). *Estimated Costs Associated with NIST
    800-53 and NIST 800-171.* Retrieved
    from [www.goldskysecurity.com](http://www.goldskysecurity.com/)

[^38]: \"Why You Need an MSP That Knows NIST 800-171 Compliance\"
    (Systems X, 2022) accessed at
    https://www.systems-x.com/blog/why-you-need-a-msp-that-does-nist-compliance

[^39]: Dawson, M. (2022). The essentials of small business IT
    infrastructure. Retrieved from
    https://www.smallbusinesscomputing.com

[^40]: Delgado, D. (2022). Small business network essentials: Security
    and best practices. Retrieved from https://www.techrepublic.com

[^41]: O'Brien, J., & Marakas, G. (2021). Introduction to Information
    Systems (17th ed.). New York, NY: McGraw-Hill Education.

[^42]: Small Business Administration. (2022). Cybersecurity for small
    businesses. Retrieved from https://www.sba.gov

[^43]: Tyson, J. (2023). Network setup for small businesses: A simple
    guide. Retrieved from <https://www.lifewire.com>

[^44]: Khan, Rafaqat & Tariq, Muhammad. (2019). A Survey on Wired and
    Wireless Network. Lahore Garrison University Research Journal of
    Computer Science and Information Technology. 2.
    10.54692/lgurjcsit.2018.020350.

[^45]: Statcounter, Operating System Market Share Worldwide accessed at
    https://gs.statcounter.com/os-market-share/

[^46]: ProTechGuy. (2020). *The difference between consumer-grade and
    business-grade firewall protection*. Retrieved
    from https://www.protechguy.com/business-firewall-difference/

[^47]: Zonure Technologies. (n.d.). *How the business-grade firewalls
    are different than the consumer firewalls?* Retrieved
    from https://zonuretech.com/business-vs-consumer-firewall-differences/

[^48]: Workgroup vs Domain: Definition and the Difference Between the
    Two accessed at https://www.gorelo.io/blog/workgroup-vs-domain/

[^49]: See https://marketplace.fedramp.gov/products?status=authorized

[^50]: Anecdotally, I have been personally quoted on the order of
    \$500/month for a minimal storage plan. Secure email relies on
    services such as Google Workspace or Microsoft Office 365 GCC High
    and can be equally or more expensive depending on options selected.

[^51]: Cloudwards. (2023). Should small businesses use cloud storage?
    Retrieved from https://www.cloudwards.net

[^52]: ibid

[^53]: O'Brien, J., & Marakas, G. (2021). Introduction to Information
    Systems (17th ed.). New York, NY: McGraw-Hill Education.

[^54]: Teal Technology Services. (2024). Small business servers
    explained. Retrieved from https://www.tealtech.com

[^55]: An informal poll of FedRamp secure service providers indicated
    the typical minimum cost was about 5K per year for a minimum
    deployment of storage, email, or identity verification using FedRamp
    secure servers for 5 users.

[^56]: Red Hat Enterprise Linux Server Support accessed at:
    https://www.redhat.com/en/store/red-hat-enterprise-linux-server

[^57]: See <https://en.wikipedia.org/wiki/Free_software_movement>
    <https://www.centos.org> and <https://rockylinux.org>

[^58]: https://www.tier5security.com/far-dfars-calculator/

[^59]: See https://www.tier5security.com/far-dfars-calculator/

[^60]: U.S. Small Business Administration -- Office of Advocacy
    "Frequently Asked Questions" accessed at
    https://advocacy.sba.gov/wp-content/uploads/2024/12/Frequently-Asked-Questions-About-Small-Business_2024-508.pdf

[^61]: U.S. Senate Committee on Small Business and Entrepreneurship\'s
    report *A Troubling Trend: The Decline of Small Business
    Participation in DoD Contracting accessed at:
    https://www.sbc.senate.gov/public/index.cfm/*

[^62]: The split between employer and nonemployrer firms is a subjective
    estimate. National data suggests an 80%/20% split and is baded on
    other data showing 78% of small business contracts are awarded to
    businesses with fewer than 15 people.

[^63]: https://en.wikipedia.org/wiki/History_of_the_graphical_user_interface

[^64]: https://x.com/i/grok?conversation=1972740112829292905

[^65]: ibid

[^66]: ibid

[^67]: Wikipedia

[^68]: https://rockylinux.org

[^69]: Vulnerability is defined by the CVE Program as "An instance of
    one or more weaknesses in a Product that can be exploited, causing a
    negative impact to confidentiality, integrity, or availability; a
    set of conditions or behaviors that allows the violation of an
    explicit or implicit security policy."

[^70]: About the CVE Program accessed at:
    https://www.cve.org/About/Overview

[^71]: See BIOS Protection Guidelines at
    https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-147.pdf

[^72]: See <https://www.open-scap.org>

[^73]: Accessed at https://www.cvedetails.com

[^74]: The Best Tools To Check For Software Updates accessed at
    https://www.digitalcitizen.life/best-tools-check-software-updates/

[^75]: The full feature set for the Synology DiskStation Manager (DSM)
    operating system may be found at
    https://www.synology.com/en-global/dsm/7.2/software_spec/dsm.

[^76]: DiskStation Manager (DSM) is a Linux-based operating system by
    Synology. Synology\'s software architecture allows for third-party
    add-on application integration. See:
    https://en.wikipedia.org/wiki/Synology

[^77]: Synology C2 Identity service free for up to 250 seats. See
    https://c2.synology.com/en-global/pricing/identity

[^78]: Cloudflare free service for very small businesses described at
    https://www.cloudflare.com/plans/free/

[^79]: https://en.wikipedia.org/wiki/Security_Technical_Implementation_Guide

[^80]: See
    https://www.cisecurity.org/insights/blog/new-options-from-cis-for-stig-compliance

[^81]: Wi-Fi 6 vs Ethernet: who is taking the connectivity crown?
    Accessed at
    https://www.techradar.com/news/wi-fi-6-vs-ethernet-who-is-taking-the-connectivity-crown

[^82]: PC World, What Separates Business Routers From Consumer Routers?
    Accessed at:

    https://www.pcworld.com/article/464980/what_separates_business_routers_from_consumer_routers\_.html

[^83]: Information Security Asia What is Stateful Packet Inspection
    (SPI)?

    accessed at:
    https://informationsecurityasia.com/what-is-stateful-packet-inspection/

[^84]: Endpoint Detection and Response (EDR) Defined accessed at
    https://www.fortinet.com/resources/cyberglossary/what-is-edr

[^85]: See Designing a Representative Lab Network (Below) for detailed
    pricing summary.

[^86]: Cross Point correlation accessed at:
    https://www.bitdefender.com/en-us/business/products/endpoint-detection-response

[^87]: Accessed at https://en.wikipedia.org/wiki/PfSense

[^88]: See
    <https://projectdiscovery.io/blog/introducing-nuclei-templates-labs-a-hands-on-security-testing-playground>

[^89]: Informal quotes have placed the MSP costs for a 10 person
    (minimum size) at \$50/person/month or about \$6,000/year. Al la
    carte support services are typically priced at \$200/hour.

[^90]: https://en.wikipedia.org/wiki/Security_Technical_Implementation_Guide

[^91]: See
    https://www.cisecurity.org/insights/blog/new-options-from-cis-for-stig-compliance
