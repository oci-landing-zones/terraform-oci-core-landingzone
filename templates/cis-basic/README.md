# Core Landing Zone Express/Lite Template

This template shows how to deploy the most basic CIS compliant landing zone using [OCI Core Landing Zone](../../) configuration. In this "express" or "lite" template, no networking is deployed.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.


## Default Values

This template has the following parameters set:

### General

| Variable Name | Description | Value |
|---------------|-------------|-------|
| service\_label | A unique identifier to prefix the resources | express |
| network\_admin\_email\_endpoints | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| security\_admin\_email\_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |


For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"express","network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

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

