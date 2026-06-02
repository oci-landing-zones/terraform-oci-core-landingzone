# Core Landing Zone with Existing DRG and Custom ExaCS VCN

This template shows how to deploy an [OCI Core Landing Zone](../../) configuration with one VCN for Exadata Cloud Service that gets attached to an existing DRG. Such network configuration is useful in scenarios to connect existing VCNs (in the same or different regions) and providing on-prem connectivity to a newly added Exadata Cloud Service system. Note however, that this template assumes that IpSec VPN or FastConnect are externally configured.

Please see [templates](../../templates/) for other CIS compliant Core Landing Zone templates.

## Included Components

- Adds one Exadata VCN with customized client, backup, and integration subnet names and CIDRs.
- Allows explicit external CIDR access into the client and integration tiers on the specific ports.
- Enables routing through DRG to onprem CIDRs for the Exadata VCN.

## Configuration Variables

This template has the following variables pre-configured: 

| Variable | Description | Value |
|---------|-------|-------|
| *service_label* | Resource name prefix used by Core Landing Zone. | *exacs* |
| *define_net* | Whether networking resources are deployed. By default, Core Landing Zone does NOT deploy any networks. | *true* | 
| *hub_deployment_option* | The Hub network deployment topology | "VCN or on-premises connectivity routing via DRG (existing DRG)" |
| *existing_drg_ocid* | The existing DRG OCID that the Exa VCN attaches to | "ocid1.drg..replace-with-existing-drg-ocid" |
| *add_exa_vcn1* | Whether a VCN for Exadata Cloud Service | *true* | 
| *exa_vcn1_attach_to_drg* | Whether the VCN gets attached to DRG, enabling VCN connectivity to other DRG-connected networks. | *true*
| *exa_vcn1_name* | The VCN name | *"exa-prod"* | 
| *exa_vcn1_cidrs* | The VCN CIDR blocks | *["172.20.0.0/20"]* | 
| *customize_exa_vcn1_subnets* | RMS UI control to display/hide subnets customization options | *true* | 
| *exa_vcn1_client_subnet_cidr* | The client subnet CIDR block | *"172.20.0.0/24"* | 
| *exa_vcn1_backup_subnet_cidr* | The backup subnet CIDR block | *"172.20.1.0/24"* | 
| *add_exa_vcn1_integration_subnet* | Whether a subnet for integration (like migration, replication) needs is deployed | *true* | 
| *exa_vcn1_integration_subnet_cidr* | The integration subnet CIDR block | *"172.20.2.0/24"* | 
| *exa_vcn1_client_ingress_destination_ports* | The set of protocol:port allowed into client NSG | *["TCP:1521", "TCP:1522", "TCP:5500"]* | 
| *exa_vcn1_external_allowed_cidrs_into_client_tier* | The set of IP ranges allowed into client NSG | *["198.51.100.20/32", "203.0.113.20/32"]* | 
| *exa_vcn1_integration_ingress_destination_ports* | The set of protocol:port allowed into integration NSG | *["TCP:443", "TCP:8443"]* | 
| *exa_vcn1_external_allowed_cidrs_into_integration_tier* | The set of IP ranges allowed into integration NSG | *["198.51.100.0/24"]* | 
| *exa_vcn1_onprem_route_enable* | Whether the VCN routes to on-premises. This enables VCN subnet route rules targeting the DRG for *onprem_cidrs*. | *true* | 
| *onprem_cidrs* | The set of on-prem CIDRs | *["10.0.0.0/16"]* |
| *network_admin_email_endpoints* | List of email addresses that receive notifications for networking related events. | *["email.address@example.com"]* | 
| *security_admin_email_endpoints* | List of email addresses that receive notifications for security related events. | *["email.address@example.com"]* | 

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"service_label":"exacs","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20via%20DRG%20(existing%20DRG)","existing_drg_ocid":"ocid1.drg..replace-with-existing-drg-ocid","add_exa_vcn1":true,"exa_vcn1_attach_to_drg":true,"exa_vcn1_name":"exa-prod","exa_vcn1_cidrs":["172.20.0.0/20"],"customize_exa_vcn1_subnets":true,"exa_vcn1_client_subnet_name":"exa-prod-client-subnet","exa_vcn1_client_subnet_cidr":"172.20.0.0/24","exa_vcn1_backup_subnet_name":"exa-prod-backup-subnet","exa_vcn1_backup_subnet_cidr":"172.20.1.0/24","add_exa_vcn1_integration_subnet":true,"exa_vcn1_integration_subnet_name":"exa-prod-integration-subnet","exa_vcn1_integration_subnet_cidr":"172.20.2.0/24","exa_vcn1_client_ingress_destination_ports":["TCP:1521","TCP:1522","TCP:5500"],"exa_vcn1_external_allowed_cidrs_into_client_tier":["198.51.100.20/32","203.0.113.20/32"],"exa_vcn1_integration_ingress_destination_ports":["TCP:443","TCP:8443"],"exa_vcn1_external_allowed_cidrs_into_integration_tier":["198.51.100.0/24"],"exa_vcn1_onprem_route_enable":true,"onprem_cidrs":["10.0.0.0/16"],"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply
