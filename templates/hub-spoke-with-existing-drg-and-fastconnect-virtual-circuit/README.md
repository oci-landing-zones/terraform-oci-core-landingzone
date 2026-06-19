# Core Landing Zone with Existing DRG and FastConnect Virtual Circuit

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configured with a Hub & Spoke networking topology using a FastConnect virtual circuit for on-premises connectivity. It deploys a FastConnect Partner connection using the partner provider ocid, one Three Tier VCN, and one Exadata VCN which are peered through an existing DRG. The DRG is configured to route traffic across all VCNs. 

**Note**: To get a list of the available FastConnect Partner service offerings, see [ListFastConnectProviderServices](https://docs.cloud.oracle.com/iaas/api/#/en/iaas/latest/FastConnectProviderService/ListFastConnectProviderServices).

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value |
|---------------|-------------|-------|
| *service_label* | A unique identifier to prefix the resources | "fc" |
| *define_net* | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks. | true |
| *hub_deployment_option* | The Hub network deployment topology | "VCN or on-premises connectivity routing via DRG (existing DRG)" |
| *existing_drg_ocid* | The existing DRG OCID that the Exa VCN attaches to | "ocid1.drg..replace-with-existing-drg-ocid" |
| *on_premises_connection_option* | The options for connecting to on-premises. Valid options are 'None', 'Create New FastConnect Virtual Circuit', 'Create New IPSec VPN', 'Create New FastConnect Virtual Circuit and IPSec VPN', or 'Use Existing On-Premises Connectivity' | "Create New FastConnect Virtual Circuit" |
| *onprem_cidrs* | List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG. | [10.0.0.0/16"] |
| *fastconnect_virtual_circuit_bandwidth_shape* | Bandwidth level (shape) of the Fast Connect virtual circuit. | "1 Gbps" |
| *fastconnect_virtual_circuit_type* | | "PRIVATE" |
| *fastconnect_virtual_circuit_provider_service_id* | The OCID of the service offered by the provider (if you are connecting via a provider). | "ocid1.providerservice.oc1.xxx..." |
| *fastconnect_virtual_circuit_customer_asn* | Your BGP ASN (either public or private). Provide this value only if there is a BGP session that goes from your edge router to Oracle. Otherwise, leave this empty or null. Can be a 2-byte or 4-byte ASN. | "65100" |
| *fastconnect_virtual_circuit_customer_bgp_peering_ip* | The BGP IPv4 address for the edge router on the other end of the BGP session from Oracle. Must use a subnet mask from /28 to /31. | "10.10.10.1/30" |
| *fastconnect_virtual_circuit_oracle_bgp_peering_ip* | The IPv4 address for Oracles end of the BGP session. Must use a subnet mask from /28 to /31. | "10.10.10.2/30" |
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

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"service_label":"fc","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20via%20DRG%20(existing%20DRG)","existing_drg_ocid":"ocid1.drg..replace-with-existing-drg-ocid","on_premises_connection_option":"Create%20New%20FastConnect%20Virtual%20Circuit","onprem_cidrs":"10.0.0.0/16","fastconnect_virtual_circuit_bandwidth_shape":"1%20Gbps","fastconnect_virtual_circuit_type":"PRIVATE","fastconnect_virtual_circuit_provider_service_id":"ocid1.providerservice.oc1.xxx...","fastconnect_virtual_circuit_customer_asn":"65100","fastconnect_virtual_circuit_customer_bgp_peering_ip":"10.10.10.1/30","fastconnect_virtual_circuit_oracle_bgp_peering_ip":"10.10.10.2/30","add_tt_vcn1":true,"tt_vcn1_onprem_route_enable":true,"tt_vcn1_cidrs":["172.16.0.0/24"],"tt_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_onprem_route_enable":true,"exa_vcn1_cidrs":["172.16.1.0/24"],"exa_vcn1_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:

 - Make sure to pick an OCI region for deployment.
 - Provide customer FastConnect provider OCID for *fastconnect\_virtual\_circuit\_provider\_service\_id* field.
 - Provide customer BGP ASN for *fastconnect\_virtual\_circuit\_customer\_asn* field.
 - Provide customer email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
 - $ terraform init
 - $ terraform plan
 - $ terraform apply

