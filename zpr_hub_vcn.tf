locals {

  hub_zpr_grants = local.hub_with_vcn ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow '${coalesce(var.hub_vcn_mgmt_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 3))}' to connect to ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} to connect to 'osn-services-ip-addresses' with protocol='tcp/443'"
  ] : []

  hub_on_prem_zpr_grants = local.hub_with_vcn ? [
    for cidr in var.bastion_jump_host_allow_list : ##UPDATE IN FUTURE?
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow '${cidr}' to connect to ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints with protocol='tcp/22'"
  ] : []

  hub_to_tt_1_zpr_grants = local.hub_with_vcn && local.add_tt_vcn1 && var.deploy_tt_vcn1_bastion_subnet ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn1_bastion_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 9, 96))}' with protocol='tcp/22'"
  ] : []

  hub_to_tt_2_zpr_grants = local.hub_with_vcn && local.add_tt_vcn2 && var.deploy_tt_vcn2_bastion_subnet ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_bastion_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 9, 96))}' with protocol='tcp/22'"
  ] : []

  hub_to_tt_3_zpr_grants = local.hub_with_vcn && local.add_tt_vcn3 && var.deploy_tt_vcn3_bastion_subnet ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_bastion_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 9, 96))}' with protocol='tcp/22'",
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_bastion_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 9, 96))}' with protocol='tcp/22'"

  ] : []

  hub_to_exa_1_zpr_grants = local.hub_with_vcn && local.add_exa_vcn1 ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' with protocol='tcp/22'"
  ] : []

  hub_to_exa_2_zpr_grants = local.hub_with_vcn && local.add_exa_vcn2 ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))}' with protocol='tcp/22'"
  ] : []

  hub_to_exa_3_zpr_grants = local.hub_with_vcn && local.add_exa_vcn3 ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' with protocol='tcp/22'"
  ] : []

  hub_zpr_policy = local.hub_with_vcn ? {
    ZPR-POLICY-HUB-VCN = {
      description = "Core Landing Zone ZPR policy for ${var.hub_vcn_name != null ? "${var.service_label}-${var.hub_vcn_name}-zpr-policy" : "${var.service_label}-hub-vcn-zpr-policy"}."
      name        = var.hub_vcn_name != null ? "${var.service_label}-${var.hub_vcn_name}-zpr-policy" : "${var.service_label}-hub-vcn-zpr-policy"
      statements  = concat(local.hub_zpr_grants, local.hub_to_tt_1_zpr_grants, local.hub_to_tt_2_zpr_grants, local.hub_to_tt_3_zpr_grants, local.hub_to_exa_1_zpr_grants, local.hub_to_exa_2_zpr_grants, local.hub_to_exa_3_zpr_grants)
    }
  } : {}

}

