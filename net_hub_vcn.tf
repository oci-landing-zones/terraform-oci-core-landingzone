# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  hub_vcn = local.hub_with_vcn == true ? { # local variable hub_with_vcn is defined in net_hub_drg.tf.
    "HUB-VCN" = {
      display_name                     = coalesce(var.hub_vcn_name, "${var.service_label}-hub-vcn")
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.hub_vcn_cidrs
      dns_label                        = replace(coalesce(var.hub_vcn_dns, "${var.service_label}-hub-vcn"), "-", "")
      block_nat_traffic                = false

      subnets = {
        "WEB-SUBNET" = {
          cidr_block                 = coalesce(var.hub_vcn_web_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 0))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.hub_vcn_web_subnet_name, "${var.service_label}-hub-vcn-web-subnet")
          dns_label                  = replace(coalesce(var.hub_vcn_web_subnet_dns, "web-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = false
          prohibit_public_ip_on_vnic = false
          route_table_key            = "WEB-SUBNET-ROUTE-TABLE"
          security_list_keys         = ["HUB-VCN-SL"]
        }
        "OUTDOOR-SUBNET" = {
          cidr_block                 = coalesce(var.hub_vcn_outdoor_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 1))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.hub_vcn_outdoor_subnet_name, "${var.service_label}-hub-vcn-outdoor-subnet")
          dns_label                  = replace(coalesce(var.hub_vcn_outdoor_subnet_dns, "outdoor-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "OUTDOOR-SUBNET-ROUTE-TABLE"
          security_list_keys         = ["HUB-VCN-SL"]
        }
        "INDOOR-SUBNET" = {
          cidr_block                 = coalesce(var.hub_vcn_indoor_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 2))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.hub_vcn_indoor_subnet_name, "${var.service_label}-hub-vcn-indoor-subnet")
          dns_label                  = replace(coalesce(var.hub_vcn_indoor_subnet_dns, "indoor-subnet"), "-", "")
          ipv6cidr_blocks            = []
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "INDOOR-SUBNET-ROUTE-TABLE"
          security_list_keys         = ["HUB-VCN-SL"]
        }
        "MGMT-SUBNET" = {
          cidr_block                 = coalesce(var.hub_vcn_mgmt_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 3))
          dhcp_options_key           = "default_dhcp_options"
          display_name               = coalesce(var.hub_vcn_mgmt_subnet_name, "${var.service_label}-hub-vcn-mgmt-subnet")
          dns_label                  = replace(coalesce(var.hub_vcn_mgmt_subnet_dns, "mgmt-subnet"), "-", "")
          ipv6cidr_blocks            = [],
          prohibit_internet_ingress  = true
          prohibit_public_ip_on_vnic = true
          route_table_key            = "MGMT-SUBNET-ROUTE-TABLE"
          security_list_keys         = ["MGMT-SUB-SL"]
        }
      }

      security_lists = {
        "HUB-VCN-SL" = {
          display_name = "basic-security-list"
          ingress_rules = [
            {
              description = "Ingress on UDP type 3 code 4."
              stateless   = false
              protocol    = "UDP"
              src         = "0.0.0.0/0"
              src_type    = "CIDR_BLOCK"
              icmp_type   = 3
              icmp_code   = 4
            }
          ]
          egress_rules = []
        }
        "MGMT-SUB-SL" = {
          display_name = "mgmt-subnet-security-list"
          ingress_rules = [
            {
              description = "Ingress on UDP type 3 code 4."
              stateless   = false
              protocol    = "UDP"
              src         = "0.0.0.0/0"
              src_type    = "CIDR_BLOCK"
              icmp_type   = 3
              icmp_code   = 4
            }
          ]
          egress_rules = [
            {
              description  = "Egress to Mgmt subnet on SSH port. Required by Bastion service session."
              stateless    = false
              protocol     = "TCP"
              dst          = coalesce(var.hub_vcn_mgmt_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 3))
              dst_type     = "CIDR_BLOCK"
              dst_port_min = "22"
              dst_port_max = "22"
            },
            {
              description  = "Egress to Mgmt subnet on HTTP port. Required by Bastion service session."
              stateless    = false
              protocol     = "TCP"
              dst          = coalesce(var.hub_vcn_mgmt_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 3))
              dst_type     = "CIDR_BLOCK"
              dst_port_min = "443"
              dst_port_max = "443"
            }
          ]
        }
      }

      route_tables = merge(
        {
          "WEB-SUBNET-ROUTE-TABLE" = {
            display_name = "web-subnet-route-table"
            route_rules = {
              "INTERNET-RULE" = {
                network_entity_key = "HUB-VCN-INTERNET-GATEWAY"
                description        = "To Internet."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          }
        },
        {
          "OUTDOOR-SUBNET-ROUTE-TABLE" = {
            display_name = "outdoor-subnet-route-table"
            route_rules = {
              "OSN-RULE" = {
                network_entity_key = "HUB-VCN-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              },
              "INTERNET-RULE" = {
                network_entity_key = "HUB-VCN-NAT-GATEWAY"
                description        = "To Internet."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          }
        },
        {
          "INDOOR-SUBNET-ROUTE-TABLE" = {
            display_name = "indoor-subnet-route-table"
            route_rules = {
              "OSN-RULE" = {
                network_entity_key = "HUB-VCN-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            }
          }
        },
        {
          "MGMT-SUBNET-ROUTE-TABLE" = {
            display_name = "mgmt-subnet-route-table"
            route_rules = {
              "OSN-RULE" = {
                network_entity_key = "HUB-VCN-SERVICE-GATEWAY"
                description        = "To Oracle Services Network."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
              "INTERNET-RULE" = {
                network_entity_key = "HUB-VCN-NAT-GATEWAY"
                description        = "To Internet."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          }
        },
        # Route table for East/West traffic is attached to HUB VCN DRG attachment.
        (var.hub_vcn_east_west_entry_point_ocid != null) ? {
          "HUB-VCN-INGRESS-ROUTE-TABLE" = {
            display_name = "hub-vcn-ingress-route-table"
            route_rules = {
              "ANYWHERE-RULE" = {
                description       = "All traffic goes to ${var.hub_vcn_east_west_entry_point_ocid}."
                destination       = "0.0.0.0/0"
                destination_type  = "CIDR_BLOCK"
                network_entity_id = var.hub_vcn_east_west_entry_point_ocid
              }
            }
          }
        } : {},
        # Route table for North/South traffic is attached to HUB VCN Internet Gateway.
        (var.hub_vcn_north_south_entry_point_ocid != null) ? {
          "HUB-VCN-INTERNET-GATEWAY-ROUTE-TABLE" = {
            display_name = "hub-vcn-internet-gateway-route-table"
            route_rules = {
              "ANYWHERE-RULE" = {
                description       = "All traffic goes to ${var.hub_vcn_north_south_entry_point_ocid}."
                destination       = "0.0.0.0/0"
                destination_type  = "CIDR_BLOCK"
                network_entity_id = var.hub_vcn_north_south_entry_point_ocid
              }
            }
          }
        } : {}
      ) # closing merge function

      network_security_groups = {
        "HUB-VCN-OUTDOOR-NLB-NSG" = {
          display_name = "outdoor-nlb-nsg"
          ingress_rules = {
            "INGRESS-FROM-ANYWHERE-RULE" = {
              description  = "Ingress from 0.0.0.0/0 on HTTPS port 443."
              stateless    = false
              protocol     = "TCP"
              src          = "0.0.0.0/0"
              src_type     = "CIDR_BLOCK"
              dst_port_min = 443
              dst_port_max = 443
            }
          }
          egress_rules = {
            "EGRESS-TO-OUTDOOR-FW-NSG-RULE" = {
              description = "Egress to Outdoor Firewall NSG."
              stateless   = false
              protocol    = "TCP"
              dst         = "HUB-VCN-OUTDOOR-FW-NSG"
              dst_type    = "NETWORK_SECURITY_GROUP"
            }
          }
        }

        "HUB-VCN-OUTDOOR-FW-NSG" = {
          display_name = "outdoor-fw-nsg"
          ingress_rules = {
            "INGRESS-FROM-NLB-NSG-RULE" = {
              description  = "Ingress from Outdoor NLB NSG"
              stateless    = false
              protocol     = "TCP"
              src          = "HUB-VCN-OUTDOOR-NLB-NSG"
              src_type     = "NETWORK_SECURITY_GROUP"
              dst_port_min = 80
              dst_port_max = 80
            }
          }
          egress_rules = {
            "EGRESS-TO-ANYWHERE-RULE" = {
              description = "Egress to anywhere over TCP"
              stateless   = false
              protocol    = "TCP"
              dst         = "0.0.0.0/0"
              dst_type    = "CIDR_BLOCK"
            }
          }
        }

        "HUB-VCN-INDOOR-NLB-NSG" = {
          display_name = "indoor-nlb-nsg"
          ingress_rules = {
            "INGRESS-FROM-ANYWHERE-RULE" = {
              description  = "Ingress from anywhere over TCP"
              stateless    = false
              protocol     = "TCP"
              src          = "0.0.0.0/0"
              src_type     = "CIDR_BLOCK"
              dst_port_min = 80
              dst_port_max = 80
            }
          },
          egress_rules = {
            "EGRESS-TO-INDOOR-FW-NSG-RULE" = {
              description = "Egress to Indoor Firewall NSG"
              stateless   = false
              protocol    = "TCP"
              dst         = "HUB-VCN-INDOOR-FW-NSG"
              dst_type    = "NETWORK_SECURITY_GROUP"
            }
          }
        }

        "HUB-VCN-INDOOR-FW-NSG" = {
          display_name = "indoor-fw-nsg"
          ingress_rules = {
            "INGRESS-FROM-NLB-NSG-RULE" = {
              description  = "Ingress from Indoor NLB NSG"
              stateless    = false
              protocol     = "TCP"
              src          = "HUB-VCN-INDOOR-NLB-NSG"
              src_type     = "NETWORK_SECURITY_GROUP"
              dst_port_min = 80
              dst_port_max = 80
            }
          },
          egress_rules = {
            "EGRESS-TO-ANYWHERE-RULE" = {
              description = "Egress to anywhere over TCP"
              stateless   = false
              protocol    = "TCP"
              dst         = "0.0.0.0/0"
              dst_type    = "CIDR_BLOCK"
            }
          }
        }

        "HUB-VCN-MGMT-NSG" = {
          display_name = "mgmt-nsg"
          ingress_rules = merge(
            { for cidr in var.hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http : "INGRESS-FROM-${cidr}-HTTP-RULE" => {
              description  = "Ingress from ${cidr} on port 443. Allows inbound HTTP access for on-prem IP addresses."
              stateless    = false
              protocol     = "TCP"
              src          = cidr
              src_type     = "CIDR_BLOCK"
              dst_port_min = 443
              dst_port_max = 443
            } },
            { for cidr in var.hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh : "INGRESS-FROM-${cidr}-SSH-RULE" => {
              description  = "Ingress from ${cidr} on port 22. Allows inbound SSH access for on-prem IP addresses."
              stateless    = false
              protocol     = "TCP"
              src          = cidr
              src_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            } },
            { "INGRESS-FROM-JUMP-HOST-NSG-SSH-RULE" = {
              description  = "Ingress from Jump Host NSG to SSH port. Required by hosts deployed in the Jump Host NSG."
              stateless    = false
              protocol     = "TCP"
              src          = "HUB-VCN-JUMP-HOST-NSG"
              src_type     = "NETWORK_SECURITY_GROUP"
              dst_port_min = 22
              dst_port_max = 22
            } },
            { "INGRESS-FROM-MGMT-SUBNET-SSH-RULE" = {
              description  = "Ingress from Mgmt subnet to SSH port. Required by OCI Bastion Service port forwarding session."
              stateless    = false
              protocol     = "TCP"
              src          = coalesce(var.hub_vcn_mgmt_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 3))
              src_type     = "CIDR_BLOCK"
              dst_port_min = 22
              dst_port_max = 22
            } },
            { "INGRESS-FROM-MGMT-SUBNET-HTTP-RULE" = {
              description  = "Ingress from Mgmt subnet to HTTP port. Required by OCI Bastion Service port forwarding session.",
              stateless    = false
              protocol     = "TCP"
              src          = coalesce(var.hub_vcn_mgmt_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 3))
              src_type     = "CIDR_BLOCK"
              dst_port_min = 443
              dst_port_max = 443
          } }) # closing merge function.
        }

        "HUB-VCN-JUMP-HOST-NSG" = {
          display_name = "jump-host-nsg"
          ingress_rules = { for cidr in var.hub_vcn_web_subnet_jump_host_allowed_cidrs : "INGRESS-FROM-${cidr}-RULE" => {
            description  = "Ingress from ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22,
            dst_port_max = 22
            }
          },
          "egress_rules" = {
            "EGRESS-TO-MGMT-NSG-SSH-RULE" = {
              description  = "Egress to Mgmt NSG"
              stateless    = false
              protocol     = "TCP"
              dst          = "HUB-VCN-MGMT-NSG"
              dst_type     = "NETWORK_SECURITY_GROUP"
              dst_port_min = 22
              dst_port_max = 22
            }
          }
        }
      }

      vcn_specific_gateways = {
        internet_gateways = {
          "HUB-VCN-INTERNET-GATEWAY" = {
            enabled         = true
            display_name    = "internet-gateway"
            route_table_key = var.hub_vcn_north_south_entry_point_ocid != null ? "HUB-VCN-INTERNET-GATEWAY-ROUTE-TABLE" : null
          }
        }
        nat_gateways = {
          "HUB-VCN-NAT-GATEWAY" = {
            block_traffic = false
            display_name  = "nat-gateway"
          }
        }
        service_gateways = {
          "HUB-VCN-SERVICE-GATEWAY" = {
            display_name = "service-gateway"
            services     = "all-services"
          }
        }
      }
    }
  } : null
}