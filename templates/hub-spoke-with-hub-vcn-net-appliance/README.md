# Core Landing Zone with Network Firewall Appliance

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configuration with a Hub/Spoke networking topology including either Fortinet's Fortigate Firewall or Palo Alto Networks Firewall. Both configurations are mostly the same, except for the network appliance option (_hub\_vcn\_deploy\_net\_appliance\_option_) and their respective settings (_net\_appliance\__ variables).

Deploying a network firewall appliance requires the same Terraform configuration executed twice. The first time it creates all the networking resources, except the required routing to the network load balancers that front end the network appliances (that are also created in the first run). So the second time execution is to update the configuration with that routing.

The variables to update for the second time execution are **hub_vcn_north_south_entry_point_ocid** and **hub_vcn_east_west_entry_point_ocid**. And their values are available in the **nlb_private_ip_addresses** output. 
- **hub_vcn_north_south_entry_point_ocid** takes the OCID value in **nlb_private_ip_addresses.OUTDOOR-NLB**
- **hub_vcn_east_west_entry_point_ocid** takes the OCID value in **nlb_private_ip_addresses.INDOOR_NLB**.

**Note**: this example only becomes functionally complete from a network routing perspective once you configure the network firewall appliance for connectivity. See [Palo Alto Firewall Bootstrap](./PALO-ALTO-BOOTSTRAP.md) for basic configuration and management access instructions over SSH and HTTPS through OCI Bastion.

## Deployment Scenario 1: Fortinet Firewall

It deploys Fortinet Firewall, Hub VCN, Three Tier VCN, Exa VCN and OKE VCN which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

### Default Values

This template has the following parameters set: 

| Variable Name | Description | Value |
|---------------|-------------|-------|
| *service_label* | A unique identifier to prefix the resources | "fortinet" |
| *define_net* | Whether this configuration defines networking resources. By default, the Landing Zone does NOT deploy any networks.     | true |
| *hub_deployment_option* | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| *hub_vcn_cidrs* | Hub VCN list of CIDR Blocks | ["192.168.0.0/26"] |
| *hub_vcn_deploy_net_appliance_option* | The network appliance image source. | "Marketplace Image" |
| *net_appliance_image_vendor* | The network appliance vendor | "Fortinet" |
| *net_appliance_marketplace_image_ocid* | The network appliance marketplace image OCID. Null uses image name and version. | null |
| *net_appliance_marketplace_image_name* | The network appliance marketplace image name | "Fortinet FortiGate Firewall" |
| *net_appliance_marketplace_image_version* | The network appliance marketplace image version | "7.6.4_(_X64_)" |
| *net_appliance_name_prefix* | The name prefix for the provisioned OCI Compute resources | "fortinet" |
| *net_appliance_shape* | The network appliance image shape | "VM.Standard3.Flex" |
| *net_appliance_flex_shape_memory* | The amount of memory (in Gb) for the flex shape | 56 |
| *net_appliance_flex_shape_cpu* | The amount of CPU cores for the flex shape | 4 |
| *net_appliance_boot_volume_size* | The network appliance boot volume size (in Gb) | 60 |
| *net_appliance_public_rsa_key* | The network appliance public SSH key file path or content | "replace-with-public-key-path-or-key-string" |
| *add_tt_vcn1* | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available     | true |
| *tt_vcn1_cidrs* | Three-tier VCN 1 CIDR blocks. | ["10.0.0.0/20"] |
| *tt_vcn1_attach_to_drg* | When true, attaches three-tier VCN 1 to the DRG | true |
| *add_exa_vcn1* | VCN configured for Exadata Cloud Service deployment. | true |
| *exa_vcn1_cidrs* | Exa VCN 1 CIDR blocks. | ["172.16.0.0/20"] |
| *exa_vcn1_attach_to_drg* | When true, the VCN is attached to a DRG, enabling cross-vcn traffic routing | true |
| *add_oke_vcn1* | Add OKE VCN | true |
| *oke_vcn1_cni_type* | OKE CNI Type | "Native" |
| *oke_vcn1_cidrs* | OKE VCN 1 CIDR Block. | ["10.3.0.0/16"] |
| *oke_vcn1_attach_to_drg* | Attach this VCN to DRG (Dynamic Routing Gateway) | true |
| *hub_vcn_north_south_entry_point_ocid* | The OCID of a private address the Hub VCN routes traffic to for inbound external traffic (North/South). It must be updated for the second execution of the configuration. | Initially null. For the second time execution, it is the OCID of the outdoor (aka untrust) network load balancer's private IP address. This is available in the output nlb_private_ip_addresses.OUTDOOR-NLB. |
| *hub_vcn_east_west_entry_point_ocid* | The OCID of a private address the Hub VCN routes traffic to for inbound internal cross-vcn traffic (East/West). It must be updated for the second execution of the configuration. | Initially null. For the second time execution, it is the OCID of the indoor (aka trust) network load balancer's private IP address. This is available in the output nlb_private_ip_addresses.INDOOR_NLB. |
| *network_admin_email_endpoints* | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| *security_admin_email_endpoints* | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |
| *create_budget* | Create a default budget | true |
| *budget_alert_threshold* | Percentage of Budget | 100 |
| *budget_amount* | Monthly Budget Amount (in US$) | 1000 |
| *budget_alert_email_endpoints* | Budget Alert Email Endpoints | ["email.address@example.com"] |


