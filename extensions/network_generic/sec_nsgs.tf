# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- NSGs
#-------------------------------------------------------

locals {

  workload_nsgs = var.deploy_nsgs ? merge(local.app_nsg, local.web_nsg, local.db_nsg, local.mgmt_nsg, local.lb_nsg, local.db_backup_nsg, local.spare_nsg, var.additional_nsgs) : null

  app_nsg = var.add_app_subnet ? {
    WORKLOAD-VCN-APP-NSG = {
      display_name = coalesce(var.app_nsg_name, "${var.workload_name}-app-nsg")
      ingress_rules = merge(
        {
          "INGRESS-FROM-ANYWHERE-ICMP-APP-RULE" = {
            description = "Ingress on ICMP type 3 code 4"
            stateless   = false
            protocol    = "ICMP"
            src         = "0.0.0.0/0"
            src_type    = "CIDR_BLOCK"
            icmp_type   = 3
            icmp_code   = 4
          }
        },
        {
          for cidr in var.jumphost_cidrs : "INGRESS-FROM-JUMPHOST-${cidr}-RULE" => {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        },
        var.app_nsg_additional_ingress_rules
      )
      egress_rules = merge(
        var.app_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? {
          "PUBLIC-EGRESS-TO-ALL" = {
            description  = "Egress to All for public subnets."
            stateless    = false
            protocol     = "TCP"
            dst          = "0.0.0.0/0"
            dst_type     = "CIDR_BLOCK"
            dst_port_min = null
            dst_port_max = null
          }
        } : {},
        var.app_nsg_additional_egress_rules
      )
    }
  } : {}

  web_nsg = var.add_web_subnet ? {
    WORKLOAD-VCN-WEB-NSG = {
      display_name = coalesce(var.web_nsg_name, "${var.workload_name}-web-nsg")
      ingress_rules = merge(
        {
          "INGRESS-FROM-ANYWHERE-ICMP-WEB-RULE" = {
            description = "Ingress on ICMP type 3 code 4"
            stateless   = false
            protocol    = "ICMP"
            src         = "0.0.0.0/0"
            src_type    = "CIDR_BLOCK"
            icmp_type   = 3
            icmp_code   = 4
          }
        },
        {
          for cidr in var.jumphost_cidrs : "INGRESS-FROM-JUMPHOST-${cidr}-RULE" => {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        },
        var.web_nsg_additional_ingress_rules
      )
      egress_rules = merge(
        var.web_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? {
          "PUBLIC-EGRESS-TO-ALL" = {
            description  = "Egress to All for public subnets."
            stateless    = false
            protocol     = "TCP"
            dst          = "0.0.0.0/0"
            dst_type     = "CIDR_BLOCK"
            dst_port_min = null
            dst_port_max = null
          }
        } : {},
        var.web_nsg_additional_egress_rules
      )
    }
  } : {}

  db_nsg = var.add_db_subnet ? {
    WORKLOAD-VCN-DB-NSG = {
      display_name = coalesce(var.db_nsg_name, "${var.workload_name}-db-nsg")
      ingress_rules = merge(
        {
          "INGRESS-FROM-ANYWHERE-ICMP-DB-RULE" = {
            description = "Ingress on ICMP type 3 code 4"
            stateless   = false
            protocol    = "ICMP"
            src         = "0.0.0.0/0"
            src_type    = "CIDR_BLOCK"
            icmp_type   = 3
            icmp_code   = 4
          }
        },
        {
          for cidr in var.jumphost_cidrs : "INGRESS-FROM-JUMPHOST-${cidr}-RULE" => {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        },
        var.db_nsg_additional_ingress_rules
      )
      egress_rules = merge(
        var.db_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? {
          "PUBLIC-EGRESS-TO-ALL" = {
            description  = "Egress to All for public subnets."
            stateless    = false
            protocol     = "TCP"
            dst          = "0.0.0.0/0"
            dst_type     = "CIDR_BLOCK"
            dst_port_min = null
            dst_port_max = null
          }
        } : {},
        var.db_nsg_additional_egress_rules
      )
    }
  } : {}

  mgmt_nsg = var.add_mgmt_subnet ? {
    WORKLOAD-VCN-MGMT-NSG = {
      display_name = coalesce(var.mgmt_nsg_name, "${var.workload_name}-mgmt-nsg")
      ingress_rules = merge(
        {
          "INGRESS-FROM-ANYWHERE-ICMP-MGMT-RULE" = {
            description = "Ingress on ICMP type 3 code 4"
            stateless   = false
            protocol    = "ICMP"
            src         = "0.0.0.0/0"
            src_type    = "CIDR_BLOCK"
            icmp_type   = 3
            icmp_code   = 4
          }
        },
        {
          for cidr in var.jumphost_cidrs : "INGRESS-FROM-JUMPHOST-${cidr}-RULE" => {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        },
        var.mgmt_nsg_additional_ingress_rules
      )
      egress_rules = merge(
        var.mgmt_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? {
          "PUBLIC-EGRESS-TO-ALL" = {
            description  = "Egress to All for public subnets."
            stateless    = false
            protocol     = "TCP"
            dst          = "0.0.0.0/0"
            dst_type     = "CIDR_BLOCK"
            dst_port_min = null
            dst_port_max = null
          }
        } : {},
        var.mgmt_nsg_additional_egress_rules
      )
    }
  } : {}

  lb_nsg = var.add_lb_subnet ? {
    WORKLOAD-VCN-LB-NSG = {
      display_name = coalesce(var.lb_nsg_name, "${var.workload_name}-lb-nsg")
      ingress_rules = merge(
        {
          "INGRESS-FROM-ANYWHERE-ICMP-LB-RULE" = {
            description = "Ingress on ICMP type 3 code 4"
            stateless   = false
            protocol    = "ICMP"
            src         = "0.0.0.0/0"
            src_type    = "CIDR_BLOCK"
            icmp_type   = 3
            icmp_code   = 4
          }
        },
        {
          for cidr in var.jumphost_cidrs : "INGRESS-FROM-JUMPHOST-${cidr}-RULE" => {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        },
        var.lb_nsg_additional_ingress_rules
      )
      egress_rules = merge(
        var.lb_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? {
          "PUBLIC-EGRESS-TO-ALL" = {
            description  = "Egress to All for public subnets."
            stateless    = false
            protocol     = "TCP"
            dst          = "0.0.0.0/0"
            dst_type     = "CIDR_BLOCK"
            dst_port_min = null
            dst_port_max = null
          }
        } : {},
        var.lb_nsg_additional_egress_rules
      )
    }
  } : {}

  db_backup_nsg = var.add_db_backup_subnet ? {
    WORKLOAD-VCN-DB-BACKUP-NSG = {
      display_name = coalesce(var.db_backup_nsg_name, "${var.workload_name}-db-backup-nsg")
      ingress_rules = merge(
        {
          "INGRESS-FROM-ANYWHERE-ICMP-DB-BACKUP-RULE" = {
            description = "Ingress on ICMP type 3 code 4"
            stateless   = false
            protocol    = "ICMP"
            src         = "0.0.0.0/0"
            src_type    = "CIDR_BLOCK"
            icmp_type   = 3
            icmp_code   = 4
          }
        },
        {
          for cidr in var.jumphost_cidrs : "INGRESS-FROM-JUMPHOST-${cidr}-RULE" => {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        },
        var.db_backup_nsg_additional_ingress_rules
      )
      egress_rules = merge(
        var.db_backup_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? {
          "PUBLIC-EGRESS-TO-ALL" = {
            description  = "Egress to All for public subnets."
            stateless    = false
            protocol     = "TCP"
            dst          = "0.0.0.0/0"
            dst_type     = "CIDR_BLOCK"
            dst_port_min = null
            dst_port_max = null
          }
        } : {},
        var.db_backup_nsg_additional_egress_rules
      )
    }
  } : {}

  spare_nsg = var.add_spare_subnet ? {
    WORKLOAD-VCN-SPARE-NSG = {
      display_name = var.spare_nsg_name
      ingress_rules = merge(
        {
          "INGRESS-FROM-ANYWHERE-ICMP-SPARE-RULE" = {
            description = "Ingress on ICMP type 3 code 4"
            stateless   = false
            protocol    = "ICMP"
            src         = "0.0.0.0/0"
            src_type    = "CIDR_BLOCK"
            icmp_type   = 3
            icmp_code   = 4
          }
        },
        {
          for cidr in var.jumphost_cidrs : "INGRESS-FROM-JUMPHOST-${cidr}-RULE" => {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        },
        var.spare_nsg_additional_ingress_rules,
      )
      egress_rules = merge(
        var.spare_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? {
          "PUBLIC-EGRESS-TO-ALL" = {
            description  = "Egress to All for public subnets."
            stateless    = false
            protocol     = "TCP"
            dst          = "0.0.0.0/0"
            dst_type     = "CIDR_BLOCK"
            dst_port_min = null
            dst_port_max = null
          }
        } : {},
        var.spare_nsg_additional_egress_rules
      )
    }
  } : {}

}
