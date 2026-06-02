# Core Landing Zone with Existing Identity Domain

This template deploys a landing zone for a pre-existing non-Default identity domain using [OCI Core Landing Zone](../../) configuration. The landing zone also deploys the groups and dynamic groups for the existing domain in this template.

Please see [templates](../../templates/) for other CIS compliant Core Landing Zone templates.

## Default Values

This template has the following parameters pre-configured: 

| Variable Name | Description | Value |
|---------------|-------------|-------|
| *service_label* | A unique identifier to prefix the resources | "existdomain" |
| *network_admin_email_endpoints* | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| *security_admin_email_endpoints* | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |
| *identity_domain_option* | Option to use the default identity domain, create a new identity domain or use custom identity domain. Value to use: Default Domain, New Identity Domain, Use Custom Identity Domain | "Use Custom Identity Domain" |
| *custom_id_domain_compartment_ocid* | Replace with the OCID of the compartment containing your identity domain. Use the tenancy OCID if the identity domain is in the root compartment. | "ocid1.compartment.oc1..replace-with-your-identity-domain-compartment-ocid" |
| *custom_id_domain_ocid* | Replace with your identity domain OCID. | "ocid1.domain.oc1..replace-with-your-identity-domain-ocid" |
| *deploy_custom_domain_groups* | Deploy custom identity domain groups and dynamic groups. | true |
| *customize_iam* | RMS UI control to show/hide Landing Zone customization options. Ignored by during plan/apply. | true |


For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables=%7B%22service_label%22%3A%22existdomain%22%2C%22customize_iam%22%3Atrue%2C%22identity_domain_option%22%3A%22Use%20Custom%20Identity%20Domain%22%2C%22custom_id_domain_compartment_ocid%22%3A%22ocid1.compartment.oc1..replace-with-your-identity-domain-compartment-ocid%22%2C%22custom_id_domain_ocid%22%3A%22ocid1.domain.oc1..replace-with-your-identity-domain-ocid%22%2C%22deploy_custom_domain_groups%22%3Atrue%2C%22network_admin_email_endpoints%22%3A%5B%22email.address%40example.com%22%5D%2C%22security_admin_email_endpoints%22%3A%5B%22email.address%40example.com%22%5D%7D)

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide the OCID of the compartment containing your existing identity domain.
 - Provide the OCID of your existing identity domain.
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

