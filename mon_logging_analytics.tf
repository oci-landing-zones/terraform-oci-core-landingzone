# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local vars can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  custom_logging_analytics_log_group_name = null
  custom_logging_analytics_defined_tags   = null
  custom_logging_analytics_freeform_tags  = null
  logging_analytics_log_group_key         = "LOG-ANALYTICS-LOG-GROUP"

  #------------------------------------------------------------------------
  #----- Logging Analytics configuration definition. Input to module.
  #------------------------------------------------------------------------
  logging_analytics_configuration = {
    default_compartment_id    = local.security_compartment_id
    onboard_logging_analytics = var.onboard_logging_analytics, # if logging analytics has not been enabled already, set to true, and if logging analytics has been enabled previously, set to false

    log_groups = {
      (local.logging_analytics_log_group_key) = {
        type          = "logging_analytics"
        name          = local.logging_analytics_log_group_name
        description   = "Logging Analytics Log Group for ${local.logging_analytics_log_group_name}"
        defined_tags  = local.logging_analytics_defined_tags
        freeform_tags = local.logging_analytics_freeform_tags
      }
    }
  }
}

module "lz_logging_analytics" {
  source                = "github.com/oci-landing-zones/terraform-oci-modules-observability//logging?ref=v0.1.8"
  count                 = var.enable_service_connector && var.service_connector_target_kind == "logginganalytics" ? 1 : 0
  logging_configuration = local.logging_analytics_configuration
  tenancy_ocid          = var.tenancy_ocid
}

locals {
  #------------------------------------------------------------------------------------------------------
  #-- These variables are NOT meant to be overriden
  #------------------------------------------------------------------------------------------------------
  #-- Logging Analytics tags
  default_logging_analytics_defined_tags  = null
  default_logging_analytics_freeform_tags = local.landing_zone_tags
  logging_analytics_defined_tags          = local.custom_logging_analytics_defined_tags != null ? merge(local.custom_logging_analytics_defined_tags, local.default_logging_analytics_defined_tags) : local.default_logging_analytics_defined_tags
  logging_analytics_freeform_tags         = local.custom_logging_analytics_freeform_tags != null ? merge(local.custom_logging_analytics_freeform_tags, local.default_logging_analytics_freeform_tags) : local.default_logging_analytics_freeform_tags

  #-- Logging Analytics resources naming
  default_logging_analytics_log_group_name = "${var.service_label}-logging-analytics-log-group"
  logging_analytics_log_group_name         = local.custom_logging_analytics_log_group_name != null ? local.custom_logging_analytics_log_group_name : local.default_logging_analytics_log_group_name
}