# CIS Landing Zone With Hub/Spoke DRG with Network Firewall Topology Template

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configuration. 

## Deployment Scenario 1: Fortinet Firewall

It deploys Fortinet Firewall, Hub VCN, Exa VCN and OKE VCN which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

### Default Values

This template has the following parameters set: 

| Variable Name | Description | Value |
|---------------|-------------|-------|
| service_label | A unique identifier to prefix the resources | abcde |
| define_net | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks.     | true |
| hub_deployment_option | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| hub_vcn_cidrs | Hub VCN list of CIDR Blocks | ["192.168.0.0/26"]|
| hub_vcn_deploy_net_appliance_option | Choose one of the available network appliance options for deploying in the Hub VCN.| Fortinet FortiGate Firewall |
| net_fortigate_version | Fortinet Fortigate Firewall Version. | 7.2.9_(\_X_64) or 7.4.4_(\_X_64) |
| net_appliance_flex_shape_memory | Network Appliance Amount of Memory for the Selected Flex Shape | 56 |
| net_appliance_flex_shape_cpu |Network Appliance Number of OCPUs for the Selected Flex Shape | 2 |
| net_appliance_boot_volume_size | Network Appliance Boot Volume Size | 60 |
| net_appliance_public_rsa_key | Network Appliance Instance public SSH Key | Enter Public SSH Key |
| net_appliance_shape | Network Appliance Instance Shape | VM.Standard.E4.Flex |
| add_tt_vcn1 | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available     | true |
| tt_vcn1_cidrs | Three-tier VCN 1 CIDR blocks. | ["10.0.0.0/20"] |
| tt_vcn1_attach_to_drg | When true, attaches three-tier VCN 1 to the DRG | true |
| add_exa_vcn1 | VCN configured for Exadata Cloud Service deployment. | true |
| exa_vcn1_cidrs | Exa VCN 1 CIDR blocks. | ["172.16.0.0/20"] |
| exa_vcn1_attach_to_drg | When true, the VCN is attached to a DRG, enabling cross-vcn traffic routing | true |
| add_oke_vcn1 | Add OKE VCN | true |
| oke_vcn1_cni_type | OKE CNI Type | "Native" |
| oke_vcn1_cidrs | OKE VCN 1 CIDR Block. | ["10.3.0.0/16"]|
| oke_vcn1_attach_to_drg | Attach this VCN to DRG (Dynamic Routing Gateway) | true |
| network_admin_email_endpoints | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| security_admin_email_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |
| enable_cloud_guard | When true, OCI Cloud Guard Service is enabled. Set to false if it's been already enabled through other means. | true |
| create_budget | Create a default budget | true |
| budget_alert_threshold | Percentage of Budget | 100 |
| budget_amount | Monthly Budget Amount (in US$) | 1000|
| budget_alert_email_endpoints | Budget Alert Email Endpoints | ["email.address@example.com"] |


For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

### OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with some variables pre-assigned for deployment. Enter the missing Variable Manually.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](
https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"drghs","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20via%20DRG%20(DRG%20will%20be%20created)","add_tt_vcn1":true,"tt_vcn1_cidrs":["192.168.0.0/24"],"tt_vcn1_attach_to_drg":true,"add_tt_vcn2":true,"tt_vcn2_cidrs":["192.168.1.0/24"],"tt_vcn2_attach_to_drg":true,"add_tt_vcn3":true,"tt_vcn3_cidrs":["192.168.2.0/24"],"tt_vcn3_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"],"enable_cloud_guard":true}
)

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields. 
 - Uncheck *Enable Cloud Guard Service* option in case it is already enabled in your tenancy.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

### Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply


## Deployment Scenario 2: Palo Alto Firewall

It deploys Palo Alto Firewall, Hub VCN, Exa VCN and OKE VCN which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

### Default Values

This template has the following parameters set: 

| Variable Name | Description | Value |
|---------------|-------------|-------|
| service_label | A unique identifier to prefix the resources | abcde |
| define_net | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks.     | true |
| hub_deployment_option | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| hub_vcn_cidrs | Hub VCN list of CIDR Blocks | ["192.168.0.0/26"]|
| hub_vcn_deploy_net_appliance_option | Choose one of the available network appliance options for deploying in the Hub VCN.| Palo Alto Networks VM-Series Firewall |
| net_palo_alto_version | Palo Alto Network Firewall Version. | 11.1.3 or 11.1.2-h3 |
| net_appliance_flex_shape_memory | Network Appliance Amount of Memory for the Selected Flex Shape | 56 |
| net_appliance_flex_shape_cpu |Network Appliance Number of OCPUs for the Selected Flex Shape | 2 |
| net_appliance_boot_volume_size | Network Appliance Boot Volume Size | 60 |
| net_appliance_public_rsa_key | Network Appliance Instance public SSH Key | Enter Public SSH Key |
| net_appliance_shape | Network Appliance Instance Shape | VM.Standard2.4 |
| add_tt_vcn1 | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available     | true |
| tt_vcn1_cidrs | Three-tier VCN 1 CIDR blocks. | ["10.0.0.0/20"] |
| tt_vcn1_attach_to_drg | When true, attaches three-tier VCN 1 to the DRG | true |
| add_exa_vcn1 | VCN configured for Exadata Cloud Service deployment. | true |
| exa_vcn1_cidrs | Exa VCN 1 CIDR blocks. | ["172.16.0.0/20"] |
| exa_vcn1_attach_to_drg | When true, the VCN is attached to a DRG, enabling cross-vcn traffic routing | true |
| add_oke_vcn1 | Add OKE VCN | true |
| oke_vcn1_cni_type | OKE CNI Type | "Native" |
| oke_vcn1_cidrs | OKE VCN 1 CIDR Block. | ["10.3.0.0/16"]|
| oke_vcn1_attach_to_drg | Attach this VCN to DRG (Dynamic Routing Gateway) | true |
| network_admin_email_endpoints | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| security_admin_email_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |
| enable_cloud_guard | When true, OCI Cloud Guard Service is enabled. Set to false if it's been already enabled through other means. | true |
| create_budget | Create a default budget | true |
| budget_alert_threshold | Percentage of Budget | 100 |
| budget_amount | Monthly Budget Amount (in US$) | 1000|
| budget_alert_email_endpoints | Budget Alert Email Endpoints | ["email.address@example.com"] |


For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

### OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with some variables pre-assigned for deployment. Enter the missing Variable Manually.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"drghs","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20via%20DRG%20(DRG%20will%20be%20created)","add_tt_vcn1":true,"tt_vcn1_cidrs":["192.168.0.0/24"],"tt_vcn1_attach_to_drg":true,"add_tt_vcn2":true,"tt_vcn2_cidrs":["192.168.1.0/24"],"tt_vcn2_attach_to_drg":true,"add_tt_vcn3":true,"tt_vcn3_cidrs":["192.168.2.0/24"],"tt_vcn3_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"],"enable_cloud_guard":true})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields. 
 - Uncheck *Enable Cloud Guard Service* option in case it is already enabled in your tenancy.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

### Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply

