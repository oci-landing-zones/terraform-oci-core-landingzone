locals {

  exa_vcn_2 = var.add_exa_vcn2 == true ? {
    "EXA-VCN-2" = {
      display_name                     = coalesce(var.exa_vcn2_name, "${var.service_label}-exadata-vcn-2")
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn2_cidrs,
      dns_label                        = replace(coalesce(var.exa_vcn2_dns, "exa-vcn-2"), "-", "")
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
            (local.hub_options[var.hub_deployment_option] != 3 && local.hub_options[var.hub_deployment_option] != 4) ? {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-2-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
              } : {
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        = "Route to HUB DRG"
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            },
            local.exa_vcn_2_drg_routing
          )
        },
        "EXA-VCN-2-BACKUP-SUBNET-ROUTE-TABLE" = {
          display_name = "backup-subnet-route-table"
          route_rules = merge(
            (local.hub_options[var.hub_deployment_option] != 3 && local.hub_options[var.hub_deployment_option] != 4) ? {
              "OSN-RULE" = {
                network_entity_key = "EXA-VCN-2-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services" # TODO: confirm if it's objectstorage or all-services
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
              } : {
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        = "Route to HUB DRG"
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
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
              description  = "Allows SSH connections from hosts in Exadata client subnet."
              stateless    = false
              protocol     = "TCP"
              src          = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 9, 96))
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
              dst          = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 9, 96))
              dst_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            },
            {
              description = "Allows the initiation of ICMP connections to hosts in Exadata VCN."
              stateless   = false
              protocol    = "UDP"
              dst         = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 9, 96))
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
              } if(local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) && var.exa_vcn2_attach_to_drg == true && var.add_exa_vcn2 == true
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
            },
            local.exa_vcn_2_to_client_subnet_cross_vcn_ingress
          ),
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
            {
              "EGRESS-TO-SQLNET-RULE" = {
                description = "Allows SQLNet connections to hosts in Client NSG."
                stateless   = false
                protocol    = "TCP"
                dst         = "EXA-VCN-2-CLIENT-NSG"
                dst_type    = "NETWORK_SECURITY_GROUP"
                dst_port_min : 1521
                dst_port_max : 1522
              }
            },
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
            },
            local.exa_vcn_2_to_client_subnet_cross_vcn_egress,
            local.exa_vcn_2_to_workers_subnet_cross_vcn_egress,
            local.exa_vcn_2_to_services_subnet_cross_vcn_egress,
            local.exa_vcn_2_to_pods_subnet_cross_vcn_egress,
            local.exa_vcn_2_to_web_subnet_cross_vcn_egress,
            local.exa_vcn_2_to_app_subnet_cross_vcn_egress,
            local.exa_vcn_2_to_db_subnet_cross_vcn_egress
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

  ## VCN routing thru DRG is dependent on some factors:
  ## 1) If there's a Hub VCN (3 or 4), the route to DRG is always enabled, because the Firewall in the Hub VCN will constrain traffic appropriately.
  ## 2) If there's no Hub VCN (1 or 2), the route to DRG is enabled by default or if explicitly configured via the 'exa_vcn2_routable_vcns' attribute.
  ## Explicitly setting 'exa_vcn2_routable_vcns' constrains routing to provided VCNs only.
  exa_vcn_2_drg_routing = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1"))) ? {
      for cidr in var.exa_vcn1_cidrs : "EXA-VCN-1-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},

    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3"))) ? {
      for cidr in var.exa_vcn3_cidrs : "EXA-VCN-3-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},

    ## EXA-VCN-2 to TT-VCNs
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1"))) ? {
      for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},

    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2"))) ? {
      for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},

    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3"))) ? {
      for cidr in var.tt_vcn3_cidrs : "TT-VCN-3-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},

    ## EXA-VCN-2 to OKE-VCNs
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1"))) ? {
      for cidr in var.oke_vcn1_cidrs : "OKE-VCN-1-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},

    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2"))) ? {
      for cidr in var.oke_vcn2_cidrs : "OKE-VCN-2-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},

    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3"))) ? {
      for cidr in var.oke_vcn3_cidrs : "OKE-VCN-3-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
        network_entity_key = "HUB-DRG"
        description        = "To DRG."
        destination        = cidr
        destination_type   = "CIDR_BLOCK"
      }
    } : {},
  )

  #### Cross VCN NSG Rules
  ### EXA-VCN-2:
  ## Egress Rules
  ## These rules are subject to the same conditions as the routing for EXA-VCN-2, also expressed in exa_vcn_2_drg_routing variable.
  exa_vcn_2_to_client_subnet_cross_vcn_egress = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1"))) ? {
      "EGRESS-TO-VCN-1-CLIENT-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exa-vcn-1-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
      /* port 6200 likely not needed in cross-vcn use case; commenting out
      "EGRESS-TO-VCN-1-CLIENT-SUBNET-ONS-RULE" = {
        description  = "Egress to ${coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exa-vcn-1-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 6200
        dst_port_max = 6200
      } */
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3"))) ? {
      "EGRESS-TO-VCN-3-CLIENT-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exa-vcn-3-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
      /* port 6200 likely not needed in cross-vcn use case; commenting out
      "EGRESS-TO-VCN-3-CLIENT-SUBNET-ONS-RULE" = {
        description  = "Egress to ${coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exa-vcn-3-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 6200
        dst_port_max = 6200
      } */
    } : {}
  )

  ## EXA-VCN-2 to TT-VCN EGRESS
  exa_vcn_2_to_web_subnet_cross_vcn_egress = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1"))) ? {
      "EGRESS-TO-TT-VCN-1-WEB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn1_web_subnet_name, "${var.service_label}-tt-vcn-1-web-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn1_web_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2"))) ? {
      "EGRESS-TO-TT-VCN-2-WEB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn2_web_subnet_name, "${var.service_label}-tt-vcn-2-web-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn2_web_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3"))) ? {
      "EGRESS-TO-TT-VCN-3-WEB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn3_web_subnet_name, "${var.service_label}-tt-vcn-3-web-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn3_web_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 0))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )

  exa_vcn_2_to_app_subnet_cross_vcn_egress = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1"))) ? {
      "EGRESS-TO-TT-VCN-1-APP-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn1_app_subnet_name, "${var.service_label}-tt-vcn-1-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2"))) ? {
      "EGRESS-TO-TT-VCN-2-APP-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn2_app_subnet_name, "${var.service_label}-tt-vcn-2-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3"))) ? {
      "EGRESS-TO-TT-VCN-3-APP-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn3_app_subnet_name, "${var.service_label}-tt-vcn-3-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )

  exa_vcn_2_to_db_subnet_cross_vcn_egress = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1"))) ? {
      "EGRESS-TO-TT-VCN-1-DB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn1_db_subnet_name, "${var.service_label}-tt-vcn-1-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2"))) ? {
      "EGRESS-TO-TT-VCN-2-DB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn2_db_subnet_name, "${var.service_label}-tt-vcn-2-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3"))) ? {
      "EGRESS-TO-TT-VCN-3-DB-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.tt_vcn3_db_subnet_name, "${var.service_label}-tt-vcn-3-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )

  ## EXA-VCN-2 to OKE-VCN EGRESS
  exa_vcn_2_to_workers_subnet_cross_vcn_egress = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1"))) ? {
      "EGRESS-TO-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn1_workers_subnet_name, "${var.service_label}-oke-vcn-1-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2"))) ? {
      "EGRESS-TO-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn2_workers_subnet_name, "${var.service_label}-oke-vcn-2-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3"))) ? {
      "EGRESS-TO-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn3_workers_subnet_name, "${var.service_label}-oke-vcn-3-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )
  exa_vcn_2_to_services_subnet_cross_vcn_egress = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1"))) ? {
      "EGRESS-TO-OKE-VCN-1-SERVICES-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn1_services_subnet_name, "${var.service_label}-oke-vcn-1-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn1_services_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2"))) ? {
      "EGRESS-TO-OKE-VCN-2-SERVICES-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn2_services_subnet_name, "${var.service_label}-oke-vcn-2-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn2_services_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3"))) ? {
      "EGRESS-TO-OKE-VCN-3-SERVICES-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn3_services_subnet_name, "${var.service_label}-oke-vcn-3-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn3_services_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 2))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )
  exa_vcn_2_to_pods_subnet_cross_vcn_egress = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (upper(var.oke_vcn1_cni_type) == "NATIVE") &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1"))) ? {
      "EGRESS-TO-OKE-VCN-1-PODS-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn2_pods_subnet_name, "${var.service_label}-oke-vcn-2-pods-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn1_pods_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 3, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (upper(var.oke_vcn2_cni_type) == "NATIVE") &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2"))) ? {
      "EGRESS-TO-OKE-VCN-2-PODS-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn2_pods_subnet_name, "${var.service_label}-oke-vcn-2-pods-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (upper(var.oke_vcn3_cni_type) == "NATIVE") &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3"))) ? {
      "EGRESS-TO-OKE-VCN-3-PODS-SUBNET-RULE" = {
        description  = "Egress to ${coalesce(var.oke_vcn3_pods_subnet_name, "${var.service_label}-oke-vcn-3-pods-subnet")}."
        stateless    = false
        protocol     = "TCP"
        dst          = coalesce(var.oke_vcn3_pods_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 3, 1))
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 443
        dst_port_max = 443
      }
    } : {}
  )

  ## Ingress rules
  exa_vcn_2_to_client_subnet_cross_vcn_ingress = merge(
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1"))) ? {
      "INGRESS-FROM-EXA-VCN-1-CLIENT-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exa-vcn-1-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
      /* port 6200 likely not needed in cross-vcn use case; commenting out
      "INGRESS-FROM-EXA-VCN-1-CLIENT-SUBNET-ONS-RULE" = {
        description  = "Ingress from ${coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exa-vcn-1-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 6200
        dst_port_max = 6200
      }, */
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3"))) ? {
      "INGRESS-FROM-EXA-VCN-3-CLIENT-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exa-vcn-3-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
      /* port 6200 likely not needed in cross-vcn use case; commenting out
      "INGRESS-FROM-EXA-VCN-3-CLIENT-SUBNET-ONS-RULE" = {
        description  = "Ingress from ${coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exa-vcn-3-client-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 6200
        dst_port_max = 6200
      }, */
    } : {},

    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1"))) ? {
      "INGRESS-FROM-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn2_workers_subnet_name, "${var.service_label}-oke-vcn-2-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
      "INGRESS-FROM-OKE-VCN-1-SERVICES-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn1_services_subnet_name, "${var.service_label}-oke-vcn-1-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn1_services_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 2))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (upper(var.oke_vcn2_cni_type) == "NATIVE") &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1"))) ? {
      "INGRESS-FROM-OKE-VCN-1-PODS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn1_pods_subnet_name, "${var.service_label}-oke-vcn-1-pods-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn1_pods_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 3, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},

    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2"))) ? {
      "INGRESS-FROM-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn2_workers_subnet_name, "${var.service_label}-oke-vcn-2-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
      "INGRESS-FROM-OKE-VCN-2-SERVICES-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn2_services_subnet_name, "${var.service_label}-oke-vcn-2-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn2_services_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 2))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
    (upper(var.oke_vcn2_cni_type) == "NATIVE") &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2"))) ? {
      "INGRESS-FROM-OKE-VCN-2-PODS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn2_pods_subnet_name, "${var.service_label}-oke-vcn-2-pods-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3"))) ? {
      "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn3_workers_subnet_name, "${var.service_label}-oke-vcn-3-workers-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
      "INGRESS-FROM-OKE-VCN-3-SERVICES-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn3_services_subnet_name, "${var.service_label}-oke-vcn-3-services-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn3_services_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 2))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (upper(var.oke_vcn3_cni_type) == "NATIVE") &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3"))) ? {
      "INGRESS-FROM-OKE-VCN-3-PODS-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.oke_vcn3_pods_subnet_name, "${var.service_label}-oke-vcn-3-pods-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.oke_vcn3_pods_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 3, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1"))) ? {
      "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn1_app_subnet_name, "${var.service_label}-tt-vcn-1-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1"))) ? {
      "INGRESS-FROM-TT-VCN-1-DB-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn1_db_subnet_name, "${var.service_label}-tt-vcn-1-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2"))) ? {
      "INGRESS-FROM-TT-VCN-2-APP-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn2_app_subnet_name, "${var.service_label}-tt-vcn-2-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2"))) ? {
      "INGRESS-FROM-TT-VCN-2-DB-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn2_db_subnet_name, "${var.service_label}-tt-vcn-2-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3"))) ? {
      "INGRESS-FROM-TT-VCN-3-APP-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn3_app_subnet_name, "${var.service_label}-tt-vcn-3-app-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 1))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      },
    } : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_options[var.hub_deployment_option] == 3 || local.hub_options[var.hub_deployment_option] == 4) ||
    ((local.hub_options[var.hub_deployment_option] == 1 || local.hub_options[var.hub_deployment_option] == 2) && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3"))) ? {
      "INGRESS-FROM-TT-VCN-3-DB-SUBNET-RULE" = {
        description  = "Ingress from ${coalesce(var.tt_vcn3_db_subnet_name, "${var.service_label}-tt-vcn-3-db-subnet")}."
        stateless    = false
        protocol     = "TCP"
        src          = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 2))
        src_type     = "CIDR_BLOCK"
        dst_port_min = 1521
        dst_port_max = 1522
      }
    } : {},
  )
}