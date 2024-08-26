# CIS Landing Zone Basic Template

This template shows how to deploy the most basic CIS compliant landing zone using [OCI Core Landing Zone](../../) configuration. In this template, no networking is deployed.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/andrecorreaneto/v3testing/archive/refs/heads/misc.zip&zipUrlVariables={"service_label":"cisbasic","network_admin_email_endpoints":"email.address@example.com","security_admin_email_endpoints":"email.address@example.com"})

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