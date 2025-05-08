# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  allow_any_public_access = (var.add_app_subnet && var.app_subnet_allow_public_access) || (var.add_db_subnet && var.db_subnet_allow_public_access) || (var.add_lb_subnet && var.lb_subnet_allow_public_access) || (var.add_mgmt_subnet && var.mgmt_subnet_allow_public_access) || (var.add_web_subnet && var.web_subnet_allow_public_access) || (var.add_db_backup_subnet && var.db_backup_subnet_allow_public_access) || (var.add_spare_subnet && var.spare_subnet_allow_public_access)

  workload_vcn = {
    "WORKLOAD-VCN" = {
      display_name = "${var.workload_name}-vcn"
      cidr_blocks  = [var.workload_vcn_cidr_block]
      dns_label    = substr(replace(coalesce(lower(var.workload_name), "workloadvcn"), "/[^\\w]/", ""), 0, 14)

      subnets = merge(
        var.add_app_subnet ? {
          "WORKLOAD-APP-SUBNET" = {
            cidr_block                = coalesce(var.app_subnet_cidr, cidrsubnet(var.workload_vcn_cidr_block, 3, 0))
            display_name              = coalesce(var.app_subnet_name, "${var.workload_name}-app-subnet")
            dns_label                 = substr(replace(coalesce(var.app_subnet_name, "app-subnet"), "/[^\\w]/", ""), 0, 14)
            dhcp_options_key          = "default_dhcp_options"
            prohibit_internet_ingress = var.deploy_network_architecture == "Standalone" && var.app_subnet_allow_public_access == true ? false : true
            route_table_key           = "WORKLOAD-APP-SUBNET-ROUTE-TABLE"
            security_list_keys        = var.deploy_security_lists ? ["WORKLOAD-APP-SUBNET-SECLIST"] : null
          }
        } : {},
        var.add_db_subnet ? {
          "WORKLOAD-DB-SUBNET" = {
            cidr_block                = coalesce(var.db_subnet_cidr, cidrsubnet(var.workload_vcn_cidr_block, 3, 1))
            display_name              = coalesce(var.db_subnet_name, "${var.workload_name}-db-subnet")
            dns_label                 = substr(replace(coalesce(var.db_subnet_name, "db-subnet"), "/[^\\w]/", ""), 0, 14)
            dhcp_options_key          = "default_dhcp_options"
            prohibit_internet_ingress = var.deploy_network_architecture == "Standalone" && var.db_subnet_allow_public_access == true ? false : true
            route_table_key           = "WORKLOAD-DB-SUBNET-ROUTE-TABLE"
            security_list_keys        = var.deploy_security_lists ? ["WORKLOAD-DB-SUBNET-SECLIST"] : null
          }
        } : {},
        var.add_lb_subnet ? {
          "WORKLOAD-LB-SUBNET" = {
            cidr_block                = coalesce(var.lb_subnet_cidr, cidrsubnet(var.workload_vcn_cidr_block, 3, 2))
            display_name              = coalesce(var.lb_subnet_name, "${var.workload_name}-lb-subnet")
            dns_label                 = substr(replace(coalesce(var.lb_subnet_name, "lb-subnet"), "/[^\\w]/", ""), 0, 14)
            dhcp_options_key          = "default_dhcp_options"
            prohibit_internet_ingress = var.deploy_network_architecture == "Standalone" && var.lb_subnet_allow_public_access == true ? false : true
            route_table_key           = "WORKLOAD-LB-SUBNET-ROUTE-TABLE"
            security_list_keys        = var.deploy_security_lists ? ["WORKLOAD-LB-SUBNET-SECLIST"] : null
          }
        } : {},
        var.add_mgmt_subnet ? {
          "WORKLOAD-MGMT-SUBNET" = {
            cidr_block                = coalesce(var.mgmt_subnet_cidr, cidrsubnet(var.workload_vcn_cidr_block, 3, 3))
            display_name              = coalesce(var.mgmt_subnet_name, "${var.workload_name}-mgmt-subnet")
            dns_label                 = substr(replace(coalesce(var.mgmt_subnet_name, "mgmt-subnet"), "/[^\\w]/", ""), 0, 14)
            dhcp_options_key          = "default_dhcp_options"
            prohibit_internet_ingress = var.deploy_network_architecture == "Standalone" && var.mgmt_subnet_allow_public_access == true ? false : true
            route_table_key           = "WORKLOAD-MGMT-SUBNET-ROUTE-TABLE"
            security_list_keys        = var.deploy_security_lists ? ["WORKLOAD-MGMT-SUBNET-SECLIST"] : null
          }
        } : {},
        var.add_web_subnet ? {
          "WORKLOAD-WEB-SUBNET" = {
            cidr_block                = coalesce(var.web_subnet_cidr, cidrsubnet(var.workload_vcn_cidr_block, 3, 4))
            display_name              = coalesce(var.web_subnet_name, "${var.workload_name}-web-subnet")
            dns_label                 = substr(replace(coalesce(var.web_subnet_name, "web-subnet"), "/[^\\w]/", ""), 0, 14)
            dhcp_options_key          = "default_dhcp_options"
            prohibit_internet_ingress = var.deploy_network_architecture == "Standalone" && var.web_subnet_allow_public_access == true ? false : true
            route_table_key           = "WORKLOAD-WEB-SUBNET-ROUTE-TABLE"
            security_list_keys        = var.deploy_security_lists ? ["WORKLOAD-WEB-SUBNET-SECLIST"] : null
          }
        } : {},
        var.add_db_backup_subnet ? {
          "WORKLOAD-DB-BACKUP-SUBNET" = {
            cidr_block                = coalesce(var.db_backup_subnet_cidr, cidrsubnet(var.workload_vcn_cidr_block, 3, 5))
            display_name              = coalesce(var.db_backup_subnet_name, "${var.workload_name}-db-backup-subnet")
            dns_label                 = substr(replace(coalesce(var.db_backup_subnet_name, "dbbackupsubnet"), "/[^\\w]/", ""), 0, 14)
            dhcp_options_key          = "default_dhcp_options"
            prohibit_internet_ingress = var.deploy_network_architecture == "Standalone" && var.db_backup_subnet_allow_public_access == true ? false : true
            route_table_key           = "WORKLOAD-DB-BACKUP-SUBNET-ROUTE-TABLE"
            security_list_keys        = var.deploy_security_lists ? ["WORKLOAD-DB-BACKUP-SUBNET-SECLIST"] : null
          }
        } : {},
        var.add_spare_subnet ? {
          "WORKLOAD-SPARE-SUBNET" = {
            cidr_block                = var.spare_subnet_cidr
            display_name              = var.spare_subnet_name
            dns_label                 = substr(replace(var.spare_subnet_name, "/[^\\w]/", ""), 0, 14)
            dhcp_options_key          = "default_dhcp_options"
            prohibit_internet_ingress = var.deploy_network_architecture == "Standalone" && var.spare_subnet_allow_public_access == true ? false : true
            route_table_key           = "WORKLOAD-SPARE-SUBNET-ROUTE-TABLE"
            security_list_keys        = var.deploy_security_lists ? ["WORKLOAD-SPARE-SUBNET-SECLIST"] : null
          }
        } : {}
      )

      route_tables = merge(
        var.add_app_subnet ? {
          "WORKLOAD-APP-SUBNET-ROUTE-TABLE" = {
            display_name = "${coalesce(var.app_subnet_name, "${var.workload_name}-app-subnet")}-route-table"
            route_rules = merge(
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.app_subnet_allow_public_access == false)) && var.app_subnet_allow_onprem_connectivity && var.onprem_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke" && var.app_subnet_allow_public_access == true ) || (var.deploy_network_architecture == "Standalone" && var.app_subnet_allow_public_access == false)) && var.hub_vcn_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.hub_vcn_cidrs : "HUB-VCN-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Hub VCN ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.app_subnet_allow_public_access == false)) && var.jumphost_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.jumphost_cidrs : "JUMPHOST-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Jumphost ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              var.deploy_network_architecture == "Standalone" && var.app_subnet_allow_public_access == true ? {
                "IGW-RULE" = {
                  network_entity_key = "IGW"
                  description        = "All traffic goes to internet gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {},
              var.app_subnet_additional_route_rules
            )
          }
        } : {},
        var.add_db_subnet ? {
          "WORKLOAD-DB-SUBNET-ROUTE-TABLE" = {
            display_name = "${coalesce(var.db_subnet_name, "${var.workload_name}-db-subnet")}-route-table"
            route_rules = merge(
              ((var.deploy_network_architecture == "Hub and Spoke")  || (var.deploy_network_architecture == "Standalone" && var.db_subnet_allow_public_access == false)) && var.db_subnet_allow_onprem_connectivity && var.onprem_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke" && var.db_subnet_allow_public_access == true) || (var.deploy_network_architecture == "Standalone" && var.db_subnet_allow_public_access == false)) && var.hub_vcn_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.hub_vcn_cidrs : "HUB-VCN-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Hub VCN ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.db_subnet_allow_public_access == false)) && var.jumphost_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.jumphost_cidrs : "JUMPHOST-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Jumphost ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              var.deploy_network_architecture == "Standalone" && var.db_subnet_allow_public_access == true ? {
                "IGW-RULE" = {
                  network_entity_key = "IGW"
                  description        = "All traffic goes to internet gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {},
              var.db_subnet_additional_route_rules
            )
          }
        } : {},
        var.add_lb_subnet ? {
          "WORKLOAD-LB-SUBNET-ROUTE-TABLE" = {
            display_name = "${coalesce(var.lb_subnet_name, "${var.workload_name}-lb-subnet")}-route-table"
            route_rules = merge(
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.lb_subnet_allow_public_access == false)) && var.lb_subnet_allow_onprem_connectivity && var.onprem_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke" && var.lb_subnet_allow_public_access == true) || (var.deploy_network_architecture == "Standalone" && var.lb_subnet_allow_public_access == false)) && var.hub_vcn_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.hub_vcn_cidrs : "HUB-VCN-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Hub VCN ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.lb_subnet_allow_public_access == false)) && var.jumphost_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.jumphost_cidrs : "JUMPHOST-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Jumphost ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              var.deploy_network_architecture == "Standalone" && var.lb_subnet_allow_public_access == true ? {
                "IGW-RULE" = {
                  network_entity_key = "IGW"
                  description        = "All traffic goes to internet gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {},
              var.lb_subnet_additional_route_rules
            )
          }
        } : {},
        var.add_mgmt_subnet ? {
          "WORKLOAD-MGMT-SUBNET-ROUTE-TABLE" = {
            display_name = "${coalesce(var.mgmt_subnet_name, "${var.workload_name}-mgmt-subnet")}-route-table"
            route_rules = merge(
              ((var.deploy_network_architecture == "Hub and Spoke")|| (var.deploy_network_architecture == "Standalone" && var.mgmt_subnet_allow_public_access == false)) && var.mgmt_subnet_allow_onprem_connectivity && var.onprem_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke" && var.mgmt_subnet_allow_public_access == true) || (var.deploy_network_architecture == "Standalone" && var.mgmt_subnet_allow_public_access == false)) && var.hub_vcn_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.hub_vcn_cidrs : "HUB-VCN-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Hub VCN ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.mgmt_subnet_allow_public_access == false)) && var.jumphost_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.jumphost_cidrs : "JUMPHOST-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Jumphost ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              var.deploy_network_architecture == "Standalone" && var.mgmt_subnet_allow_public_access == true ? {
                "IGW-RULE" = {
                  network_entity_key = "IGW"
                  description        = "All traffic goes to internet gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {},
              var.mgmt_subnet_additional_route_rules
            )
          }
        } : {},
        var.add_web_subnet ? {
          "WORKLOAD-WEB-SUBNET-ROUTE-TABLE" = {
            display_name = "${coalesce(var.web_subnet_name, "${var.workload_name}-web-subnet")}-route-table"
            route_rules = merge(
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.web_subnet_allow_public_access == false)) && var.web_subnet_allow_onprem_connectivity && var.onprem_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke" && var.web_subnet_allow_public_access == true) || (var.deploy_network_architecture == "Standalone" && var.web_subnet_allow_public_access == false)) && var.hub_vcn_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.hub_vcn_cidrs : "HUB-VCN-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Hub VCN ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.web_subnet_allow_public_access == false)) && var.jumphost_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.jumphost_cidrs : "JUMPHOST-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Jumphost ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              var.deploy_network_architecture == "Standalone" && var.web_subnet_allow_public_access == true ? {
                "IGW-RULE" = {
                  network_entity_key = "IGW"
                  description        = "All traffic goes to internet gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {},
              var.web_subnet_additional_route_rules
            )
          }
        } : {},
        var.add_db_backup_subnet ? {
          "WORKLOAD-DB-BACKUP-SUBNET-ROUTE-TABLE" = {
            display_name = "${coalesce(var.db_backup_subnet_name, "${var.workload_name}-db-backup-subnet")}-route-table"
            route_rules = merge(
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.db_backup_subnet_allow_public_access == false)) && var.db_backup_subnet_allow_onprem_connectivity && var.onprem_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke" && var.db_backup_subnet_allow_public_access == true) || (var.deploy_network_architecture == "Standalone" && var.db_backup_subnet_allow_public_access == false)) && var.hub_vcn_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.hub_vcn_cidrs : "HUB-VCN-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Hub VCN ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.db_backup_subnet_allow_public_access == false)) && var.jumphost_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.jumphost_cidrs : "JUMPHOST-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Jumphost ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              var.deploy_network_architecture == "Standalone" && var.db_backup_subnet_allow_public_access == true ? {
                "IGW-RULE" = {
                  network_entity_key = "IGW"
                  description        = "All traffic goes to internet gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {},
              var.db_backup_subnet_additional_route_rules
            )
          }
        } : {},
        var.add_spare_subnet ? {
          "WORKLOAD-SPARE-SUBNET-ROUTE-TABLE" = {
            display_name = "${var.spare_subnet_name}-route-table"
            route_rules = merge(
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.spare_subnet_allow_public_access == false)) && var.spare_subnet_allow_onprem_connectivity && var.onprem_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke" && var.spare_subnet_allow_public_access == true) || (var.deploy_network_architecture == "Standalone" && var.spare_subnet_allow_public_access == false)) && var.hub_vcn_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.hub_vcn_cidrs : "HUB-VCN-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Hub VCN ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              ((var.deploy_network_architecture == "Hub and Spoke") || (var.deploy_network_architecture == "Standalone" && var.spare_subnet_allow_public_access == false)) && var.jumphost_cidrs != null && var.hub_drg_ocid != null ? {
                for cidr in var.jumphost_cidrs : "JUMPHOST-${replace(replace(cidr, ".", ""), "/", "")}-RULE" => {
                  network_entity_id = var.hub_drg_ocid
                  description       = "Traffic destined to Jumphost ${cidr} CIDR range goes to DRG."
                  destination       = cidr
                  destination_type  = "CIDR_BLOCK"
                }
              } : {},
              var.deploy_network_architecture == "Standalone" && var.spare_subnet_allow_public_access == true ? {
                "IGW-RULE" = {
                  network_entity_key = "IGW"
                  description        = "All traffic goes to internet gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              } : {},
              var.spare_subnet_additional_route_rules
            )
          }
        } : {},
        var.additional_route_tables
      )

      security_lists          = local.workload_seclists
      network_security_groups = local.workload_nsgs

      vcn_specific_gateways = {
        internet_gateways = var.deploy_network_architecture == "Standalone" && local.allow_any_public_access ? {
          "IGW" = {
            display_name = var.internet_gateway_display_name
          }
        } : {}
        nat_gateways = var.enable_nat_gateway ? {
          "NATGW" = {
            display_name  = var.nat_gateway_display_name
            block_traffic = var.nat_gateway_block_traffic
          }
        } : {}
        service_gateways = var.enable_service_gateway ? {
          "SGW" = {
            display_name = var.service_gateway_display_name
            services     = var.service_gateway_services
          }
        } : {}
      }
    }
  }

  network_configuration = {
    default_compartment_id = var.isolated_resources ? var.workload_compartment_ocid : var.network_compartment_ocid
    network_configuration_categories = {
      "generic-network" = {
        vcns = local.workload_vcn
      }
    }
  }
}

module "network" {
  source                = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.7.3"
  network_configuration = local.network_configuration
  tenancy_ocid          = var.tenancy_ocid
}
