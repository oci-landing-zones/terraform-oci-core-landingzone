locals {

  hub_on_prem_zpr_grants = local.hub_with_vcn && var.deploy_bastion_jump_host && length(var.bastion_onprem_ssh_allowed_cidrs) > 0 ? [
    for cidr in var.bastion_onprem_ssh_allowed_cidrs :
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow '${cidr}' to connect to ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints with protocol='tcp/22'"
  ] : []

  hub_bastion_zpr_grants = local.hub_with_vcn && var.deploy_bastion_jump_host && var.deploy_bastion_service == true ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow '${coalesce(var.hub_vcn_jumphost_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 4))}' to connect to ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to 'osn-services-ip-addresses' with protocol='tcp/443'"
  ] : []

  hub_to_tt_1_zpr_grants = local.hub_with_vcn && local.add_tt_vcn1 && var.deploy_bastion_jump_host ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/22'"
  ] : []

  hub_to_tt_2_zpr_grants = local.hub_with_vcn && local.add_tt_vcn2 && var.deploy_bastion_jump_host ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/22'"
  ] : []

  hub_to_tt_3_zpr_grants = local.hub_with_vcn && local.add_tt_vcn3 && var.deploy_bastion_jump_host ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/22'"
  ] : []

  hub_to_exa_1_zpr_grants = local.hub_with_vcn && local.add_exa_vcn1 && var.deploy_bastion_jump_host ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' with protocol='tcp/22'"
  ] : []

  hub_to_exa_2_zpr_grants = local.hub_with_vcn && local.add_exa_vcn2 && var.deploy_bastion_jump_host ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))}' with protocol='tcp/22'"
  ] : []

  hub_to_exa_3_zpr_grants = local.hub_with_vcn && local.add_exa_vcn3 && var.deploy_bastion_jump_host ? [
    "in ${local.zpr_namespace_name}.net:hub-vcn VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' with protocol='tcp/22'"
  ] : []

  hub_zpr_policy = local.hub_with_vcn && var.deploy_bastion_jump_host ? {
    ZPR-POLICY-HUB-VCN = {
      description = "Core Landing Zone ZPR policy for ${var.hub_vcn_name != null ? "${var.service_label}-${var.hub_vcn_name}-zpr-policy" : "${var.service_label}-hub-vcn-zpr-policy"}."
      name        = var.hub_vcn_name != null ? "${var.service_label}-${var.hub_vcn_name}-zpr-policy" : "${var.service_label}-hub-vcn-zpr-policy"
      statements  = concat(local.hub_bastion_zpr_grants, local.hub_on_prem_zpr_grants, local.hub_to_tt_1_zpr_grants, local.hub_to_tt_2_zpr_grants, local.hub_to_tt_3_zpr_grants, local.hub_to_exa_1_zpr_grants, local.hub_to_exa_2_zpr_grants, local.hub_to_exa_3_zpr_grants)
    }
  } : {}

}

