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