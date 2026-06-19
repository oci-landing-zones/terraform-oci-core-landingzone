# Core Landing Zone with Existing DRG and Externally Managed VCNs

This template show how to add externally managed VCNs to [OCI Core Landing Zone](../../) managed Hub/Spoke topology.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value |
|---------------|-------------|-------|
| *service_label* | A unique identifier to prefix the resources | "addnet" |
| *define_net* | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks. | true |
| *hub_deployment_option* | The hub deployment option. In this case, an existing DRG used as the hub. | "VCN or on-premises connectivity routing via DRG (existing DRG)" |
| *existing_drg_ocid* | The existing DRG OCID that the Exa VCN attaches to | "ocid1.drg..replace-with-existing-drg-ocid" |
| *workloadvcn_ocids_public_access* | A list of externally managed VCN OCIDs that require public connectivity. The VCNs provided here attach to the DRG as a spoke and are routeable from the web subnet in the (pre-existing) Hub VCN. | ["ocid1.vcn.oc1aaaaa...yba", "ocid1.vcn.oc1aaaaaa...q7a"] |
| *workloadvcn_ocids_onprem_access* | A list of externally managed VCN OCIDs that require on-premises connectivity. The VCNs provided here attach to the DRG as a spoke and are routeable from the on-premises network. | ["ocid1.vcn.oc1.iadaaaaa...q7a", "ocid1.vcn.oc1.iadaaaaaa...tga"] |
| *onprem_cidrs* | List of on-premises CIDR blocks allowed to connect to the Landing Zone network via a DRG. | ["x.x.x.x/x"] |
| *network_admin_email_endpoints* | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| *security_admin_email_endpoints* | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"service_label":"addnet","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20via%20DRG%20(existing%20DRG)","existing_drg_ocid":"ocid1.drg..replace-with-existing-drg-ocid","onprem_cidrs":["10.0.0.0/16"],"workloadvcn_ocids_public_access":["ocid1.vcn.oc1aaaaa...yba","ocid1.vcn.oc1aaaaaa...q7a"],"workloadvcn_ocids_onprem_access":["ocid1.vcn.oc1.iadaaaaa...q7a","ocid1.vcn.oc1.iadaaaaaa...tga"],"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:

 - Make sure to pick an OCI region for deployment.
 - Provide a list of externally managed VCN OCIDs that are allowed access to existing on-premises connection for *workloadvcn\_ocids\_public\_accesss* field.
 - Provide a list of externally managed VCN OCIDs that are allowed public access through the Hub VCN for *workloadvcn\_ocids\_onprem\_access* field.
 - Provide customer email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply


