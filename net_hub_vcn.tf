# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  hub_vcn_display_name                 = coalesce(var.hub_vcn_name, "${var.service_label}-hub-vcn")
  hub_vcn_dns_label                    = substr(replace(coalesce(var.hub_vcn_name, "hub-vcn"), "/[^\\w]/", ""), 0, 14)
  hub_vcn_web_subnet_display_name      = coalesce(var.hub_vcn_web_subnet_name, "${var.service_label}-hub-vcn-web-subnet")
  hub_vcn_web_subnet_dns_label         = substr(replace(coalesce(var.hub_vcn_web_subnet_name, "web-subnet"), "/[^\\w]/", ""), 0, 14)
  hub_vcn_web_subnet_cidr              = coalesce(var.hub_vcn_web_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 0))
  hub_vcn_outdoor_subnet_display_name  = coalesce(var.hub_vcn_outdoor_subnet_name, "${var.service_label}-hub-vcn-outdoor-subnet")
  hub_vcn_outdoor_subnet_dns_label     = substr(replace(coalesce(var.hub_vcn_outdoor_subnet_name, "outdoor-subnet"), "/[^\\w]/", ""), 0, 14)
  hub_vcn_outdoor_subnet_cidr          = coalesce(var.hub_vcn_outdoor_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 1))
  hub_vcn_indoor_subnet_display_name   = coalesce(var.hub_vcn_indoor_subnet_name, "${var.service_label}-hub-vcn-indoor-subnet")
  hub_vcn_indoor_subnet_dns_label      = substr(replace(coalesce(var.hub_vcn_indoor_subnet_name, "indoor-subnet"), "/[^\\w]/", ""), 0, 14)
  hub_vcn_indoor_subnet_cidr           = coalesce(var.hub_vcn_indoor_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 2))
  hub_vcn_mgmt_subnet_display_name     = coalesce(var.hub_vcn_mgmt_subnet_name, "${var.service_label}-hub-vcn-mgmt-subnet")
  hub_vcn_mgmt_subnet_dns_label        = substr(replace(coalesce(var.hub_vcn_mgmt_subnet_name, "mgmt-subnet"), "/[^\\w]/", ""), 0, 14)
  hub_vcn_mgmt_subnet_cidr             = coalesce(var.hub_vcn_mgmt_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 3))
  hub_vcn_jumphost_subnet_display_name = coalesce(var.hub_vcn_jumphost_subnet_name, "${var.service_label}-hub-vcn-jumphost-subnet")
  hub_vcn_jumphost_subnet_dns_label    = substr(replace(coalesce(var.hub_vcn_jumphost_subnet_name, "jumphost-subnet"), "/[^\\w]/", ""), 0, 14)
  hub_vcn_jumphost_subnet_cidr         = coalesce(var.hub_vcn_jumphost_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 4))

  hub_vcn_allowed_cidrs_into_web_tier          = var.hub_vcn_web_subnet_is_private == true ? toset(var.onprem_cidrs) : toset(concat(var.onprem_cidrs, var.hub_vcn_external_allowed_cidrs_into_web_tier))
  hub_vcn_allowed_cidrs_to_ports_into_web_tier = local.hub_with_vcn == true ? flatten([for cidr in local.hub_vcn_allowed_cidrs_into_web_tier : [for port in var.hub_vcn_web_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(local.hub_vcn_allowed_cidrs_into_web_tier) > 0 && length(var.hub_vcn_web_ingress_destination_ports) > 0]) : []
  fw_mgmt_external_allowed_cidrs_to_ports      = local.chosen_firewall_option != "OCINFW" ? flatten([for cidr in var.allowed_onprem_cidrs_to_fw_mgmt_interface : [for port in var.fw_mgmt_interface_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.allowed_onprem_cidrs_to_fw_mgmt_interface) > 0 && length(var.fw_mgmt_interface_ports) > 0]) : []

  hub_vcn = local.hub_with_vcn == true ? { # local variable hub_with_vcn is defined in net_hub_drg.tf.
    "HUB-VCN" = {
      enable_cis_checks                = false # This is consciously done here to let any traffic to enter the firewall for inspection.
      display_name                     = local.hub_vcn_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.hub_vcn_cidrs
      dns_label                        = local.hub_vcn_dns_label
      block_nat_traffic                = false
      security                         = local.enable_zpr == true ? { zpr_attributes = [{ namespace : "${local.zpr_namespace_name}", attr_name : "net", attr_value : "hub-vcn" }] } : null

      subnets = merge(
        {
          "WEB-SUBNET" = {
            cidr_block                = local.hub_vcn_web_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.hub_vcn_web_subnet_display_name
            dns_label                 = local.hub_vcn_web_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = false
            route_table_key           = "WEB-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.hub_vcn_web_subnet_security_list != null ? ["WEB-SUB-SL"] : []
          }
        },
        local.chosen_firewall_option != "OCINFW" ? {
          "OUTDOOR-SUBNET" = {
            cidr_block                = local.hub_vcn_outdoor_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.hub_vcn_outdoor_subnet_display_name
            dns_label                 = local.hub_vcn_outdoor_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = local.hub_vcn_outdoor_subnet_private
            route_table_key           = "OUTDOOR-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.hub_vcn_outdoor_subnet_security_list != null ? ["OUTDOOR-SUB-SL"] : []
          }
        } : {},
        {
          "INDOOR-SUBNET" = {
            cidr_block                = local.hub_vcn_indoor_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.hub_vcn_indoor_subnet_display_name
            dns_label                 = local.hub_vcn_indoor_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "INDOOR-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.hub_vcn_indoor_subnet_security_list != null ? ["INDOOR-SUB-SL"] : []
          }
        },
        local.chosen_firewall_option != "OCINFW" ? {
          "MGMT-SUBNET" = {
            cidr_block                = local.hub_vcn_mgmt_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.hub_vcn_mgmt_subnet_display_name
            dns_label                 = local.hub_vcn_mgmt_subnet_dns_label
            ipv6cidr_blocks           = [],
            prohibit_internet_ingress = true
            route_table_key           = "MGMT-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["MGMT-SUB-SL"]
          }
        } : {},
        var.add_hub_vcn_jumphost_subnet == true ? {
          "JUMPHOST-SUBNET" = {
            cidr_block                = local.hub_vcn_jumphost_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.hub_vcn_jumphost_subnet_display_name
            dns_label                 = local.hub_vcn_jumphost_subnet_dns_label
            ipv6cidr_blocks           = [],
            prohibit_internet_ingress = true
            route_table_key           = "JUMPHOST-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["JUMPHOST-SUB-SL"]
          }
        } : {}
      ) # closing Subnets merge function   

      security_lists = merge(
        local.chosen_firewall_option != "OCINFW" ? {
          "MGMT-SUB-SL" = coalesce(local.hub_vcn_mgmt_subnet_security_list, {
            display_name = "mgmt-subnet-security-list"
            ingress_rules = [
              {
                description  = "Ingress from ${local.hub_vcn_mgmt_subnet_cidr} on HTTP port. Required for inbound port forwarding connections from OCI Bastion service to FW management interface."
                stateless    = false
                protocol     = "TCP"
                src          = local.hub_vcn_mgmt_subnet_cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
              }
            ]
            egress_rules = [
              {
                description  = "Egress to ${local.hub_vcn_mgmt_subnet_cidr} on HTTP port. Required for outbound port forwarding connections from OCI Bastion service to FW management interface."
                stateless    = false
                protocol     = "TCP"
                dst          = local.hub_vcn_mgmt_subnet_cidr
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
              }
            ]
          })
        } : {},
        var.add_hub_vcn_jumphost_subnet == true ? {
          "JUMPHOST-SUB-SL" = coalesce(local.hub_vcn_jumphost_subnet_security_list, {
            display_name = "jumphost-subnet-security-list"
            ingress_rules = [
              {
                description  = "Ingress from ${local.hub_vcn_jumphost_subnet_display_name} on SSH port. Required for inbound managed SSH connections from OCI Bastion service to jump host."
                stateless    = false
                protocol     = "TCP"
                src          = local.hub_vcn_jumphost_subnet_cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
            egress_rules = [
              {
                description  = "Egress to ${local.hub_vcn_jumphost_subnet_display_name} on SSH port. Required for outbound managed SSH connections from OCI Bastion service to jump host."
                stateless    = false
                protocol     = "TCP"
                dst          = local.hub_vcn_jumphost_subnet_cidr
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
          })
        } : {},
        # Security lists overrides
        local.hub_vcn_web_subnet_security_list != null ? {
          "WEB-SUB-SL" = local.hub_vcn_web_subnet_security_list
        } : {},
        local.hub_vcn_outdoor_subnet_security_list != null ? {
          "OUTDOOR-SUB-SL" = local.hub_vcn_outdoor_subnet_security_list
        } : {},
        local.hub_vcn_indoor_subnet_security_list != null ? {
          "INDOOR-SUB-SL" = local.hub_vcn_indoor_subnet_security_list
        } : {}
      ) # closing Security List merge function        

      route_tables = merge(
        {
          "WEB-SUBNET-ROUTE-TABLE" = {
            display_name = "web-subnet-route-table"
            route_rules = merge(
              var.hub_vcn_enable_internet_gateway ? {
                "INTERNET-RULE" = {
                  network_entity_key = "HUB-VCN-INTERNET-GATEWAY"
                  description        = "Traffic destined for networks outside the VCN is routed through the Internet Gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {},
              local.spoke_subnets_routing
            )
          }
        },
        local.chosen_firewall_option != "OCINFW" ? {
          "OUTDOOR-SUBNET-ROUTE-TABLE" = {
            display_name = "outdoor-subnet-route-table"
            route_rules = {
              "OSN-RULE" = {
                network_entity_key = "HUB-VCN-SERVICE-GATEWAY"
                description        = "Traffic destined for ${local.hub_vcn_outdoor_subnet_private ? "all OCI services" : "OCI Object Storage service"} in Oracle Services Network is routed through the Service Gateway."
                destination        = local.hub_vcn_outdoor_subnet_private ? "all-services" : "objectstorage"
                destination_type   = "SERVICE_CIDR_BLOCK"
              },
              "EVERYWHERE-ELSE-RULE" = {
                network_entity_key = local.hub_vcn_outdoor_subnet_private ? "HUB-VCN-NAT-GATEWAY" : "HUB-VCN-INTERNET-GATEWAY"
                description        = "Traffic destined for networks outside the VCN is routed through the ${local.hub_vcn_outdoor_subnet_private ? "NAT" : "Internet"} Gateway."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          }
        } : {},
        {
          "INDOOR-SUBNET-ROUTE-TABLE" = {
            display_name = "indoor-subnet-route-table"
            route_rules = merge(
              {
                "OSN-RULE" = {
                  network_entity_key = "HUB-VCN-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                },
                "DRG-RULE" = {
                  network_entity_key = "HUB-DRG"
                  description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              }
            )
          }
        },
        local.chosen_firewall_option != "OCINFW" ? {
          "MGMT-SUBNET-ROUTE-TABLE" = {
            display_name = "mgmt-subnet-route-table"
            route_rules = merge(
              {
                "OSN-RULE" = {
                  network_entity_key = "HUB-VCN-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              # We don't route thru firewall because eventual problems with the firewall itself can lock admins out of mgmt interfaces.
              { for cidr in toset(concat(var.onprem_cidrs, var.allowed_onprem_cidrs_to_fw_mgmt_interface)) : "ON-PREM-${cidr}-RULE" => {
                network_entity_key = "HUB-DRG" # FW admins can connect from on-prem to the management subnet through the DRG.
                description        = "Traffic destined for on-prem CIDR ${cidr} is routed through the DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
                }
              },
              {
                "EVERYWHERE-ELSE-RULE" = {
                  network_entity_key = "HUB-VCN-NAT-GATEWAY"
                  description        = "Traffic destined for networks outside the VCN is routed through the NAT GAteway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              }
            )
          }
        } : {},
        var.add_hub_vcn_jumphost_subnet == true ? {
          "JUMPHOST-SUBNET-ROUTE-TABLE" = {
            display_name = "jumphost-subnet-route-table"
            route_rules = merge(
              {
                "OSN-RULE" = {
                  network_entity_key = "HUB-VCN-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid, local.void) != local.void ? {
                "EVERYWHERE-ELSE-RULE" = {
                  network_entity_id = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid)
                  description       = "Traffic destined for networks outside the VCN is routed through the private IP address ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined") : coalesce(data.oci_core_private_ip.indoor_nlb[0].ip_address, "undetermined")}."
                  destination       = "0.0.0.0/0"
                  destination_type  = "CIDR_BLOCK"
                }
              } : {}
            )
          }
        } : {},
        # HUB-VCN-INGRESS-ROUTE-TABLE gets attached as the ingress route table of Hub VCN DRG attachment (see net_hub_drg.tf). It controls where traffic that enters the Hub VCN via its DRG attachment is routed to.
        {
          "HUB-VCN-INGRESS-ROUTE-TABLE" = {
            display_name = "hub-vcn-ingress-route-table"
            route_rules = merge(
              {
                "OSN-RULE" = {
                  network_entity_key = "HUB-VCN-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              var.add_hub_vcn_jumphost_subnet == true && coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid, local.void) != local.void ? {
                "JUMP-HOST-SUBNET-RULE" = { # Required for routing traffic destined to the jump host subnet in the Hub VCN. Without this, traffic doesn't reach the firewall because local VCN routes kick in first.
                  description       = "Traffic destined for ${local.hub_vcn_jumphost_subnet_display_name} is routed through the private IP address ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined") : coalesce(data.oci_core_private_ip.indoor_nlb[0].ip_address, "undetermined")}."
                  destination       = local.hub_vcn_jumphost_subnet_cidr
                  destination_type  = "CIDR_BLOCK"
                  network_entity_id = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid)
                }
              } : {},
              coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid, local.void) != local.void ? {
                "WEB-SUBNET-RULE" = { # Required for routing traffic destined to the web subnet in the Hub VCN. Without this, traffic doesn't reach the firewall because local VCN routes kick in first.
                  description       = "Traffic destined for ${local.hub_vcn_web_subnet_display_name} is routed through the private IP address ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined") : coalesce(data.oci_core_private_ip.indoor_nlb[0].ip_address, "undetermined")}."
                  destination       = local.hub_vcn_web_subnet_cidr
                  destination_type  = "CIDR_BLOCK"
                  network_entity_id = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid)
                }
              } : {},
              coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid, local.void) != local.void ? {
                "EVERYWHERE-ELSE-RULE" = {
                  description       = "Traffic destined for networks outside the VCN is routed through the private IP address ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined") : coalesce(data.oci_core_private_ip.indoor_nlb[0].ip_address, "undetermined")}."
                  destination       = "0.0.0.0/0"
                  destination_type  = "CIDR_BLOCK"
                  network_entity_id = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid)
                }
              } : {}
            )
          }
        },
        coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid, local.void) != local.void ? {
          "HUB-VCN-NAT-GATEWAY-ROUTE-TABLE" = {
            display_name = "nat-gateway-route-table"
            route_rules = {
              "EVERYWHERE-ELSE-RULE" = {
                network_entity_id = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid)
                description       = "Traffic destined for networks outside the VCN is routed through the private IP address ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined") : coalesce(data.oci_core_private_ip.indoor_nlb[0].ip_address, "undetermined")}."
                destination       = "0.0.0.0/0"
                destination_type  = "CIDR_BLOCK"
              }
            }
          }
        } : {},
      ) # closing Route Table merge function

      network_security_groups = merge(
        local.chosen_firewall_option != "OCINFW" ? {
          "HUB-VCN-OUTDOOR-NLB-NSG" = {
            display_name  = "outdoor-nlb-nsg"
            ingress_rules = local.hub_vcn_outdoor_nlb_nsg_ingress_rules
            egress_rules  = local.hub_vcn_outdoor_nsg_egress_rules
          }
        } : {},
        local.chosen_firewall_option != "OCINFW" ? {
          "HUB-VCN-OUTDOOR-FW-NSG" = {
            display_name  = "outdoor-fw-nsg"
            ingress_rules = local.hub_vcn_outdoor_fw_nsg_ingress_rules
            egress_rules  = local.hub_vcn_outdoor_nsg_egress_rules
          }
        } : {},
        local.chosen_firewall_option != "OCINFW" ? {
          "HUB-VCN-INDOOR-NLB-NSG" = {
            display_name  = "indoor-nlb-nsg"
            ingress_rules = local.hub_vcn_indoor_nsg_ingress_rules
            egress_rules  = local.hub_vcn_indoor_nsg_egress_rules
          }
        } : {},
        local.chosen_firewall_option != "OCINFW" ? {
          "HUB-VCN-INDOOR-FW-NSG" = {
            display_name  = "indoor-fw-nsg"
            ingress_rules = local.hub_vcn_indoor_nsg_ingress_rules
            egress_rules  = local.hub_vcn_indoor_nsg_egress_rules
          }
        } : {},
        local.chosen_firewall_option != "OCINFW" ? {
          "HUB-VCN-MGMT-NSG" = {
            display_name = "mgmt-nsg"
            ingress_rules = merge(
              { for cidr_port_pair in local.fw_mgmt_external_allowed_cidrs_to_ports : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
                description  = "Ingress from ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
                stateless    = false
                protocol     = split(":", split(",", cidr_port_pair)[1])[0]
                src          = split(",", cidr_port_pair)[0]
                src_type     = "CIDR_BLOCK"
                dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? (split(":", split(",", cidr_port_pair)[1])[1] == "ALL" ? null : split(":", split(",", cidr_port_pair)[1])[1]) : null
                dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? (split(":", split(",", cidr_port_pair)[1])[1] == "ALL" ? null : split(":", split(",", cidr_port_pair)[1])[1]) : null
                icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
                icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
              } },
              var.add_hub_vcn_jumphost_subnet == true ? {
                "INGRESS-FROM-JUMP-HOST-NSG-SSH-RULE" = {
                  description  = "Ingress from Jump Host NSG to SSH port. Required by hosts deployed in the Jump Host NSG."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "HUB-VCN-JUMP-HOST-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
              } } : {}
            )
          }
        } : {},
        var.add_hub_vcn_jumphost_subnet == true ? {
          "HUB-VCN-JUMP-HOST-NSG" = {
            display_name = "jump-host-nsg"
            ingress_rules = merge(
              {
                for cidr in var.onprem_cidrs : "INGRESS-FROM-${cidr}-RULE" => {
                  description  = "Ingress from ${cidr} on port 22. Allows inbound SSH access for on-prem IP addresses"
                  stateless    = false
                  protocol     = "TCP"
                  src          = cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22,
                  dst_port_max = 22
                }
              }
            )
            egress_rules = merge(
              local.chosen_firewall_option != "OCINFW" ? { # Only FW network appliances have management interfaces in the management NSG.
                "EGRESS-TO-FW-MGMT-NSG-SSH-RULE" = {
                  description  = "Egress to FW Mgmt NSG"
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "HUB-VCN-MGMT-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              {
                "EGRESS-TO-OSN-RULE" = {
                  description  = "Egress to Oracle Services Network."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "all-services"
                  dst_type     = "SERVICE_CIDR_BLOCK"
                  dst_port_min = 443
                  dst_port_max = 443
                }
              },
              ## Egress to TT-VCN - SSH traffic
              local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-TT-VCN-1-APP-SUBNET-RULE" = {
                  description  = "Egress to ${local.tt_vcn1_app_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.tt_vcn1_app_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-TT-VCN-2-APP-SUBNET-RULE" = {
                  description  = "Egress to ${local.tt_vcn2_app_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.tt_vcn2_app_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-TT-VCN-3-APP-SUBNET-RULE" = {
                  description  = "Egress to ${local.tt_vcn3_app_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0], 4, 1))
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-TT-VCN-1-DB-SUBNET-RULE" = {
                  description  = "Egress to ${local.tt_vcn1_db_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.tt_vcn1_db_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-TT-VCN-2-DB-SUBNET-RULE" = {
                  description  = "Egress to ${local.tt_vcn2_db_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.tt_vcn2_db_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-TT-VCN-3-DB-SUBNET-RULE" = {
                  description  = "Egress to ${local.tt_vcn3_db_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.tt_vcn3_db_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              ## Egress to OKE VCN - SSH traffic
              var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
                  description  = "Egress to ${local.oke_vcn1_workers_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.oke_vcn1_workers_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
                  description  = "Egress to ${local.oke_vcn2_workers_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.oke_vcn2_workers_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
                  description  = "Egress to ${local.oke_vcn3_workers_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.oke_vcn3_workers_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              ## Egress to EXA-VCN - SSH traffic
              var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-EXA-VCN-1-CLIENT-SUBNET-RULE" = {
                  description  = "Egress to ${local.exa_vcn1_client_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.exa_vcn1_client_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-EXA-VCN-2-CLIENT-SUBNET-RULE" = {
                  description  = "Egress to ${local.exa_vcn2_client_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.exa_vcn2_client_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && local.hub_with_vcn == true ? {
                "EGRESS-TO-EXA-VCN-3-CLIENT-SUBNET-RULE" = {
                  description  = "Egress to ${local.exa_vcn3_client_subnet_display_name}."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = local.exa_vcn3_client_subnet_cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              {
                for cidr in local.combined_workload_cidrs : "EGRESS-TO-WORKLOAD-${cidr}-RULE" => {
                  description  = "Egress to Workload VCN CIDR ${cidr} for SSH."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = cidr
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              }
            )
          }
        } : {},
        local.chosen_firewall_option == "OCINFW" ? {
          "HUB-VCN-OCI-FIREWALL-NSG" = {
            display_name  = "oci-firewall-nsg"
            ingress_rules = local.hub_vcn_indoor_nsg_ingress_rules
            egress_rules  = local.hub_vcn_indoor_nsg_egress_rules
          }
        } : {},
        local.hub_vcn_cross_vcn_open_nsg,
        {
          "HUB-VCN-APP-LOAD-BALANCER-NSG" = {
            display_name = "app-load-balancer-nsg" # OCI Load Balancers further deployed in the hub VCN should be associated with this NSG.
            ingress_rules = coalesce(local.hub_vcn_app_load_balancer_nsg_ingress_rules, {
              for cidr_port_pair in local.hub_vcn_allowed_cidrs_to_ports_into_web_tier : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
                description  = "Ingress from ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
                stateless    = false
                protocol     = split(":", split(",", cidr_port_pair)[1])[0]
                src          = split(",", cidr_port_pair)[0]
                src_type     = "CIDR_BLOCK"
                dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
                dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
                icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
                icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
              }
            })
            egress_rules = coalesce(local.hub_vcn_app_load_balancer_nsg_egress_rules, local.hub_vcn_app_load_balancer_nsg_default_egress_rules)
          }
        },
        local.additional_nsgs_by_vcn["HUB-VCN"]
      ) # closing NSG merge function  

      vcn_specific_gateways = merge(
        var.hub_vcn_enable_internet_gateway ? {
          internet_gateways = {
            "HUB-VCN-INTERNET-GATEWAY" = {
              enabled      = true
              display_name = "internet-gateway"
            }
          }
        } : {},
        # Deploys NAT Gateway if chosen firewall option is OCINFW or if chosen firewall option is not OCINFW and the firewall does not have public interfaces (outdoor subnet is private, as then the NAT Gateway is required to allow outbound internet access through the outdoor - untrust - subnet).
        # When a 3rd-party firewall with public interface is deployed (outdoor subnet is public), there is no need for a NATGW, and the firewall talks to the Internet Gateway directly and virtually becomes a NAT Gateway.
        local.chosen_firewall_option == "OCINFW" || (local.chosen_firewall_option != "OCINFW" && local.hub_vcn_outdoor_subnet_private == true) ? {
          nat_gateways = {
            "HUB-VCN-NAT-GATEWAY" = {
              block_traffic   = false
              display_name    = "nat-gateway"
              route_table_key = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_east_west_entry_point_ocid, local.void) != local.void ? "HUB-VCN-NAT-GATEWAY-ROUTE-TABLE" : null
            }
          }
        } : {},
        {
          service_gateways = {
            "HUB-VCN-SERVICE-GATEWAY" = {
              display_name = "service-gateway"
              services     = "all-services"
            }
          }
        }
      )
    }
  } : null

  spoke_subnets_routing = merge(
    local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true ? { for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${cidr}-RULE" => {
      description        = "Traffic destined for ${local.tt_vcn1_display_name} CIDR ${cidr} is routed through ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined")}" : coalesce(var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.outdoor_nlb[0].ip_address, "undetermined")}" : "the DRG"}."
      destination        = "${cidr}"
      destination_type   = "CIDR_BLOCK"
      network_entity_id  = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid) : null
      network_entity_key = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) == local.void ? "HUB-DRG" : null
    } } : {},
    local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true ? { for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${cidr}-RULE" => {
      description        = "Traffic destined for ${local.tt_vcn2_display_name} CIDR ${cidr} is routed through ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined")}" : coalesce(var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.outdoor_nlb[0].ip_address, "undetermined")}" : "the DRG"}."
      destination        = "${cidr}"
      destination_type   = "CIDR_BLOCK"
      network_entity_id  = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid) : null
      network_entity_key = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) == local.void ? "HUB-DRG" : null
    } } : {},
    local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true ? { for cidr in var.tt_vcn3_cidrs : "TT-VCN-3-${cidr}-RULE" => {
      description        = "Traffic destined for ${local.tt_vcn3_display_name} CIDR ${cidr} is routed through ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined")}" : coalesce(var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.outdoor_nlb[0].ip_address, "undetermined")}" : "the DRG"}."
      destination        = "${cidr}"
      destination_type   = "CIDR_BLOCK"
      network_entity_id  = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid) : null
      network_entity_key = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) == local.void ? "HUB-DRG" : null
    } } : {},
    local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true ? { for cidr in var.oke_vcn1_cidrs : "OKE-VCN-1-${cidr}}-RULE" => {
      description        = "Traffic destined for ${local.oke_vcn1_display_name} CIDR ${cidr} is routed through ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined")}" : coalesce(var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.outdoor_nlb[0].ip_address, "undetermined")}" : "the DRG"}."
      destination        = "${cidr}"
      destination_type   = "CIDR_BLOCK"
      network_entity_id  = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid) : null
      network_entity_key = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) == local.void ? "HUB-DRG" : null
    } } : {},
    local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true ? { for cidr in var.oke_vcn2_cidrs : "OKE-VCN-2-${cidr}}-RULE" => {
      description        = "Traffic destined for ${local.oke_vcn2_display_name} CIDR ${cidr} is routed through ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined")}" : coalesce(var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.outdoor_nlb[0].ip_address, "undetermined")}" : "the DRG"}."
      destination        = "${cidr}"
      destination_type   = "CIDR_BLOCK"
      network_entity_id  = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid) : null
      network_entity_key = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) == local.void ? "HUB-DRG" : null
    } } : {},
    local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true ? { for cidr in var.oke_vcn3_cidrs : "OKE-VCN-3-${cidr}}-RULE" => {
      description        = "Traffic destined for ${local.oke_vcn3_display_name} CIDR ${cidr} is routed through ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined")}" : coalesce(var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.outdoor_nlb[0].ip_address, "undetermined")}" : "the DRG"}."
      destination        = "${cidr}"
      destination_type   = "CIDR_BLOCK"
      network_entity_id  = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid) : null
      network_entity_key = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) == local.void ? "HUB-DRG" : null
    } } : {},
    local.workload_cidrs_public != null ? { for cidr in local.workload_cidrs_public : "PUBLIC-ACCESS-VCN-${cidr}}-RULE" => {
      description        = "Traffic destined for VCN with CIDR ${cidr} is routed through ${coalesce(var.oci_nfw_ip_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.oci_firewall[0].ip_address, "undetermined")}" : coalesce(var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? "the private IP address ${coalesce(data.oci_core_private_ip.outdoor_nlb[0].ip_address, "undetermined")}" : "the DRG"}."
      destination        = "${cidr}"
      destination_type   = "CIDR_BLOCK"
      network_entity_id  = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) != local.void ? coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid) : null
      network_entity_key = coalesce(var.oci_nfw_ip_ocid, var.hub_vcn_north_south_entry_point_ocid, local.void) == local.void ? "HUB-DRG" : null
    } } : {}
  )

  ## Ingress rules:
  hub_vcn_indoor_nsg_ingress_rules = {
    "INGRESS-FROM-ANYWHERE-RULE" = {
      description = "Ingress from anywhere."
      stateless   = true
      protocol    = "ALL"
      src         = "0.0.0.0/0"
      src_type    = "CIDR_BLOCK"
    }
  }

  ## Egress rules:
  hub_vcn_indoor_nsg_egress_rules = {
    "EGRESS-TO-ANYWHERE-RULE" = {
      description = "Egress to anywhere."
      stateless   = true
      protocol    = "ALL"
      dst         = "0.0.0.0/0"
      dst_type    = "CIDR_BLOCK"
    }
  }

  hub_vcn_outdoor_allowed_public_cidr_ingress_rules = local.hub_vcn_outdoor_subnet_private == false ? { for cidr in local.hub_vcn_outdoor_allowed_public_cidrs : "INGRESS-FROM-EXTERNAL-${cidr}-RULE" => {
    # For customized hub VCN deployments with overridden local.hub_vcn_outdoor_subnet_private and local.hub_vcn_outdoor_allowed_public_cidrs.
    description = "Ingress from external CIDR ${cidr}."
    stateless   = false
    protocol    = "ALL"
    src         = "${cidr}"
    src_type    = "CIDR_BLOCK"
    }
  } : {}

  hub_vcn_outdoor_fw_nsg_ingress_rules = merge(
    {
      "INGRESS-FROM-NLB-NSG-RULE" = {
        description = "Ingress from outdoor NLB NSG."
        stateless   = false
        protocol    = "ALL"
        src         = "HUB-VCN-OUTDOOR-NLB-NSG"
        src_type    = "NETWORK_SECURITY_GROUP"
      }
    },
    local.hub_vcn_outdoor_allowed_public_cidr_ingress_rules
  )

  hub_vcn_outdoor_nlb_nsg_ingress_rules = {
    "INGRESS-FROM-LBR-NSG-RULE" = {
      description = "Ingress from App Load Balancer NSG."
      stateless   = false
      protocol    = "ALL"
      src         = "HUB-VCN-APP-LOAD-BALANCER-NSG"
      src_type    = "NETWORK_SECURITY_GROUP"
    }
  }

  hub_vcn_outdoor_nsg_egress_rules = {
    "EGRESS-TO-ANYWHERE-RULE" = {
      description = "Egress to anywhere."
      stateless   = false
      protocol    = "ALL"
      dst         = "0.0.0.0/0"
      dst_type    = "CIDR_BLOCK"
    }
  }

  hub_vcn_cross_vcn_open_nsg = (local.hub_with_vcn == true && var.enable_cross_vcn_open_nsg == true) ? {
    "HUB-VCN-CROSS-VCN-OPEN-NSG" = {
      display_name  = "cross-vcn-open-nsg"
      ingress_rules = local.hub_vcn_cross_vcn_open_nsg_ingress_security_rules
      egress_rules  = local.hub_vcn_cross_vcn_open_nsg_egress_security_rules
    }
  } : {}

  hub_vcn_cross_vcn_open_nsg_ingress_security_rules = merge(
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? local.from_tt_vcn_1_ingress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? local.from_tt_vcn_2_ingress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? local.from_tt_vcn_3_ingress_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? local.from_oke_vcn_1_ingress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? local.from_oke_vcn_2_ingress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? local.from_oke_vcn_3_ingress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) ? local.from_exa_vcn_1_ingress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? local.from_exa_vcn_2_ingress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? local.from_exa_vcn_3_ingress_security_rules : {},
    { for cidr in local.all_onprem_cidrs : "INGRESS-FROM-ONPREM-${cidr}-RULE" => {
      description = "Ingress from on-premises CIDR ${cidr}."
      stateless   = false
      protocol    = "ALL"
      src         = cidr
      src_type    = "CIDR_BLOCK"
    } },
    { for cidr in local.combined_workload_cidrs : "INGRESS-FROM-WORKLOAD-${cidr}-RULE" => {
      description = "Ingress from workload CIDR ${cidr}."
      stateless   = false
      protocol    = "ALL"
      src         = cidr
      src_type    = "CIDR_BLOCK"
    } }
  )

  hub_vcn_cross_vcn_open_nsg_egress_security_rules = merge(
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? local.to_tt_vcn_1_egress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? local.to_tt_vcn_2_egress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? local.to_tt_vcn_3_egress_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? local.to_oke_vcn_1_egress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? local.to_oke_vcn_2_egress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? local.to_oke_vcn_3_egress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) ? local.to_exa_vcn_1_egress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? local.to_exa_vcn_2_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? local.to_exa_vcn_3_egress_security_rules : {},
    { for cidr in local.all_onprem_cidrs : "EGRESS-TO-ONPREM-${cidr}-RULE" => {
      description = "Egress to on-premises CIDR ${cidr}."
      stateless   = false
      protocol    = "ALL"
      dst         = cidr
      dst_type    = "CIDR_BLOCK"
    } },
    { for cidr in local.combined_workload_cidrs : "EGRESS-TO-WORKLOAD-${cidr}-RULE" => {
      description = "Egress to workload CIDR ${cidr}."
      stateless   = false
      protocol    = "ALL"
      dst         = cidr
      dst_type    = "CIDR_BLOCK"
    } }
  )

  hub_vcn_app_load_balancer_nsg_default_egress_rules = merge(
    local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.tt_vcn1_web_ingress_destination_ports : "EGRESS-TO-TT-VCN1-WEB-ON-${port}-RULE" => {
        description  = "Egress to ${local.tt_vcn1_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.tt_vcn1_web_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {},
    local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.tt_vcn1_app_ingress_destination_ports : "EGRESS-TO-TT-VCN1-APP-ON-${port}-RULE" => {
        description  = "Egress to ${local.tt_vcn1_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.tt_vcn1_app_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {},
    local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.tt_vcn2_web_ingress_destination_ports : "EGRESS-TO-TT-VCN2-WEB-ON-${port}-RULE" => {
        description  = "Egress to ${local.tt_vcn2_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.tt_vcn2_web_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {},
    local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.tt_vcn2_app_ingress_destination_ports : "EGRESS-TO-TT-VCN2-APP-ON-${port}-RULE" => {
        description  = "Egress to ${local.tt_vcn2_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.tt_vcn2_app_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {},
    local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.tt_vcn3_web_ingress_destination_ports : "EGRESS-TO-TT-VCN3-WEB-ON-${port}-RULE" => {
        description  = "Egress to ${local.tt_vcn3_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.tt_vcn3_web_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {},
    local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.tt_vcn3_app_ingress_destination_ports : "EGRESS-TO-TT-VCN3-APP-ON-${port}-RULE" => {
        description  = "Egress to ${local.tt_vcn3_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.tt_vcn3_app_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {},
    local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.oke_vcn1_services_ingress_destination_ports : "EGRESS-TO-OKE-VCN1-SERVICES-ON-${port}-RULE" => {
        description  = "Egress to ${local.oke_vcn1_services_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.oke_vcn1_services_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {},
    local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.oke_vcn2_services_ingress_destination_ports : "EGRESS-TO-OKE-VCN2-SERVICES-ON-${port}-RULE" => {
        description  = "Egress to ${local.oke_vcn2_services_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.oke_vcn2_services_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {},
    local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true && local.hub_with_vcn == true ? {
      for port in var.oke_vcn3_services_ingress_destination_ports : "EGRESS-TO-OKE-VCN3-SERVICES-ON-${port}-RULE" => {
        description  = "Egress to ${local.oke_vcn3_services_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
        stateless    = false
        protocol     = split(":", port)[0]
        dst          = local.oke_vcn3_services_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
        icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
        icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
      }
    } : {}
  )
}
