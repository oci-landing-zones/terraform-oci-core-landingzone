# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  exa_vcn_1 = var.add_exa_vcn1 == true ? {
    "EXA-VCN-1" = {
      display_name                     = coalesce(var.exa_vcn1_name, "${var.service_label}-exadata-vcn-1")
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn1_cidrs,
      dns_label                        = replace(coalesce(var.exa_vcn1_dns, "${var.service_label}-exadata-vcn-1"), "-", "")
      block_nat_traffic                = false
      subnets = {
        "EXA-VCN-1-CLIENT-SUBNET" = {
          cidr_block                 = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exadata-vcn-1-client-subnet")
          dns_label                  = replace(coalesce(var.exa_vcn1_client_subnet_dns, "client-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "EXA-VCN-1-CLIENT-SUBNET-ROUTE-TABLE"
        }
        "EXA-VCN-1-BACKUP-SUBNET" = {
          cidr_block                 = coalesce(var.exa_vcn1_backup_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 1))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.exa_vcn1_backup_subnet_name, "${var.service_label}-exadata-vcn-1-backup-subnet")
          dns_label                  = replace(coalesce(var.exa_vcn1_backup_subnet_dns, "backup-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "EXA-VCN-1-BACKUP-SUBNET-ROUTE-TABLE"
        }
      }
      route_tables = {
        "EXA-VCN-1-CLIENT-SUBNET-ROUTE-TABLE" = {
          display_name = "client-subnet-route-table"
          route_rules = merge(
            {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-1-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            },
            {
              "ANYWHERE-RULE" = { # TODO: need a good name
                network_entity_key = "HUB-DRG"
                description        = "Traffic destined to ${local.anywhere} goes to DRG."
                destination        = local.anywhere
                destination_type   = "CIDR_BLOCK"
              }
            },
            { for cidr in var.exa_vcn2_cidrs : "EXA-VCN-2-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "EXA-VCN-2"))
            },
            { for cidr in var.exa_vcn3_cidrs : "EXA-VCN-3-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "EXA-VCN-3"))
            },
            { for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-1"))
            },
            { for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-2"))
            },
            { for cidr in var.tt_vcn3_cidrs : "TT-VCN-3-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-3"))
            }
          )
        }
        "EXA-VCN-1-BACKUP-SUBNET-ROUTE-TABLE" = {
          display_name = "backup-subnet-route-table"
          route_rules = merge(
            {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-1-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services" # TODO: confirm if it's objectstorage or all-services
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            }
          )
        }
      }
      security_lists = {
        "EXA-VCN-1-CLIENT-SUBNET-SL" = {
          display_name = "${coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exadata-vcn-1-client-subnet")}-security-list"
          ingress_rules = [
            {
              description = "Allows SSH connections from hosts in Exadata client subnet."
              stateless   = false
              protocol    = "TCP"
              src         = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 9, 96))
              src_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            }
          ]
          egress_rules = [
            {
              description = "Allows SSH connections to hosts in Exadata client subnet."
              stateless   = false
              protocol    = "TCP"
              dst         = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 9, 96))
              dst_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            },
            {
              description = "Allows the initiation of ICMP connections to hosts in Exadata VCN."
              stateless   = false
              protocol    = "UDP"
              dst         = var.exa_vcn1_cidrs
              dst_type    = "CIDR_BLOCK"
              icmp_type   = 3
              icmp_code   = 4
            }
          ]
        }
      }
      network_security_groups = {
        "EXA-VCN-1-CLIENT-NSG" = {
          display_name = "client-nsg"
          ingress_rules = merge(
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-SSH-${cidr}-RULE" =>
              {
                description  = "Allows SSH connections from hosts in ${cidr} VCN."
                stateless    = false
                protocol     = "TCP"
                src          = cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            },
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-SQLNET-${cidr}-RULE" =>
              {
                description = "Allows SQLNet connections from hosts in ${cidr} VCN."
                stateless   = false
                protocol    = "TCP"
                src         = cidr
                src_type    = "CIDR_BLOCK"
                dst_port_min : 1521
                dst_port_max : 1522
              }
            },
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-ONS-${cidr}-RULE" =>
              {
                description = "Allows Oracle Notification Services (ONS) communication from hosts in Hub VCN for Fast Application Notifications (FAN)."
                stateless   = false
                protocol    = "TCP"
                src         = cidr
                src_type    = "CIDR_BLOCK"
                dst_port_min : 6200,
                dst_port_max : 6200
              }
            },
            {
              "INGRESS-FROM-SSH-CLIENT-RULE" = {
                description  = "Allows SSH connections from hosts in Client NSG."
                stateless    = false
                protocol     = "TCP"
                src          = "EXA-VCN-1-CLIENT-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 22
                dst_port_max = 22
              }
            },
            {
              "INGRESS-FROM-SQLNET-CLIENT-RULE" = {
                description = "Allows SQLNet connections from hosts in Client NSG."
                stateless   = false
                protocol    = "TCP"
                src         = "EXA-VCN-1-CLIENT-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 1521,
                dst_port_max : 1522
              }
            },
            {
              "INGRESS-FROM-ONS-CLIENT-RULE" = {
                description = "Allows Oracle Notification Services (ONS) communication from hosts in Client NSG for Fast Application Notifications (FAN)."
                stateless   = false
                protocol    = "TCP"
                src         = "EXA-VCN-1-CLIENT-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 6200,
                dst_port_max : 6200
              }
            }
          )
          egress_rules = {
            "EGRESS-TO-SSH-RULE" = {
              description  = "Allows SSH connections to hosts in Client NSG."
              stateless    = false
              protocol     = "TCP"
              dst          = "EXA-VCN-1-CLIENT-NSG"
              dst_type     = "NETWORK_SECURITY_GROUP"
              dst_port_min = 22
              dst_port_max = 22
            }
            "EGRESS-TO-SQLNET-RULE" = {
              description = "Allows SQLNet connections to hosts in Client NSG."
              stateless   = false
              protocol    = "TCP"
              dst         = "EXA-VCN-1-CLIENT-NSG"
              dst_type    = "NETWORK_SECURITY_GROUP"
              dst_port_min : 1521
              dst_port_max : 1522
            },
            "EGRESS-TO-ONS-RULE" = {
              description = "Allows Oracle Notification Services (ONS) communication to hosts in Client NSG for Fast Application Notifications (FAN)."
              stateless   = false
              protocol    = "TCP"
              dst         = "EXA-VCN-1-CLIENT-NSG"
              dst_type    = "NETWORK_SECURITY_GROUP"
              dst_port_min : 6200
              dst_port_max : 6200
            }
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
        }
        "EXA-VCN-1-BACKUP-NSG" = {
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
          "EXA-VCN-1-SERVICE-GATEWAY" = {
            display_name = "service-gateway"
            services     = "all-services"
          }
        }
      }
    }
  } : {}

  exa_vcn_2 = var.add_exa_vcn2 == true ? {
    "EXA-VCN-2" = {
      display_name                     = coalesce(var.exa_vcn2_name, "${var.service_label}-exadata-vcn-2")
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn2_cidrs,
      dns_label                        = replace(coalesce(var.exa_vcn2_dns, "${var.service_label}-exadata-vcn-2"), "-", "")
      block_nat_traffic                = false
      subnets = {
        "EXA-VCN-2-CLIENT-SUBNET" = {
          cidr_block                 = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.exa_vcn2_client_subnet_name, "${var.service_label}-exadata-vcn-2-client-subnet")
          dns_label                  = replace(coalesce(var.exa_vcn2_client_subnet_dns, "client-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "EXA-VCN-2-CLIENT-SUBNET-ROUTE-TABLE"
        }
        "EXA-VCN-2-BACKUP-SUBNET" = {
          cidr_block                 = coalesce(var.exa_vcn2_backup_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 1))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.exa_vcn2_backup_subnet_name, "${var.service_label}-exadata-vcn-2-backup-subnet")
          dns_label                  = replace(coalesce(var.exa_vcn2_backup_subnet_dns, "backup-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "EXA-VCN-2-BACKUP-SUBNET-ROUTE-TABLE"
        }
      }
      route_tables = {
        "EXA-VCN-2-CLIENT-SUBNET-ROUTE-TABLE" = {
          display_name = "client-subnet-route-table"
          route_rules = merge(
            {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-2-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            },
            {
              "ANYWHERE-RULE" = { # TODO: need a good name
                network_entity_key = "HUB-DRG"
                description        = "Traffic destined to ${local.anywhere} goes to DRG."
                destination        = local.anywhere
                destination_type   = "CIDR_BLOCK"
              }
            },
            { for cidr in var.exa_vcn1_cidrs : "EXA-VCN-1-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1"))
            },
            { for cidr in var.exa_vcn3_cidrs : "EXA-VCN-3-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3"))
            },
            { for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1"))
            },
            { for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2"))
            },
            { for cidr in var.tt_vcn3_cidrs : "TT-VCN-3-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3"))
            }
          )
        }
        "EXA-VCN-2-BACKUP-SUBNET-ROUTE-TABLE" = {
          display_name = "backup-subnet-route-table"
          route_rules = merge(
            {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-2-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            }
          )
        }
      }
      security_lists = {
        "EXA-VCN-2-CLIENT-SUBNET-SL" = {
          display_name = "${coalesce(var.exa_vcn2_client_subnet_name, "${var.service_label}-exadata-vcn-2-client-subnet")}-security-list"
          ingress_rules = [
            {
              description = "Allows SSH connections from hosts in Exadata client subnet."
              stateless   = false
              protocol    = "TCP"
              src         = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 9, 96))
              src_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            }
          ]
          egress_rules = [
            {
              description = "Allows SSH connections to hosts in Exadata client subnet."
              stateless   = false
              protocol    = "TCP"
              dst         = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 9, 96))
              dst_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            },
            {
              description = "Allows the initiation of ICMP connections to hosts in Exadata VCN."
              stateless   = false
              protocol    = "UDP"
              dst         = var.exa_vcn2_cidrs
              dst_type    = "CIDR_BLOCK"
              icmp_type   = 3
              icmp_code   = 4
            }
          ]
        }
      }
      network_security_groups = {
        "EXA-VCN-2-CLIENT-NSG" = {
          display_name = "client-nsg"
          ingress_rules = merge(
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-SSH-${cidr}-RULE" =>
              {
                description  = "Allows SSH connections from hosts in ${cidr} VCN."
                stateless    = false
                protocol     = "TCP"
                src          = cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            },
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-SQLNET-${cidr}-RULE" =>
              {
                description = "Allows SQLNet connections from hosts in ${cidr} VCN."
                stateless   = false
                protocol    = "TCP"
                src         = cidr
                src_type    = "CIDR_BLOCK"
                dst_port_min : 1521
                dst_port_max : 1522
              }
            },
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-ONS-${cidr}-RULE" =>
              {
                description = "Allows Oracle Notification Services (ONS) communication from hosts in Hub VCN for Fast Application Notifications (FAN)."
                stateless   = false
                protocol    = "TCP"
                src         = cidr
                src_type    = "CIDR_BLOCK"
                dst_port_min : 6200,
                dst_port_max : 6200
              }
            },
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
            {
              "INGRESS-FROM-SQLNET-CLIENT-RULE" = {
                description = "Allows SQLNet connections from hosts in Client NSG."
                stateless   = false
                protocol    = "TCP"
                src         = "EXA-VCN-2-CLIENT-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 1521,
                dst_port_max : 1522
              }
            },
            {
              "INGRESS-FROM-ONS-CLIENT-RULE" = {
                description = "Allows Oracle Notification Services (ONS) communication from hosts in Client NSG for Fast Application Notifications (FAN)."
                stateless   = false
                protocol    = "TCP"
                src         = "EXA-VCN-2-CLIENT-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 6200,
                dst_port_max : 6200
              }
            }
          )
          egress_rules = {
            "EGRESS-TO-SSH-RULE" = {
              description  = "Allows SSH connections to hosts in Client NSG."
              stateless    = false
              protocol     = "TCP"
              dst          = "EXA-VCN-2-CLIENT-NSG"
              dst_type     = "NETWORK_SECURITY_GROUP"
              dst_port_min = 22
              dst_port_max = 22
            }
            "EGRESS-TO-SQLNET-RULE" = {
              description = "Allows SQLNet connections to hosts in Client NSG."
              stateless   = false
              protocol    = "TCP"
              dst         = "EXA-VCN-2-CLIENT-NSG"
              dst_type    = "NETWORK_SECURITY_GROUP"
              dst_port_min : 1521
              dst_port_max : 1522
            },
            "EGRESS-TO-ONS-RULE" = {
              description = "Allows Oracle Notification Services (ONS) communication to hosts in Client NSG for Fast Application Notifications (FAN)."
              stateless   = false
              protocol    = "TCP"
              dst         = "EXA-VCN-2-CLIENT-NSG"
              dst_type    = "NETWORK_SECURITY_GROUP"
              dst_port_min : 6200
              dst_port_max : 6200
            }
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
      }
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

  exa_vcn_3 = var.add_exa_vcn3 == true ? {
    "EXA-VCN-3" = {
      display_name                     = coalesce(var.exa_vcn3_name, "${var.service_label}-exadata-vcn-3")
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn3_cidrs,
      dns_label                        = replace(coalesce(var.exa_vcn3_dns, "${var.service_label}-exadata-vcn-3"), "-", "")
      block_nat_traffic                = false
      subnets = {
        "EXA-VCN-3-CLIENT-SUBNET" = {
          cidr_block                 = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exadata-vcn-3-client-subnet")
          dns_label                  = replace(coalesce(var.exa_vcn3_client_subnet_dns, "client-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "EXA-VCN-3-CLIENT-SUBNET-ROUTE-TABLE"
        }
        "EXA-VCN-3-BACKUP-SUBNET" = {
          cidr_block                 = coalesce(var.exa_vcn3_backup_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 1))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.exa_vcn3_backup_subnet_name, "${var.service_label}-exadata-vcn-3-backup-subnet")
          dns_label                  = replace(coalesce(var.exa_vcn3_backup_subnet_dns, "backup-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "EXA-VCN-3-BACKUP-SUBNET-ROUTE-TABLE"
        }
      }
      route_tables = {
        "EXA-VCN-3-CLIENT-SUBNET-ROUTE-TABLE" = {
          display_name = "client-subnet-route-table"
          route_rules = merge(
            {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-3-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            },
            {
              "ANYWHERE-RULE" = { # TODO: need a good name
                network_entity_key = "HUB-DRG"
                description        = "Traffic destined to ${local.anywhere} goes to DRG."
                destination        = local.anywhere
                destination_type   = "CIDR_BLOCK"
              }
            },
            { for cidr in var.exa_vcn1_cidrs : "EXA-VCN-1-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-1"))
            },
            { for cidr in var.exa_vcn2_cidrs : "EXA-VCN-2-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-2"))
            },
            { for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1"))
            },
            { for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-2"))
            },
            { for cidr in var.tt_vcn3_cidrs : "TT-VCN-3-${cidr}-RULE" =>
              {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
              } if local.hub_options[var.hub_options] != 0 && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-3"))
            }
          )
        }
        "EXA-VCN-3-BACKUP-SUBNET-ROUTE-TABLE" = {
          display_name = "backup-subnet-route-table"
          route_rules = merge(
            {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-3-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            }
          )
        }
      }
      security_lists = {
        "EXA-VCN-3-CLIENT-SUBNET-SL" = {
          display_name = "${coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exadata-vcn-3-client-subnet")}-security-list"
          ingress_rules = [
            {
              description = "Allows SSH connections from hosts in Exadata client subnet."
              stateless   = false
              protocol    = "TCP"
              src         = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 9, 96))
              src_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            }
          ]
          egress_rules = [
            {
              description = "Allows SSH connections to hosts in Exadata client subnet."
              stateless   = false
              protocol    = "TCP"
              dst         = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 9, 96))
              dst_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            },
            {
              description = "Allows the initiation of ICMP connections to hosts in Exadata VCN."
              stateless   = false
              protocol    = "UDP"
              dst         = var.exa_vcn3_cidrs
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
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-SSH-${cidr}-RULE" =>
              {
                description  = "Allows SSH connections from hosts in ${cidr} VCN."
                stateless    = false
                protocol     = "TCP"
                src          = cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            },
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-SQLNET-${cidr}-RULE" =>
              {
                description = "Allows SQLNet connections from hosts in ${cidr} VCN."
                stateless   = false
                protocol    = "TCP"
                src         = cidr
                src_type    = "CIDR_BLOCK"
                dst_port_min : 1521
                dst_port_max : 1522
              }
            },
            { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-ONS-${cidr}-RULE" =>
              {
                description = "Allows Oracle Notification Services (ONS) communication from hosts in Hub VCN for Fast Application Notifications (FAN)."
                stateless   = false
                protocol    = "TCP"
                src         = cidr
                src_type    = "CIDR_BLOCK"
                dst_port_min : 6200,
                dst_port_max : 6200
              }
            },
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
            {
              "INGRESS-FROM-SQLNET-CLIENT-RULE" = {
                description = "Allows SQLNet connections from hosts in Client NSG."
                stateless   = false
                protocol    = "TCP"
                src         = "EXA-VCN-3-CLIENT-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 1521,
                dst_port_max : 1522
              }
            },
            {
              "INGRESS-FROM-ONS-CLIENT-RULE" = {
                description = "Allows Oracle Notification Services (ONS) communication from hosts in Client NSG for Fast Application Notifications (FAN)."
                stateless   = false
                protocol    = "TCP"
                src         = "EXA-VCN-3-CLIENT-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 6200,
                dst_port_max : 6200
              }
            }
          )
          egress_rules = {
            "EGRESS-TO-SSH-RULE" = {
              description  = "Allows SSH connections to hosts in Client NSG."
              stateless    = false
              protocol     = "TCP"
              dst          = "EXA-VCN-3-CLIENT-NSG"
              dst_type     = "NETWORK_SECURITY_GROUP"
              dst_port_min = 22
              dst_port_max = 22
            }
            "EGRESS-TO-SQLNET-RULE" = {
              description = "Allows SQLNet connections to hosts in Client NSG."
              stateless   = false
              protocol    = "TCP"
              dst         = "EXA-VCN-3-CLIENT-NSG"
              dst_type    = "NETWORK_SECURITY_GROUP"
              dst_port_min : 1521
              dst_port_max : 1522
            },
            "EGRESS-TO-ONS-RULE" = {
              description = "Allows Oracle Notification Services (ONS) communication to hosts in Client NSG for Fast Application Notifications (FAN)."
              stateless   = false
              protocol    = "TCP"
              dst         = "EXA-VCN-3-CLIENT-NSG"
              dst_type    = "NETWORK_SECURITY_GROUP"
              dst_port_min : 6200
              dst_port_max : 6200
            }
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
}