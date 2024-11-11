locals {

  exa_1_zpr_grants = local.add_exa_vcn1 ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.bastion:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/6200'"
  ] : []

  exa_1_hub_zpr_grants = ((local.add_exa_vcn1) && (local.hub_with_vcn == true) && (var.exa_vcn1_attach_to_drg == true)) ? [
    for cidr in var.hub_vcn_cidrs :
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${cidr}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'"
  ] : []

  exa_1_to_exa_2_zpr_grants = (local.add_exa_vcn1 && local.add_exa_vcn2 && var.exa_vcn1_attach_to_drg && var.exa_vcn2_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns,"EXA-VCN-2"))) ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_1_to_exa_3_zpr_grants = (local.add_exa_vcn1 && local.add_exa_vcn3 && var.exa_vcn1_attach_to_drg && var.exa_vcn3_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns,"EXA-VCN-3"))) ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_1_to_tt_1_zpr_grants = (local.add_exa_vcn1 && local.add_tt_vcn1 && var.exa_vcn1_attach_to_drg && var.tt_vcn1_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns,"TT-VCN-1"))) ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_1_to_tt_2_zpr_grants = (local.add_exa_vcn1 && local.add_tt_vcn2 && var.exa_vcn1_attach_to_drg && var.tt_vcn2_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns,"TT-VCN-2"))) ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_1_to_tt_3_zpr_grants = (local.add_exa_vcn1 && local.add_tt_vcn3 && var.exa_vcn1_attach_to_drg && var.tt_vcn3_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns,"TT-VCN-3"))) ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_1_zpr_policy = local.add_exa_vcn1 ? {
    ZPR-POLICY-EXA-1 = {
      description = "Core Landing Zone ZPR policy for ${coalesce(var.exa_vcn1_name, "${var.service_label}-exadata-vcn-1")}."
      name        = "${coalesce(var.exa_vcn1_name, "${var.service_label}-exa-vcn-1")}-zpr-policy"
      statements = concat(local.exa_1_zpr_grants, local.exa_1_to_exa_2_zpr_grants, local.exa_1_to_exa_3_zpr_grants, local.exa_1_to_tt_1_zpr_grants, local.exa_1_to_tt_2_zpr_grants, local.exa_1_to_tt_3_zpr_grants)
    }
  } : {}
}

