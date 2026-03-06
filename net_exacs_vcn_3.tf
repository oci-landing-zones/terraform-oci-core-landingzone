# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  add_exa_vcn3 = var.define_net == true && var.add_exa_vcn3 == true

  exa_vcn3_display_name               = coalesce(var.exa_vcn3_name, "${var.service_label}-exadata-vcn-3")
  exa_vcn3_dns_label                  = substr(replace(coalesce(var.exa_vcn3_name, "exadata-vcn-3"), "/[^\\w]/", ""), 0, 14)
  exa_vcn3_client_subnet_display_name = coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exadata-vcn-3-client-subnet")
  exa_vcn3_client_subnet_dns_label    = substr(replace(coalesce(var.exa_vcn3_client_subnet_name, "client-subnet"), "/[^\\w]/", ""), 0, 14)
  exa_vcn3_client_subnet_cidr         = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
  exa_vcn3_backup_subnet_display_name = coalesce(var.exa_vcn3_backup_subnet_name, "${var.service_label}-exadata-vcn-3-backup-subnet")
  exa_vcn3_backup_subnet_dns_label    = substr(replace(coalesce(var.exa_vcn3_backup_subnet_name, "backup-subnet"), "/[^\\w]/", ""), 0, 14)
  exa_vcn3_backup_subnet_cidr         = coalesce(var.exa_vcn3_backup_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 1))

  exa_vcn_3 = local.add_exa_vcn3 == true ? {
    "EXA-VCN-3" = {
      display_name                     = local.exa_vcn3_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn3_cidrs,
      dns_label                        = local.exa_vcn3_dns_label
      block_nat_traffic                = false
      security                         = local.enable_zpr == true ? { zpr_attributes = [{ namespace : "${local.zpr_namespace_name}", attr_name : "net", attr_value : "exa-vcn-3" }] } : null

      subnets = {
        "EXA-VCN-3-CLIENT-SUBNET" = {
          cidr_block                = local.exa_vcn3_client_subnet_cidr
          dhcp_options_key          = "default_dhcp_options"
          display_name              = local.exa_vcn3_client_subnet_display_name
          dns_label                 = local.exa_vcn3_client_subnet_dns_label
          ipv6cidr_blocks           = []
          prohibit_internet_ingress = true
          route_table_key           = "EXA-VCN-3-CLIENT-SUBNET-ROUTE-TABLE"
          security_list_keys        = ["EXA-VCN-3-CLIENT-SUBNET-SL"]
        }
        "EXA-VCN-3-BACKUP-SUBNET" = {
          cidr_block                = local.exa_vcn3_backup_subnet_cidr
          dhcp_options_key          = "default_dhcp_options"
          display_name              = coalesce(var.exa_vcn3_backup_subnet_name, "${var.service_label}-exadata-vcn-3-backup-subnet")
          dns_label                 = local.exa_vcn3_backup_subnet_dns_label
          ipv6cidr_blocks           = []
          prohibit_internet_ingress = true
          route_table_key           = "EXA-VCN-3-BACKUP-SUBNET-ROUTE-TABLE"
        }
      }

      route_tables = {
        "EXA-VCN-3-CLIENT-SUBNET-ROUTE-TABLE" = {
          display_name = "client-subnet-route-table"
          route_rules = merge(
            {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-3-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            },  
            (local.hub_with_vcn == false) ? local.exa_vcn_3_drg_routing : { 
              "HUB-DRG-RULE" = { # Case when there is a Hub VCN. All traffic is routed through the DRG.
                network_entity_key = "HUB-DRG"
                description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          )
        },
        "EXA-VCN-3-BACKUP-SUBNET-ROUTE-TABLE" = {
          display_name = "backup-subnet-route-table"
          route_rules = {
            "OSN-RULE" = {
              network_entity_key = "EXA-VCN-3-SERVICE-GATEWAY"
              description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
              destination        = "all-services"
              destination_type   = "SERVICE_CIDR_BLOCK"
            }
          }
        }
      }

      security_lists = {
        "EXA-VCN-3-CLIENT-SUBNET-SL" = {
          display_name = "${local.exa_vcn3_client_subnet_display_name}-security-list"
          ingress_rules = [
            {
              description  = "Allows SSH connections from hosts in Exadata client subnet."
              stateless    = false
              protocol     = "TCP"
              src          = local.exa_vcn3_client_subnet_cidr
              src_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            }
          ]
          egress_rules = [
            {
              description  = "Allows SSH connections to hosts in Exadata client subnet."
              stateless    = false
              protocol     = "TCP"
              dst          = local.exa_vcn3_client_subnet_cidr
              dst_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            },
            {
              description = "Allows the initiation of ICMP connections to hosts in Exadata VCN."
              stateless   = false
              protocol    = "UDP"
              dst         = local.exa_vcn3_client_subnet_cidr
              dst_type    = "CIDR_BLOCK"
              icmp_type   = 3
              icmp_code   = 4
            }
          ]
        }
      }

      network_security_groups = {
        "EXA-VCN-3-CLIENT-NSG" = {
          display_name = "client-nsg"
          ingress_rules = merge(
            local.hub_with_vcn == true && var.exa_vcn3_attach_to_drg == true && local.add_exa_vcn3 == true && var.deploy_bastion_jump_host == true ? {
              "INGRESS-FROM-SSH-HUB-VCN-RULE" = {
                description  = "Allows SSH connections from ${local.hub_vcn_jumphost_subnet_cidr} in Hub VCN Jumphost subnet."
                stateless    = false
                protocol     = "TCP"
                src          = local.hub_vcn_jumphost_subnet_cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            } : {},
            {
              "INGRESS-FROM-SSH-CLIENT-RULE" = {
                description  = "Allows SSH connections from hosts in Client NSG."
                stateless    = false
                protocol     = "TCP"
                src          = "EXA-VCN-3-CLIENT-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 22
                dst_port_max = 22
              }
            },
            { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-CLIENT-NSG-ON-${port}-RULE" => {
                description  = "Ingress from Client NSG over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"} (for SQLNet connections)"
                stateless    = false
                protocol     = split(":",port)[0]
                src          = "EXA-VCN-3-CLIENT-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
            }},
            {
              "INGRESS-FROM-ONS-CLIENT-RULE" = {
                description = "Allows Oracle Notification Services (ONS) communication from hosts in Client NSG for Fast Application Notifications (FAN)."
                stateless   = false
                protocol    = "TCP"
                src         = "EXA-VCN-3-CLIENT-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 6200
                dst_port_max : 6200
              }
            },
            local.exa_vcn_3_to_client_subnet_cross_vcn_ingress
          )
          egress_rules = merge(
            {
              "EGRESS-TO-SSH-RULE" = {
                description  = "Allows SSH connections to hosts in Client NSG."
                stateless    = false
                protocol     = "TCP"
                dst          = "EXA-VCN-3-CLIENT-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 22
                dst_port_max = 22
              }
            },
            { for port in var.exa_vcn3_client_ingress_destination_ports : "EGRESS-TO-CLIENT-NSG-ON-${port}-RULE" => {
                description  = "Egress to Client NSG over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"} (for SQLNet connections)"
                stateless    = false
                protocol     = split(":",port)[0]
                dst          = "EXA-VCN-3-CLIENT-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
            }},
            {
              "EGRESS-TO-ONS-RULE" = {
                description = "Allows Oracle Notification Services (ONS) communication to hosts in Client NSG for Fast Application Notifications (FAN)."
                stateless   = false
                protocol    = "TCP"
                dst         = "EXA-VCN-3-CLIENT-NSG"
                dst_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 6200
                dst_port_max : 6200
              }
            },
            {
              "EGRESS-TO-OSN-RULE" = {
                description = "Allows HTTPS connections to Oracle Services Network (OSN)."
                stateless   = false
                protocol    = "TCP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
                dst_port_min : 443
                dst_port_max : 443
              }
            },
            local.exa_vcn_3_to_client_subnet_cross_vcn_egress,
            local.exa_vcn_3_to_db_subnet_cross_vcn_egress
          )
        }
        "EXA-VCN-3-BACKUP-NSG" = {
          display_name = "backup-nsg"
          egress_rules = {
            "EGRESS-TO-OSN-RULE" = {
              description = "Allows HTTPS connections to Oracle Services Network (OSN)."
              stateless   = false
              protocol    = "TCP"
              dst         = "objectstorage"
              dst_type    = "SERVICE_CIDR_BLOCK"
              dst_port_min : 443,
              dst_port_max : 443
            }
          }
        }
      }

      vcn_specific_gateways = {
        service_gateways = {
          "EXA-VCN-3-SERVICE-GATEWAY" = {
            display_name = "service-gateway"
            services     = "all-services"
          }
        }
      }
    }
  } : {}

  ## Cross VCN Egress Rules for EXA_VCN_3
  ### Cross VCN egress rules to other EXA VCNs' Clients subnets
  exa_vcn_3_to_client_subnet_cross_vcn_egress = merge(
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-1")))) ? { for port in var.exa_vcn1_client_ingress_destination_ports : "EGRESS-TO-EXA-VCN1-ON-${port}-RULE" => {
      description  = "Egress to ${local.exa_vcn1_client_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.exa_vcn1_client_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-2")))) ? { for port in var.exa_vcn2_client_ingress_destination_ports : "EGRESS-TO-EXA-VCN2-ON-${port}-RULE" => {
      description  = "Egress to ${local.exa_vcn2_client_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.exa_vcn2_client_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
  )

  ### Cross VCN egress rules to Three-tier VCNs' db subnets
  exa_vcn_3_to_db_subnet_cross_vcn_egress = merge(
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1")))) ? { for port in var.tt_vcn1_db_ingress_destination_ports : "EGRESS-TO-TT-VCN1-ON-${port}-RULE" => {
      description  = "Egress to ${local.tt_vcn1_db_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.tt_vcn1_db_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-2")))) ? { for port in var.tt_vcn2_db_ingress_destination_ports : "EGRESS-TO-TT-VCN2-ON-${port}-RULE" => {
      description  = "Egress to ${local.tt_vcn2_db_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.tt_vcn2_db_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-3")))) ? { for port in var.tt_vcn3_db_ingress_destination_ports : "EGRESS-TO-TT-VCN3-ON-${port}-RULE" => {
      description  = "Egress to ${local.tt_vcn3_db_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.tt_vcn3_db_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {}
  )

  ## Cross VCN Ingress rules for EXA_VCN_3
  ### Cross VCN ingress rules from other VCNs' subnets
  exa_vcn_3_to_client_subnet_cross_vcn_ingress = merge(
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-1")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
      description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.exa_vcn1_client_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-2")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
      description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.exa_vcn2_client_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-1")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
      description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.oke_vcn1_workers_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (upper(var.oke_vcn1_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-1")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
      description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.oke_vcn1_pods_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-2")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
      description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.oke_vcn2_workers_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (upper(var.oke_vcn2_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-2")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
      description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.oke_vcn2_pods_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-3")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
      description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (upper(var.oke_vcn3_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-3")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
      description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.oke_vcn3_pods_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-APP-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn1_app_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-DB-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn1_db_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn1_db_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-2")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-APP-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn2_app_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-2")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-DB-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn2_db_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn2_db_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-3")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-APP-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn3_app_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-3")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-DB-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn3_db_subnet_display_name} over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn3_db_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }} : {},
    ## Ingress from on-premises CIDRs
    (local.add_exa_vcn3 == true && (var.exa_vcn3_attach_to_drg == true && var.exa_vcn3_onprem_route_enable)) &&
    (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? { for cidr_port_pair in flatten([for cidr in var.allowed_onprem_cidrs_to_app_endpoints : [for port in var.exa_vcn3_client_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}" ] if length(var.allowed_onprem_cidrs_to_app_endpoints) > 0 && length(var.exa_vcn3_client_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",",cidr_port_pair)[0]}-ON-${split(",",cidr_port_pair)[1]}-RULE" => {
      description  = "Ingress from onprem ${split(",",cidr_port_pair)[0]} over ${split(":",split(",",cidr_port_pair)[1])[0]} on ${split(":",split(",",cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":",split(",",cidr_port_pair)[1])[1]}" : "port ${split(":",split(",",cidr_port_pair)[1])[1]}"}."
      stateless    = false
      protocol     = split(":",split(",",cidr_port_pair)[1])[0]
      src          = split(",",cidr_port_pair)[0]
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":",split(",",cidr_port_pair)[1])[0] != "ICMP" ? (split(":",split(",",cidr_port_pair)[1])[1]) : null
      dst_port_max = split(":",split(",",cidr_port_pair)[1])[0] != "ICMP" ? (split(":",split(",",cidr_port_pair)[1])[1]) : null
      icmp_type    = split(":",split(",",cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":",split(",",cidr_port_pair)[1])[1])[0] : null
      icmp_code    = split(":",split(",",cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":",split(",",cidr_port_pair)[1])[1])) > 1 ? split("/", split(":",split(",",cidr_port_pair)[1])[1])[1] : null) : null
    }} : {}
  )

  exa_vcn_3_drg_routing = (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? merge(
    length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1") ? local.tt_vcn1_route_rule : {},
    length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-2") ? local.tt_vcn2_route_rule : {},
    length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-3") ? local.tt_vcn3_route_rule : {},
    length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-1") ? local.oke_vcn1_route_rule : {},
    length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-2") ? local.oke_vcn2_route_rule : {},
    length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-3") ? local.oke_vcn3_route_rule : {},
    length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-1") ? local.exa_vcn1_route_rule : {},
    length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-2") ? local.exa_vcn2_route_rule : {},
    var.tt_vcn3_onprem_route_enable == true ? local.on_prem_route_rule : {}
  ) : {}
}

