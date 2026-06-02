# Core Landing Zone with No Firewall

This template shows how to deploy [OCI Core Landing Zone](../../) with a Hub VCN configuration with no network firewall. It showcases that Core Landing Zone configures the Hub VCN for the further deployment of a network firewall (through Core Landing Zone or other means). This is useful for customers that already have their firewall deployment automated, requiring only the adequate network configuration in place. The template additionally pre-configures the VCN with a jump host subnet where a jump host and OCI Bastion service are deployed.

Once the firewall is deployed, it is required to run this configuration a second time with the following variables assigned:

- **hub_vcn_north_south_entry_point_ocid** takes the OCID value of the OCI private IP address of the firewall untrust (aka outdoor, in Core LZ's terminology) interface.
- **hub_vcn_east_west_entry_point_ocid** takes the OCID value of the OCI private IP address of the firewall trust (aka indoor, in Core LZ's terminology) interface.

## Configuration Variables

This template has the following parameters pre-configured: 

| Variable Name | Description | Value |
|---------------|-------------|-------|
| *service_label* | A unique identifier to prefix the resources | "nofw" |
| *define_net* | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks.     | true |
| *hub_deployment_option* | The hub deployment option. In this case, both DRG and Hub VCN are deployed. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| *hub_vcn_cidrs* | Hub VCN list of CIDR Blocks | ["172.16.0.0/26"]|
| *add_hub_vcn_jumphost_subnet*    | The option to deploy the jump host subnet, where both Jump host and OCI Bastion are further deployed. | true                                                                                                       |
| *deploy_bastion_jump_host*       | The option to deploy the bastion jump host. | true                                                                                                                       |
| *bastion_jump_host_image_source* | Jump host image source. | *"Marketplace Image"* |
| *bastion_jump_host_marketplace_image_name* | Jump host marketplace image name. | *"Oracle Linux 8 STIG"* |
| *bastion_jump_host_marketplace_image_version* | Jump host marketplace image version. | *"Oracle-Linux-8.10-2025.06.24-STIG"* |
| *bastion_jump_host_ssh_public_key_path* | SSH public key path or content for the jump host. | *"~/.ssh/id_rsa.pub"* or *"ssh-rsa%20AAAAB3NzaC1yc2EAAAADAQABAAABAQCmockedPublicKeyContentOnlyDoNotUse%20mock@example.com"* |
| *bastion_jump_host_instance_shape* | Jump host compute shape. | *"VM.Standard.E4.Flex"* |
| *bastion_jump_host_boot_volume_size* | Jump host boot volume size in GB. | *60* |
| *bastion_jump_host_flex_shape_memory* | Jump host flex memory in GB. | *16* |
| *bastion_jump_host_flex_shape_cpu* | Jump host flex OCPU count. | *2* |
| *deploy_bastion_service*          | The option to deploy the bastion service. | true                                                                                                                       |
| *bastion_service_allowed_cidrs*  | List of the bastion service allowed cidrs. | ["x.x.x.x"]
| *network_admin_email_endpoints* | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| *security_admin_email_endpoints* | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

### OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment. 

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"service_label":"nofw","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20%28DRG%20and%20DMZ%20VCN%20will%20be%20created%29","hub_vcn_cidrs":["172.16.0.0/26"],"customize_hub_vcn_subnets":true,"add_hub_vcn_jumphost_subnet":true,"deploy_bastion_jump_host":true,"bastion_jump_host_image_source":"Marketplace%20Image","bastion_jump_host_marketplace_image_name":"Oracle%20Linux%208%20STIG","bastion_jump_host_marketplace_image_version":"Oracle-Linux-8.10-2025.06.24-STIG","bastion_jump_host_ssh_public_key_path":"~/.ssh/id_rsa.pub","bastion_jump_host_instance_shape":"VM.Standard.E4.Flex","bastion_jump_host_boot_volume_size":60,"bastion_jump_host_flex_shape_memory":16,"bastion_jump_host_flex_shape_cpu":2,"deploy_bastion_service":true,"bastion_service_allowed_cidrs":["x.x.x.x"],"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:
 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.
 - Provide a list of IP address allowed to connect through the OCI Bastion Service in "OCI Bastion Service Allowed CIDR Blocks" (*bastion_service_allowed_cidrs* variable). Do not use "0.0.0.0/0".

With the stack created, perform a Plan, followed by an Apply using RMS UI.

### Terraform CLI Deployment

1. Rename file *main.tf.fortinet.template* to *main.tf*. 
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply
