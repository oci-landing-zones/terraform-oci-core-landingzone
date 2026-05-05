# May 08, 2026 Release Notes - 1.6.0

## Networking Updates

### Generic

1. Network route rules and security rules have been updated. Existing customers who uptake this release must be aware that route rules and security rules are going to be refreshed.
2. Cross-VCN security rules are now defined in separate Network Security Groups. Core Landing Zone supports two modes for cross-VCN NSGs: constrained or open. Constrained NSGs are opinionated and useful in Hub/Spoke topologies where the Hub is the DRG. Open NSGs are useful in Hub/Spoke topologies where the Hub is a VCN with a firewall that enforces security rules. See [Cross-VCN Network Security Rules](./DEPLOYMENT-GUIDE.md#cross-vcn-network-security-rules) for details.
3. Configuration overrides are introduced for advanced networking and IAM customization scenarios. The available overridable variables are defined and described in [locals_overrides.tf](./locals_overrides.tf). Sample overrides are provided in [net_override.tf](./net_override.tf) for networking and in [iam_override.tf](./iam_override.tf) for IAM. Terraform overrides are useful for preserving customizations in face of future code updates to Core Landing Zone.

### Three-Tier VCNs

1. The Web subnet in Three-Tier VCNs is no longer automatically made private when the VCN is attached to DRG. It now must be explicitly made private through **tt_vcn\*_web_subnet_is_private** variables. 
2. Newly added global variables for capturing external CIDRs allowed into application endpoints in Three-Tier Web subnets:
    - **tt_vcn\*_external_allowed_cidrs_into_web_tier**: the list of external CIDRs blocks allowed ingress access on LBR NSG (**lbr-nsg**) of **tt_vcn\*** VCN . Use this to limit the range of IP addresses that can access the web tier. (the previously hardcoded value (0.0.0.0/0) is now the default.)
3. Newly added global variables for capturing protocols and ports in NSG ingress rules (previously hardcoded), allowing for easier management of application listening ports at OCI network security rules level (previously hardcoded values are now the default.):
    - **tt_vcn\*_web_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into LBR NSG (**lbr-nsg**). Each value is a colon-separated pair like "TCP:443".
    - **tt_vcn\*_app_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into App NSG (**app-nsg**). Each value is a colon-separated pair like "TCP:80".
    - **tt_vcn\*_db_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into DB NSG (**db-nsg**). Each value is a colon-separated pair like "TCP:1521".    

### OKE VCNs

1. The Service subnet in OKE VCNs can now be made private through newly added **oke_vcn\*_services_subnet_is_private** variables.
2. A DB subnet can now be optionally deployed within OKE VCNs through newly added **add_oke_vcn\*_db_subnet** variables, and further qualified with newly added **oke_vcn\*_db_subnet_cidr**, **oke_vcn\*_db_subnet_name** and **oke_vcn\*_db_ingress_destination_ports** variables.
3. Newly added global variables for capturing external CIDRs allowed into application endpoints in OKE Services subnets:
    - **oke_vcn\*_external_allowed_cidrs_into_services_tier**: the list of external CIDRs blocks allowed ingress access on Services NSG (**services-nsg**) of **oke_vcn\*** VCN. Use this to limit the range of IP addresses that can access the services tier. (the previously hardcoded value (0.0.0.0/0) is now the default.)
4. Newly added global variables for capturing protocols and ports in NSG ingress rules (previously hardcoded), allowing for easier management of application listening ports at OCI network security rules level (previously hardcoded values are now the default.):
    - **oke_vcn\*_services_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into Services NSG (**services-nsg**). Each value is a colon-separated pair like "TCP:443".
    - **oke_vcn\*_db_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into DB NSG (**db-nsg**). Each value is a colon-separated pair like "TCP:1521".    

### Exadata VCNs

1. The Backup subnet is now optional through newly added **add_exa_vcn\*_backup_subnet** variables (default is true), improving Core Landing Zone coverage for Autonomous Database on Exadata Dedicated Infrastructure.
2. Exadata VCNs can now be optionally deployed with an integration subnet, enhancing Core Landing Zone support for integration solutions like Oracle GoldenGate. The following global variables have been introduced: 
    - **add_exa_vcn\*_integration_subnet**: whether to add an optional Integration subnet to the VCN.
    - **exa_vcn\*_integration_subnet_cidr**: the Integration subnet CIDR block.
    - **exa_vcn\*_integration_subnet_name**: the Integration subnet name.
    - **exa_vcn\*_external_allowed_cidrs_into_integration_tier**: the list of external CIDR blocks allowed ingress access on Integration NSG (**integration-nsg**) of **exa_vcn\*** VCN . Use this to limit the range of IP addresses that can access the integration tier.
    - **exa_vcn\*_integration_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into newly added Integration NSG (**integration-nsg**). Each value is a colon-separated pair like "TCP:443". 
3. Newly added global variables for capturing external CIDRs allowed into application endpoints in Exadata Client subnets:
    - **exa_vcn\*_external_allowed_cidrs_into_client_tier**:  the list of external CIDRs blocks allowed ingress access on Client NSG (*client-nsg*) in **exa_vcn\*** VCN. Use this to limit the range of IP addresses that can access the client tier.
4. Newly added global variables for capturing protocols and ports in NSG ingress rules (previously hardcoded), allowing for easier management of application listening ports at OCI network security rules level (previously hardcoded values are now the default.):
    - **exa_vcn\*_client_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into Client NSG (**client-nsg**). Each value is a colon-separated pair like "TCP:1521". 
    - **exa_vcn\*_integration_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into newly added Integration NSG (**integration-nsg**). Each value is a colon-separated pair like "TCP:443". 

### Hub VCN

1. Cross-VCN routing: in cross-vcn and on-premises connectivity scenarios, the subnet route tables in a spoke VCN always target the DRG. The DRG route tables of spoke VCN attachments are now configured either with dynamic routes to other attached spokes and on-premises when a Hub VCN is not deployed, or with a single static route targeting the Hub VCN attachment when a Hub VCN is deployed. The DRG route tables of Hub VCN attachment is always configured with dynamic routes.
2. Infrastructure (subnets, NSGs, routing) for 3rd-party firewall is now always deployed whenever Hub VCN is deployed, even when **hub_vcn_deploy_net_appliance_option="Don\'t deploy any network appliance at this time"**. This helps with a separate stack for the deployment of a 3r-party firewall with OCI networking already in place.
3. Variables **hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http** and **hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh** are replaced by newly added **allowed_onprem_cidrs_to_fw_mgmt_interface**, that works in conjunction with newly added **fw_mgmt_interface_ports**:
    - **allowed_onprem_cidrs_to_fw_mgmt_interface**: the list of on-premises CIDR blocks allowed access to Firewall management NSG (**mgmt-nsg**).
    - **fw_mgmt_interface_ports**: the list of protocols and ports allowed into Firewall Management NSG (**mgmt-nsg**) by the CIDRs provided in variable **allowed_onprem_cidrs_to_fw_mgmt_interface**. Each value is a colon-separated entry like \"TCP:22\".
4. Application Load Balancer NSG (**app-load-balancer-nsg**) automatically populated with combined values provided in **tt_vcn\*_external_allowed_cidrs_into_web_tier** and **tt_vcn\*_web_ingress_destination_ports** for access to Three-Tier VCN workloads through Hub VCN.	
5. Bastion/Jump Host subnet is now provisioned based on newly added **add_hub_vcn_jumphost_subnet** variable. OCI Bastion deployment is based on **deploy_bastion_service** variable and Jump host deployment is based on **deploy_bastion_jump_host** variable.


# February 20, 2026 Release Notes - 1.5.5
1. IAM module references updated to v0.3.3. Fixes bug when provisioning a new identity domain.
2. Networking module references updated to v0.8.1.

# November 17, 2025 Release Notes - 1.5.4
1. Allowing access from the internet to the Hub VCN is now an optional variable. Set to true to enable access from the Internet via the Internet Gateway.
2. Ability to add defined_tags and freeform_tags to Log Analytics Log Group.
3. Event *com.oraclecloud.identitycontrolplane.createidpgroupmapping* and *com.oraclecloud.identitycontrolplane.deleteidpgroupmapping* are updated to *com.oraclecloud.identitycontrolplane.addidpgroupmapping* and *com.oraclecloud.identitycontrolplane.removeidpgroupmapping* in IAM pre-configured events.
4. Updated observability, workloads, IAM, networking, governance, and security modules to latest release versions.
5. Updated required variables and default values in Schema UI.
6. Bug fix: ZPR can now be enabled when deploying a Hub VCN without needing a Bastion Jump Host. 
7. Bug fix: custom values for OKE and Exadata subnets are now saved when editing an existing stack in RMS. 

# August 26, 2025 Release Notes - 1.5.3
1. Ability to customize default compartment names through input variables. See [Customizing Compartments](./DEPLOYMENT-GUIDE.md#custom-cmp) for details. 
2. Ability to explicitly deploy Vault service and define its type through input variables. Virtual private vaults can be replicated to another region. See variables *enable_vault*, *vault_type* and *vault_replica_region* in [VARIABLES.md](./VARIABLES.md).
3. Jump Host Compute instance configured according to CIS level setting.
4. IAM backed module updated (v0.3.0) for user lookup optimization in custom identity domains.
5. Ability to customize Landing Zone resource descriptions via *lz_provenant_label* input variable (currently not exposed in RMS UI). 
6. Generic IAM and Network provider files updated.

# July 16, 2025 Release Notes - 1.5.2
1. Ability to selectively deploy application and database compartments. When the compartment is suppressed from deployment, so are its associated admin group, dynamic groups and policies. See [Customizing Compartments](./DEPLOYMENT-GUIDE.md#custom-cmp) for details.
2. East/West traffic enabled for Hub/Spoke topology with no network appliance.
3. *Cloud Guard 404-NotAuthorizedOrNotFound Error* documented in [Known Issues](./README.md#known-issues).
4. Added new FortiGate version (7.2.11_(X64)) to list of supported versions.

# May 22, 2025 Release Notes - 1.5.1
1. User Interface (UI) refinements and clarifications.
2. Generic IAM Extension bug fixes

# May 09, 2025 Release Notes - 1.5.0
1. Core Landing Zone Enhancements:
   - Added support for externally managed VCNs with associated security controls and routing for Hub DRG attachments.
   - Added routing for jump host access to network firewalls and workload VCNs.
   - Disallowed CIDR 0.0.0.0/0 from ingress/egress rules in the default security lists.
   - Automatically enables Cloud Guard service and creates a managed target at the root compartment if it does not already exist.
   - Added a "Display Security/Logging/Governance Settings?" checkbox that displays settings for Cloud Guard, Security Zones, Logging, Vulnerability Scanning and Cost Management.
2. Generic Network Extension: provides prerequisite resources (VCN, subnets, security lists and NSGs) for a generic workload based on user input.
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
