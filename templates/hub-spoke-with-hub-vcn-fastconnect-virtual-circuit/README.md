# Core Landing Zone with Hub & Spoke Topology, Including FastConnect Virtual Circuit On-Premises Connectivity Template

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configured with a Hub & Spoke networking topology using a FastConnect virtual circuit for on-premises connectivity. It deploys a FastConnect Partner connection using the partner provider ocid, a Three Tier VCN, and an Exadata VCN which are peered through the DRG. The DRG is configured to route traffic across all VCNs. To get a list of the available FastConnect Partner service offerings, see [ListFastConnectProviderServices](https://docs.cloud.oracle.com/iaas/api/#/en/iaas/latest/FastConnectProviderService/ListFastConnectProviderServices).

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value |
|---------------|-------------|-------|
| service\_label | A unique identifier to prefix the resources | ocifastconnect |
| define\_net | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks. | true |
| hub\_deployment\_option | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| hub\_vcn\_cidrs | Hub VCN list of CIDR Blocks | ["192.168.0.0/24"] |
| on\_premises\_connection\_option | The options for connecting to on-premises. Valid options are 'None', 'Create New FastConnect Virtual Circuit', 'Create New IPSec VPN', 'Create New FastConnect Virtual Circuit and IPSec VPN', or 'Use Existing On-Premises Connectivity' | "Create New FastConnect Virtual Circuit" |
| onprem\_cidrs | List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG. | [x.x.x.x/x"] |
| fastconnect\_virtual\_circuit\_bandwidth\_shape | Bandwidth level (shape) of the Fast Connect virtual circuit. | "1 Gbps" |
| fastconnect\_virtual\_circuit\_type | | "PRIVATE" |
| fastconnect\_virtual\_circuit\_provider\_service\_id | The OCID of the service offered by the provider (if you are connecting via a provider). | "ocid1.providerservice.oc1.xxx..." |
| fastconnect\_virtual\_circuit\_customer\_asn | Your BGP ASN (either public or private). Provide this value only if there is a BGP session that goes from your edge router to Oracle. Otherwise, leave this empty or null. Can be a 2-byte or 4-byte ASN. | "xxxxx" |
| fastconnect\_virtual\_circuit\_customer\_bgp\_peering\_ip | The BGP IPv4 address for the edge router on the other end of the BGP session from Oracle. Must use a subnet mask from /28 to /31. | "10.10.10.1/30" |
| fastconnect\_virtual\_circuit\_oracle\_bgp\_peering\_ip | The IPv4 address for Oracles end of the BGP session. Must use a subnet mask from /28 to /31. | "10.10.10.2/30" |
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
| enable\_cloud\_guard | When true, OCI Cloud Guard Service is enabled. Set to false if it's been already enabled through other means. | false |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://objectstorage.us-phoenix-1.oraclecloud.com/p/BTYmFcgp5AHWAdsfzamM5CgqjsniQOd_eVb76I4kZgG5EKBlMUnqOxyy5-uz90H6/n/axs5iy7wsxxn/b/ipsec-bucket/o/oci-core-landing-zone-ipsec-fc-deployment-templates.zip&zipUrlVariables={"service_label":"ocifastconnect","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20%28DRG%20and%20DMZ%20VCN%20will%20be%20created%29","hub_vcn_cidrs":["192.168.0.0/24"],"on_premises_connection_option":"Create%20New%20FastConnect%20Virtual%20Circuit","onprem_cidrs":"x.x.x.x/x","fastconnect_virtual_circuit_bandwidth_shape":"1%20Gbps","fastconnect_virtual_circuit_type":"PRIVATE","fastconnect_virtual_circuit_provider_service_id":"ocid1.providerservice.oc1.xxx...","fastconnect_virtual_circuit_customer_asn":"xxxxx","fastconnect_virtual_circuit_customer_bgp_peering_ip":"10.10.10.1/30","fastconnect_virtual_circuit_oracle_bgp_peering_ip":"10.10.10.2/30","fastconnect_virtual_circuit_provider_service_id":"ocid1.providerservice.oc1...","add_tt_vcn1":true,"tt_vcn1_onprem_route_enable":true,"tt_vcn1_cidrs":["10.0.0.0/20"],"tt_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_onprem_route_enable":true,"exa_vcn1_cidrs":["172.16.0.0/20"],"exa_vcn1_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"],"enable_cloud_guard":false})

You are required to review/adjust the following variable settings:

 - Make sure to pick an OCI region for deployment.
 - Provide customer CIDR block(s) used to access on-premises network(s) for *onprem\_cidrs* field.
 - Provide customer FastConnect provider OCID for *fastconnect\_virtual\_circuit\_provider\_service\_id* field.
 - Provide customer BGP ASN for *fastconnect\_virtual\_circuit\_customer\_asn* field.
 - Provide customer email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.
 - Uncheck *Enable Cloud Guard Service* option in case it is already enabled in your tenancy.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
 - $ terraform init
 - $ terraform plan
 - $ terraform apply

