# Core Landing Zone With Hub/Spoke DRG-Only Topology Template

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configuration. 

It deploys one DRG (Dynamic Routing Gateway) and three three-tier VCNs, which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set: 

| Variable Name | Description | Value |
|---------------|-------------|-------|
| service_label | A unique identifier to prefix the resources | drghs |
| define_net | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks.     | true |
| hub_deployment_option | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing via DRG (DRG will be created)" |
| add_tt_vcn1 | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available     | true |
| tt_vcn1_cidrs | Three-tier VCN 1 CIDR blocks. | ["192.168.0.0/24"] |
| tt_vcn1_attach_to_drg | When true, attaches three-tier VCN 1 to the DRG | true |
| add_tt_vcn2 | When true, deploys three-tier VCN 2, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available     | true |
| tt_vcn2_cidrs | Three-tier VCN 2 CIDR blocks. | ["192.168.1.0/24"] |
| tt_vcn2_attach_to_drg | When true, attaches three-tier VCN 2 to the DRG | true |
| add_tt_vcn3 | Adds three-tier VCN 3, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available     | true |
| tt_vcn3_cidrs | Three-tier VCN 3 CIDR blocks. | ["192.168.2.0/24"] |
| tt_vcn3_attach_to_drg | When true, attaches three-tier VCN 3 to the DRG | true |
| network_admin_email_endpoints | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| security_admin_email_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"drghs","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20via%20DRG%20(DRG%20will%20be%20created)","add_tt_vcn1":true,"tt_vcn1_cidrs":["192.168.0.0/24"],"tt_vcn1_attach_to_drg":true,"add_tt_vcn2":true,"tt_vcn2_cidrs":["192.168.1.0/24"],"tt_vcn2_attach_to_drg":true,"add_tt_vcn3":true,"tt_vcn3_cidrs":["192.168.2.0/24"],"tt_vcn3_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply
