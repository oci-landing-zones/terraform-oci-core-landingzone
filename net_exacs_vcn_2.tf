# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  add_exa_vcn2 = var.define_net == true && var.add_exa_vcn2 == true

  exa_vcn2_display_name               = coalesce(var.exa_vcn2_name, "${var.service_label}-exadata-vcn-2")
  exa_vcn2_dns_label                  = substr(replace(coalesce(var.exa_vcn2_name, "exadata-vcn-2"), "/[^\\w]/", ""), 0, 14)
  exa_vcn2_client_subnet_display_name = coalesce(var.exa_vcn2_client_subnet_name, "${var.service_label}-exadata-vcn-2-client-subnet")
  exa_vcn2_client_subnet_dns_label    = substr(replace(coalesce(var.exa_vcn2_client_subnet_name, "client-subnet"), "/[^\\w]/", ""), 0, 14)
  exa_vcn2_client_subnet_cidr         = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))
  exa_vcn2_backup_subnet_display_name = coalesce(var.exa_vcn2_backup_subnet_name, "${var.service_label}-exadata-vcn-2-backup-subnet")
  exa_vcn2_backup_subnet_dns_label    = substr(replace(coalesce(var.exa_vcn2_backup_subnet_name, "backup-subnet"), "/[^\\w]/", ""), 0, 14)
  exa_vcn2_backup_subnet_cidr         = coalesce(var.exa_vcn2_backup_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 1))
  
  exa_vcn_2 = local.add_exa_vcn2 == true ? {
    "EXA-VCN-2" = {
      display_name                     = local.exa_vcn2_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn2_cidrs,
      dns_label                        = local.exa_vcn2_dns_label
      block_nat_traffic                = false
      security                         = local.enable_zpr == true ? { zpr_attributes = [{ namespace : "${local.zpr_namespace_name}", attr_name : "net", attr_value : "exa-vcn-2" }] } : null

      subnets = {
        "EXA-VCN-2-CLIENT-SUBNET" = {
          cidr_block                = local.exa_vcn2_client_subnet_cidr
          dhcp_options_key          = "default_dhcp_options"
          display_name              = local.exa_vcn2_client_subnet_display_name
          dns_label                 = local.exa_vcn2_client_subnet_dns_label
          ipv6cidr_blocks           = []
          prohibit_internet_ingress = true
          route_table_key           = "EXA-VCN-2-CLIENT-SUBNET-ROUTE-TABLE"
          security_list_keys        = ["EXA-VCN-2-CLIENT-SUBNET-SL"]
        }
        "EXA-VCN-2-BACKUP-SUBNET" = {
          cidr_block                = local.exa_vcn2_backup_subnet_cidr
          dhcp_options_key          = "default_dhcp_options"
          display_name              = local.exa_vcn2_backup_subnet_display_name
          dns_label                 = local.exa_vcn2_backup_subnet_dns_label
          ipv6cidr_blocks           = []
          prohibit_internet_ingress = true
          route_table_key           = "EXA-VCN-2-BACKUP-SUBNET-ROUTE-TABLE"
        }
      }

      route_tables = {
        "EXA-VCN-2-CLIENT-SUBNET-ROUTE-TABLE" = {
          display_name = "client-subnet-route-table"
          route_rules = merge(
            {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-2-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            },  
            (local.hub_with_vcn == false) ? local.exa_vcn_2_drg_routing : { 
              "HUB-DRG-RULE" = { # Case when there is a Hub VCN. All traffic is routed through the DRG.
                network_entity_key = "HUB-DRG"
                description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          )
        },
        "EXA-VCN-2-BACKUP-SUBNET-ROUTE-TABLE" = {
          display_name = "backup-subnet-route-table"
          route_rules = {
            "OSN-RULE" = {
              network_entity_key = "EXA-VCN-2-SERVICE-GATEWAY"
              description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
              destination        = "all-services"
              destination_type   = "SERVICE_CIDR_BLOCK"
            }
          }
        }
      }

      security_lists = {
        "EXA-VCN-2-CLIENT-SUBNET-SL" = {
          display_name = "${local.exa_vcn2_client_subnet_display_name}-security-list"
          ingress_rules = [
            {
              description  = "Allows SSH connections from hosts in Exadata client subnet."
              stateless    = false
              protocol     = "TCP"
              src          = local.exa_vcn2_client_subnet_cidr
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
              dst          = local.exa_vcn2_client_subnet_cidr
              dst_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            },
            {
              description = "Allows the initiation of ICMP connections to hosts in Exadata VCN."
              stateless   = false
              protocol    = "UDP"
              dst         = local.exa_vcn2_client_subnet_cidr
              dst_type    = "CIDR_BLOCK"
              icmp_type   = 3
              icmp_code   = 4
            }
          ]
        }
      }

      network_security_groups = merge(
        {
          "EXA-VCN-2-CLIENT-NSG" = {
            display_name = "client-nsg"
            ingress_rules = merge(
              local.hub_with_vcn == true && var.exa_vcn2_attach_to_drg == true && local.add_exa_vcn2 == true && var.deploy_bastion_jump_host == true ? {
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
                  src          = "EXA-VCN-2-CLIENT-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              },
              { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-CLIENT-NSG-ON-${port}-RULE" => {
                  description  = "Ingress from Client NSG over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"} (for SQLNet connections)"
                  stateless    = false
                  protocol     = split(":",port)[0]
                  src          = "EXA-VCN-2-CLIENT-NSG"
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
                  src         = "EXA-VCN-2-CLIENT-NSG"
                  src_type    = "NETWORK_SECURITY_GROUP"
                  dst_port_min : 6200
                  dst_port_max : 6200
                }
              }
            )
            egress_rules = merge(
              {
                "EGRESS-TO-SSH-RULE" = {
                  description  = "Allows SSH connections to hosts in Client NSG."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "EXA-VCN-2-CLIENT-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              },
              { for port in var.exa_vcn2_client_ingress_destination_ports : "EGRESS-TO-CLIENT-NSG-ON-${port}-RULE" => {
                  description  = "Egress to Client NSG over ${split(":",port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"} (for SQLNet connections)"
                  stateless    = false
                  protocol     = split(":",port)[0]
                  dst          = "EXA-VCN-2-CLIENT-NSG"
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
                  dst         = "EXA-VCN-2-CLIENT-NSG"
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
              }
            )
          }
          "EXA-VCN-2-BACKUP-NSG" = {
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
        },
        local.exa_vcn2_cross_vcn_open_nsg,
        local.exa_vcn2_cross_vcn_client_nsg
      )

      vcn_specific_gateways = {
        service_gateways = {
          "EXA-VCN-2-SERVICE-GATEWAY" = {
            display_name = "service-gateway"
            services     = "all-services"
          }
        }
      }
    }
  } : {}

  exa_vcn_2_drg_routing = (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? merge(
    length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1") ? local.tt_vcn1_route_rule : {},
    length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2") ? local.tt_vcn2_route_rule : {},
    length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3") ? local.tt_vcn3_route_rule : {},
    length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1") ? local.oke_vcn1_route_rule : {},
    length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2") ? local.oke_vcn2_route_rule : {},
    length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3") ? local.oke_vcn3_route_rule : {},
    length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1") ? local.exa_vcn1_route_rule : {},
    length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3") ? local.exa_vcn3_route_rule : {},
    var.tt_vcn2_onprem_route_enable == true ? local.on_prem_route_rule : {}
  ) : {}

  #-------------------------------------------------------------
  # Cross VCN Open NSG
  #-------------------------------------------------------------
  exa_vcn2_cross_vcn_open_nsg = (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.enable_cross_vcn_open_nsg == true) ? {
    "EXA-VCN-2-CROSS-VCN-OPEN-NSG" = {
      display_name = "cross-vcn-open-nsg"
      ingress_rules = merge(local.exa_vcn2_cross_vcn_open_nsg_ingress_security_rules, local.ingress_from_hub_jumphost_subnet_security_rule)
      egress_rules  = local.exa_vcn2_cross_vcn_open_nsg_egress_security_rules
    }
  } : {}

  exa_vcn2_cross_vcn_open_nsg_ingress_security_rules = merge(
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.from_tt_vcn_1_ingress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "EXA-VCN-2")))) ? local.from_tt_vcn_2_ingress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-2")))) ? local.from_tt_vcn_3_ingress_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.from_oke_vcn_1_ingress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-2")))) ? local.from_oke_vcn_2_ingress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "EXA-VCN-2")))) ? local.from_oke_vcn_3_ingress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.from_exa_vcn_1_ingress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-2")))) ? local.from_exa_vcn_3_ingress_security_rules : {},
    (var.exa_vcn2_onprem_route_enable == true) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.from_onprem_ingress_security_rules : {}
  )

  exa_vcn2_cross_vcn_open_nsg_egress_security_rules = merge(
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1")))) ? local.to_tt_vcn_1_egress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2")))) ? local.to_tt_vcn_2_egress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3")))) ? local.to_tt_vcn_3_egress_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.to_oke_vcn_1_egress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2")))) ? local.to_oke_vcn_2_egress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3")))) ? local.to_oke_vcn_3_egress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1")))) ? local.to_exa_vcn_1_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3")))) ? local.to_exa_vcn_3_egress_security_rules : {},
    (var.exa_vcn2_onprem_route_enable == true) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.to_onprem_egress_security_rules : {}
  )

  #-------------------------------------------------------------
  # Cross VCN Constrained NSG
  #-------------------------------------------------------------
  exa_vcn2_cross_vcn_client_nsg = (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.enable_cross_vcn_constrained_nsgs == true) ? {
    "EXA-VCN-2-CROSS-VCN-CLIENT-NSG" = {
      display_name = "cross-vcn-client-nsg"
      ingress_rules = merge(local.exa_vcn2_cross_vcn_client_nsg_ingress_security_rules, local.ingress_from_hub_jumphost_subnet_security_rule)
      egress_rules  = local.exa_vcn2_cross_vcn_client_nsg_egress_security_rules
    }
  } : {}

  exa_vcn2_cross_vcn_client_nsg_ingress_security_rules = merge(
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_ingress_from_tt_vcn1_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_ingress_from_tt_vcn2_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_ingress_from_tt_vcn3_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")))) ? merge(local.exa_vcn_2_client_subnet_ingress_from_oke_vcn1_workers_security_rules, local.exa_vcn_2_client_subnet_ingress_from_oke_vcn1_pods_security_rules, local.exa_vcn_2_client_subnet_ingress_from_oke_vcn1_db_security_rules) : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-2")))) ? merge(local.exa_vcn_2_client_subnet_ingress_from_oke_vcn2_workers_security_rules, local.exa_vcn_2_client_subnet_ingress_from_oke_vcn2_pods_security_rules, local.exa_vcn_2_client_subnet_ingress_from_oke_vcn2_db_security_rules) : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "EXA-VCN-2")))) ? merge(local.exa_vcn_2_client_subnet_ingress_from_oke_vcn3_workers_security_rules, local.exa_vcn_2_client_subnet_ingress_from_oke_vcn3_pods_security_rules, local.exa_vcn_2_client_subnet_ingress_from_oke_vcn3_db_security_rules) : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_ingress_from_exa_vcn1_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_ingress_from_exa_vcn3_security_rules : {},
    (var.exa_vcn2_onprem_route_enable == true) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.exa_vcn_2_client_subnet_ingress_from_onprem_security_rules : {}
  )

  exa_vcn2_cross_vcn_client_nsg_egress_security_rules = merge(
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1")))) ? local.tt_vcn_1_db_subnet_egress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2")))) ? local.tt_vcn_2_db_subnet_egress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3")))) ? local.tt_vcn_3_db_subnet_egress_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_db_subnet_egress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2")))) ? local.oke_vcn_2_db_subnet_egress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3")))) ? local.oke_vcn_3_db_subnet_egress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1")))) ? local.exa_vcn_1_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3")))) ? local.exa_vcn_3_client_subnet_egress_security_rules : {}
  )
}

