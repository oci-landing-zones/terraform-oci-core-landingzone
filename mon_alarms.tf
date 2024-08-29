# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

### This Terraform configuration provisions alarms for the tenancy.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local variables can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  custom_alarms_defined_tags  = null
  custom_alarms_freeform_tags = null
}

# Alarms is a regional service. As such, we must not skip provisioning when extending Landing Zone to a new region.
module "lz_alarms" {
  source               = "github.com/oci-landing-zones/terraform-oci-modules-observability//alarms?ref=v0.1.8"
  alarms_configuration = local.alarms_configuration
  topics_dependency    = module.lz_regional_topics.topics
}

locals {
  #------------------------------------------------------------------------------------------------------
  #-- These variables are not meant to be overriden
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
    COMPUTE-ALARM-HIGH-CPU = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-high-cpu-alarm"
      preconfigured_alarm_type = "high-cpu-alarm"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-INSTANCE-STATUS = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-instance-status-alarm"
      preconfigured_alarm_type = "instance-status-alarm"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-VM-MAINTENANCE-STATUS = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-vm-maintenance-alarm"
      preconfigured_alarm_type = "vm-maintenance-alarm"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-BARE-METAL-HEALTH-STATUS = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-bare-metal-unhealthy-alarm"
      preconfigured_alarm_type = "bare-metal-unhealthy-alarm"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    COMPUTE-ALARM-HIGH-MEMORY = {
      compartment_id           = local.app_compartment_id
      display_name             = "${var.service_label}-high-memory-alarm"
      preconfigured_alarm_type = "high-memory-alarm"
      destination_topic_ids    = ["COMPUTE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Database Alarms
  #--------------------------------------------------------------------
  database_alarms = length(var.database_admin_email_endpoints) > 0 ? {
    DATABASE-ALARM-ADB-HIGH-CPU = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-cpu-alarm"
      preconfigured_alarm_type = "adb-cpu-alarm"
      destination_topic_ids    = ["DATABASE-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    DATABASE-ALARM-ADB-STORAGE-UTILIZATION = {
      compartment_id           = local.database_compartment_id
      display_name             = "${var.service_label}-adb-storage-alarm"
      preconfigured_alarm_type = "adb-storage-alarm"
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
    NETWORK-ALARM-VPN-STATUS = {
      compartment_id           = local.network_compartment_id
      display_name             = "${var.service_label}-vpn-status-alarm"
      preconfigured_alarm_type = "vpn-status-alarm"
      destination_topic_ids    = ["NETWORK-TOPIC"]
      defined_tags             = local.alarms_defined_tags
      freeform_tags            = local.alarms_freeform_tags
      is_enabled               = var.create_alarms_as_enabled
    }
    NETWORK-ALARM-FAST-CONNECT-STATUS = {
      compartment_id           = local.network_compartment_id
      display_name             = "${var.service_label}-fast-connect-status-alarm"
      preconfigured_alarm_type = "fast-connect-status-alarm"
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
    alarms                 = merge(local.compute_alarms, local.database_alarms, local.network_alarms)
  }
}
