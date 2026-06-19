# Core Landing Zone with new DRG and Site to Site IPSec VPN

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configured with a Hub & Spoke networking topology using OCI site-to-site IPSec VPN for on-premises connectivity. It deploys one DRG, two VPN tunnels to Libreswan CPE (customer-premises equipment), one Three Tier VCN, and one Exadata VCN, which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value |
|---------------|-------------|-------|
| *service_label* | A unique identifier to prefix the resources | "ipsecvpn" |
| *define_net* | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks. | true |
| *hub_deployment_option* | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing via DRG (DRG will be created)" |
| *on_premises_connection_option* | The options for connecting to on-premises. Valid options are 'None', 'Create New FastConnect Virtual Circuit', 'Create New IPSec VPN', 'Create New FastConnect Virtual Circuit and IPSec VPN', or 'Use Existing On-Premises Connectivity' | "Create New IPSec VPN" |
| *onprem_cidrs* | List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG. | ["10.0.0.0/16"] |
| *cpe_ip_address* | Public IP address used by the Customer-Premises Equipment (CPE) so that a VPN connection can be established. | "x.x.x.x" |
| *cpe_device_shape_vendor* | Name of the CPE device vendor. | "Libreswan". Valid names are: "Fortinet", "Cisco", "Juniper", "Furukawa", "Check Point", "Palo Alto", "Yamaha", "Libreswan", "NEC", "WatchGuard", "Other". |
| *ipsec_customer_bgp_asn* | Customer on-premises networks Autonomous System Number. | "65000" |
| *ipsec_tunnel1_customer_interface_ip* | Customer provided IP CIDR block used on the CPE side for BGP peering in IPSec Tunnel 1. Must be /30 or /31. | "10.10.10.1/30" |
| *ipsec_tunnel1_oracle_interface_ip* | Customer provided IP CIDR block used on the OCI side for BGP peering in IPSec Tunnel 1. Must be /30 or /31. | "10.10.10.2/30" |
| *ipsec_tunnel1_ike_version* | Version of the internet key exchange (IKE), if using a CPE IKE identifier. Supported values are 'V1' or 'V2'. | "V1" |
| *ipsec_tunnel2_customer_interface_ip* | Customer provided IP CIDR block used on the CPE side for BGP peering in IPSec Tunnel 2. Must be /30 or /31. | "10.10.10.5/30" |
| *ipsec_tunnel2_oracle_interface_ip* | Customer provided IP CIDR block used on the OCI side for BGP peering in IPSec Tunnel 2. | "10.10.10.6/30" |
| *ipsec_tunnel2_ike_version* | Version of the internet key exchange (IKE), if using a CPE IKE identifier. Supported values are 'V1' or 'V2'. | "V1" |
| *add_tt_vcn1* | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available | true |
| *tt_vcn1_onprem_route_enable* | This will drive the creation of the routes and security list rules | true |
| *tt_vcn1_cidrs* | Three-tier VCN 1 CIDR blocks. | ["172.16.0.0/24"] |
| *tt_vcn1_attach_to_drg* | When true, attaches three-tier VCN 1 to the DRG | true |
| *add_exa_vcn1* | VCN configured for Exadata Cloud Service deployment. | true |
| *exa_vcn1_onprem_route_enable* | This will drive the creation of the routes and security list rules | true |
| *exa_vcn1_cidrs* | Exa VCN 1 CIDR blocks. | ["172.16.1.0/24"] |
| *exa_vcn1_attach_to_drg* | When true, the VCN is attached to a DRG, enabling cross-vcn traffic routing | true |
| *network_admin_email_endpoints* | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| *security_admin_email_endpoints* | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"service_label":"ipsecvpn","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20via%20DRG%20(DRG%20will%20be%20created)","on_premises_connection_option":"Create%20New%20IPSec%20VPN","onprem_cidrs":["10.0.0.0/16"],"cpe_ip_address":"x.x.x.x","cpe_device_shape_vendor":"Libreswan","ipsec_customer_bgp_asn":"65000","ipsec_tunnel1_customer_interface_ip":"10.10.10.1/30","ipsec_tunnel1_oracle_interface_ip":"10.10.10.2/30","ipsec_tunnel1_ike_version":"V1","ipsec_tunnel2_customer_interface_ip":"10.10.10.5/30","ipsec_tunnel2_oracle_interface_ip":"10.10.10.6/30","ipsec_tunnel2_ike_version":"V1","add_tt_vcn1":true,"tt_vcn1_onprem_route_enable":true,"tt_vcn1_cidrs":["171.16.0.0/24"],"tt_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_onprem_route_enable":true,"exa_vcn1_cidrs":["172.16.1.0/24"],"exa_vcn1_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:

 - Make sure to pick an OCI region for deployment.
 - Provide customer IP address used for CPE for *cpe\_ip\_address* field.
 - Provide customer email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
 - $ terraform init
 - $ terraform plan
 - $ terraform apply

