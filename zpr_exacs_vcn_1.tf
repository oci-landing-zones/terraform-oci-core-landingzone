locals {

  exa_vcn_1_zpr_policies = merge(
    var.add_exa_vcn1 ? {
      ZPR-POLICY-EXA-VCN-1 = {
        description = "zpr policy for exa vcn 1"
        name        = "zpr-policy-exa-vcn-1"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.bastion:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/6200'"

        ]
      }
    } : {},
    ((var.add_exa_vcn1) && (local.hub_with_vcn == true) && (var.exa_vcn1_attach_to_drg == true)) ? {
      ZPR-POLICY-EXA-VCN-1-HUB = {
        description = "zpr policy for exa vcn 1 to hub vcn cidrs"
        name        = "zpr-policy-exa-vcn-1-hub"
        statements = [
          for cidr in var.hub_vcn_cidrs :
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${cidr}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/22'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_exa_vcn2 ? {
      ZPR-POLICY-EXA-VCN-1-TO-EXA-VCN-2 = {
        description = "zpr-policy-exa-vcn-1-to-exa-vcn-2"
        name        = "zpr-policy-exa-vcn-1-to-exa-vcn-2"
        statements = [
          // Allow endpoints in Client subnet of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
          // Allow endpoints in other Exa VCNs to connect to db server
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_exa_vcn3 ? {
      ZPR-POLICY-EXA-VCN-1-TO-EXA-VCN-3 = {
        description = "zpr-policy-exa-vcn-1-to-exa-vcn-3"
        name        = "zpr-policy-exa-vcn-1-to-exa-vcn-3"
        statements = [
          // Allow endpoints in Client subnet of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
          // Allow endpoints in other Exa VCNs to connect to db server
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_tt_vcn1 ? {
      ZPR-POLICY-EXA-VCN-1-TO-TT-VCN-1 = {
        description = "zpr policy for exa vcn 1 to tt vcn 1"
        name        = "zpr-policy-exa-vcn-1-to-tt-vcn-1"
        statements = [
          // Allow DB Server to communicate with other endpoints in the TT VCNs
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
          // Allow DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_tt_vcn2 ? {
      ZPR-POLICY-EXA-VCN-1-TO-TT-VCN-2 = {
        description = "zpr policy for exa vcn 1 to tt vcn 2"
        name        = "zpr-policy-exa-vcn-1-to-tt-vcn-2"
        statements = [
          // Allow DB Server to communicate with other endpoints in the TT VCNs
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
          // Allow DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_tt_vcn3 ? {
      ZPR-POLICY-EXA-VCN-1-TO-TT-VCN-3 = {
        description = "zpr policy for exa vcn 1 to tt vcn 3"
        name        = "zpr-policy-exa-vcn-1-to-tt-vcn-3"
        statements = [
          // Allow DB Server to communicate with other endpoints in the TT VCNs
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'",
          // Allow DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))}' endpoints to connect to ${var.zpr_security_attributes_namespace}.database:${local.zpr_label} with protocol='tcp/1521-1522'"
        ]
      }
    } : {}
  )
}

