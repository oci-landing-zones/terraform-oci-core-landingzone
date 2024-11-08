locals {

  exa_2_policies = var.add_exa_vcn2 ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.bastion:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/6200'",
  ] : []

  exa_2_hub_policies = ((var.add_exa_vcn2) && (local.hub_with_vcn == true) && (var.exa_vcn2_attach_to_drg == true)) ? [
    for cidr in var.hub_vcn_cidrs :
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${cidr}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'"
  ] : []

  exa_2_to_exa_1_policies = var.add_exa_vcn2 && var.add_exa_vcn1 ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_to_exa_3_policies = var.add_exa_vcn2 && var.add_exa_vcn3 ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_to_tt_1_policies = var.add_exa_vcn2 && var.add_tt_vcn1 ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_to_tt_2_policies = var.add_exa_vcn2 && var.add_tt_vcn2 ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_to_tt_3_policies = var.add_exa_vcn2 && var.add_tt_vcn3 ? [
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  exa_2_zpr_policies = var.add_exa_vcn2 ? {
    ZPR-POLICY-EXA-2 = {
      description = "ZPR policies for Exadata VCN 2"
      name        = "zpr-policy-exa-vcn-2-${local.zpr_label}"
      statements  = concat(local.exa_2_policies, local.exa_2_to_exa_1_policies, local.exa_2_to_exa_3_policies,
        local.exa_2_to_tt_1_policies, local.exa_2_to_tt_2_policies, local.exa_2_to_tt_3_policies)
    }
  } : {}
}

