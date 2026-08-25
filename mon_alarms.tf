# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

### This Terraform configuration provisions alarms for the tenancy.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local variables can be overridden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  custom_alarms_defined_tags  = null
  custom_alarms_freeform_tags = null
}

# Alarms is a regional service. As such, we must not skip provisioning when extending Landing Zone to a new region.
module "lz_alarms" {
  source               = "github.com/oci-landing-zones/terraform-oci-modules-observability//alarms?ref=release-0.2.7"
  alarms_configuration = local.alarms_configuration
  topics_dependency    = module.lz_regional_topics.topics
}

locals {
  #------------------------------------------------------------------------------------------------------
  #-- These variables are not meant to be overridden
  #------------------------------------------------------------------------------------------------------

  #-----------------------------------------------------------
  #----- Tags to apply to alarms
  #-----------------------------------------------------------
  default_alarms_defined_tags  = null
  default_alarms_freeform_tags = local.landing_zone_tags

  alarms_defined_tags  = local.custom_alarms_defined_tags != null ? local.custom_alarms_defined_tags : local.default_alarms_defined_tags
  alarms_freeform_tags = local.custom_alarms_freeform_tags != null ? merge(local.custom_alarms_freeform_tags, local.default_alarms_freeform_tags) : local.default_alarms_freeform_tags

  #--------------------------------------------------------------------
  #-- Compute Alarms
  #--------------------------------------------------------------------
  compute_alarms = length(var.compute_admin_email_endpoints) > 0 ? {
    COMPUTE-ALARM-HIGH-CPU-WARNING = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-high-cpu-alarm-warning"
      preconfigured_alarm_type = "COMPUTE-HIGH-CPU-ALARM-WARNING"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-HIGH-CPU-CRITICAL = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-high-cpu-alarm-critical"
      preconfigured_alarm_type = "COMPUTE-HIGH-CPU-ALARM-CRITICAL"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-INSTANCE-STATUS = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-instance-status-alarm"
      preconfigured_alarm_type = "COMPUTE-VM-STATUS-ALARM-CRITICAL"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-VM-MAINTENANCE-STATUS = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-vm-maintenance-alarm"
      preconfigured_alarm_type = "COMPUTE-MAINTENANCE-ALARM-WARNING"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-BARE-METAL-HEALTH-STATUS = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-bare-metal-health-alarm"
      preconfigured_alarm_type = "COMPUTE-BARE-METAL-HEALTH-ALARM-CRITICAL"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-HIGH-MEMORY-WARNING = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-high-memory-alarm-warning"
      preconfigured_alarm_type = "COMPUTE-HIGH-MEMORY-ALARM-WARNING"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-HIGH-MEMORY-CRITICAL = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-high-memory-alarm-critical"
      preconfigured_alarm_type = "COMPUTE-HIGH-MEMORY-ALARM-CRITICAL"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Database Alarms
  #--------------------------------------------------------------------
  database_alarms = length(var.database_admin_email_endpoints) > 0 && local.enable_database_compartment ? {
    ADB-HIGH-CPU-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-high-cpu-alarm-warning"
      preconfigured_alarm_type = "ADB-HIGH-CPU-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    ADB-HIGH-CPU-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-high-cpu-alarm-critical"
      preconfigured_alarm_type = "ADB-HIGH-CPU-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    ADB-HIGH-STORAGE-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-high-storage-alarm-warning"
      preconfigured_alarm_type = "ADB-HIGH-STORAGE-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    ADB-HIGH-STORAGE-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-high-storage-alarm-critical"
      preconfigured_alarm_type = "ADB-HIGH-STORAGE-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    ADB-FAILED-LOGINS-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-failed-logins-alarm-warning"
      preconfigured_alarm_type = "ADB-FAILED-LOGINS-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    ADB-FAILED-LOGINS-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-failed-logins-alarm-critical"
      preconfigured_alarm_type = "ADB-FAILED-LOGINS-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    ADB-MONITORING-AVAILABILITY-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-monitoring-availability-alarm-critical"
      preconfigured_alarm_type = "ADB-MONITORING-AVAILABILITY-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    ADB-SESSIONS-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-sessions-alarm-warning"
      preconfigured_alarm_type = "ADB-SESSIONS-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    # OCI Database cluster and database metrics are common to Base DB, ExaCS, and ExaCC.
    DATABASE-CLUSTER-HIGH-CPU-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-cpu-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-CPU-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-CPU-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-cpu-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-CPU-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-MEMORY-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-memory-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-MEMORY-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-MEMORY-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-memory-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-MEMORY-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-FILESYSTEM-UTILIZATION-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-filesystem-utilization-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-FILESYSTEM-UTILIZATION-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-FILESYSTEM-UTILIZATION-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-filesystem-utilization-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-FILESYSTEM-UTILIZATION-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-ASM-DISKGROUP-UTILIZATION-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-asm-diskgroup-utilization-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-ASM-DISKGROUP-UTILIZATION-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-ASM-DISKGROUP-UTILIZATION-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-asm-diskgroup-utilization-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-ASM-DISKGROUP-UTILIZATION-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-SWAP-UTILIZATION-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-swap-utilization-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-SWAP-UTILIZATION-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-HIGH-SWAP-UTILIZATION-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-swap-utilization-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-SWAP-UTILIZATION-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-CLUSTER-NODE-STATUS-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-cluster-node-status-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-NODE-STATUS-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-HIGH-CPU-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-high-cpu-alarm-warning"
      preconfigured_alarm_type = "DATABASE-HIGH-CPU-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-HIGH-CPU-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-high-cpu-alarm-critical"
      preconfigured_alarm_type = "DATABASE-HIGH-CPU-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-HIGH-STORAGE-UTILIZATION-ALARM-WARNING = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-storage-utilization-alarm-warning"
      preconfigured_alarm_type = "DATABASE-HIGH-STORAGE-UTILIZATION-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-HIGH-STORAGE-UTILIZATION-ALARM-CRITICAL = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-database-storage-utilization-alarm-critical"
      preconfigured_alarm_type = "DATABASE-HIGH-STORAGE-UTILIZATION-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
  } : {}

  exainfra_cluster_alarms = length(var.exainfra_admin_email_endpoints) > 0 && local.enable_exainfra_compartment ? {
    EXAINFRA-CLUSTER-HIGH-CPU-ALARM-WARNING = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-cpu-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-CPU-ALARM-WARNING"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-CPU-ALARM-CRITICAL = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-cpu-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-CPU-ALARM-CRITICAL"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-MEMORY-ALARM-WARNING = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-memory-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-MEMORY-ALARM-WARNING"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-MEMORY-ALARM-CRITICAL = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-memory-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-MEMORY-ALARM-CRITICAL"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-FILESYSTEM-UTILIZATION-ALARM-WARNING = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-filesystem-utilization-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-FILESYSTEM-UTILIZATION-ALARM-WARNING"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-FILESYSTEM-UTILIZATION-ALARM-CRITICAL = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-filesystem-utilization-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-FILESYSTEM-UTILIZATION-ALARM-CRITICAL"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-ASM-DISKGROUP-UTILIZATION-ALARM-WARNING = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-asm-diskgroup-utilization-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-ASM-DISKGROUP-UTILIZATION-ALARM-WARNING"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-ASM-DISKGROUP-UTILIZATION-ALARM-CRITICAL = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-asm-diskgroup-utilization-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-ASM-DISKGROUP-UTILIZATION-ALARM-CRITICAL"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-SWAP-UTILIZATION-ALARM-WARNING = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-swap-utilization-alarm-warning"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-SWAP-UTILIZATION-ALARM-WARNING"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-HIGH-SWAP-UTILIZATION-ALARM-CRITICAL = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-high-swap-utilization-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-HIGH-SWAP-UTILIZATION-ALARM-CRITICAL"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-CLUSTER-NODE-STATUS-ALARM-CRITICAL = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-cluster-node-status-alarm-critical"
      preconfigured_alarm_type = "DATABASE-CLUSTER-NODE-STATUS-ALARM-CRITICAL"
      destination_topic_ids    = ["EXAINFRA-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
  } : {}

  exainfra_database_alarms = length(var.database_admin_email_endpoints) > 0 && local.enable_exainfra_compartment ? {
    EXAINFRA-DATABASE-HIGH-CPU-ALARM-WARNING = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-high-cpu-alarm-warning"
      preconfigured_alarm_type = "DATABASE-HIGH-CPU-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-DATABASE-HIGH-CPU-ALARM-CRITICAL = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-high-cpu-alarm-critical"
      preconfigured_alarm_type = "DATABASE-HIGH-CPU-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-DATABASE-HIGH-STORAGE-UTILIZATION-ALARM-WARNING = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-storage-utilization-alarm-warning"
      preconfigured_alarm_type = "DATABASE-HIGH-STORAGE-UTILIZATION-ALARM-WARNING"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    EXAINFRA-DATABASE-HIGH-STORAGE-UTILIZATION-ALARM-CRITICAL = {
      compartment_id           = local.exainfra_compartment_id
      display_name             = "${var.service_label}-database-storage-utilization-alarm-critical"
      preconfigured_alarm_type = "DATABASE-HIGH-STORAGE-UTILIZATION-ALARM-CRITICAL"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Network Alarms
  #--------------------------------------------------------------------  
  network_alarms = length(var.network_admin_email_endpoints) > 0 ? {
    NETWORK-VPN-STATUS-ALARM-CRITICAL = {
      compartment_id           = local.network_compartment_id
      display_name             = "${var.service_label}-network-vpn-status-alarm-critical"
      preconfigured_alarm_type = "NETWORK-VPN-STATUS-ALARM-CRITICAL"
      destination_topic_ids    = ["NETWORK-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    NETWORK-FAST-CONNECT-STATUS-ALARM-CRITICAL = {
      compartment_id           = local.network_compartment_id
      display_name             = "${var.service_label}-fast-connect-status-alarm-critical"
      preconfigured_alarm_type = "NETWORK-FAST-CONNECT-STATUS-ALARM-CRITICAL"
      destination_topic_ids    = ["NETWORK-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    NETWORK-VNIC-CONNECTION-TRACKING-ALARM-CRITICAL = {
      compartment_id           = local.network_compartment_id
      display_name             = "${var.service_label}-vnic-connection-tracking-alarm-critical"
      preconfigured_alarm_type = "NETWORK-VNIC-CONNECTION-TRACKING-ALARM-CRITICAL"
      destination_topic_ids    = ["NETWORK-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
  } : {}

  #------------------------------------------------------------------------
  #----- Alarms configuration definition. Input to module.
  #------------------------------------------------------------------------
  alarms_configuration = {
    default_compartment_id = null
    default_defined_tags   = local.default_alarms_defined_tags
    default_freeform_tags  = local.default_alarms_freeform_tags
    alarms                 = merge(local.compute_alarms, local.database_alarms, local.exainfra_cluster_alarms, local.exainfra_database_alarms, local.network_alarms)
  }
}
