# June 03, 2026 Release Notes - 1.6.0

In addition to bug fixes, release 1.6.0 brings in significant extensibility enhancements to Core Landing Zone networking across all supported workload types, as well as to IAM. New global variables have been introduced for more flexible standard deployments, while more advanced scenarios are supported via override variables.

## Bug Fixes

1. [Issue 39](https://github.com/oci-landing-zones/terraform-oci-core-landingzone/issues/39) fixed: Jump Host now deploys in the requested region.
2. [Issue 47](https://github.com/oci-landing-zones/terraform-oci-core-landingzone/issues/47) addressed with enhanced documentation in [VARIABLES.md](./VARIABLES.md), [variables_security.tf](./variables_security.tf) and [schema.yml](./schema.yml).
3. [Issue 48](https://github.com/oci-landing-zones/terraform-oci-core-landingzone/issues/48) addressed with enhanced documentation in [Deployment Guide](./DEPLOYMENT-GUIDE.md#extending-landing-zone-to-a-new-region) for Extending Core Landing Zone and fixes for deploying Compute instances in requested region.
4. [Issue 50](https://github.com/oci-landing-zones/terraform-oci-core-landingzone/issues/50) fixed: OSMS policy removed.

## Networking Enhancements

### Generic

1. Network route rules and security rules have been updated. Existing customers who uptake this release will have route rules and security rules refreshed.
2. Cross-VCN security rules are now defined in separate Network Security Groups than local security rules. Core Landing Zone supports two modes for cross-VCN NSGs: constrained or open. Constrained NSGs are enabled by default. Open and constrained NSGs can coexist for spoke VCNs, which supports migrating to open NSGs in two applies. Constrained NSGs are opinionated and useful in Hub/Spoke topologies where the Hub is the DRG. Open NSGs are useful in Hub/Spoke topologies where the Hub is a VCN with a firewall that enforces security rules. See [Cross-VCN Network Security Rules](./DEPLOYMENT-GUIDE.md#cross-vcn-network-security-rules) for details.
3. Configuration overrides are introduced for advanced networking scenarios. The available overridable variables are defined and described in [locals_overrides.tf](./locals_overrides.tf). Sample overrides are provided in [net_override.tf](./net_override.tf). [Terraform override files](https://developer.hashicorp.com/terraform/language/files/override) are useful for preserving customizations in face of future code updates to Core Landing Zone.

### Three-Tier VCNs

1. The Web subnet in Three-Tier VCNs is no longer automatically made private when the VCN is attached to DRG. It now must be explicitly made private through **tt_vcn{1,2,3}_web_subnet_is_private** variables.
2. Newly added global variables for capturing external CIDRs allowed into application endpoints in Three-Tier Web subnets:
    - **tt_vcn{1,2,3}_external_allowed_cidrs_into_web_tier**: the list of external CIDRs blocks allowed ingress access on LBR NSG (**lbr-nsg**) of **tt_vcn{1,2,3}** VCN . Use this to limit the range of IP addresses that can access the web tier. (the previously hardcoded value 0.0.0.0/0 is now the default.)
3. Newly added global variables for capturing protocols and ports in NSG ingress rules, allowing for easier management of application listening ports at OCI network security rules level (previously hardcoded values are now the default.):
    - **tt_vcn{1,2,3}_web_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into LBR NSG (**lbr-nsg**). Each value is a colon-separated pair like "TCP:443".
    - **tt_vcn{1,2,3}_app_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into App NSG (**app-nsg**). Each value is a colon-separated pair like "TCP:80".
    - **tt_vcn{1,2,3}_db_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into DB NSG (**db-nsg**). Each value is a colon-separated pair like "TCP:1521".

### OKE VCNs

1. The Service subnet in OKE VCNs can now be made private through newly added **oke_vcn{1,2,3}_services_subnet_is_private** variables.
2. Newly added global variables for capturing external CIDRs allowed into application endpoints in OKE Services subnets:
    - **oke_vcn{1,2,3}_external_allowed_cidrs_into_services_tier**: the list of external CIDRs blocks allowed ingress access on Services NSG (**services-nsg**) of **oke_vcn{1,2,3}** VCN. Use this to limit the range of IP addresses that can access the services tier. (the previously hardcoded value 0.0.0.0/0 is now the default.)
3. A DB subnet can now be optionally deployed within OKE VCNs through newly added **add_oke_vcn{1,2,3}_db_subnet** variables, and further qualified with newly added **oke_vcn{1,2,3}_db_subnet_cidr**, **oke_vcn{1,2,3}_db_subnet_name** and **oke_vcn{1,2,3}_db_ingress_destination_ports** variables.
4. Newly added global variables for capturing protocols and ports in NSG ingress rules, allowing for easier management of application listening ports at OCI network security rules level (previously hardcoded values are now the default.):
    - **oke_vcn{1,2,3}_services_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into Services NSG (**services-nsg**). Each value is a colon-separated pair like "TCP:443".
    - **oke_vcn{1,2,3}_db_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into DB NSG (**db-nsg**). Each value is a colon-separated pair like "TCP:1521".

### Exadata VCNs

1. The Backup subnet is now optional through newly added **add_exa_vcn{1,2,3}_backup_subnet** variables (default is true), improving Core Landing Zone coverage for Autonomous Database on Exadata Dedicated Infrastructure.
2. Exadata VCNs can now be optionally deployed with an integration subnet, enhancing Core Landing Zone support for integration solutions like Oracle GoldenGate. The following global variables have been introduced: 
    - **add_exa_vcn{1,2,3}_integration_subnet**: whether to add an optional Integration subnet to the VCN.
    - **exa_vcn{1,2,3}_integration_subnet_cidr**: the Integration subnet CIDR block.
    - **exa_vcn{1,2,3}_integration_subnet_name**: the Integration subnet name.
    - **exa_vcn{1,2,3}_external_allowed_cidrs_into_integration_tier**: the list of external CIDR blocks allowed ingress access on Integration NSG (**integration-nsg**) of **exa_vcn{1,2,3}** VCN . Use this to limit the range of IP addresses that can access the integration tier.
    - **exa_vcn{1,2,3}_integration_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into newly added Integration NSG (**integration-nsg**). Each value is a colon-separated pair like "TCP:443".
3. Newly added global variables for capturing external CIDRs allowed into application endpoints in Exadata Client subnets:
    - **exa_vcn{1,2,3}_external_allowed_cidrs_into_client_tier**:  the list of external CIDRs blocks allowed ingress access on Client NSG (*client-nsg*) in **exa_vcn{1,2,3}** VCN. Use this to limit the range of IP addresses that can access the client tier.
4. Newly added global variables for capturing protocols and ports in NSG ingress rules, allowing for easier management of application listening ports at OCI network security rules level (previously hardcoded values are now the default.):
    - **exa_vcn{1,2,3}_client_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into Client NSG (**client-nsg**). Each value is a colon-separated pair like "TCP:1521".
    - **exa_vcn{1,2,3}_integration_ingress_destination_ports**: the list of protocols and destination ports allowed for ingress packets into newly added Integration NSG (**integration-nsg**). Each value is a colon-separated pair like "TCP:443".

### Hub VCN

1. Cross-VCN routing: in cross-vcn and on-premises connectivity scenarios, the subnet route tables in a spoke VCN always target the DRG. The DRG route tables of spoke VCN attachments are now configured either with dynamic routes to other attached spokes and on-premises when a Hub VCN is not deployed, or with a single static route targeting the Hub VCN attachment when a Hub VCN is deployed. The DRG route tables of Hub VCN attachment is always configured with dynamic routes.
2. Infrastructure (subnets, NSGs, routing) for 3rd-party firewall is now always deployed whenever Hub VCN is deployed, even when **hub_vcn_deploy_net_appliance_option="Don\'t deploy any network appliance at this time"**. This helps with a separate deployment of a 3rd-party firewall with OCI networking already in place.
3. Variables **hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http** and **hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh** are replaced by newly added **allowed_onprem_cidrs_to_fw_mgmt_interface**, that works in conjunction with newly added **fw_mgmt_interface_ports**:
    - **allowed_onprem_cidrs_to_fw_mgmt_interface**: the list of on-premises CIDR blocks allowed access to Firewall management NSG (**mgmt-nsg**).
    - **fw_mgmt_interface_ports**: the list of protocols and ports allowed into Firewall Management NSG (**mgmt-nsg**) by the CIDRs provided in variable **allowed_onprem_cidrs_to_fw_mgmt_interface**. Each value is a colon-separated entry like \"TCP:22\".
4. Application Load Balancer NSG (**app-load-balancer-nsg**) default ingress rules are controlled by **onprem_cidrs** plus **hub_vcn_external_allowed_cidrs_into_web_tier** when the Hub Web subnet is public, and by **onprem_cidrs** only when the Hub Web subnet is private. Allowed ports come from **hub_vcn_web_ingress_destination_ports**. The public-subnet default remains **0.0.0.0/0** on **TCP:443**. Its rules can still be customized via override variables **hub_vcn_app_load_balancer_nsg_ingress_rules** and **hub_vcn_app_load_balancer_nsg_egress_rules**.
5. Bastion/Jump Host subnet is now provisioned based on newly added **add_hub_vcn_jumphost_subnet** variable. OCI Bastion deployment is based on **deploy_bastion_service** variable and Jump host deployment is based on **deploy_bastion_jump_host** variable.
6. Jump Host can now be provisioned based on OCI Marketplace image OCID, in addition to name/version. Variable **bastion_jump_host_marketplace_image_option** has been replaced by newly added **bastion_jump_host_marketplace_image_name** and **bastion_jump_host_image_source** has been introduced to let users indicate whether the image is custom, platform or marketplace.
7. Network firewall appliance can now be provisioned based on OCI Marketplace image OCID, in addition to name/version. 
8. Newly added variable **net_appliance_marketplace_image_version** replaces both **net_palo_alto_version** and **net_fortigate_version** when specifying the OCI Marketplace image version for the network firewall appliance.
9. Additional NSGs for Hub, Three-tier, OKE, and Exadata VCNs can now be configured through **define_hub_vcn_additional_nsgs**, **hub_vcn_additional_nsgs**, **define_tt_vcn{1,2,3}_additional_nsgs**, **tt_vcn{1,2,3}_additional_nsgs**, **define_oke_vcn{1,2,3}_additional_nsgs**, **oke_vcn{1,2,3}_additional_nsgs**, **define_exa_vcn{1,2,3}_additional_nsgs**, and **exa_vcn{1,2,3}_additional_nsgs** variables. The NSG definition accepts a native HCL map/object or a JSON object string, and the Resource Manager UI exposes it as a multiline JSON field.
10. Basic bootstrap configuration for Palo Alto Networks VM-Series Firewall. See [Palo Alto Networks VM-Series Firewall Bootstrap](./templates/hub-spoke-with-hub-vcn-net-appliance/PALO-ALTO-BOOTSTRAP.md).

## IAM Enhancements

1. Core Landing Zone enclosed compartments can be augmented using newly added **additional_enclosed_compartments** override variable. The provided compartments are provisioned within the enclosing compartment. See [iam_override.tf](./iam_override.tf) for an example.
2. Core Landing Zone IAM policies can be augmented using newly added **custom_policy_statements** override variable. The provided statements are put together in a separate policy at the enclosing compartment of the landing zone, and only when the enclosing compartment is not the Root compartment. *Use this with extreme caution as it may introduce security issues if not used properly. Make sure to follow the principle of least privilege when defining custom statements, ensuring to grant only the necessary permissions required for your use case.* See [iam_override.tf](./iam_override.tf) for an example.
3. Core Landing Zone can provision additional customer-defined tag namespaces and tags through the newly added **custom_tag_namespaces** override variable. These tag namespaces are created in addition to the default tag namespace and tags. See [iam_override.tf](./iam_override.tf) for an example.

## Global Variable Changes from 1.5.5 to 1.6.0

The list below summarizes all changes mentioned above. Before upgrading existing deployments, review any removed or replaced variables in your existing configurations. Variables shown with *{1,2,3}* exist once for each numbered VCN family member.

### Removed Variables

- **customize_bastion_service**
  This was a Resource Manager UI control and has no direct replacement. Use **add_hub_vcn_jumphost_subnet** and **deploy_bastion_service** to control optional OCI Bastion Service provisioning.
- **customize_jumphost_subnet**
  This was a Resource Manager UI control and has no direct replacement. Use **add_hub_vcn_jumphost_subnet** and **deploy_bastion_jump_host** to control optional Jump Host subnet provisioning.

### Replaced Variables

- **bastion_jump_host_marketplace_image_option**
  Replaced by **bastion_jump_host_image_source**, **bastion_jump_host_marketplace_image_name**, **bastion_jump_host_marketplace_image_version**, and **bastion_jump_host_marketplace_image_ocid**. Use **bastion_jump_host_image_source** = *"Marketplace Image"* for Marketplace images.
- **hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http** and **hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh**
  Replaced by **allowed_onprem_cidrs_to_fw_mgmt_interface** and **fw_mgmt_interface_ports**. Move allowed firewall-management CIDRs to **allowed_onprem_cidrs_to_fw_mgmt_interface**, and list allowed protocol/port pairs such as *TCP:22* or *TCP:443* in **fw_mgmt_interface_ports**.
- **net_palo_alto_version**
  Replaced by **net_appliance_image_vendor**, **net_appliance_marketplace_image_name**, **net_appliance_marketplace_image_version**, and **net_appliance_marketplace_image_ocid**. Set **net_appliance_image_vendor** = *"PaloAlto"*.
- **net_fortigate_version**
  Replaced by **net_appliance_image_vendor**, **net_appliance_marketplace_image_name**, **net_appliance_marketplace_image_version**, and **net_appliance_marketplace_image_ocid**. Set **net_appliance_image_vendor** = *"Fortinet"*.

For Marketplace network appliance images, provide either **net_appliance_marketplace_image_ocid** or **net_appliance_marketplace_image_name** plus optional **net_appliance_marketplace_image_version**.

### Added Variables

- **custom_id_domain_compartment_ocid**
  Resource Manager helper input for selecting the compartment containing an existing custom identity domain. Terraform CLI deployments can continue using **custom_id_domain_ocid** directly.
- **enable_cross_vcn_constrained_nsgs** and **enable_cross_vcn_open_nsg**
  Controls the new cross-VCN NSG modes. Constrained NSGs are enabled by default. Open and constrained NSGs can coexist for spoke VCNs to support a two-apply migration from constrained to open rules. Hub VCN creates the open NSG when requested and leaves it unattached by default.
- **add_hub_vcn_jumphost_subnet**
  Controls whether the optional private Jump Host/Bastion subnet is created in the Hub VCN.
- **allowed_onprem_cidrs_to_fw_mgmt_interface** and **fw_mgmt_interface_ports**
  Provides a vendor-neutral way to allow selected on-premises CIDRs and ports into firewall management interfaces.
- **hub_vcn_external_allowed_cidrs_into_web_tier** and **hub_vcn_web_ingress_destination_ports**
  Controls default ingress CIDRs and protocol:port pairs for the Hub VCN Application Load Balancer NSG. Public Hub Web subnets allow **onprem_cidrs** plus **hub_vcn_external_allowed_cidrs_into_web_tier**; private Hub Web subnets allow **onprem_cidrs** only. Defaults preserve the existing public-subnet **0.0.0.0/0** on **TCP:443** behavior.
- **net_appliance_image_vendor**, **net_appliance_marketplace_image_ocid**, **net_appliance_marketplace_image_name**, and **net_appliance_marketplace_image_version**
  Adds vendor and Marketplace image selection for Hub VCN network appliances, including support for Marketplace image OCIDs.
- **bastion_jump_host_image_source**, **bastion_jump_host_marketplace_image_ocid**, **bastion_jump_host_marketplace_image_name**, **bastion_jump_host_marketplace_image_version**, and **bastion_jump_host_platform_image_ocid**
  Adds explicit image-source handling for Bastion Jump Host: Marketplace, platform, or custom images.
- **define_hub_vcn_additional_nsgs** and **hub_vcn_additional_nsgs**
  Allows additional Hub VCN NSGs to be defined without editing module internals.
- **define_tt_vcn{1,2,3}_additional_nsgs** and **tt_vcn{1,2,3}_additional_nsgs**
  Allows additional Three-Tier VCN NSGs to be defined per VCN.
- **define_oke_vcn{1,2,3}_additional_nsgs** and **oke_vcn{1,2,3}_additional_nsgs**
  Allows additional OKE VCN NSGs to be defined per VCN.
- **define_exa_vcn{1,2,3}_additional_nsgs** and **exa_vcn{1,2,3}_additional_nsgs**
  Allows additional Exadata VCN NSGs to be defined per VCN.
- **tt_vcn{1,2,3}_external_allowed_cidrs_into_web_tier**
  Lets users restrict external CIDRs allowed into Three-Tier Web/LBR tiers. Defaults preserve the existing behavior.
- **tt_vcn{1,2,3}_web_ingress_destination_ports**, **tt_vcn{1,2,3}_app_ingress_destination_ports**, and **tt_vcn{1,2,3}_db_ingress_destination_ports**
  Exposes previously hardcoded Three-Tier NSG ingress destination ports.
- **oke_vcn{1,2,3}_services_subnet_is_private**
  Allows OKE services subnets to be made private.
- **add_oke_vcn{1,2,3}_db_subnet**, **oke_vcn{1,2,3}_db_subnet_cidr**, and **oke_vcn{1,2,3}_db_subnet_name**
  Adds optional DB subnets to OKE VCNs.
- **oke_vcn{1,2,3}_external_allowed_cidrs_into_services_tier**
  Lets users restrict external CIDRs allowed into OKE services tiers. Defaults preserve the existing behavior.
- **oke_vcn{1,2,3}_services_ingress_destination_ports** and **oke_vcn{1,2,3}_db_ingress_destination_ports**
  Exposes OKE Services and DB NSG ingress destination ports.
- **add_exa_vcn{1,2,3}_backup_subnet**
  Makes Exadata backup subnets optional. Defaults preserve existing behavior (true by default).
- **add_exa_vcn{1,2,3}_integration_subnet**, **exa_vcn{1,2,3}_integration_subnet_cidr**, and **exa_vcn{1,2,3}_integration_subnet_name**
  Adds optional Exadata integration subnets.
- **exa_vcn{1,2,3}_external_allowed_cidrs_into_client_tier** and **exa_vcn{1,2,3}_client_ingress_destination_ports**
  Lets users restrict external CIDRs and destination ports for Exadata client tier.
- **exa_vcn{1,2,3}_external_allowed_cidrs_into_integration_tier** and **exa_vcn{1,2,3}_integration_ingress_destination_ports**
  Lets users restrict external CIDRs and destination ports for Exadata integration tier.


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
