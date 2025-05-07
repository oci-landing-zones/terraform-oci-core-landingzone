# Core Landing Zone with Hub & Spoke Topology, Including Jump Host with Bastion Service Template

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configured with TODO

Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set:

| Variable Name                     | Description | Value                                                                                                                      |
|-----------------------------------|-------------|----------------------------------------------------------------------------------------------------------------------------|
TODO

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"addnett","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20%28DRG%20and%20DMZ%20VCN%20will%20be%20created%29","onprem_cidrs":["100.0.0.0/24"],"hub_vcn_deploy_net_appliance_option":"Don%2527t%2Bdeploy%2Bany%2Bnetwork%2Bappliance%2Bat%2Bthis%2Btime", "workloadvcn_ocids_public_access":["ocid1.vcn.oc1...aaaaa...yba","ocid1.vcn.oc1...aaaaaa...q7a"],"workloadvcn_ocids_onprem_access":["ocid1.vcn.oc1.iad...aaaaa...q7a","ocid1.vcn.oc1.iad...aaaaaa...tga"],"on_premises_connection_option":"Create%20New%20IPSec%20VPN","cpe_ip_address":"129.146.105.156","cpe_device_shape_vendor":"Libreswan","ipsec_customer_bgp_asn":"65000","ipsec_tunnel1_customer_interface_ip":"10.10.10.1%2F30","ipsec_tunnel1_oracle_interface_ip":"10.10.10.2%2F30","ipsec_tunnel2_customer_interface_ip":"10.10.10.5%2F30","ipsec_tunnel2_oracle_interface_ip":"10.10.10.6%2F30","add_tt_vcn1":true,"tt_vcn1_attach_to_drg":true,"tt_vcn1_onprem_route_enable":true,"tt_vcn1_name":"TT-VCN-1","network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})


https://orahub.oci.oraclecorp.com/nace-shared-services/oci-core-landing-zone/-/archive/additional-networks-feature/oci-core-landing-zone-additional-networks-feature.zip

You are required to review/adjust the following variable settings:
TODO

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply

