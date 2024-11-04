locals {
  exa_generic_zpr_policy = var.add_exa_vcn1 || var.add_exa_vcn2 || var.add_exa_vcn3 ? [
  // Allow endpoints in Client subnet of Exadata VCN to communicate with other endpoints in the Client subnet using SSH, SQLNet, and Fast Application Notifications (FAN).
  "in ${var.zpr_security_attributes_namespace}.net:exa-vcn VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22,1521-1522,6200'",
  // Allow HTTPS connections to Oracle Services Network (OSN) from all endpoints in the Exadata VCN.
  "in ${var.zpr_security_attributes_namespace}.net:exa-vcn VCN allow all-endpoints to connect to ’osn-services-ip-addresses’ with protocol='tcp/443'"] : []

  exa_hub_zpr_policy = ((var.add_exa_vcn1 || var.add_exa_vcn2 || var.add_exa_vcn3) && (local.hub_with_vcn == true) && (var.exa_vcn1_attach_to_drg == true)) ? [ for cidr in var.hub_vcn_cidrs :
  // Allows SSH connections from hosts in ${cidr} from hub_vcn_cidrs. May need a for loop for each cidr
  "in ${var.zpr_security_attributes_namespace}.net:exa-vcn VCN allow '${cidr}' to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22'"
  ] : []

  exa_vcn_1_to_exa_vcn_2_zpr_policy = var.add_exa_vcn1 && var.add_exa_vcn2 ? [
    // Allow endpoints in Client subnet of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.exa_vcn2_client_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow endpoints in DB server of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.exa_vcn2_client_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow endpoints in other Exa VCNs to connect to db server
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.exa_vcn2_client_subnet_cidr} to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
  ] : []

  exa_vcn_1_to_exa_vcn_3_zpr_policy = var.add_exa_vcn1 && var.add_exa_vcn3 ? [
    // Allow endpoints in Client subnet of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.exa_vcn3_client_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow endpoints in DB server of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.exa_vcn3_client_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow endpoints in other Exa VCNs to connect to db server
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.exa_vcn3_client_subnet_cidr} to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
  ] : []

  exa_vcn_1_to_tt_vcn_1_zpr_policy = var.add_exa_vcn1 && var.add_tt_vcn1 ? [
    // Allow endpoints in Client subnet of Exadata VCN to communicate with other endpoints in the TT VCNs
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_web_subnet_cidr} with protocol='tcp/443'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_app_subnet_cidr} with protocol='tcp/80'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow DB Server to communicate with other endpoints in the TT VCNs
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_web_subnet_cidr} with protocol='tcp/443'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_app_subnet_cidr} with protocol='tcp/80'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow App and DB Subnet endpoints in Three Tier VCNs connect to Client Subnet in Exadata / Ingress
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn1_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn1_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
    // Allow App and DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn1_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn1_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
  ] : []

  exa_vcn_1_to_tt_vcn_2_zpr_policy = var.add_exa_vcn1 && var.add_tt_vcn2 ? [
    // Allow endpoints in Client subnet of Exadata VCN to communicate with other endpoints in the TT VCNs
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_web_subnet_cidr} with protocol='tcp/443'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_app_subnet_cidr} with protocol='tcp/80'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow DB Server to communicate with other endpoints in the TT VCNs
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_web_subnet_cidr} with protocol='tcp/443'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_app_subnet_cidr} with protocol='tcp/80'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow App and DB Subnet endpoints in Three Tier VCNs connect to Client Subnet in Exadata / Ingress
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn2_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn2_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
    // Allow App and DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn2_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn2_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
  ] : []

  exa_vcn_1_to_tt_vcn_3_zpr_policy = var.add_exa_vcn1 && var.add_tt_vcn3 ? [
    // Allow endpoints in Client subnet of Exadata VCN to communicate with other endpoints in the TT VCNs
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_web_subnet_cidr} with protocol='tcp/443'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_app_subnet_cidr} with protocol='tcp/80'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_db_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow DB Server to communicate with other endpoints in the TT VCNs
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_web_subnet_cidr} with protocol='tcp/443'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_app_subnet_cidr} with protocol='tcp/80'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_db_subnet_cidr} with protocol='tcp/1521-1522'",
    // Allow App and DB Subnet endpoints in Three Tier VCNs connect to Client Subnet in Exadata / Ingress
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn3_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn3_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
    // Allow App and DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn3_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1 VCN allow ${var.tt_vcn3_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
  ] : []

  exa_zpr_policies = {
    ZPR-POLICY-EXA = {
      description = "ZPR policy for Exadata VCNs"
      name = "zpr-policy-exa"
      statements = merge(local.exa_generic_zpr_policy, local.exa_hub_zpr_policy, local.exa_vcn_1_to_exa_vcn_2_zpr_policy, local.exa_vcn_1_to_exa_vcn_2_zpr_policy,
        local.exa_vcn_1_to_tt_vcn_1_zpr_policy, local.exa_vcn_1_to_tt_vcn_2_zpr_policy, local.exa_vcn_1_to_tt_vcn_3_zpr_policy)
    }
  }
}

