# CIS Landing Zone With Standalone Custom VCN Template

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configuration. 

In this template, a single custom three-tier VCN is deployed. The following VCN parameters are customized:
  - VCN name, CIDR blocks and DNS name.
  - All subnets name, CIDR block and DNS name.
  - A public bastion subnet is deployed, with custom name, CIDR block and DNS name.
  - List of CIDR blocks allowed to SSH into jump hosts eventually deployed in Bastion subnet.

Additionally, the following services are enabled:
  - [Connector Hub](https://docs.oracle.com/en-us/iaas/Content/connector-hub/overview.htm), for logging consolidation. Collected logs are sent to an OCI stream.
  - A [Security Zone](https://docs.oracle.com/en-us/iaas/security-zone/using/security-zones.htm) is created for the deployment. The Security Zone target is the landing zone top (enclosing) compartment.
  - [Vulnerability Scanning Service](https://docs.oracle.com/en-us/iaas/scanning/using/overview.htm#scanning_overview) is configured to scan Compute instances that are eventually deployed in the landing zone.
  - A basic [Budget](https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/budgetsoverview.htm#Budgets_Overview) is created.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.


## Default Values

This template will have following parameters set by default: 

| Variable Name | Description | Value |
|---------------|:-----------|:------|
| service_label | A unique identifier to prefix the resources | custvcn |
| customize_net | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks.     | true |
| add_tt_vcn1 | Click to add a three-tier VCN, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available     | true |
| tt_vcn1_name | Enter the VCN name. Otherwise a default name is provided. The label above should be used in the 'Routable VCNs' field of other VCNs for constraining network traffic in a Hub/Spoke topology.     | my-vcn-1 |
| tt_vcn1_cidrs | Enter the list of CIDR blocks for the VCN.        | 192.168.0.0/20 |
| tt_vcn1_dns | Enter the VCN DNS name.             | myvcn1 |
| customize_tt_vcn1_subnets | Check to customize default subnets settings.     | true |
| tt_vcn1_web_subnet_name | Enter the Web subnet name.     | frontend-subnet |
| tt_vcn1_web_subnet_cidr | Enter the Web subnet CIDR block. It must be within the VCN CIDR blocks.      | 192.168.0.0/24 |
| tt_vcn1_web_subnet_dns | Enter the Web subnet DNS name. Use only letters and numbers, no special characters.     | frontend |
| tt_vcn1_web_subnet_is_private | Check to make the Web subnet private. It is public by default.     | true |
| tt_vcn1_app_subnet_name | Enter the Application subnet name.     | middle-subnet |
| tt_vcn1_app_subnet_cidr | Enter the Application subnet CIDR block. It must be within the VCN CIDR blocks.     | 192.168.1.0/24 |
| tt_vcn1_app_subnet_dns | Enter the Application subnet DNS name. Use only letters and numbers, no special characters.      | middle |
| tt_vcn1_db_subnet_name | Enter the Database subnet name.     | backend-subnet |
| tt_vcn1_db_subnet_cidr | Enter the Database subnet CIDR block. It must be within the VCN CIDR blocks.     | 192.168.2.0/24 |
| tt_vcn1_db_subnet_dns | Enter the Database subnet DNS name. Use only letters and numbers, no special characters.      | backend |
| deploy_tt_vcn1_bastion_subnet | Check to to deploy a subnet where you can further deploy OCI Bastion service or a jump host.     | true |
| tt_vcn1_bastion_subnet_name | Enter the Bastion subnet name.     | bastion-subnet |
| tt_vcn1_bastion_subnet_cidr | Enter the Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks.     | 192.168.3.0/29 |
| tt_vcn1_bastion_subnet_dns | Enter the Bastion subnet DNS name. Use only letters and numbers, no special characters.     | bastion |
| tt_vcn1_bastion_is_access_via_public_endpoint | If checked, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed.     | true |
| tt_vcn1_bastion_subnet_allowed_cidrs | These CIDRs are allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access.     | REPLACE_WITH_CIDR_BLOCKS_ALLOWED_FOR_SSH_ACCESS |
| enable_service_connector | Whether Service Connector should be enabled. If true, a single Service Connector is managed for all services log sources and the designated target specified in 'Service Connector Target Kind'. The Service Connector resource is created in INACTIVE state. To activate, check 'Activate Service Connector?' (costs may incur).     | true |
| activate_service_connector | Whether Service Connector should be activated. If true, costs my incur due to usage of Object Storage bucket, Streaming or Function.     | true |
| service_connector_target_kind |Service Connector Hub target resource. Valid values are 'objectstorage', 'streaming', 'functions' or 'logginganalytics'. In case of 'objectstorage', a new bucket is created. In case of 'streaming', you can provide an existing stream ocid in 'existing_service_connector_target_stream_id' and that stream is used. If no ocid is provided, a new stream is created. In case of 'functions', you must provide the existing function ocid in 'existing_service_connector_target_function_id'. If case of 'logginganalytics', a log group for Logging Analytics service is created and the service is enabled if not already      | streaming |
| enable_security_zones |Determines if Security Zones are enabled in Landing Zone compartments. When set to true, the Security Zone is enabled for the enclosing compartment. If no enclosing compartment is used, then the Security Zone is not enabled.   | true |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | streaming |
| vss_create | Whether Vulnerability Scanning should be enabled. If checked, a scanning recipe is enabled and scanning targets are enabled for each Landing Zone compartment.    | true |
| create_budget | If checked, a budget will be created at the root or enclosing compartment and based on forecast spend.      | true |

For a detailed description of all variables that can be used, see the [Variables](../../variables.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/andrecorreaneto/v3testing/archive/refs/heads/misc.zip&zipUrlVariables={"service_label":"custvcn","network_admin_email_endpoints":"email.address@example.com","security_admin_email_endpoints":"email.address@example.com","customize_net":true,"add_tt_vcn1":true,"tt_vcn1_name":"my-vcn-1","tt_vcn1_cidrs":"192.168.0.0/20","tt_vcn1_dns":"myvcn1","customize_tt_vcn1_subnets":true,"tt_vcn1_web_subnet_name":"frontend-subnet","tt_vcn1_web_subnet_cidr":"192.168.0.0/24","tt_vcn1_web_subnet_dns":"frontend","tt_vcn1_web_subnet_is_private":true,"tt_vcn1_app_subnet_name":"middle-subnet","tt_vcn1_app_subnet_cidr":"192.168.1.0/24","tt_vcn1_app_subnet_dns":"middle","tt_vcn1_db_subnet_name":"backend-subnet","tt_vcn1_db_subnet_cidr":"192.168.2.0/24","tt_vcn1_db_subnet_dns":"backend","deploy_tt_vcn1_bastion_subnet":true,"tt_vcn1_bastion_subnet_name":"bastion-subnet","tt_vcn1_bastion_subnet_cidr":"192.168.3.0/29","tt_vcn1_bastion_subnet_dns":"bastion","tt_vcn1_bastion_is_access_via_public_endpoint":true,"tt_vcn1_bastion_subnet_allowed_cidrs":"REPLACE_WITH_CIDR_BLOCKS_ALLOWED_FOR_SSH_ACCESS","enable_service_connector":true,"activate_service_connector":true,"service_connector_target_kind":"streaming","enable_security_zones":true,"vss_create":true,"create_budget":true})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Replace *REPLACE_WITH_CIDR_BLOCKS_ALLOWED_FOR_SSH_ACCESS* with one or more CIDR blocks in *List of CIDR blocks allowed to SSH into jump hosts eventually deployed in Bastion subnet* field. *0.0.0.0/0* is not allowed.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields. 
 - Uncheck *Enable Cloud Guard Service* option in case it is already enabled in your tenancy.

With the stack created, perform a Plan, followed by an Apply using RMS UI.


## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply