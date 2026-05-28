# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  add_tt_vcn1 = var.define_net == true && var.add_tt_vcn1 == true

  tt_vcn1_display_name                = coalesce(var.tt_vcn1_name, "${var.service_label}-three-tier-vcn-1")
  tt_vcn1_dns_label                   = substr(replace(coalesce(var.tt_vcn1_name, "three-tier-vcn-1"), "/[^\\w]/", ""), 0, 14)
  tt_vcn1_web_subnet_display_name     = coalesce(var.tt_vcn1_web_subnet_name, "${var.service_label}-three-tier-vcn-1-web-subnet")
  tt_vcn1_web_subnet_dns_label        = substr(replace(coalesce(var.tt_vcn1_web_subnet_name, "web-subnet"), "/[^\\w]/", ""), 0, 14)
  tt_vcn1_web_subnet_cidr             = coalesce(var.tt_vcn1_web_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 0))
  tt_vcn1_app_subnet_display_name     = coalesce(var.tt_vcn1_app_subnet_name, "${var.service_label}-three-tier-vcn-1-app-subnet")
  tt_vcn1_app_subnet_dns_label        = substr(replace(coalesce(var.tt_vcn1_app_subnet_name, "app-subnet"), "/[^\\w]/", ""), 0, 14)
  tt_vcn1_app_subnet_cidr             = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 1))
  tt_vcn1_db_subnet_display_name      = coalesce(var.tt_vcn1_db_subnet_name, "${var.service_label}-three-tier-vcn-1-db-subnet")
  tt_vcn1_db_subnet_dns_label         = substr(replace(coalesce(var.tt_vcn1_db_subnet_name, "db-subnet"), "/[^\\w]/", ""), 0, 14)
  tt_vcn1_db_subnet_cidr              = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))
  tt_vcn1_bastion_subnet_display_name = coalesce(var.tt_vcn1_bastion_subnet_name, "${var.service_label}-three-tier-vcn-1-bastion-subnet")
  tt_vcn1_bastion_subnet_dns_label    = substr(replace(coalesce(var.tt_vcn1_bastion_subnet_name, "bastion-subnet"), "/[^\\w]/", ""), 0, 14)
  tt_vcn1_bastion_subnet_cidr         = var.deploy_tt_vcn1_bastion_subnet == true ? coalesce(var.tt_vcn1_bastion_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 9, 96)) : null

  ## This variable defines the allowed CIDR and port combinations for ingress into the TT-VCN-1 web tier subnet.  
  tt_vcn1_external_allowed_cidrs_to_ports_into_web_tier = local.add_tt_vcn1 == true ? flatten([for cidr in var.tt_vcn1_external_allowed_cidrs_into_web_tier : [for port in var.tt_vcn1_web_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.tt_vcn1_external_allowed_cidrs_into_web_tier) > 0 && length(var.tt_vcn1_web_ingress_destination_ports) > 0]) : []

  tt_vcn_1 = local.add_tt_vcn1 == true ? {
    "TT-VCN-1" = {
      enable_cis_checks                = local.vcn_cis_checks_override_allowed ? local.tt_vcn1_cis_checks_enabled : true
      display_name                     = local.tt_vcn1_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.tt_vcn1_cidrs,
      dns_label                        = local.tt_vcn1_dns_label
      block_nat_traffic                = false
      security                         = local.enable_zpr == true ? { zpr_attributes = [{ namespace : "${local.zpr_namespace_name}", attr_name : "net", attr_value : "tt-vcn-1" }] } : null

      subnets = merge(
        {
          "TT-VCN-1-WEB-SUBNET" = {
            cidr_block                = local.tt_vcn1_web_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.tt_vcn1_web_subnet_display_name
            dns_label                 = local.tt_vcn1_web_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = var.tt_vcn1_web_subnet_is_private
            route_table_key           = "TT-VCN-1-WEB-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.tt_vcn1_web_subnet_security_list != null ? ["TT-VCN-1-WEB-SUBNET-SL"] : []
          }
        },
        {
          "TT-VCN-1-APP-SUBNET" = {
            cidr_block                = local.tt_vcn1_app_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.tt_vcn1_app_subnet_display_name
            dns_label                 = local.tt_vcn1_app_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "TT-VCN-1-APP-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.tt_vcn1_app_subnet_security_list != null ? ["TT-VCN-1-APP-SUBNET-SL"] : []
          }
        },
        {
          "TT-VCN-1-DB-SUBNET" = {
            cidr_block                = local.tt_vcn1_db_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.tt_vcn1_db_subnet_display_name
            dns_label                 = local.tt_vcn1_db_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "TT-VCN-1-DB-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.tt_vcn1_db_subnet_security_list != null ? ["TT-VCN-1-DB-SUBNET-SL"] : []
          }
        },
        var.deploy_tt_vcn1_bastion_subnet == true ? {
          "TT-VCN-1-BASTION-SUBNET" = {
            cidr_block                = local.tt_vcn1_bastion_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.tt_vcn1_bastion_subnet_display_name
            dns_label                 = local.tt_vcn1_bastion_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = var.tt_vcn1_bastion_is_access_via_public_endpoint == true ? false : true
            route_table_key           = "TT-VCN-1-BASTION-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["TT-VCN-1-BASTION-SUBNET-SL"]
          }
        } : {}
      ) # merge function

      security_lists = merge(
        var.deploy_tt_vcn1_bastion_subnet == true ? {
          # The default bastion subnet security list applies to private Bastion service endpoints; a non-null override replaces it whenever the bastion subnet is deployed.
          "TT-VCN-1-BASTION-SUBNET-SL" = coalesce(local.tt_vcn1_bastion_subnet_security_list, {
            display_name = "${local.tt_vcn1_bastion_subnet_display_name}-security-list"
            ingress_rules = [
              {
                description  = "Ingress from ${local.tt_vcn1_bastion_subnet_display_name} on SSH port. Required for connecting Bastion service endpoint to Bastion host."
                stateless    = false
                protocol     = "TCP"
                src          = local.tt_vcn1_bastion_subnet_cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
            egress_rules = [
              {
                description  = "Egress to ${local.tt_vcn1_bastion_subnet_display_name} on SSH port. Required for connecting Bastion service endpoint to Bastion host."
                stateless    = false
                protocol     = "TCP"
                dst          = local.tt_vcn1_bastion_subnet_cidr
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
          })
        } : {},
        # Security lists overrides
        local.tt_vcn1_web_subnet_security_list != null ? {
          "TT-VCN-1-WEB-SUBNET-SL" = local.tt_vcn1_web_subnet_security_list
        } : {},
        local.tt_vcn1_app_subnet_security_list != null ? {
          "TT-VCN-1-APP-SUBNET-SL" = local.tt_vcn1_app_subnet_security_list
        } : {},
        local.tt_vcn1_db_subnet_security_list != null ? {
          "TT-VCN-1-DB-SUBNET-SL" = local.tt_vcn1_db_subnet_security_list
        } : {}
      )

      route_tables = merge(
        {
          "TT-VCN-1-WEB-SUBNET-ROUTE-TABLE" = {
            display_name = "web-subnet-rtable"
            route_rules = merge(
              local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
                {
                  "INTERNET-RULE" = {
                    network_entity_key = var.tt_vcn1_web_subnet_is_private == false ? "TT-VCN-1-INTERNET-GATEWAY" : "TT-VCN-1-NAT-GATEWAY"
                    description        = "Traffic destined for networks outside the VCN is routed through the ${var.tt_vcn1_web_subnet_is_private == false ? "Internet" : "NAT"} Gateway."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "OSN-RULE" = {
                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for ${var.tt_vcn1_web_subnet_is_private == false ? "OCI Object Storage Service" : "all OCI services"} in Oracle Services Network is routed through the Service Gateway."
                    # If subnet is public, routes to Object Storage only. Routes to 0/0 over Internet Gateway and to all OSN services cannot coexist.
                    destination      = var.tt_vcn1_web_subnet_is_private == false ? "objectstorage" : "all-services"
                    destination_type = "SERVICE_CIDR_BLOCK"
                  }
                },
                local.tt_vcn_1_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.
                ) : merge(
                {
                  "HUB-DRG-RULE" = { # Case when there is a Hub VCN. All traffic is routed through the DRG.
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "OSN-RULE" = {
                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                local.tt_vcn1_enable_intra_vcn_drg_route == true && var.tt_vcn1_attach_to_drg == true ? merge( # Intra VCN traffic routed through DRG
                  {
                    "APP-SUBNET-RULE" = { # Traffic destined for App subnet is routed through DRG.
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_app_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_app_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  {
                    "DB-SUBNET-RULE" = { # Traffic destined for DB subnet is routed through DRG.
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_db_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_db_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  var.deploy_tt_vcn1_bastion_subnet == true ? {
                    "BASTION-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_bastion_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_bastion_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  } : {}
                ) : {} # Intra VCN routes
              )
            )
          }
        },
        {
          "TT-VCN-1-APP-SUBNET-ROUTE-TABLE" = {
            display_name = "app-subnet-rtable"
            route_rules = merge(
              local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
                {
                  "INTERNET-RULE" = {
                    network_entity_key = "TT-VCN-1-NAT-GATEWAY"
                    description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "OSN-RULE" = {
                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                local.tt_vcn_1_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.  
                ) : merge(
                {
                  "HUB-DRG-RULE" = { # Case when there is a Hub VCN. All traffic is routed through the DRG.
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "OSN-RULE" = {
                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                local.tt_vcn1_enable_intra_vcn_drg_route == true && var.tt_vcn1_attach_to_drg == true ? merge( # Intra VCN traffic routed through DRG
                  {
                    "WEB-SUBNET-RULE" = { # Traffic destined for Web subnet is routed through DRG.
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_web_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_web_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  {
                    "DB-SUBNET-RULE" = { # Traffic destined for DB subnet is routed through DRG.
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_db_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_db_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  var.deploy_tt_vcn1_bastion_subnet == true ? {
                    "BASTION-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_bastion_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_bastion_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  } : {}
                ) : {} # Intra VCN routes 
              )
            )
          }
        },
        {
          "TT-VCN-1-DB-SUBNET-ROUTE-TABLE" = {
            display_name = "db-subnet-rtable"
            route_rules = merge(
              local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
                {
                  "INTERNET-RULE" = {
                    network_entity_key = "TT-VCN-1-NAT-GATEWAY"
                    description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "OSN-RULE" = {
                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                local.tt_vcn_1_drg_routing # There can be cross VCN and on-prem connectivity through the DRG. 
                ) : merge(
                {
                  "HUB-DRG-RULE" = { # Case when there is a Hub VCN. All traffic is routed through the DRG.
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "OSN-RULE" = {
                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                local.tt_vcn1_enable_intra_vcn_drg_route == true && var.tt_vcn1_attach_to_drg == true ? merge( # Intra VCN traffic routed through DRG
                  {
                    "WEB-SUBNET-RULE" = { # Traffic destined for Web subnet is routed through DRG.
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_web_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_web_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  {
                    "APP-SUBNET-RULE" = { # Traffic destined for App subnet is routed through DRG.
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_app_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_app_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  var.deploy_tt_vcn1_bastion_subnet == true ? {
                    "BASTION-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.tt_vcn1_bastion_subnet_display_name} is routed through the DRG."
                      destination        = local.tt_vcn1_bastion_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  } : {}
                ) : {} # Intra VCN routes 
              )
            )
          }
        },
        var.deploy_tt_vcn1_bastion_subnet == true ? {
          "TT-VCN-1-BASTION-SUBNET-ROUTE-TABLE" = {
            display_name = "bastion-subnet-route-table"
            route_rules = merge(
              local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
                {
                  "INTERNET-RULE" = {
                    network_entity_key = var.tt_vcn1_bastion_is_access_via_public_endpoint == false ? "TT-VCN-1-NAT-GATEWAY" : "TT-VCN-1-INTERNET-GATEWAY"
                    description        = "Traffic destined for networks outside the VCN is routed through the ${var.tt_vcn1_bastion_is_access_via_public_endpoint == false ? "NAT" : "Internet"} Gateway."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "OSN-RULE" = {
                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for ${var.tt_vcn1_bastion_is_access_via_public_endpoint == false ? "all OCI services" : "OCI Object Storage Service"} in Oracle Services Network is routed through the Service Gateway."
                    destination        = var.tt_vcn1_bastion_is_access_via_public_endpoint == false ? "all-services" : "objectstorage" # If public endpoint, route to object storage only. Routes to 0/0 over Internet Gateway and to all  OSN services cannot coexist.
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                local.tt_vcn_1_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.
                ) : merge(
                {
                  "HUB-DRG-RULE" = { # Case when there is a Hub VCN. All traffic is routed through the DRG.
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "OSN-RULE" = {
                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                local.tt_vcn1_enable_intra_vcn_drg_route == true && var.tt_vcn1_attach_to_drg == true ? { # Intra VCN traffic routed through DRG
                  "WEB-SUBNET-RULE" = {                                                                   # Traffic destined for Web subnet is routed through DRG.
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.tt_vcn1_web_subnet_display_name} is routed through the DRG."
                    destination        = local.tt_vcn1_web_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  },
                  "APP-SUBNET-RULE" = { # Traffic destined for App subnet is routed through DRG.
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.tt_vcn1_app_subnet_display_name} is routed through the DRG."
                    destination        = local.tt_vcn1_app_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  },
                  "DB-SUBNET-RULE" = { # Traffic destined for DB subnet is routed through DRG.
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.tt_vcn1_db_subnet_display_name} is routed through the DRG."
                    destination        = local.tt_vcn1_db_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {} # Intra VCN routes
              )
            )
          }
        } : {}
      ) # merge function

      network_security_groups = merge(
        {
          "TT-VCN-1-LBR-NSG" = {
            display_name = "lbr-nsg"
            ingress_rules = merge(
              { for cidr_port_pair in local.tt_vcn1_external_allowed_cidrs_to_ports_into_web_tier : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
                description  = "Ingress from ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
                stateless    = false
                protocol     = split(":", split(",", cidr_port_pair)[1])[0]
                src          = split(",", cidr_port_pair)[0]
                src_type     = "CIDR_BLOCK"
                dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? (split(":", split(",", cidr_port_pair)[1])[1]) : null
                dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? (split(":", split(",", cidr_port_pair)[1])[1]) : null
                icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
                icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
              } },
              var.deploy_tt_vcn1_bastion_subnet == true ? {
                "INGRESS-FROM-BASTION-NSG-RULE" = {
                  description  = "Ingress from Bastion NSG."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "TT-VCN-1-BASTION-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {}
            ),
            egress_rules = merge(
              { for port in var.tt_vcn1_app_ingress_destination_ports : "EGRESS-TO-APP-NSG-ON-${port}-RULE" => {
                description  = "Egress to App NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                stateless    = false
                protocol     = split(":", port)[0]
                dst          = "TT-VCN-1-APP-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } },
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
            )
          }
        },
        {
          "TT-VCN-1-APP-NSG" = {
            display_name = "app-nsg"
            ingress_rules = merge(
              { for port in var.tt_vcn1_app_ingress_destination_ports : "INGRESS-FROM-LBR-NSG-ON-${port}-RULE" => {
                description  = "Ingress from LBR NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                stateless    = false
                protocol     = split(":", port)[0]
                src          = "TT-VCN-1-LBR-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } },
              var.deploy_tt_vcn1_bastion_subnet == true ? {
                "INGRESS-FROM-BASTION-NSG-RULE" = {
                  description  = "Ingress from Bastion NSG."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "TT-VCN-1-BASTION-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {}
            ),
            egress_rules = merge(
              { for port in var.tt_vcn1_db_ingress_destination_ports : "EGRESS-TO-DB-NSG-ON-${port}-RULE" => {
                description  = "Egress to DB NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                stateless    = false
                protocol     = split(":", port)[0]
                dst          = "TT-VCN-1-DB-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } },
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
              {
                "EGRESS-TO-ALL" = {
                  description  = "Egress to all remaining destinations."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "0.0.0.0/0"
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = null
                  dst_port_max = null
                }
              }
            )
          }
        },
        {
          "TT-VCN-1-DB-NSG" = {
            display_name = "db-nsg"
            ingress_rules = merge(
              { for port in var.tt_vcn1_db_ingress_destination_ports : "INGRESS-FROM-APP-NSG-ON-${port}-RULE" => {
                description  = "Ingress from App NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                stateless    = false
                protocol     = split(":", port)[0]
                src          = "TT-VCN-1-APP-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } },
              var.deploy_tt_vcn1_bastion_subnet == true ? {
                "INGRESS-FROM-BASTION-RULE" = {
                  description  = "Ingress from Bastion NSG."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "TT-VCN-1-BASTION-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              (var.tt_vcn1_attach_to_drg == true && local.hub_with_vcn == true && var.deploy_bastion_jump_host) ? {
                "INGRESS-FROM-HUB-JUMPHOST-SUBNET-RULE" = {
                  description  = "Ingress from Hub VCN Jumphost subnet."
                  stateless    = false
                  protocol     = "TCP"
                  src          = local.hub_vcn_jumphost_subnet_cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {}
            ),
            egress_rules = merge(
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
              {
                "EGRESS-TO-ALL" = {
                  description  = "Egress to all remaining destinations."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "0.0.0.0/0"
                  dst_type     = "CIDR_BLOCK"
                  dst_port_min = null
                  dst_port_max = null
                }
              }
            )
          }
        },
        var.deploy_tt_vcn1_bastion_subnet == true ? {
          "TT-VCN-1-BASTION-NSG" = {
            display_name = "bastion-nsg"
            ingress_rules = {
              for cidr in var.tt_vcn1_bastion_subnet_allowed_cidrs : "INGRESS-FROM-${cidr}-RULE" => {
                description  = "Ingress from ${cidr} on port 22."
                stateless    = false
                protocol     = "TCP"
                src          = cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              } if var.tt_vcn1_bastion_is_access_via_public_endpoint == true # Ingress rule only for jump hosts later deployed in the bastion public subnet.
            },
            egress_rules = merge(
              {
                "EGRESS-TO-LBR-RULE" = {
                  description  = "Egress to LBR NSG."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "TT-VCN-1-LBR-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              },
              {
                "EGRESS-TO-APP-RULE" = {
                  description  = "Egress to App NSG."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "TT-VCN-1-APP-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              },
              {
                "EGRESS-TO-DB-RULE" = {
                  description  = "Egress to DB NSG."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "TT-VCN-1-DB-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              },
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
              }
            ) # inner merge function
          }
        } : {},
        local.tt_vcn1_cross_vcn_open_nsg,
        local.tt_vcn1_cross_vcn_lbr_nsg,
        local.tt_vcn1_cross_vcn_app_nsg,
        local.tt_vcn1_cross_vcn_db_nsg,
        local.additional_nsgs_by_vcn["TT-VCN-1"]
      ) # merge function

      vcn_specific_gateways = merge(
        {
          service_gateways = {
            "TT-VCN-1-SERVICE-GATEWAY" = {
              display_name = "Service Gateway"
              services     = "all-services"
            }
          }
        },
        local.hub_with_vcn == false ? {
          internet_gateways = {
            "TT-VCN-1-INTERNET-GATEWAY" = {
              enabled      = true
              display_name = "Internet Gateway"
            }
          }
          nat_gateways = {
            "TT-VCN-1-NAT-GATEWAY" = {
              block_traffic = false
              display_name  = "NAT Gateway"
            }
          }
        } : {}
      )
    }
  } : {}

  tt_vcn_1_drg_routing = (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? merge(
    length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-2") ? local.tt_vcn2_route_rule : {},
    length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-3") ? local.tt_vcn3_route_rule : {},
    length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-1") ? local.oke_vcn1_route_rule : {},
    length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-2") ? local.oke_vcn2_route_rule : {},
    length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-3") ? local.oke_vcn3_route_rule : {},
    length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-1") ? local.exa_vcn1_route_rule : {},
    length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-2") ? local.exa_vcn2_route_rule : {},
    length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-3") ? local.exa_vcn3_route_rule : {},
    var.tt_vcn1_onprem_route_enable == true ? local.on_prem_route_rule : {}
  ) : {}

  #-------------------------------------------------------------
  # Cross VCN Open NSG
  #-------------------------------------------------------------
  tt_vcn1_cross_vcn_open_nsg = (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && local.cross_vcn_open_nsg_enabled == true) ? {
    "TT-VCN-1-CROSS-VCN-OPEN-NSG" = {
      display_name  = "cross-vcn-open-nsg"
      ingress_rules = local.tt_vcn1_cross_vcn_open_nsg_ingress_security_rules
      egress_rules  = local.tt_vcn1_cross_vcn_open_nsg_egress_security_rules
    }
  } : {}

  # Cross VCN Open NSG ingress security rules
  tt_vcn1_cross_vcn_open_nsg_ingress_security_rules = merge(
    (local.hub_with_vcn == true) ? local.from_hub_vcn_ingress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "TT-VCN-1")))) ? local.from_tt_vcn_2_ingress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "TT-VCN-1")))) ? local.from_tt_vcn_3_ingress_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? local.from_oke_vcn_1_ingress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-1")))) ? local.from_oke_vcn_2_ingress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "TT-VCN-1")))) ? local.from_oke_vcn_3_ingress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-1")))) ? local.from_exa_vcn_1_ingress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1")))) ? local.from_exa_vcn_2_ingress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1")))) ? local.from_exa_vcn_3_ingress_security_rules : {},
    (var.tt_vcn1_onprem_route_enable) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.from_onprem_ingress_security_rules : {}
  )
  # Cross VCN Open NSG egress security rules
  tt_vcn1_cross_vcn_open_nsg_egress_security_rules = merge(
    (local.hub_with_vcn == true) ? local.to_hub_vcn_egress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-2")))) ? local.to_tt_vcn_2_egress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-3")))) ? local.to_tt_vcn_3_egress_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-1")))) ? local.to_oke_vcn_1_egress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-2")))) ? local.to_oke_vcn_2_egress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-3")))) ? local.to_oke_vcn_3_egress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-1")))) ? local.to_exa_vcn_1_egress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.to_exa_vcn_2_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-3")))) ? local.to_exa_vcn_3_egress_security_rules : {},
    (var.tt_vcn1_onprem_route_enable) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.to_onprem_egress_security_rules : {}
  )
  #-------------------------------------------------------------

  #-------------------------------------------------------------
  # Cross VCN Constrained NSGs
  #-------------------------------------------------------------
  tt_vcn1_cross_vcn_lbr_nsg = (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && var.enable_cross_vcn_constrained_nsgs == true) ? {
    "TT-VCN-1-CROSS-VCN-LBR-NSG" = {
      display_name  = "cross-vcn-lbr-nsg"
      ingress_rules = merge(local.tt_vcn1_cross_vcn_lbr_nsg_ingress_security_rules, local.ingress_from_hub_web_subnet_into_tt_vcn1_web_security_rule, local.ingress_from_hub_jumphost_subnet_security_rule)
      egress_rules  = {}
    }
  } : {}

  tt_vcn1_cross_vcn_app_nsg = (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && var.enable_cross_vcn_constrained_nsgs == true) ? {
    "TT-VCN-1-CROSS-VCN-APP-NSG" = {
      display_name  = "cross-vcn-app-nsg"
      ingress_rules = merge(local.ingress_from_hub_web_subnet_into_tt_vcn1_app_security_rule, local.ingress_from_hub_jumphost_subnet_security_rule)
      egress_rules  = local.tt_vcn1_cross_vcn_app_nsg_egress_security_rules
    }
  } : {}

  tt_vcn1_cross_vcn_db_nsg = (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && var.enable_cross_vcn_constrained_nsgs == true) ? {
    "TT-VCN-1-CROSS-VCN-DB-NSG" = {
      display_name  = "cross-vcn-db-nsg"
      ingress_rules = merge(local.tt_vcn1_cross_vcn_db_nsg_ingress_security_rules, local.ingress_from_hub_jumphost_subnet_security_rule)
      egress_rules  = local.tt_vcn1_cross_vcn_db_nsg_egress_security_rules
    }
  } : {}

  tt_vcn1_cross_vcn_lbr_nsg_ingress_security_rules = merge(
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "TT-VCN-1")))) ? local.tt_vcn_1_web_subnet_ingress_from_tt_vcn2_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "TT-VCN-1")))) ? local.tt_vcn_1_web_subnet_ingress_from_tt_vcn3_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? merge(local.tt_vcn_1_web_subnet_ingress_from_oke_vcn1_workers_security_rules, local.tt_vcn_1_web_subnet_ingress_from_oke_vcn1_pods_security_rules) : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-1")))) ? merge(local.tt_vcn_1_web_subnet_ingress_from_oke_vcn2_workers_security_rules, local.tt_vcn_1_web_subnet_ingress_from_oke_vcn2_pods_security_rules) : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "TT-VCN-1")))) ? merge(local.tt_vcn_1_web_subnet_ingress_from_oke_vcn3_workers_security_rules, local.tt_vcn_1_web_subnet_ingress_from_oke_vcn3_pods_security_rules) : {},
    (var.tt_vcn1_onprem_route_enable) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.tt_vcn_1_web_subnet_ingress_from_onprem_security_rules : {}
  )

  tt_vcn1_cross_vcn_app_nsg_egress_security_rules = merge(
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-2")))) ? local.tt_vcn_2_web_subnet_egress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-3")))) ? local.tt_vcn_3_web_subnet_egress_security_rules : {},
    (var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_services_subnet_egress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-2")))) ? local.oke_vcn_2_services_subnet_egress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-3")))) ? local.oke_vcn_3_services_subnet_egress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-1")))) ? local.exa_vcn_1_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-3")))) ? local.exa_vcn_3_client_subnet_egress_security_rules : {}
  )

  tt_vcn1_cross_vcn_db_nsg_ingress_security_rules = merge(
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-1")))) ? local.tt_vcn_1_db_subnet_ingress_from_exa_vcn1_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1")))) ? local.tt_vcn_1_db_subnet_ingress_from_exa_vcn2_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1")))) ? local.tt_vcn_1_db_subnet_ingress_from_exa_vcn3_security_rules : {}
  )

  tt_vcn1_cross_vcn_db_nsg_egress_security_rules = merge(
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-1")))) ? local.exa_vcn_1_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-3")))) ? local.exa_vcn_3_client_subnet_egress_security_rules : {}
  )
  #-------------------------------------------------------------
}
