# Core Landing Zone Hub/Spoke Routing-Only Template

Use this template when you want to bootstrap the Core Landing Zone with a DMZ Hub VCN that only performs centralized routing (no network firewall yet) and multiple spoke VCN types. It deploys:

- Hub VCN + DRG with bastion access controls.
- Two three-tier spoke VCNs (one public web tier, one fully private).
- A dedicated OKE VCN and an Exadata VCN.
- On-premises CIDR awareness so routes are precreated, even if FastConnect/IPSec will be added later.

## Key Variables

| Variable | Why it matters | Default in template |
| --- | --- | --- |
| `hub_deployment_option` | Selects the DMZ Hub VCN + DRG pattern. Required for centralized routing. | `"VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"` |
| `hub_vcn_deploy_net_appliance_option` | Keeps the hub appliance-free so you can add Network Firewall or 3rd-party firewalls later. | `"Don't deploy any network appliance at this time"` |
| `onprem_cidrs` | Pre-populates DRG route tables for your corporate CIDRs to prevent later rebuilds. | `["172.16.10.0/24"]` |
| `add_tt_vcn1`, `add_tt_vcn2` | Enable two application spokes; `tt_vcn2_web_subnet_is_private` locks the second VCN down. | `true` / `true` |
| `add_oke_vcn1`, `add_exa_vcn1` | Enable container-platform and database spokes for east-west testing. | `true` / `true` |
| `deploy_bastion_service`, `bastion_service_allowed_cidrs` | Provides controlled operator access to the DMZ jump host. | `true`, `["203.0.113.0/32"]` |
| `network_admin_email_endpoints`, `security_admin_email_endpoints` | Required for CIS notifications. Update with real distribution lists. | `["network.team@example.com"]`, `["security.team@example.com"]` |

For the full list of variables you can further tune, review [`VARIABLES.md`](../../VARIABLES.md).

## Terraform CLI Deployment

1. Copy this folder, rename `main.tf.template` to `main.tf`, and replace the placeholder OCIDs/paths with your tenancy information.
2. Adjust the networking variables above so CIDRs and subnet visibility align with your standards. Leave `hub_vcn_deploy_net_appliance_option` set to `"Don't deploy any network appliance at this time"` unless you explicitly want to add a firewall.
3. (Optional) Create a `terraform.tfvars` file for secrets such as SSH keys.
4. Run Terraform as usual:

```bash
terraform init
terraform plan
terraform apply
```

5. After the apply succeeds, capture the DRG, hub VCN, and subnet OCIDs from the outputs so they can be referenced by future firewall or connectivity stacks.

## OCI Resource Manager Deployment

Launch a pre-populated stack directly from the console:

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"routinghub","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20(DRG%20and%20DMZ%20VCN%20will%20be%20created)","hub_vcn_cidrs":["10.50.0.0/26"],"hub_vcn_deploy_net_appliance_option":"Don't%20deploy%20any%20network%20appliance%20at%20this%20time","enable_cross_vcn_open_nsg":true,"onprem_cidrs":["172.16.10.0/24"],"deploy_bastion_service":true,"bastion_service_allowed_cidrs":["203.0.113.0/32"],"add_tt_vcn1":true,"tt_vcn1_cidrs":["10.0.0.0/20"],"tt_vcn1_attach_to_drg":true,"tt_vcn1_onprem_route_enable":true,"add_tt_vcn2":true,"tt_vcn2_cidrs":["10.1.0.0/20"],"tt_vcn2_web_subnet_is_private":true,"tt_vcn2_attach_to_drg":true,"add_oke_vcn1":true,"oke_vcn1_cni_type":"Native","oke_vcn1_cidrs":["10.10.0.0/16"],"oke_vcn1_attach_to_drg":true,"add_exa_vcn1":true,"exa_vcn1_cidrs":["10.20.0.0/22"],"exa_vcn1_attach_to_drg":true,"network_admin_email_endpoints":["network.team@example.com"],"security_admin_email_endpoints":["security.team@example.com"],"create_budget":true,"budget_amount":"5000","budget_alert_threshold":"90","budget_alert_email_endpoints":["finops@example.com"]})

After the stack opens:

1. Pick the target region and compartment.
2. Replace every placeholder OCID, CIDR, and email with production values.
3. Run **Plan** and then **Apply**.
4. Save the generated outputs (Hub VCN, DRG, bastion) to feed downstream firewall or hybrid-connectivity templates.

## When to Use This Template

- You need multiple spoke VCNs wired on day one, but the security team will implement firewalls later.
- You want to validate DRG route tables and NSGs for Zero Trust Packet Routing (ZPR) before turning it on globally.
- You plan to attach existing on-premises connectivity (FastConnect/IPSec) in a follow-up deployment and need all spokes to already advertise/consume the CIDRs.
