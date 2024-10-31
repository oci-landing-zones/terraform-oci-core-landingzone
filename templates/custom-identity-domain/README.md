# CIS Landing Zone Custom Identity Domain Template

This template deploys a landing zone for a pre-existing non-Default identity domain using [OCI Core Landing Zone](../../) configuration. The landing zone also deploys the groups and dynamic groups for the existing domain in this template.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.


## Default Values

This template has the following parameters set: 

### General

| Variable Name | Description | Value |
|---------------|-------------|-------|
| service_label | A unique identifier to prefix the resources | existingID |
| network_admin_email_endpoints | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| security_admin_email_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |
| enable_cloud_guard | When true, OCI Cloud Guard Service is enabled. Set to false if it's been already enabled through other means. | false |
| use_custom_id_domain | Designate to use a pre-existing identity domain. | true |
| custom_id_domain_ocid | Replace with your identity domain OCID. | ["your_domain_ocid"] |
| deploy_custom_domain_groups | Deploy custom identity domain groups and dynamic groups. | true |


For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"existingID","network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"],"enable_cloud_guard":false,"use_custom_id_domain":true,"custom_id_domain_ocid":["your_domain_ocid"],"deploy_custom_domain_groups":true})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields. 
 - Uncheck *Enable Cloud Guard Service* option in case it is already enabled in your tenancy.

Everything else is optional.    

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply

