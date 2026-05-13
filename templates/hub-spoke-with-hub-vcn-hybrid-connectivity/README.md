# Core Landing Zone Hub/Spoke With Hybrid Connectivity Template

This template shows how to deploy a Core Landing Zone where the Hub VCN terminates both FastConnect and IPSec VPN connections while enforcing OCI Native Network Firewall for all north/south flows. It stands up:

- DMZ Hub VCN + DRG with Network Firewall logging enabled.
- Simultaneous FastConnect virtual circuit and IPSec Site-to-Site VPN.
- Three spokes (three-tier, OKE, Exadata) with on-prem routes and NSG rules preconfigured.
- Bastion service and jump host for controlled management access.

## Key Variables

| Variable | Why it matters | Default in template |
| --- | --- | --- |
| `hub_vcn_deploy_net_appliance_option` | Chooses OCI Native Firewall so every ingress/egress flow is inspected. | `"OCI Native Firewall"` |
| `enable_native_firewall_threat_log`, `enable_native_firewall_traffic_log` | Switch on logging streams for SecOps monitoring. | `true` / `true` |
| `on_premises_connection_option` | Enables the dual FastConnect + IPSec pattern supported by Landing Zone. | `"Create New FastConnect Virtual Circuit and IPSec VPN"` |
| `fastconnect_virtual_circuit_*` | Defines the private virtual circuit (bandwidth, peering IPs, VLAN, provider). | Example bandwidth `2 Gbps`, VLAN `200`. |
| `cpe_ip_address`, `ipsec_*` | Configure IPSec tunnels and BGP peering to match your CPE. | Uses RFC 5737 placeholders. |
| `allowed_onprem_cidrs_to_fw_mgmt_interface`, `fw_mgmt_interface_ports` | Restricts who can reach the firewall management UI. | `["198.51.100.10/32"]`, `["TCP:22","TCP:443"]` |
| `oci_firewall_ip_ocid`, `oci_nfw_policy_ocid` | Needed during the second apply to associate the firewall IP and your curated policy. | Commented out initially. |

## Terraform CLI Deployment (Two Passes)

1. Rename `main.tf.template` to `main.tf` and replace all placeholder OCIDs, IPs, and CIDRs with production values.
2. Run `terraform init`, `terraform plan`, and `terraform apply`. This provisions networking, FastConnect, IPSec, and creates the Network Firewall with a default deny policy.
3. Note the `oci_firewall_ip_ocid` output. Create or update your firewall policy in the OCI Console and copy its OCID.
4. Update `main.tf` (or `terraform.tfvars`) with `oci_firewall_ip_ocid` and `oci_nfw_policy_ocid`, then run `terraform apply` again. The second pass wires routes through the firewall and persists your policy association.

## OCI Resource Manager Deployment

Launch the stack with pre-populated defaults:

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"service_label":"hybrid","define_net":true,"hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20(DRG%20and%20DMZ%20VCN%20will%20be%20created)","hub_vcn_cidrs":["10.60.0.0/26"],"hub_vcn_deploy_net_appliance_option":"OCI%20Native%20Firewall","enable_native_firewall_threat_log":true,"enable_native_firewall_traffic_log":true,"onprem_cidrs":["192.168.10.0/23","172.20.0.0/22"],"allowed_onprem_cidrs_to_fw_mgmt_interface":["198.51.100.10/32"],"fw_mgmt_interface_ports":["TCP:22","TCP:443"],"deploy_bastion_service":true,"deploy_bastion_jump_host":true,"bastion_service_allowed_cidrs":["198.51.100.0/24"],"on_premises_connection_option":"Create%20New%20FastConnect%20Virtual%20Circuit%20and%20IPSec%20VPN","fastconnect_virtual_circuit_bandwidth_shape":"2%20Gbps","fastconnect_virtual_circuit_type":"PRIVATE","fastconnect_virtual_circuit_customer_asn":"65010","fastconnect_virtual_circuit_customer_bgp_peering_ip":"10.250.0.2/30","fastconnect_virtual_circuit_oracle_bgp_peering_ip":"10.250.0.1/30","fastconnect_virtual_circuit_vlan":"200","fastconnect_virtual_circuit_provider_service_id":"ocid1.providerservice.oc1..example","cpe_ip_address":"203.0.113.10","cpe_device_shape_vendor":"Cisco%20CSR1000V","ipsec_vpn_name":"Hybrid-VPN","ipsec_customer_bgp_asn":"65010","ipsec_tunnel1_customer_interface_ip":"10.251.0.2/30","ipsec_tunnel1_oracle_interface_ip":"10.251.0.1/30","ipsec_tunnel1_ike_version":"V2","ipsec_tunnel2_customer_interface_ip":"10.251.0.6/30","ipsec_tunnel2_oracle_interface_ip":"10.251.0.5/30","ipsec_tunnel2_ike_version":"V2","add_tt_vcn1":true,"tt_vcn1_cidrs":["10.0.0.0/20"],"tt_vcn1_attach_to_drg":true,"tt_vcn1_onprem_route_enable":true,"add_oke_vcn1":true,"oke_vcn1_cni_type":"Native","oke_vcn1_cidrs":["10.3.0.0/16"],"oke_vcn1_attach_to_drg":true,"oke_vcn1_onprem_route_enable":true,"add_exa_vcn1":true,"exa_vcn1_cidrs":["10.30.0.0/22"],"exa_vcn1_attach_to_drg":true,"exa_vcn1_onprem_route_enable":true,"network_admin_email_endpoints":["network.team@example.com"],"security_admin_email_endpoints":["security.team@example.com"],"create_budget":true,"budget_amount":"7000","budget_alert_threshold":"85","budget_alert_email_endpoints":["finops@example.com"]})

Stack workflow:

1. Choose the target region/compartment, then override all placeholder values with real OCIDs, provider IDs, ASN, VLAN, and CIDRs.
2. Run **Plan** and **Apply**. After the first apply, capture the `OCI Firewall Forwarding IP` output and create/associate your firewall policy.
3. Edit the stack variables to set `oci_firewall_ip_ocid` and `oci_nfw_policy_ocid`, then run **Apply** again to finalize routing.

## When to Use This Template

- You must stand up FastConnect and IPSec at the same time for high availability or vendor diversity.
- You want a prescriptive example of routing all hub ingress/egress flows through OCI Native Firewall with audit-ready logs.
- You need all spokes (app, container, database) to learn on-prem routes automatically via the DRG so workloads are hybrid-ready from day one.
