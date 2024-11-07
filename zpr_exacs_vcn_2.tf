locals {

  exa_vcn_2_zpr_policies = merge(
    var.add_exa_vcn2 ? {
      ZPR-POLICY-EXA-VCN-2 = {
        description = "zpr policy for exa vcn 2"
        name        = "zpr-policy-exa-vcn-2-${local.zpr_label}"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.bastion:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/6200'",
        ]
      }
    } : {},
    ((var.add_exa_vcn2) && (local.hub_with_vcn == true) && (var.exa_vcn2_attach_to_drg == true)) ? {
      ZPR-POLICY-EXA-VCN-2-HUB = {
        description = "zpr policy for exa vcn 2 to hub vcn cidrs"
        name        = "zpr-policy-exa-vcn-2-hub-${local.zpr_label}"
        statements = [
          for cidr in var.hub_vcn_cidrs :
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${cidr}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'"
        ]
      }
    } : {},
    var.add_exa_vcn2 && var.add_exa_vcn1 ? {
      ZPR-POLICY-EXA-VCN-2-TO-EXA-VCN-1 = {
        description = "zpr-policy-exa-vcn-2-to-exa-vcn-1"
        name        = "zpr-policy-exa-vcn-2-to-exa-vcn-1-${local.zpr_label}"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn2 && var.add_exa_vcn3 ? {
      ZPR-POLICY-EXA-VCN-1-TO-EXA-VCN-3 = {
        description = "zpr-policy-exa-vcn-2-to-exa-vcn-3"
        name        = "zpr-policy-exa-vcn-2-to-exa-vcn-3-${local.zpr_label}"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn2 && var.add_tt_vcn1 ? {
      ZPR-POLICY-EXA-VCN-2-TO-TT-VCN-1 = {
        description = "zpr policy for exa vcn 2 to tt vcn 1"
        name        = "zpr-policy-exa-vcn-2-to-tt-vcn-1-${local.zpr_label}"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn2 && var.add_tt_vcn2 ? {
      ZPR-POLICY-EXA-VCN-2-TO-TT-VCN-2 = {
        description = "zpr policy for exa vcn 2 to tt vcn 2"
        name        = "zpr-policy-exa-vcn-2-to-tt-vcn-2-${local.zpr_label}"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn2 && var.add_tt_vcn3 ? {
      ZPR-POLICY-EXA-VCN-2-TO-TT-VCN-3 = {
        description = "zpr policy for exa vcn 2 to tt vcn 3"
        name        = "zpr-policy-exa-vcn-2-to-tt-vcn-3-${local.zpr_label}"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {}
  )
}

