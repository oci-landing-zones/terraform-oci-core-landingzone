locals {

  exa_2_zpr_grants = local.add_exa_vcn2 ? [
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/6200'",
  ] : []

  exa_2_hub_zpr_grants = ((local.add_exa_vcn2) && (local.hub_with_vcn == true) && (var.exa_vcn2_attach_to_drg == true) && (var.deploy_bastion_jump_host)) ? [
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow '${coalesce(var.hub_vcn_jumphost_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 4))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/22'"
  ] : []

  exa_2_to_exa_1_zpr_grants = (local.add_exa_vcn2 && local.add_exa_vcn1 && var.exa_vcn2_attach_to_drg && var.exa_vcn1_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1"))) ? [
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_to_exa_3_zpr_grants = (local.add_exa_vcn2 && local.add_exa_vcn3 && var.exa_vcn2_attach_to_drg && var.exa_vcn3_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3"))) ? [
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_to_tt_1_zpr_grants = (local.add_exa_vcn2 && local.add_tt_vcn1 && var.exa_vcn2_attach_to_drg && var.tt_vcn1_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1"))) ? [
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_to_tt_2_zpr_grants = (local.add_exa_vcn2 && local.add_tt_vcn2 && var.exa_vcn2_attach_to_drg && var.tt_vcn2_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2"))) ? [
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_to_tt_3_zpr_grants = (local.add_exa_vcn2 && local.add_tt_vcn3 && var.exa_vcn2_attach_to_drg && var.tt_vcn3_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3"))) ? [
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:exa-vcn-2 VCN allow '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_zpr_policy = local.add_exa_vcn2 ? {
    ZPR-POLICY-EXA-2 = {
      description = "Core Landing Zone ZPR policy for ${var.service_label}-${coalesce(var.exa_vcn2_name, "exa-vcn-2")}-zpr-policy."
      name        = "${var.service_label}-${coalesce(var.exa_vcn2_name, "exa-vcn-2")}-zpr-policy"
      statements  = concat(local.exa_2_zpr_grants, local.exa_2_hub_zpr_grants, local.exa_2_to_exa_1_zpr_grants, local.exa_2_to_exa_3_zpr_grants, local.exa_2_to_tt_1_zpr_grants, local.exa_2_to_tt_2_zpr_grants, local.exa_2_to_tt_3_zpr_grants)
    }
  } : {}
}

