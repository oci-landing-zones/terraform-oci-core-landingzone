locals {

  tt_1_policies = var.add_tt_vcn1 ? [
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.app:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.bastion:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to 'osn-services-ip-addresses' with protocol='tcp/443'"
  ] : []
  tt_1_to_tt_2_policies = var.add_tt_vcn1 && var.add_tt_vcn2 ? [
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'"
  ] : []
  tt_1_to_tt_3_policies = var.add_tt_vcn1 && var.add_tt_vcn3 ? [
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'"
  ] : []
  tt_1_to_exa_1_policies = var.add_tt_vcn1 && var.add_exa_vcn1 ? [
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []
  tt_1_to_exa_2_policies = var.add_tt_vcn1 && var.add_exa_vcn2 ? [
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []
  tt_1_to_exa_3_policies = var.add_tt_vcn1 && var.add_exa_vcn3 ? [
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
    "in ${var.zpr_security_attributes_namespace}.net:tt-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
  ] : []

  tt_1_zpr_policies = var.add_tt_vcn1 ? {
    ZPR-POLICY-TT-1 = {
      description = "ZPR policies for TT VCN 1"
      name        = "zpr-policy-tt-vcn-1-${local.zpr_label}"
      statements = concat(
        local.tt_1_policies,
        local.tt_1_to_tt_2_policies,
        local.tt_1_to_tt_3_policies,
        local.tt_1_to_exa_1_policies,
        local.tt_1_to_exa_2_policies,
        local.tt_1_to_exa_3_policies
      )
    }
  } : {}
}
