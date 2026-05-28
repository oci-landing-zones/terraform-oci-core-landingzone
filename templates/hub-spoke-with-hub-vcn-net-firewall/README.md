# Core Landing Zone with OCI Network Firewall

This template shows how to deploy a CIS compliant landing zone using [OCI Core Landing Zone](../../) configured with a Hub & Spoke networking topology including OCI Network Firewall. It deploys Network Firewall in the Hub VCN, a Three Tier VCN, an Exadata VCN and an OKE VCN which are peered through the DRG. The DRG is configured to route traffic across all VCNs.

Deploying a native OCI Network Firewall requires the Terraform configuration executed twice. In the first run Terraform creates all the networking resources, except the required routing to the Network Firewall. In the second run it updates the configuration with that routing, and optionally, with a user provided firewall policy (the first run creates an empty policy with no rules, in which case all traffic is denied).

- For updating the routing, use variable *oci\_firewall\_ip\_ocid*. Assign it the value of output variable *oci\_firewall\_ip\_ocid*.
- For updating the policy, use variable *oci\_nfw\_policy\_ocid*: 
    1. Using the OCI Console, create a policy according to your specific requirements.
    2. Using the OCI Console,associate the new policy to the OCI Network Firewall.
    3. Update *oci\_nfw\_policy\_ocid* variable with the new policy OCID.

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value |
|---------------|-------------|-------|
| *service_label* | A unique identifier to prefix the resources | "ocinetfw" |
| *define_net* | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks. | true |
| *hub_deployment_option* | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology. | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)" |
| *hub_vcn_cidrs* | Hub VCN list of CIDR Blocks | ["192.168.0.0/26"] |
| *hub_vcn_deploy_net_appliance_option* | Choose one of the available network appliance options for deploying in the Hub VCN. | OCI Native Firewall |
| *enable_native_firewall_threat_log* | Enable OCI Native Firewall Threat Log. | true |
| *enable_native_firewall_traffic_log* | Enable OCI Native Firewall Traffic Log. | true |
| *add_tt_vcn1* | When true, deploys three-tier VCN 1, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available | true |
| *tt_vcn1_cidrs* | Three-tier VCN 1 CIDR blocks. | ["10.0.0.0/20"] |
| *tt_vcn1_attach_to_drg* | When true, attaches three-tier VCN 1 to the DRG | true |
| *add_exa_vcn1* | VCN configured for Exadata Cloud Service deployment. | true |
| *exa_vcn1_cidrs* | Exa VCN 1 CIDR blocks. | ["172.16.0.0/20"] |
| *exa_vcn1_attach_to_drg* | When true, the VCN is attached to a DRG, enabling cross-vcn traffic routing | true |
| *add_oke_vcn1* | Add OKE VCN | true |
| *oke_vcn1_cni_type* | OKE CNI Type | "Native" |
| *oke_vcn1_cidrs* | OKE VCN 1 CIDR Block. | ["10.3.0.0/16"] |
| *oke_vcn1_attach_to_drg* | Attach this VCN to DRG (Dynamic Routing Gateway) | true |
| *network_admin_email_endpoints* | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] |
| *security_admin_email_endpoints* | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] |
| **Used during second terraform run**: | | |
| *oci_nfw_ip_ocid* | OCI Native Firewall Forwarding IP OCID. | ["ocid1.privateip.oc1.phx.abuwclj...goq"] |
| *oci_nfw_policy_ocid* | User created OCI Network Firewall policy OCID | ["ocid1.networkfirewallpolicy.oc1.phx.amaaaa...gmm"] |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/release-1.6.0.zip&zipUrlVariables={"service_label":"ocinetfw","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20%28DRG%20and%20DMZ%20VCN%20will%20be%20created%29","hub_vcn_cidrs":["192.168.0.0/26"],"hub_vcn_deploy_net_appliance_option":"OCI%20Native%20Firewall","enable_native_firewall_threat_log":true,"enable_native_firewall_traffic_log":true,"add_tt_vcn1":true,"tt_vcn1_cidrs":["10.0.0.0/20"],"tt_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_cidrs":["172.16.0.0/20"],"exa_vcn1_attach_to_drg":true,"add_oke_vcn1":true,"oke_vcn1_cni_type":"Native","oke_vcn1_cidrs":["10.3.0.0/16"],"oke_vcn1_attach_to_drg":true,"network_admin_email_endpoints":["email.address@example.com"],"security_admin_email_endpoints":["email.address@example.com"]})

You are required to review/adjust the following variable settings:

 - Make sure to pick an OCI region for deployment.
 - Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

Once the Apply finishes, RMS displays the stack output under the **Application information** tab. Under Networking, there is an output named **Oci Firewall Ip Ocid**, whose value looks like:


**Oci Firewall Ip Ocid** : ocid1.privateip.oc1.phx.abyhql...goq


Edit the RMS stack to update the "OCI Network Firewall Forwarding IP OCID" with above value.

- Enter the OCID of OCI Network Firewall IP address (*ocid1.privateip.oc1.phx.abyhql...goq*) in the **OCI Network Firewall Forwarding IP OCID** field.
- Enter the OCID of your own OCI Network Firewall policy" in the **Enter the OCI Network Firewall Policy OCID** field to replace the initially provisioned sample policy.

![nfw_deploy_update](../../images/nfw_deploy_update.png)

**Note**: Make sure to associate the Network Firewall with your policy. Use OCI Console for this.

Perform a new Plan, followed by an Apply.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply
4. Take note of the value in the output **oci\_firewall\_ip\_ocid**.
5. Uncomment and update the variable **oci\_nfw\_ip\_ocid** as instructed in *main.tf.template*.
6. Assign the OCID of your network policy to **oci\_nfw\_policy\_ocid** variable.
7. **Note**: Make sure to associate the Network Firewall with your policy. Use OCI Console for this.
8. In this folder, execute Terraform plan and apply again:
    - $ terraform plan
    - $ terraform apply