For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

### OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"service_label":"fortinet","display_security_logging_governance_settings":true,"define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20%28DRG%20and%20DMZ%20VCN%20will%20be%20created%29","hub_vcn_cidrs":["192.168.0.0/26"],"hub_vcn_deploy_net_appliance_option":"Marketplace%20Image","net_appliance_image_vendor":"Fortinet","net_appliance_marketplace_image_name":"Fortinet%20FortiGate%20Firewall","net_appliance_marketplace_image_version":"7.6.4_%28_X64_%29","net_appliance_name_prefix":"fortinet","net_appliance_shape":"VM.Standard3.Flex","net_appliance_flex_shape_memory":56,"net_appliance_flex_shape_cpu":4,"net_appliance_boot_volume_size":60,"add_tt_vcn1":true,"tt_vcn1_cidrs":["10.0.0.0/20"],"tt_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_cidrs":["172.16.0.0/20"],"exa_vcn1_attach_to_drg":true,"add_oke_vcn1":true,"oke_vcn1_cni_type":"Native","oke_vcn1_cidrs":["10.3.0.0/16"],"oke_vcn1_attach_to_drg":true,"hub_vcn_north_south_entry_point_ocid":null,"hub_vcn_east_west_entry_point_ocid":null,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"],"create_budget":true,"budget_alert_threshold":100,"budget_amount":1000,"budget_alert_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

Once the Apply finishes, RMS displays the stack output under the **Application information** tab. Under Networking, there is an output named **Network Load Balancers (NLB) Private IP Addresses**, whose value looks like:
```
{"INDOOR_NLB":{"id":"ocid1.privateip.oc1.phx.abyhql...goq"},"OUTDOOR-NLB":{"id":"ocid1.privateip.oc1.phx.abyhql...4ga"}}
```

Edit the RMS stack variables to update the routings to the network appliance using the values above. 
- Enter the id value in OUTDOOR-NLB ("ocid1.privateip.oc1.phx.abyhql...4ga") to update **Hub VCN North/South Traffic Destination OCID** field.
- Enter the id value in INDOOR_NLB ("ocid1.privateip.oc1.phx.abyhql...goq") to update **Hub VCN East/West Traffic Destination OCID** field.

![panf_deploy_update](../../images/panf_deploy_update.png)

Perform a new Plan, followed by an Apply.

### Terraform CLI Deployment

1. Rename file *main.tf.fortinet.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply
4. Take note of the values in the output **nlb_private_ip_addresses**.
5. Uncomment and update the variables **hub_vcn_north_south_entry_point_ocid** and **hub_vcn_east_west_entry_point_ocid** as instructed in *main.tf.fortinet.template*.
6. In this folder, execute Terraform plan and apply again:
    - $ terraform plan
    - $ terraform apply

## Deployment Scenario 2: Palo Alto Firewall

It deploys Palo Alto Firewall, Hub VCN, Three Tier VCN, Exa VCN and OKE VCN which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

### Default Values

This template has the following parameters set: 

