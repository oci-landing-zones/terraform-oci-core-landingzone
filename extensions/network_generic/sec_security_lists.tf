# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Security Lists
#-------------------------------------------------------

locals {

  workload_seclists = var.deploy_security_lists ? merge(local.app_subnet_seclist, local.web_subnet_seclist, local.db_subnet_seclist, local.mgmt_subnet_seclist, local.lb_subnet_seclist, local.db_backup_subnet_seclist, local.spare_subnet_seclist) : null

  app_subnet_seclist = var.add_app_subnet ? {
    WORKLOAD-APP-SUBNET-SECLIST = {
      display_name = "${coalesce(var.app_subnet_seclist_name, "${var.workload_name}-app-subnet")}-security-list"
      ingress_rules = flatten([
        {
          description = "Ingress on ICMP type 3 code 4"
          stateless   = false
          protocol    = "ICMP"
          src         = "0.0.0.0/0"
          src_type    = "CIDR_BLOCK"
          icmp_type   = 3
          icmp_code   = 4
        },
        [
          for cidr in var.jumphost_cidrs : {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        ],
        var.app_subnet_seclist_additional_ingress_rules
      ])
      egress_rules = flatten([
        var.app_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? [{
          description  = "Egress to All for public subnets."
          stateless    = false
          protocol     = "TCP"
          dst          = "0.0.0.0/0"
          dst_type     = "CIDR_BLOCK"
          dst_port_min = null
          dst_port_max = null
        }] : [],
        var.app_subnet_seclist_additional_egress_rules
      ])
    }
  } : {}

  web_subnet_seclist = var.add_web_subnet ? {
    WORKLOAD-WEB-SUBNET-SECLIST = {
      display_name = "${coalesce(var.web_subnet_seclist_name, "${var.workload_name}-web-subnet")}-security-list"
      ingress_rules = flatten([
        {
          description = "Ingress on ICMP type 3 code 4"
          stateless   = false
          protocol    = "ICMP"
          src         = "0.0.0.0/0"
          src_type    = "CIDR_BLOCK"
          icmp_type   = 3
          icmp_code   = 4
        },
        [
          for cidr in var.jumphost_cidrs : {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        ],
        var.web_subnet_seclist_additional_ingress_rules
      ])
      egress_rules = flatten([
        var.web_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? [{
          description  = "Egress to All for public subnets."
          stateless    = false
          protocol     = "TCP"
          dst          = "0.0.0.0/0"
          dst_type     = "CIDR_BLOCK"
          dst_port_min = null
          dst_port_max = null
        }] : [],
        var.web_subnet_seclist_additional_egress_rules
      ])
    }
  } : {}

  db_subnet_seclist = var.add_db_subnet ? {
    WORKLOAD-DB-SUBNET-SECLIST = {
      display_name = "${coalesce(var.db_subnet_seclist_name, "${var.workload_name}-db-subnet")}-security-list"
      ingress_rules = flatten([
        {
          description = "Ingress on ICMP type 3 code 4"
          stateless   = false
          protocol    = "ICMP"
          src         = "0.0.0.0/0"
          src_type    = "CIDR_BLOCK"
          icmp_type   = 3
          icmp_code   = 4
        },
        [
          for cidr in var.jumphost_cidrs : {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        ],
        var.db_subnet_seclist_additional_ingress_rules
      ])
      egress_rules = flatten([
        var.db_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? [{
          description  = "Egress to All for public subnets."
          stateless    = false
          protocol     = "TCP"
          dst          = "0.0.0.0/0"
          dst_type     = "CIDR_BLOCK"
          dst_port_min = null
          dst_port_max = null
        }] : [],
        var.db_subnet_seclist_additional_egress_rules
      ])
    }
  } : {}

  mgmt_subnet_seclist = var.add_mgmt_subnet ? {
    WORKLOAD-MGMT-SUBNET-SECLIST = {
      display_name = "${coalesce(var.mgmt_subnet_seclist_name, "${var.workload_name}-mgmt-subnet")}-security-list"
      ingress_rules = flatten([
        {
          description = "Ingress on ICMP type 3 code 4"
          stateless   = false
          protocol    = "ICMP"
          src         = "0.0.0.0/0"
          src_type    = "CIDR_BLOCK"
          icmp_type   = 3
          icmp_code   = 4
        },
        [
          for cidr in var.jumphost_cidrs : {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        ],
        var.mgmt_subnet_seclist_additional_ingress_rules
      ])
      egress_rules = flatten([
        var.mgmt_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? [{
          description  = "Egress to All for public subnets."
          stateless    = false
          protocol     = "TCP"
          dst          = "0.0.0.0/0"
          dst_type     = "CIDR_BLOCK"
          dst_port_min = null
          dst_port_max = null
        }] : [],
        var.mgmt_subnet_seclist_additional_egress_rules
      ])
    }
  } : {}

  lb_subnet_seclist = var.add_lb_subnet ? {
    WORKLOAD-LB-SUBNET-SECLIST = {
      display_name = "${coalesce(var.lb_subnet_seclist_name, "${var.workload_name}-lb-subnet")}-security-list"
      ingress_rules = flatten([
        {
          description = "Ingress on ICMP type 3 code 4"
          stateless   = false
          protocol    = "ICMP"
          src         = "0.0.0.0/0"
          src_type    = "CIDR_BLOCK"
          icmp_type   = 3
          icmp_code   = 4
        },
        [
          for cidr in var.jumphost_cidrs : {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        ],
        var.lb_subnet_seclist_additional_ingress_rules
      ])
      egress_rules = flatten([
        var.lb_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? [{
          description  = "Egress to All for public subnets."
          stateless    = false
          protocol     = "TCP"
          dst          = "0.0.0.0/0"
          dst_type     = "CIDR_BLOCK"
          dst_port_min = null
          dst_port_max = null
        }] : [],
        var.lb_subnet_seclist_additional_egress_rules
      ])
    }
  } : {}

  db_backup_subnet_seclist = var.add_db_backup_subnet ? {
    WORKLOAD-DB-BACKUP-SUBNET-SECLIST = {
      display_name = "${coalesce(var.db_backup_subnet_seclist_name, "${var.workload_name}-db-backup-subnet")}-security-list"
      ingress_rules = flatten([
        {
          description = "Ingress on ICMP type 3 code 4"
          stateless   = false
          protocol    = "ICMP"
          src         = "0.0.0.0/0"
          src_type    = "CIDR_BLOCK"
          icmp_type   = 3
          icmp_code   = 4
        },
        [
          for cidr in var.jumphost_cidrs : {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        ],
        var.db_backup_subnet_seclist_additional_ingress_rules
      ])
      egress_rules = flatten([
        var.db_backup_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? [{
          description  = "Egress to All for public subnets."
          stateless    = false
          protocol     = "TCP"
          dst          = "0.0.0.0/0"
          dst_type     = "CIDR_BLOCK"
          dst_port_min = null
          dst_port_max = null
        }] : [],
        var.db_backup_subnet_seclist_additional_egress_rules
      ])
    }
  } : {}

  spare_subnet_seclist = var.add_spare_subnet ? {
    WORKLOAD-SPARE-SUBNET-SECLIST = {
      display_name = var.spare_subnet_seclist_name
      ingress_rules = flatten([
        {
          description = "Ingress on ICMP type 3 code 4"
          stateless   = false
          protocol    = "ICMP"
          src         = "0.0.0.0/0"
          src_type    = "CIDR_BLOCK"
          icmp_type   = 3
          icmp_code   = 4
        },
        [
          for cidr in var.jumphost_cidrs : {
            description  = "Ingress from jumphost ${cidr} on port 22."
            stateless    = false
            protocol     = "TCP"
            src          = cidr
            src_type     = "CIDR_BLOCK"
            dst_port_min = 22
            dst_port_max = 22
          }
        ],
        var.spare_subnet_seclist_additional_ingress_rules
      ])
      egress_rules = flatten([
        var.spare_subnet_allow_public_access && var.deploy_network_architecture == "Standalone" ? [{
          description  = "Egress to All for public subnets."
          stateless    = false
          protocol     = "TCP"
          dst          = "0.0.0.0/0"
          dst_type     = "CIDR_BLOCK"
          dst_port_min = null
          dst_port_max = null
        }] : [],
        var.spare_subnet_seclist_additional_egress_rules
      ])
    }
  } : {}
}