# Core Landing Zone Custom Identity Domain Template

This template deploys a landing zone for a pre-existing non-Default identity domain using [OCI Core Landing Zone](../../) configuration. The landing zone also deploys the groups and dynamic groups for the existing domain in this template.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.


## Default Values

This template has the following parameters set: 

### General

| Variable Name | Description | Value |
|---------------|-------------|-------|
| service\_label | A unique identifier to prefix the resources | existingID |
| network\_admin\_email\_endpoints | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| security\_admin\_email\_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |
| identity\_domain\_option | Option to use the default identity domain, create a new identity domain or use custom identity domain. Value to use: Default Domain, New Identity Domain, Use Custom Identity Domain | "Use Custom Identity Domain" |
| custom\_id\_domain\_ocid | Replace with your identity domain OCID. | ["your\_domain\_ocid"] |
| deploy\_custom\_domain\_groups | Deploy custom identity domain groups and dynamic groups. | true |
| customize\_iam | Whether Landing Zone IAM settings are to be customized. | true |


For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"existingID","network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"],"identity_domain_option":"Use%20Custom%20Identity%20Domain","custom_id_domain_ocid":["your_domain_ocid"],"deploy_custom_domain_groups":true,"customize_iam":true})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

Everything else is optional.    

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply

