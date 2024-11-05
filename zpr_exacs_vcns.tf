locals {

  exa_zpr_policies = merge(
    var.add_exa_vcn1 ? {
      ZPR-POLICY-EXA-VCN-1 = {
        description = "zpr policy for exa vcn 1"
        name = "zpr-policy-exa-vcn-1"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22,1521-1522,6200'"
        ]
      }
    } : {},
    ((var.add_exa_vcn1) && (local.hub_with_vcn == true) && (var.exa_vcn1_attach_to_drg == true)) ? {
      ZPR-POLICY-EXA-VCN-1-HUB = {
        description = "zpr policy for exa vcn 1 to hub vcn cidrs"
        name        = "zpr-policy-exa-vcn-1-hub"
        statements  = [
          for cidr in var.hub_vcn_cidrs :
          // Allows SSH connections from hosts in ${cidr} from hub_vcn_cidrs. May need a for loop for each cidr
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow '${cidr}' to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22'"
        ]
      }
    } : {},
    var.add_exa_vcn2 ? {
      ZPR-POLICY-EXA-VCN-2 = {
        description = "zpr policy for exa vcn 2"
        name = "zpr-policy-exa-vcn-2"
        statements = [
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22,1521-1522,6200'"
        ]
      }
    } : {},
    ((var.add_exa_vcn2) && (local.hub_with_vcn == true) && (var.exa_vcn2_attach_to_drg == true)) ? {
      ZPR-POLICY-EXA-VCN-2-HUB = {
        description = "zpr policy for exa vcn 2 to hub vcn cidrs"
        name        = "zpr-policy-exa-vcn-2-hub"
        statements  = [
          for cidr in var.hub_vcn_cidrs :
          // Allows SSH connections from hosts in ${cidr} from hub_vcn_cidrs. May need a for loop for each cidr
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-2-${local.zpr_label} VCN allow '${cidr}' to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/22'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_exa_vcn2 ? {
      ZPR-POLICY-EXA-VCN-1-TO-EXA-VCN-2 = {
        description = "zpr-policy-exa-vcn-1-to-exa-vcn-2"
        name        = "zpr-policy-exa-vcn-1-to-exa-vcn-2"
        statements  = [
          // Allow endpoints in Client subnet of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.exa_vcn2_client_subnet_cidr} with protocol='tcp/1521-1522'",
          // Allow endpoints in DB server of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.exa_vcn2_client_subnet_cidr} with protocol='tcp/1521-1522'",
          // Allow endpoints in other Exa VCNs to connect to db server
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.exa_vcn2_client_subnet_cidr} to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_exa_vcn3 ? {
      ZPR-POLICY-EXA-VCN-1-TO-EXA-VCN-3 = {
        description = "zpr-policy-exa-vcn-1-to-exa-vcn-3"
        name        = "zpr-policy-exa-vcn-1-to-exa-vcn-3"
        statements  = [
          // Allow endpoints in Client subnet of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.exa_vcn3_client_subnet_cidr} with protocol='tcp/1521-1522'",
          // Allow endpoints in DB server of Exadata VCN to communicate with other Exadata client subnets in other VCNs using SQLNet
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.exa_vcn3_client_subnet_cidr} with protocol='tcp/1521-1522'",
          // Allow endpoints in other Exa VCNs to connect to db server
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.exa_vcn3_client_subnet_cidr} to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_tt_vcn1 ? {
        ZPR-POLICY-EXA-VCN-1-TO-TT-VCN-1 = {
          description = "zpr policy for exa vcn 1 to tt vcn 1"
          name = "zpr-policy-exa-vcn-1-to-tt-vcn-1"
          statements = [
              // Allow endpoints in Client subnet of Exadata VCN to communicate with other endpoints in the TT VCNs
              "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
              // Allow DB Server to communicate with other endpoints in the TT VCNs
              "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn1_db_subnet_cidr} with protocol='tcp/1521-1522'",
              // Allow App and DB Subnet endpoints in Three Tier VCNs connect to Client Subnet in Exadata / Ingress
              "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn1_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
              "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn1_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
              // Allow App and DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
              "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn1_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
              "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn1_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'"
          ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_tt_vcn2 ? {
      ZPR-POLICY-EXA-VCN-1-TO-TT-VCN-2 = {
        description = "zpr policy for exa vcn 1 to tt vcn 2"
        name = "zpr-policy-exa-vcn-1-to-tt-vcn-2"
        statements = [
          // Allow endpoints in Client subnet of Exadata VCN to communicate with other endpoints in the TT VCNs
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
          // Allow DB Server to communicate with other endpoints in the TT VCNs
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn2_db_subnet_cidr} with protocol='tcp/1521-1522'",
          // Allow App and DB Subnet endpoints in Three Tier VCNs connect to Client Subnet in Exadata / Ingress
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn2_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn2_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
          // Allow App and DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn2_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn2_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'"
        ]
      }
    } : {},
    var.add_exa_vcn1 && var.add_tt_vcn3 ? {
      ZPR-POLICY-EXA-VCN-1-TO-TT-VCN-3 = {
        description = "zpr policy for exa vcn 1 to tt vcn 3"
        name = "zpr-policy-exa-vcn-1-to-tt-vcn-3"
        statements = [
          // Allow endpoints in Client subnet of Exadata VCN to communicate with other endpoints in the TT VCNs
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_db_subnet_cidr} with protocol='tcp/1521-1522'",
          // Allow DB Server to communicate with other endpoints in the TT VCNs
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} endpoints to connect to ${var.tt_vcn3_db_subnet_cidr} with protocol='tcp/1521-1522'",
          // Allow App and DB Subnet endpoints in Three Tier VCNs connect to Client Subnet in Exadata / Ingress
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn3_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn3_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-client:${local.zpr_label} with protocol='tcp/1521-1522'",
          // Allow App and DB Subnet endpoints in Three Tier VCNs connect to DB Subnet in Exadata / Ingress
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn3_app_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'",
          "in ${var.zpr_security_attributes_namespace}.net:exa-vcn-1-${local.zpr_label} VCN allow ${var.tt_vcn3_db_subnet_cidr} endpoints to connect to ${var.zpr_security_attributes_namespace}.db-server:${local.zpr_label} with protocol='tcp/1521-1522'"
        ]
      }
    } : {}
  )
}

