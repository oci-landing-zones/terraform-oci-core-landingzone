# Core Landing Zone with Hub & Spoke Topology, Including Jump Host with Bastion Service Template

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configured with a Hub & Spoke networking topology including a Jump Host with Bastion service enabled. It deploys a Jump Host with Oracle Linux 8 in the Jump Host subnet of the Hub VCN, a Bastion service in the Jump Host, a Three Tier VCN, and an Exadata VCN which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set:

| Variable Name                     | Description | Value                                                                                                                      |
|-----------------------------------|-------------|----------------------------------------------------------------------------------------------------------------------------|
| service\_label                    | A unique identifier to prefix the resources | ocibastion                                                                                                                 |
| define\_net                       | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks. | true                                                                                                                       |
| hub\_deployment\_option           | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| hub\_vcn\_cidrs                   | Hub VCN list of CIDR Blocks | ["192.168.0.0/24"]                                                                                                         |
| deploy\_bastion\_jump\_host       | The option to deploy the bastion jump host. | true                                                                                                                       |
| deploy\_bastion\_service          | The option to deploy the bastion service. | true                                                                                                                       |
| bastion\_service\_allowed\_cidrs  | List of the bastion service allowed cidrs. | ["x.x.x.x"]                                                                                                                |
| add\_tt\_vcn1                     | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available | true                                                                                                                       |
| tt\_vcn1\_cidrs                   | Three-tier VCN 1 CIDR blocks. | ["10.0.0.0/20"]                                                                                                            |
| tt\_vcn1\_attach\_to\_drg         | When true, attaches three-tier VCN 1 to the DRG | true                                                                                                                       |
| add\_exa\_vcn1                    | VCN configured for Exadata Cloud Service deployment. | true                                                                                                                       |
| exa\_vcn1\_cidrs                  | Exa VCN 1 CIDR blocks. | ["172.16.0.0/20"]                                                                                                          |
| exa\_vcn1\_attach\_to\_drg        | When true, the VCN is attached to a DRG, enabling cross-vcn traffic routing | true                                                                                                                       |
| network\_admin\_email\_endpoints  | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"]                                                                                              |
| security\_admin\_email\_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"]                                                                                              |
| enable\_cloud\_guard              | When true, OCI Cloud Guard Service is enabled. Set to false if it's been already enabled through other means. | false                                                                                                                      | |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={
"service_label":"ocibastion","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20%28DRG%20and%20DMZ%20VCN%20will%20be%20created%29","hub_vcn_cidrs":["192.168.0.0/24"],"deploy_bastion_jump_host":true,"deploy_bastion_service":true,"bastion_service_allowed_cidrs":["x.x.x.x"], "add_tt_vcn1":true,"tt_vcn1_cidrs":["10.0.0.0/20"],"tt_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_cidrs":["172.16.0.0/20"],"exa_vcn1_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"],"enable_cloud_guard":false})

You are required to review/adjust the following variable settings:

 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.
 - Provide real CIDR block(s) used to access the Bastion service for *bastion_service_allowed_cidrs* field.
 - Uncheck *Enable Cloud Guard Service* option in case it is already enabled in your tenancy.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply

