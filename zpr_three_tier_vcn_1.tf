locals {

  tt_1_jump_host_ingress_zpr_grants = var.tt_vcn1_bastion_is_access_via_public_endpoint ? [
    for cidr in var.tt_vcn1_bastion_subnet_allowed_cidrs : "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${cidr} to connect to ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints with protocol='tcp/22'",
  ] : []

  tt_1_zpr_grants = local.add_tt_vcn1 ? concat([
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${local.zpr_namespace_name}.app:${local.zpr_label} endpoints to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to 'osn-services-ip-addresses' with protocol='tcp/443'"
  ], local.tt_1_jump_host_ingress_zpr_grants) : []

  tt_1_to_tt_2_zpr_grants = (local.add_tt_vcn1 && local.add_tt_vcn2 && var.tt_vcn1_attach_to_drg && var.tt_vcn2_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-2"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'"
  ] : []

  tt_1_to_tt_3_zpr_grants = (local.add_tt_vcn1 && local.add_tt_vcn3 && var.tt_vcn1_attach_to_drg && var.tt_vcn3_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'"
  ] : []

  tt_1_to_exa_1_zpr_grants = (local.add_tt_vcn1 && local.add_exa_vcn1 && var.tt_vcn1_attach_to_drg && var.exa_vcn1_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"EXA-VCN-1"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  tt_1_to_exa_2_zpr_grants = (local.add_tt_vcn1 && local.add_exa_vcn2 && var.tt_vcn1_attach_to_drg && var.exa_vcn2_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"EXA-VCN-2"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  tt_1_to_exa_3_zpr_grants = (local.add_tt_vcn1 && local.add_exa_vcn3 && var.tt_vcn1_attach_to_drg && var.exa_vcn3_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"EXA-VCN-3"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  tt_1_zpr_policy = local.add_tt_vcn1 ? {
    ZPR-POLICY-TT-1 = {
      description = "Core Landing Zone ZPR policy for ${coalesce(var.tt_vcn1_name, "${var.service_label}-tt-vcn-1")}."
      name        = "${coalesce(var.tt_vcn1_name, "${var.service_label}-tt-vcn-1")}-zpr-policy"
      statements = concat(local.tt_1_zpr_grants, local.tt_1_to_tt_2_zpr_grants, local.tt_1_to_tt_3_zpr_grants, local.tt_1_to_exa_1_zpr_grants, local.tt_1_to_exa_2_zpr_grants, local.tt_1_to_exa_3_zpr_grants)
    }
  } : {}
}
