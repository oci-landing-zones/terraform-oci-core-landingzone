# Core Landing Zone with Hub & Spoke Topology, Including IPSec VPN On-Premises Connectivity Template

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configured with a Hub & Spoke networking topology using a IPSec VPN connection for on-premises connectivity. It deploys an IPSec connection using Libreswan CPE (customer-premises equipment), Three Tier VCN, and an Exadata VCN which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value |
|---------------|-------------|-------|
| service\_label | A unique identifier to prefix the resources | ociipsecvpn |
| define\_net | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks. | true |
| hub\_deployment\_option | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| hub\_vcn\_cidrs | Hub VCN list of CIDR Blocks | ["192.168.0.0/24"] |
| on\_premises\_connection\_option | The options for connecting to on-premises. Valid options are 'None', 'Create New FastConnect Virtual Circuit', 'Create New IPSec VPN', 'Create New FastConnect Virtual Circuit and IPSec VPN', or 'Use Existing On-Premises Connectivity' | "Create New IPSec VPN" |
| onprem\_cidrs | List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG. | ["x.x.x.x/x"] |
| cpe\_ip\_address | Public IP address used by the Customer-Premises Equipment (CPE) so that a VPN connection can be established. | "x.x.x.x" |
| cpe\_device\_shape\_vendor | Name of the device shape vendor used by the Customer-Premises Equipment (CPE). | "Libreswan" |
| ipsec\_customer\_bgp\_asn | Customer on-premises networks Autonomous System Number. | "65000" |
| ipsec\_tunnel1\_customer\_interface\_ip | The first IP CIDR block used on the customer side for BGP peering for IPSec Tunnel 1. | "10.10.10.1/30" |
| ipsec\_tunnel1\_oracle\_interface\_ip | The first IP CIDR block provided by OCI for BGP peering for IPSec Tunnel 1. | "10.10.10.2/30" |
| ipsec\_tunnel1\_ike\_version | Version of the internet key exchange (IKE), if using a CPE IKE identifier. Supported values are 'V1' or 'V2'. | "V1" |
| ipsec\_tunnel2\_customer\_interface\_ip | The second IP CIDR block used on the customer side for BGP peering for IPSec Tunnel 2. | "10.10.10.5/30" |
| ipsec\_tunnel2\_oracle\_interface\_ip | The second IP CIDR block provided by OCI for BGP peering for IPSec Tunnel 2. | "10.10.10.6/30" |
| ipsec\_tunnel2\_ike\_version | Version of the internet key exchange (IKE), if using a CPE IKE identifier. Supported values are 'V1' or 'V2'. | "V1" |
| add\_tt\_vcn1 | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available | true |
| tt\_vcn1\_onprem\_route\_enable | This will drive the creation of the routes and security list rules | true |
| tt\_vcn1\_cidrs | Three-tier VCN 1 CIDR blocks. | ["10.0.0.0/20"] |
| tt\_vcn1\_attach\_to\_drg | When true, attaches three-tier VCN 1 to the DRG | true |
| add\_exa\_vcn1 | VCN configured for Exadata Cloud Service deployment. | true |
| exa\_vcn1\_onprem\_route\_enable | This will drive the creation of the routes and security list rules | true |
| exa\_vcn1\_cidrs | Exa VCN 1 CIDR blocks. | ["172.16.0.0/20"] |
| exa\_vcn1\_attach\_to\_drg | When true, the VCN is attached to a DRG, enabling cross-vcn traffic routing | true |
| network\_admin\_email\_endpoints | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| security\_admin\_email\_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"ociipsecvpn","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20%28DRG%20and%20DMZ%20VCN%20will%20be%20created%29","hub_vcn_cidrs":["192.168.0.0/24"],"on_premises_connection_option":"Create%20New%20IPSec%20VPN","onprem_cidrs":["x.x.x.x/x"],"cpe_ip_address":"x.x.x.x","cpe_device_shape_vendor":"Libreswan","ipsec_customer_bgp_asn":"65000","ipsec_tunnel1_customer_interface_ip":"10.10.10.1/30","ipsec_tunnel1_oracle_interface_ip":"10.10.10.2/30","ipsec_tunnel1_ike_version":"V1","ipsec_tunnel2_customer_interface_ip":"10.10.10.5/30","ipsec_tunnel2_oracle_interface_ip":"10.10.10.6/30","ipsec_tunnel2_ike_version":"V1","add_tt_vcn1":true,"tt_vcn1_onprem_route_enable":true,"tt_vcn1_cidrs":["10.0.0.0/20"],"tt_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_onprem_route_enable":true,"exa_vcn1_cidrs":["172.16.0.0/20"],"exa_vcn1_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:

 - Make sure to pick an OCI region for deployment.
 - Provide customer CIDR block(s) used to access on-premises network(s) for *onprem\_cidrs* field.
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