| Variable Name | Description | Value |
|---------------|-------------|-------|
| *service_label* | A unique identifier to prefix the resources | "paloalto" |
| *define_net* | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks.     | true |
| *hub_deployment_option* | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| *hub_vcn_cidrs* | Hub VCN list of CIDR Blocks | ["192.168.0.0/26"] |
| *hub_vcn_deploy_net_appliance_option* | The network appliance image source. | "Marketplace Image" |
| *net_appliance_image_vendor* | The network appliance vendor | "PaloAlto" |
| *net_appliance_marketplace_image_ocid* | The network appliance marketplace image OCID. Null uses image name and version. | null |
| *net_appliance_marketplace_image_name* | The network appliance marketplace image name | "Palo Alto Networks VM-Series Firewall" |
| *net_appliance_marketplace_image_version* | The network appliance marketplace image version | "11.1.6-h7" |
| *net_appliance_name_prefix* | The name prefix for the provisioned OCI Compute resources | "panf" |
| *net_appliance_shape* | The network appliance image shape | "VM.Standard3.Flex" |
| *net_appliance_flex_shape_memory* | The amount of memory (in Gb) for the flex shape | 56 |
| *net_appliance_flex_shape_cpu* | The amount of CPU cores for the flex shape | 4 |
| *net_appliance_boot_volume_size* | The network appliance boot volume size (in Gb) | 60 |
| *net_appliance_public_rsa_key* | The network appliance public SSH key file path or content | "replace-with-public-key-path-or-key-string" |
| *add_tt_vcn1* | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available     | true |
| *tt_vcn1_cidrs* | Three-tier VCN 1 CIDR blocks. | ["10.0.0.0/20"] |
| *tt_vcn1_attach_to_drg* | When true, attaches three-tier VCN 1 to the DRG | true |
| *add_exa_vcn1* | VCN configured for Exadata Cloud Service deployment. | true |
| *exa_vcn1_cidrs* | Exa VCN 1 CIDR blocks. | ["172.16.0.0/20"] |
| *exa_vcn1_attach_to_drg* | When true, the VCN is attached to a DRG, enabling cross-vcn traffic routing | true |
| *add_oke_vcn1* | Add OKE VCN | true |
| *oke_vcn1_cni_type* | OKE CNI Type | "Native" |
| *oke_vcn1_cidrs* | OKE VCN 1 CIDR Block. | ["10.3.0.0/16"] |
| *oke_vcn1_attach_to_drg* | Attach this VCN to DRG (Dynamic Routing Gateway) | true |
| *hub_vcn_north_south_entry_point_ocid* | The OCID of a private address the Hub VCN routes traffic to for inbound external traffic (North/South). It must be updated for the second execution of the configuration. | Initially null. For the second time execution, it is the OCID of the outdoor network load balancer's private IP address. This is available in the output nlb_private_ip_addresses.OUTDOOR-NLB. |
| *hub_vcn_east_west_entry_point_ocid* | The OCID of a private address the Hub VCN routes traffic to for inbound internal cross-vcn traffic (East/West). It must be updated for the second execution of the configuration. | Initially null. For the second time execution, it is the OCID of the indoor network load balancer's private IP address. This is available in the output nlb_private_ip_addresses.INDOOR_NLB. |
| *network_admin_email_endpoints* | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| *security_admin_email_endpoints* | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |
| *create_budget* | Create a default budget | true |
| *budget_alert_threshold* | Percentage of Budget | 100 |
| *budget_amount* | Monthly Budget Amount (in US$) | 1000 |
| *budget_alert_email_endpoints* | Budget Alert Email Endpoints | ["email.address@example.com"] |


For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

### OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"service_label":"paloalto","display_security_logging_governance_settings":true,"define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20%28DRG%20and%20DMZ%20VCN%20will%20be%20created%29","hub_vcn_cidrs":["192.168.0.0/26"],"hub_vcn_deploy_net_appliance_option":"Marketplace%20Image","net_appliance_image_vendor":"PaloAlto","net_appliance_marketplace_image_name":"Palo%20Alto%20Networks%20VM-Series%20Next%20Generation%20Firewall","net_appliance_marketplace_image_version":"11.1.6-h7","net_appliance_name_prefix":"panf","net_appliance_shape":"VM.Standard3.Flex","net_appliance_flex_shape_memory":56,"net_appliance_flex_shape_cpu":4,"net_appliance_boot_volume_size":60,"add_tt_vcn1":true,"tt_vcn1_cidrs":["10.0.0.0/20"],"tt_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_cidrs":["172.16.0.0/20"],"exa_vcn1_attach_to_drg":true,"add_oke_vcn1":true,"oke_vcn1_cni_type":"Native","oke_vcn1_cidrs":["10.3.0.0/16"],"oke_vcn1_attach_to_drg":true,"hub_vcn_north_south_entry_point_ocid":null,"hub_vcn_east_west_entry_point_ocid":null,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"],"create_budget":true,"budget_alert_threshold":100,"budget_amount":1000,"budget_alert_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

Once the Apply finishes, RMS displays the stack output under the **Application information** tab. Under Networking, there is an output named **Network Load Balancers (NLB) Private IP Addresses**, whose value looks like:
```
{"INDOOR_NLB":{"id":"ocid1.privateip.oc1.phx.abyhql...goq"},"OUTDOOR-NLB":{"id":"ocid1.privateip.oc1.phx.abyhql...4ga"}}
```

Edit the RMS stack variables to update the routings to the network appliance using the values above. 
- Enter the id value in OUTDOOR-NLB ("ocid1.privateip.oc1.phx.abyhql...4ga") to update **Hub VCN North/South Traffic Destination OCID** field.
- Enter the id value in INDOOR_NLB ("ocid1.privateip.oc1.phx.abyhql...goq") to update **Hub VCN East/West Traffic Destination OCID** field.

![fortigate_deploy_update](../../images/fortigate_deploy_update.png)

Perform a new Plan, followed by an Apply.

### Terraform CLI Deployment

1. Rename file *main.tf.paloalto.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply
4. Take note of the values in the output **nlb_private_ip_addresses**.
5. Uncomment and update the variables **hub_vcn_north_south_entry_point_ocid** and **hub_vcn_east_west_entry_point_ocid** as instructed in *main.tf.paloalto.template*.
6. In this folder, execute Terraform plan and apply again:
    - $ terraform plan
    - $ terraform apply  
7. Optionally bootstrap both Palo Alto nodes by following [Palo Alto Firewall Bootstrap](./PALO-ALTO-BOOTSTRAP.md). The provided basic configuration is permissive and used to validate connectivity. 


