# May 22, 2025 Release Notes - 1.5.1
1. User Interface (UI) refinements and clarifications.

# May 09, 2025 Release Notes - 1.5.0
1. Core Landing Zone Enhancements:
   - Added support for externally managed VCNs with associated security controls and routing for Hub DRG attachments.
   - Added routing for jump host access to network firewalls and workload VCNs.
   - Disallowed CIDR 0.0.0.0/0 from ingress/egress rules in the default security lists.
   - Automatically enables Cloud Guard service and creates a managed target at the root compartment if it does not already exist.
   - Added a "Display Security/Logging/Governance Settings?" checkbox that displays settings for Cloud Guard, Security Zones, Logging, Vulnerability Scanning and Cost Management.
2. Generic Network Extension: provides prerequisite resources (VCN, subnets, seclists and NSGs) for a generic workload based on user input.
3. Generic IAM Extension: provides prerequisite resources (compartments, groups and policies) for a generic workload. This module can either share or isolate those resources from the parent landing zone.
4. General bug fixes.

# April 02, 2025 Release Notes - 1.4.1
1. Application admin policies updated for reading Compute images and repositories in the Root compartment.
2. Identity Domain group memberships managed externally are now kept on subsequent updates of Core Landing Zone.
3. Event *com.oraclecloud.identitysignon.interactivelogin* added to IAM pre-configured events.
4. Flow logs retention set to 90 days.
5. Bug fix: 3rd-party firewall boot volumes can now be encrypted with a customer managed key.

# February 28, 2025 Release Notes - 1.4.0
1. New support for on-premises connectivity through Site-to-Site VPN (IPSec), FastConnect (FC) virtual circuit, or both.

# January 31, 2025 Release Notes - 1.3.1
1. Fix the Cross-VCN routing issue when choosing to create DRG only.

# January 17, 2025 Release Notes - 1.3.0
1. Optional bastion jump host and OCI Bastion Service deployed in the Hub VCN for use with any firewall option: OCI Native or either third party network appliance.
2. Support for creating a new custom IAM Identity Domain. The previous requirement of a single Identity Domain per Landing Zone deployment remains, but this release supports an additional method for deploying a custom domain.
3. Update for network appliance third party version:
    - Palo Alto Networks Firewall: 11.1.4-h7. 

# December 23, 2024 Release Notes - 1.2.0
1. Ability to deploy the OCI Native Network Firewall.

# November 20, 2024 Release Notes - 1.1.0
1. Ability to enable OCI Zero Trust Packet Routing (ZPR) service in Three-Tier VCNs and Exadata VCNs for use cases involving access to databases.
2. Enhanced separation of duties between Database administrators and Exadata administrators. Now, Exadata infrastructure and VM clusters are only manageable in the Exadata compartment, and only by Exadata administrators.

# October 31, 2024 Release Notes - 1.0.0
1. Ability to deploy groups and dynamic groups in an existing identity domain.
2. Ability to define the network appliance versions. Supported versions are:
    - Palo Alto Networks Firewall: 11.1.3 and 11.1.2-h1. (NB: these versions are deprecated in Core Landing Zone Release 1.3.0)
    - Fortinet FortiGate Firewall: 7.2.9(X64) and 7.4.4(X64)
3. Ability to deploy a network appliance custom image.
4. Bug fixes.    

# September 06, 2024 Release Notes - 0.0.1 (Early Preview Release)
1. Utilizes the modules available in the [CIS OCI Foundations Benchmark Modules Collection](./README.md#modules) for actual resource management.
2. Adds the following to CIS Landing Zone:
    - Ability to use groups and dynamic groups from an existing Identity Domain as the grantees of IAM policies.
    - Streamlined user interface in Resource Manager, for better usability and improved customization.
    - Ability to deploy VCNs for OKE workload deployments, in addition to three-tier and Exadata Cloud service VCNs.
    - Ability to deploy a network firewall appliance in the Hub VCN (a.k.a. DMZ VCN).  
    - Ability to route traffic between select spoke VCNs, or in a full mesh model.
