# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  add_oke_vcn1 = var.define_net == true && var.add_oke_vcn1 == true

  oke_vcn1_display_name                 = coalesce(var.oke_vcn1_name, "${var.service_label}-oke-vcn-1")
  oke_vcn1_dns_label                    = substr(replace(coalesce(var.oke_vcn1_name, "oke-vcn-1"), "/[^\\w]/", ""), 0, 14)
  oke_vcn1_api_subnet_display_name      = coalesce(var.oke_vcn1_api_subnet_name, "${var.service_label}-oke-vcn-1-api-subnet")
  oke_vcn1_api_subnet_dns_label         = substr(replace(coalesce(var.oke_vcn1_api_subnet_name, "api-subnet"), "/[^\\w]/", ""), 0, 14)
  oke_vcn1_api_subnet_cidr              = coalesce(var.oke_vcn1_api_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 0))
  oke_vcn1_workers_subnet_display_name  = coalesce(var.oke_vcn1_workers_subnet_name, "${var.service_label}-oke-vcn-1-workers-subnet")
  oke_vcn1_workers_subnet_dns_label     = substr(replace(coalesce(var.oke_vcn1_workers_subnet_name, "workers-subnet"), "/[^\\w]/", ""), 0, 14)
  oke_vcn1_workers_subnet_cidr          = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
  oke_vcn1_services_subnet_display_name = coalesce(var.oke_vcn1_services_subnet_name, "${var.service_label}-oke-vcn-1-services-subnet")
  oke_vcn1_services_subnet_dns_label    = substr(replace(coalesce(var.oke_vcn1_services_subnet_name, "services-subnet"), "/[^\\w]/", ""), 0, 14)
  oke_vcn1_services_subnet_cidr         = coalesce(var.oke_vcn1_services_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 2))
  oke_vcn1_mgmt_subnet_display_name     = coalesce(var.oke_vcn1_mgmt_subnet_name, "${var.service_label}-oke-vcn-1-mgmt-subnet")
  oke_vcn1_mgmt_subnet_dns_label        = substr(replace(coalesce(var.oke_vcn1_mgmt_subnet_name, "mgmt-subnet"), "/[^\\w]/", ""), 0, 14)
  oke_vcn1_mgmt_subnet_cidr             = coalesce(var.oke_vcn1_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 12, 48))
  oke_vcn1_pods_subnet_display_name     = coalesce(var.oke_vcn1_pods_subnet_name, "${var.service_label}-oke-vcn-1-pods-subnet")
  oke_vcn1_pods_subnet_dns_label        = substr(replace(coalesce(var.oke_vcn1_pods_subnet_name, "pods-subnet"), "/[^\\w]/", ""), 0, 14)
  oke_vcn1_pods_subnet_cidr             = coalesce(var.oke_vcn1_pods_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 3, 1))
  oke_vcn1_db_subnet_display_name       = coalesce(var.oke_vcn1_db_subnet_name, "${var.service_label}-oke-vcn-1-db-subnet")
  oke_vcn1_db_subnet_dns_label          = substr(replace(coalesce(var.oke_vcn1_db_subnet_name, "db-subnet"), "/[^\\w]/", ""), 0, 14)
  oke_vcn1_db_subnet_cidr               = coalesce(var.oke_vcn1_db_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 12, 49))

  ## This variable defines the allowed CIDR and port combinations for ingress into the OKE-VCN-1 services tier subnet.  
  oke_vcn1_external_allowed_cidrs_to_ports_into_services_tier = local.add_oke_vcn1 == true ? flatten([for cidr in var.oke_vcn1_external_allowed_cidrs_into_services_tier : [for port in var.oke_vcn1_services_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.oke_vcn1_external_allowed_cidrs_into_services_tier) > 0 && length(var.oke_vcn1_services_ingress_destination_ports) > 0]) : []

  oke_vcn_1 = local.add_oke_vcn1 == true ? {
    "OKE-VCN-1" = {
      enable_cis_checks                = local.vcn_cis_checks_override_allowed ? local.oke_vcn1_cis_checks_enabled : true
      display_name                     = local.oke_vcn1_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.oke_vcn1_cidrs,
      dns_label                        = local.oke_vcn1_dns_label
      block_nat_traffic                = false

      subnets = merge(
        {
          "OKE-VCN-1-API-SUBNET" = {
            cidr_block                = local.oke_vcn1_api_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn1_api_subnet_display_name
            dns_label                 = local.oke_vcn1_api_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-API-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.oke_vcn1_api_subnet_security_list != null ? ["OKE-VCN-1-API-SUBNET-SL"] : []
          }
        },
        {
          "OKE-VCN-1-WORKERS-SUBNET" = {
            cidr_block                = local.oke_vcn1_workers_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn1_workers_subnet_display_name
            dns_label                 = local.oke_vcn1_workers_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-WORKERS-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-WORKERS-SUBNET-SL"]
          }
        },
        {
          "OKE-VCN-1-SERVICES-SUBNET" = {
            cidr_block                = local.oke_vcn1_services_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn1_services_subnet_display_name
            dns_label                 = local.oke_vcn1_services_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = var.oke_vcn1_services_subnet_is_private
            route_table_key           = "OKE-VCN-1-SERVICES-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-SERVICES-SUBNET-SL"]
          }
        },
        var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-SUBNET" = {
            cidr_block                = local.oke_vcn1_mgmt_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn1_mgmt_subnet_display_name
            dns_label                 = local.oke_vcn1_mgmt_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-MGMT-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-MGMT-SUBNET-SL"]
          }
        } : {},
        var.add_oke_vcn1_db_subnet ? {
          "OKE-VCN-1-DB-SUBNET" = {
            cidr_block                = local.oke_vcn1_db_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn1_db_subnet_display_name
            dns_label                 = local.oke_vcn1_db_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-DB-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-DB-SUBNET-SL"]
          }
        } : {},
        upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-SUBNET" = {
            cidr_block                = local.oke_vcn1_pods_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn1_pods_subnet_display_name
            dns_label                 = local.oke_vcn1_pods_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-1-PODS-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-1-PODS-SUBNET-SL"]
          }
        } : {}
      )

      route_tables = merge({
        "OKE-VCN-1-API-SUBNET-ROUTE-TABLE" = {
          display_name = "api-subnet-route-table"
          route_rules = merge(
            local.hub_with_vcn == false ? {
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              },
              "NATGW-RULE" = {
                network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
              } : merge(
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              {
                "HUB-DRG-RULE" = {
                  network_entity_key = "HUB-DRG"
                  description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              local.oke_vcn1_enable_intra_vcn_drg_route == true && var.oke_vcn1_attach_to_drg == true ? merge(
                {
                  "WORKERS-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_workers_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_workers_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                var.add_oke_vcn1_mgmt_subnet ? {
                  "MGMT-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_mgmt_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_mgmt_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {},
                upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                  "PODS-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_pods_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_pods_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
              ) : {}
            )
          )
        }
        },
        {
          "OKE-VCN-1-WORKERS-SUBNET-ROUTE-TABLE" = {
            display_name = "workers-subnet-route-table"
            route_rules = merge(
              local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
                {
                  "SGW-RULE" = {
                    network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                {
                  "NATGW-RULE" = {
                    network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                    description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                local.oke_vcn_1_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.
                ) : merge(
                {
                  "SGW-RULE" = {
                    network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                {
                  "HUB-DRG-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                local.oke_vcn1_enable_intra_vcn_drg_route == true && var.oke_vcn1_attach_to_drg == true ? merge(
                  {
                    "SERVICES-SUBNET-RULE" = { # Traffic destined for Services subnet is routed through DRG.
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.oke_vcn1_services_subnet_display_name} is routed through the DRG."
                      destination        = local.oke_vcn1_services_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  {
                    "API-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.oke_vcn1_api_subnet_display_name} is routed through the DRG."
                      destination        = local.oke_vcn1_api_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  var.add_oke_vcn1_mgmt_subnet ? {
                    "MGMT-SUBNET-RULE" = { # Traffic destined for MGMT subnet is routed through DRG.
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.oke_vcn1_mgmt_subnet_display_name} is routed through the DRG."
                      destination        = local.oke_vcn1_mgmt_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  } : {},
                  var.add_oke_vcn1_db_subnet ? {
                    "DB-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.oke_vcn1_db_subnet_display_name} is routed through the DRG."
                      destination        = local.oke_vcn1_db_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  } : {}
                ) : {}
              )
            )
          }
        },
        {
          "OKE-VCN-1-SERVICES-SUBNET-ROUTE-TABLE" = {
            display_name = "services-subnet-route-table"
            route_rules = local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
              {
                "INTERNET-RULE" = {
                  network_entity_key = var.oke_vcn1_services_subnet_is_private == false ? "OKE-VCN-1-INTERNET-GATEWAY" : "OKE-VCN-1-NAT-GATEWAY"
                  description        = "Traffic destined for networks outside the VCN is routed through the ${var.oke_vcn1_services_subnet_is_private == false ? "Internet" : "NAT"} Gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for ${var.oke_vcn1_services_subnet_is_private == false ? "OCI Object Storage service" : "all OCI services"} in Oracle Services Network is routed through the Service Gateway."
                  destination        = var.oke_vcn1_services_subnet_is_private == false ? "objectstorage" : "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              local.oke_vcn_1_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.  
              ) : merge(
              {
                "HUB-DRG-RULE" = {
                  network_entity_key = "HUB-DRG" # Case when there is a Hub VCN. All traffic is routed through the DRG.
                  description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              local.oke_vcn1_enable_intra_vcn_drg_route == true && var.oke_vcn1_attach_to_drg == true ? merge(
                {
                  "WORKERS-SUBNET-RULE" = { # Traffic destined for Workers subnet is routed through DRG.
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_workers_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_workers_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                var.add_oke_vcn1_mgmt_subnet ? {
                  "MGMT-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_mgmt_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_mgmt_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {},
                upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                  "PODS-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_pods_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_pods_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
              ) : {}
            )
          }
        },
        var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-SUBNET-ROUTE-TABLE" = {
            display_name = "mgmt-subnet-route-table"
            route_rules = local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              {
                "NATGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                  description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              local.oke_vcn_1_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.
              ) : merge(
              {
                "HUB-DRG-RULE" = {
                  network_entity_key = "HUB-DRG"
                  description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              local.oke_vcn1_enable_intra_vcn_drg_route == true && var.oke_vcn1_attach_to_drg == true ? merge(
                {
                  "WORKERS-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_workers_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_workers_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "SERVICES-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_services_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_services_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                {
                  "API-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_api_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_api_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                  "PODS-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_pods_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_pods_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
              ) : {}
            )
          }
        } : {},
        var.add_oke_vcn1_db_subnet ? {
          "OKE-VCN-1-DB-SUBNET-ROUTE-TABLE" = {
            display_name = "db-subnet-route-table"
            route_rules = local.hub_with_vcn == false ? merge(
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              {
                "NATGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                  description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              local.oke_vcn_1_drg_routing
              ) : merge(
              {
                "HUB-DRG-RULE" = {
                  network_entity_key = "HUB-DRG"
                  description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              local.oke_vcn1_enable_intra_vcn_drg_route == true && var.oke_vcn1_attach_to_drg == true ? merge(
                {
                  "WORKERS-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_workers_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_workers_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                  "PODS-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.oke_vcn1_pods_subnet_display_name} is routed through the DRG."
                    destination        = local.oke_vcn1_pods_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
              ) : {}
            )
          }
        } : {},
        upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-SUBNET-ROUTE-TABLE" = {
            display_name = "pods-subnet-route-table"
            route_rules = merge(
              local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
                {
                  "SGW-RULE" = {
                    network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                {
                  "NATGW-RULE" = {
                    network_entity_key = "OKE-VCN-1-NAT-GATEWAY"
                    description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                local.oke_vcn_1_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.
                ) : merge(
                {
                  "SGW-RULE" = {
                    network_entity_key = "OKE-VCN-1-SERVICE-GATEWAY"
                    description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                    destination        = "all-services"
                    destination_type   = "SERVICE_CIDR_BLOCK"
                  }
                },
                {
                  "HUB-DRG-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                local.oke_vcn1_enable_intra_vcn_drg_route == true && var.oke_vcn1_attach_to_drg == true ? merge(
                  {
                    "SERVICES-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.oke_vcn1_services_subnet_display_name} is routed through the DRG."
                      destination        = local.oke_vcn1_services_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  {
                    "API-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.oke_vcn1_api_subnet_display_name} is routed through the DRG."
                      destination        = local.oke_vcn1_api_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  },
                  var.add_oke_vcn1_mgmt_subnet ? {
                    "MGMT-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.oke_vcn1_mgmt_subnet_display_name} is routed through the DRG."
                      destination        = local.oke_vcn1_mgmt_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  } : {},
                  var.add_oke_vcn1_db_subnet ? {
                    "DB-SUBNET-RULE" = {
                      network_entity_key = "HUB-DRG"
                      description        = "Traffic destined for ${local.oke_vcn1_db_subnet_display_name} is routed through the DRG."
                      destination        = local.oke_vcn1_db_subnet_cidr
                      destination_type   = "CIDR_BLOCK"
                    }
                  } : {}
                ) : {}
              )
            )
          }
        } : {}
      )

      security_lists = merge(
        local.oke_vcn1_api_subnet_security_list != null ? {
          "OKE-VCN-1-API-SUBNET-SL" = local.oke_vcn1_api_subnet_security_list
        } : {},
        {
          "OKE-VCN-1-WORKERS-SUBNET-SL" = {
            display_name  = "${local.oke_vcn1_workers_subnet_display_name}-security-list"
            egress_rules  = []
            ingress_rules = [local.icmp_path_discovery_security_rule]
          }
        },
        {
          "OKE-VCN-1-SERVICES-SUBNET-SL" = {
            display_name  = "${local.oke_vcn1_services_subnet_display_name}-security-list"
            egress_rules  = []
            ingress_rules = [local.icmp_path_discovery_security_rule]
          }
        },
        var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-SUBNET-SL" = {
            display_name = "${local.oke_vcn1_mgmt_subnet_display_name}-security-list"
            egress_rules = [
              {
                description  = "Egress to mgmt subnet (Required for OCI Bastion service endpoints in the mgmt subnet to reach hosts in the mgmt subnet)."
                stateless    = false
                protocol     = "TCP"
                dst          = local.oke_vcn1_mgmt_subnet_cidr
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
            ingress_rules = [
              local.icmp_path_discovery_security_rule,
              {
                description  = "Ingress from mgmt subnet (Required for OCI Bastion service endpoints in the mgmt subnet to reach hosts in the mgmt subnet)."
                stateless    = false
                protocol     = "TCP"
                src          = local.oke_vcn1_mgmt_subnet_cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
          }
        } : {},
        var.add_oke_vcn1_db_subnet ? {
          "OKE-VCN-1-DB-SUBNET-SL" = {
            display_name  = "${local.oke_vcn1_db_subnet_display_name}-security-list"
            egress_rules  = []
            ingress_rules = [local.icmp_path_discovery_security_rule]
          }
        } : {},
        upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-SUBNET-SL" = {
            display_name  = "${local.oke_vcn1_pods_subnet_display_name}-security-list"
            egress_rules  = []
            ingress_rules = [local.icmp_path_discovery_security_rule]
          }
        } : {},
        local.oke_vcn1_workers_subnet_security_list != null ? {
          "OKE-VCN-1-WORKERS-SUBNET-SL" = local.oke_vcn1_workers_subnet_security_list
        } : {},
        local.oke_vcn1_services_subnet_security_list != null ? {
          "OKE-VCN-1-SERVICES-SUBNET-SL" = local.oke_vcn1_services_subnet_security_list
        } : {},
        local.oke_vcn1_mgmt_subnet_security_list != null && var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-SUBNET-SL" = local.oke_vcn1_mgmt_subnet_security_list
        } : {},
        local.oke_vcn1_pods_subnet_security_list != null && upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-SUBNET-SL" = local.oke_vcn1_pods_subnet_security_list
        } : {},
        local.oke_vcn1_db_subnet_security_list != null && var.add_oke_vcn1_db_subnet ? {
          "OKE-VCN-1-DB-SUBNET-SL" = local.oke_vcn1_db_subnet_security_list
        } : {}
      )

      network_security_groups = merge(
        {
          "OKE-VCN-1-API-NSG" = {
            display_name = "api-nsg"
            egress_rules = merge(
              {
                "EGRESS-TO-WORKERS-ICMP-RULE" = {
                  description = "Egress to ICMP path discovery on worker nodes."
                  stateless   = false
                  protocol    = "ICMP"
                  dst         = "OKE-VCN-1-WORKERS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                  icmp_type   = 3
                  icmp_code   = 4
                }
                "EGRESS-TO-SERVICES-RULE" = {
                  description  = "Egress to all OCI services in the Oracle Services Network."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "all-services"
                  dst_type     = "SERVICE_CIDR_BLOCK"
                  dst_port_min = 443
                  dst_port_max = 443
                }
              },
              upper(var.oke_vcn1_cni_type) == "FLANNEL" ? {
                "EGRESS-TO-WORKERS-FLANNEL-RULE" = {
                  description = "All TCP traffic from the Kubernetes API endpoint to worker nodes for Flannel CNI."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "OKE-VCN-1-WORKERS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
              } : {},
              upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "EGRESS-TO-WORKERS-10250-RULE" = {
                  description  = "Egress from the Kubernetes API endpoint to worker nodes for VCN-native pod networking."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-WORKERS-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 10250
                  dst_port_max = 10250
                }
                "EGRESS-TO-PODS-RULE" = {
                  description = "Egress to pods for VCN-native pod networking."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-1-PODS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
              } : {}
            )
            ingress_rules = merge(
              {
                "INGRESS-FROM-WORKERS-6443-RULE" = {
                  description  = "Workers to Kubernetes API endpoint communication."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-WORKERS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
              },
              {
                "INGRESS-FROM-WORKERS-12250-RULE" = {
                  description  = "Workers to Kubernetes API endpoint communication."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-WORKERS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
              },
              {
                "INGRESS-FROM-WORKERS-ICMP-RULE" = {
                  description = "Ingress for ICMP path discovery from worker nodes."
                  stateless   = false
                  protocol    = "ICMP"
                  src         = "OKE-VCN-1-WORKERS-NSG"
                  src_type    = "NETWORK_SECURITY_GROUP"
                  icmp_type   = 3
                  icmp_code   = 4
                }
              },
              upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-PODS-6443-RULE" = {
                  description  = "Pods to Kubernetes API endpoint communication for VCN-native pod networking."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-PODS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "INGRESS-FROM-PODS-12250-RULE" = {
                  description  = "Pods to Kubernetes API endpoint communication for VCN-native pod networking."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-PODS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
              } : {},
              var.add_oke_vcn1_mgmt_subnet ? {
                "INGRESS-FROM-MGMT-NSG-RULE" = {
                  description  = "Ingress from mgmt-nsg for management access to the Kubernetes API endpoint."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-MGMT-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
              } : {},
              (local.hub_with_vcn == true && var.deploy_bastion_jump_host == true) ? {
                "INGRESS-FROM-HUB-JUMPHOST-SUBNET-RULE" = {
                  description  = "Ingress from Hub VCN Jumphost Subnet for management access to the Kubernetes API endpoint."
                  stateless    = false
                  protocol     = "TCP"
                  src          = coalesce(var.hub_vcn_jumphost_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 4))
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
              } : {},
            )
          }
        },
        {
          "OKE-VCN-1-WORKERS-NSG" = {
            display_name = "workers-nsg"
            egress_rules = merge(
              {
                "EGRESS-TO-WORKERS-RULE" = {
                  description = "Egress to worker nodes."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-1-WORKERS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
                "EGRESS-TO-OSN-RULE" = {
                  description = "Egress to all OCI Services in Oracle Services Network."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "all-services"
                  dst_type    = "SERVICE_CIDR_BLOCK"
                }
                "EGRESS-TO-API-RULE" = {
                  description  = "Egress to OKE API endpoint."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "EGRESS-TO-CONTROL-PLANE-10250-RULE" = {
                  description  = "Egress to OKE control plane."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 10250
                  dst_port_max = 10250
                }
                "EGRESS-TO-CONTROL-PLANE-12250-RULE" = {
                  description  = "Egress to OKE control plane."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-1-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
                "EGRESS-TO-ANYWHERE-ICMP-RULE" = {
                  description = "Egress to any destination for ICMP path discovery."
                  stateless   = false
                  protocol    = "ICMP"
                  dst         = "0.0.0.0/0"
                  dst_type    = "CIDR_BLOCK"
                  icmp_type   = 3
                  icmp_code   = 4
                }
                "EGRESS-TO-ANYWHERE-TCP-RULE" = {
                  description = "Egress to any destination (Internet access via NAT Gateway). Update this rule to allow specific destination and ports as needed."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "0.0.0.0/0"
                  dst_type    = "CIDR_BLOCK"
                }
              },
              upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "EGRESS-TO-PODS-RULE" = {
                  description = "Egress to pods."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-1-PODS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
              } : {},
              var.add_oke_vcn1_db_subnet ? { for port in var.oke_vcn1_db_ingress_destination_ports : "EGRESS-TO-DB-ON-${port}-RULE" => {
                description  = "Egress to db-nsg over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                stateless    = false
                protocol     = split(":", port)[0]
                dst          = "OKE-VCN-1-DB-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } } : {}
            )
            ingress_rules = merge({
              "INGRESS-FROM-WORKERS-RULE" = {
                description = "Ingress from worker nodes."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-WORKERS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-API-RULE" = {
                description = "Ingress from OKE control plane for webhooks served by workers."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-API-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-API-10250-RULE" = {
                description  = "Ingress from OKE control plane for kubelet connectivity."
                stateless    = false
                protocol     = "TCP"
                src          = "OKE-VCN-1-API-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 10250
                dst_port_max = 10250
              }
              "INGRESS-FROM-API-ICMP-RULE" = {
                description = "Ingress from OKE control plane for ICMP diagnostics."
                stateless   = false
                protocol    = "ICMP"
                src         = "OKE-VCN-1-API-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-LB-10256-RULE" = {
                description  = "Ingress from load balancers for health checks."
                stateless    = false
                protocol     = "TCP"
                src          = "OKE-VCN-1-SERVICES-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 10256
                dst_port_max = 10256
              }
              "INGRESS-FROM-LB-TCP-RULE" = {
                description  = "Ingress from load balancers for TCP traffic."
                stateless    = false
                protocol     = "TCP"
                src          = "OKE-VCN-1-SERVICES-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 30000
                dst_port_max = 32767
              }
              },
              upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-PODS-RULE" = {
                  description = "Ingress from pods running in the cluster."
                  stateless   = false
                  protocol    = "ALL"
                  src         = "OKE-VCN-1-PODS-NSG"
                  src_type    = "NETWORK_SECURITY_GROUP"
                }
              } : {},
              var.add_oke_vcn1_mgmt_subnet ? {
                "INGRESS-FROM-MGMT-NSG-RULE" = {
                  description  = "Ingress from mgmt-nsg for SSH."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-1-MGMT-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              (local.hub_with_vcn == true && var.deploy_bastion_jump_host == true) ? {
                "INGRESS-FROM-HUB-JUMPHOST-SUBNET-RULE" = {
                  description  = "Ingress from Hub VCN Jumphost Subnet for SSH. Required for inbound connections from jump hosts in the Hub VCN."
                  stateless    = false
                  protocol     = "TCP"
                  src          = local.hub_vcn_jumphost_subnet_cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {}
            )
          }
        },
        {
          "OKE-VCN-1-SERVICES-NSG" = {
            display_name = "services-nsg"
            egress_rules = merge({
              "EGRESS-TO-WORKERS-NSG-RULE" = {
                description  = "Egress to workers nodes."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-WORKERS-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 30000
                dst_port_max = 32767
              }
              "EGRESS-TO-WORKERS-TCP-RULE" = {
                description  = "Egress to worker nodes."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-WORKERS-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 10256
                dst_port_max = 10256
              }
              "EGRESS-TO-WORKERS-ICMP-RULE" = {
                description = "Egress to worker nodes for ICMP path discovery."
                stateless   = false
                protocol    = "ICMP"
                dst         = "OKE-VCN-1-WORKERS-NSG"
                dst_type    = "NETWORK_SECURITY_GROUP"
                icmp_type   = 3
                icmp_code   = 4
              }
            }),
            ingress_rules = { for cidr_port_pair in local.oke_vcn1_external_allowed_cidrs_to_ports_into_services_tier : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
              description  = "Ingress from ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
              stateless    = false
              protocol     = split(":", split(",", cidr_port_pair)[1])[0]
              src          = split(",", cidr_port_pair)[0]
              src_type     = "CIDR_BLOCK"
              dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? (split(":", split(",", cidr_port_pair)[1])[1]) : null
              dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? (split(":", split(",", cidr_port_pair)[1])[1]) : null
              icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
              icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
            } }
          }
        },
        var.add_oke_vcn1_mgmt_subnet ? {
          "OKE-VCN-1-MGMT-NSG" = {
            display_name = "mgmt-nsg"
            egress_rules = {
              "EGRESS-TO-API-RULE" = {
                description  = "Egress to Kubernetes API server."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-API-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 6443
                dst_port_max = 6443
              }
              "EGRESS-TO-WORKERS-RULE" = {
                description  = "Egress to worker nodes."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-WORKERS-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 22
                dst_port_max = 22
              }
              "EGRESS-TO-SERVICE-GATEWAY-RULE" = {
                description = "Egress to all OCI services in Oracle Services Network."
                stateless   = false
                protocol    = "TCP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
              }
              "EGRESS-TO-ANYWHERE-RULE" = {
                description = "Egress to any destination (Internet access via NAT Gateway). Update this rule to allow specific destination and ports as needed."
                stateless   = false
                protocol    = "TCP"
                dst         = "0.0.0.0/0"
                dst_type    = "CIDR_BLOCK"
              }
            },
            ingress_rules = {}
          }
        } : {},
        upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
          "OKE-VCN-1-PODS-NSG" = {
            display_name = "pods-nsg"
            egress_rules = merge({
              "EGRESS-TO-PODS-RULE" = {
                description = "Egress to other pods."
                stateless   = false
                protocol    = "ALL"
                dst         = "OKE-VCN-1-PODS-NSG"
                dst_type    = "NETWORK_SECURITY_GROUP"
              }
              "EGRESS-TO-ICMP-RULE" = {
                description = "Egress to Oracle Services Network for ICMP path discovery."
                stateless   = false
                protocol    = "ICMP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
              "EGRESS-TO-SERVICES-TCP-RULE" = {
                description = "Egress to all OCI Services in Oracle Services Network."
                stateless   = false
                protocol    = "TCP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
              }
              "EGRESS-TO-INTERNET-RULE" = {
                description = "Egress to any destination (Internet access via NAT Gateway). Update this rule to allow specific destination and ports as needed."
                stateless   = false
                protocol    = "TCP"
                dst         = "0.0.0.0/0"
                dst_type    = "CIDR_BLOCK"
              }
              "EGRESS-TO-API-RULE" = {
                description  = "Egress to Kubernetes API server."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-API-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 6443
                dst_port_max = 6443
              }
              "EGRESS-TO-API-12250-RULE" = {
                description  = "Egress to OKE control plane."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-1-API-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 12250
                dst_port_max = 12250
              }
              },
              var.add_oke_vcn1_db_subnet ? { for port in var.oke_vcn1_db_ingress_destination_ports : "EGRESS-TO-DB-ON-${port}-PODS-RULE" => {
                description  = "Egress from ${split(":", port)[0]} to db-nsg."
                stateless    = false
                protocol     = split(":", port)[0]
                dst          = "OKE-VCN-1-DB-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } } : {}
            )
            ingress_rules = merge({
              "INGRESS-FROM-WORKERS-RULE" = {
                description = "Ingress from worker nodes."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-WORKERS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-API-RULE" = {
                description = "Ingress from Kubernetes API endpoint."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-API-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-TO-PODS-RULE" = {
                description = "Ingress from other pods."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-1-PODS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
            })
          }
        } : {},
        var.add_oke_vcn1_db_subnet ? {
          "OKE-VCN-1-DB-NSG" = {
            display_name = "db-nsg"
            egress_rules = merge(
              {
                "EGRESS-TO-SERVICES-TCP-RULE" = {
                  description = "Egress to all OCI Services in Oracle Services Network."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "all-services"
                  dst_type    = "SERVICE_CIDR_BLOCK"
                }
                "EGRESS-TO-INTERNET-RULE" = {
                  description = "Egress to any destination (Internet access via NAT Gateway). Update this rule to allow specific destination and ports as needed."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "0.0.0.0/0"
                  dst_type    = "CIDR_BLOCK"
                }
              }
            )
            ingress_rules = merge(
              { for port in var.oke_vcn1_db_ingress_destination_ports : "INGRESS-FROM-WORKERS-ON-${port}-DB-RULE" => {
                description  = "Ingress from worker nodes into ${split(":", port)[0]}."
                stateless    = false
                protocol     = split(":", port)[0]
                src          = "OKE-VCN-1-WORKERS-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } },
              upper(var.oke_vcn1_cni_type) == "NATIVE" ? { for port in var.oke_vcn1_db_ingress_destination_ports : "INGRESS-FROM-PODS-ON-${port}-DB-RULE" => {
                description  = "Ingress from pods into ${split(":", port)[0]}."
                stateless    = false
                protocol     = split(":", port)[0]
                src          = "OKE-VCN-1-PODS-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } } : {}
            )
          }
        } : {},
        local.oke_vcn1_cross_vcn_open_nsg,
        local.oke_vcn1_cross_vcn_workers_nsg,
        local.oke_vcn1_cross_vcn_pods_nsg,
        local.oke_vcn1_cross_vcn_db_nsg,
        local.additional_nsgs_by_vcn["OKE-VCN-1"]
      )

      vcn_specific_gateways = merge(
        {
          service_gateways = {
            "OKE-VCN-1-SERVICE-GATEWAY" = {
              display_name = "Service Gateway"
              services     = "all-services"
            }
          }
        },
        local.hub_with_vcn == false ? {
          internet_gateways = {
            "OKE-VCN-1-INTERNET-GATEWAY" = {
              enabled      = true
              display_name = "Internet Gateway"
            }
          }
          nat_gateways = {
            "OKE-VCN-1-NAT-GATEWAY" = {
              block_traffic = false
              display_name  = "NAT Gateway"
            }
          }
        } : {}
      )
    }
  } : {}

  oke_vcn_1_drg_routing = (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? merge(
    length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1") ? local.tt_vcn1_route_rule : {},
    length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2") ? local.tt_vcn2_route_rule : {},
    length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3") ? local.tt_vcn3_route_rule : {},
    length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2") ? local.oke_vcn2_route_rule : {},
    length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3") ? local.oke_vcn3_route_rule : {},
    length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1") ? local.exa_vcn1_route_rule : {},
    length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2") ? local.exa_vcn2_route_rule : {},
    length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3") ? local.exa_vcn3_route_rule : {},
    var.oke_vcn1_onprem_route_enable == true ? local.on_prem_route_rule : {}
  ) : {}

  #-------------------------------------------------------------
  # Cross VCN Open NSG
  #-------------------------------------------------------------
  oke_vcn1_cross_vcn_open_nsg = (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && local.cross_vcn_open_nsg_enabled == true) ? {
    "OKE-VCN-1-CROSS-VCN-OPEN-NSG" = {
      display_name  = "cross-vcn-open-nsg"
      ingress_rules = merge(local.oke_vcn1_cross_vcn_open_nsg_ingress_security_rules, local.ingress_from_hub_jumphost_subnet_security_rule)
      egress_rules  = local.oke_vcn1_cross_vcn_open_nsg_egress_security_rules
    }
  } : {}

  oke_vcn1_cross_vcn_open_nsg_ingress_security_rules = merge(
    (local.hub_with_vcn == true) ? local.from_hub_vcn_ingress_security_rules : {},
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-1")))) ? local.from_tt_vcn_1_ingress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.from_tt_vcn_2_ingress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "OKE-VCN-1")))) ? local.from_tt_vcn_3_ingress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.from_oke_vcn_2_ingress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "OKE-VCN-1")))) ? local.from_oke_vcn_3_ingress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "OKE-VCN-1")))) ? local.from_exa_vcn_1_ingress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.from_exa_vcn_2_ingress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-1")))) ? local.from_exa_vcn_3_ingress_security_rules : {},
    (var.oke_vcn1_onprem_route_enable == true) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.from_onprem_ingress_security_rules : {}
  )

  oke_vcn1_cross_vcn_open_nsg_egress_security_rules = merge(
    (local.hub_with_vcn == true) ? local.to_hub_vcn_egress_security_rules : {},
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? local.to_tt_vcn_1_egress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")))) ? local.to_tt_vcn_2_egress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")))) ? local.to_tt_vcn_3_egress_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? local.to_oke_vcn_2_egress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? local.to_oke_vcn_3_egress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1")))) ? local.to_exa_vcn_1_egress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.to_exa_vcn_2_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3")))) ? local.to_exa_vcn_3_egress_security_rules : {},
    (var.oke_vcn1_onprem_route_enable == true) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.to_onprem_egress_security_rules : {}
  )

  #-------------------------------------------------------------
  # Cross VCN Constrained NSGs
  #-------------------------------------------------------------
  oke_vcn1_cross_vcn_services_nsg = (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.enable_cross_vcn_constrained_nsgs == true) ? {
    "OKE-VCN-1-CROSS-VCN-SERVICES-NSG" = {
      display_name  = "cross-vcn-services-nsg"
      ingress_rules = merge(local.oke_vcn1_cross_vcn_services_nsg_ingress_security_rules, local.ingress_from_hub_web_subnet_into_oke_vcn1_services_security_rule, local.ingress_from_hub_jumphost_subnet_security_rule)
      egress_rules  = {}
    }
  } : {}

  oke_vcn1_cross_vcn_workers_nsg = (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.enable_cross_vcn_constrained_nsgs == true) ? {
    "OKE-VCN-1-CROSS-VCN-WORKERS-NSG" = {
      display_name  = "cross-vcn-workers-nsg"
      ingress_rules = local.ingress_from_hub_jumphost_subnet_security_rule
      egress_rules  = local.oke_vcn1_cross_vcn_workers_nsg_egress_security_rules
    }
  } : {}

  oke_vcn1_cross_vcn_pods_nsg = (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.enable_cross_vcn_constrained_nsgs == true && upper(var.oke_vcn1_cni_type) == "NATIVE") ? {
    "OKE-VCN-1-CROSS-VCN-PODS-NSG" = {
      display_name  = "cross-vcn-pods-nsg"
      ingress_rules = local.ingress_from_hub_jumphost_subnet_security_rule
      egress_rules  = local.oke_vcn1_cross_vcn_pods_nsg_egress_security_rules
    }
  } : {}

  oke_vcn1_cross_vcn_db_nsg = (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && var.enable_cross_vcn_constrained_nsgs == true && var.add_oke_vcn1_db_subnet == true) ? {
    "OKE-VCN-1-CROSS-VCN-DB-NSG" = {
      display_name  = "cross-vcn-db-nsg"
      ingress_rules = merge(local.oke_vcn1_cross_vcn_db_nsg_ingress_security_rules, local.ingress_from_hub_jumphost_subnet_security_rule)
      egress_rules  = local.oke_vcn1_cross_vcn_db_nsg_egress_security_rules
    }
  } : {}

  oke_vcn1_cross_vcn_services_nsg_ingress_security_rules = merge(
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_services_subnet_ingress_from_oke_vcn2_workers_security_rules : {},
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_services_subnet_ingress_from_oke_vcn2_pods_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_services_subnet_ingress_from_oke_vcn3_workers_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_services_subnet_ingress_from_oke_vcn3_pods_security_rules : {},
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_services_subnet_ingress_from_tt_vcn1_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_services_subnet_ingress_from_tt_vcn2_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_services_subnet_ingress_from_tt_vcn3_security_rules : {},
    (var.oke_vcn1_onprem_route_enable == true) && (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? local.oke_vcn_1_services_subnet_ingress_from_onprem_security_rules : {}
  )

  oke_vcn1_cross_vcn_workers_nsg_egress_security_rules = merge(
    (var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")))) ? local.oke_vcn_2_services_subnet_egress_security_rules : {},
    (var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")))) ? local.oke_vcn_3_services_subnet_egress_security_rules : {},
    (var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")))) ? local.tt_vcn_1_web_subnet_egress_security_rules : {},
    (var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")))) ? local.tt_vcn_2_web_subnet_egress_security_rules : {},
    (var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")))) ? local.tt_vcn_3_web_subnet_egress_security_rules : {},
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1")))) ? local.exa_vcn_1_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3")))) ? local.exa_vcn_3_client_subnet_egress_security_rules : {}
  )

  oke_vcn1_cross_vcn_pods_nsg_egress_security_rules = local.oke_vcn1_cross_vcn_workers_nsg_egress_security_rules

  oke_vcn1_cross_vcn_db_nsg_ingress_security_rules = merge(
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_db_subnet_ingress_from_exa_vcn1_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_db_subnet_ingress_from_exa_vcn2_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-1")))) ? local.oke_vcn_1_db_subnet_ingress_from_exa_vcn3_security_rules : {}
  )

  oke_vcn1_cross_vcn_db_nsg_egress_security_rules = merge(
    (var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1")))) ? local.exa_vcn_1_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")))) ? local.exa_vcn_2_client_subnet_egress_security_rules : {},
    (var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) && (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3")))) ? local.exa_vcn_3_client_subnet_egress_security_rules : {}
  )
}
