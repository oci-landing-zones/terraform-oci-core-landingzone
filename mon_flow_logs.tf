# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local vars can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  all_flow_logs_defined_tags  = {}
  all_flow_logs_freeform_tags = {}

  all_lz_subnets = module.lz_network.provisioned_networking_resources.subnets

  flow_logs = { for k, v in local.all_lz_subnets : "${k}-FLOW-LOG" =>
    {
      name               = "${k}-flow-log"
      log_group_id       = "FLOW-LOGS-GROUP"
      service            = "flowlogs"
      category           = "all",
      resource_id        = v.id,
      is_enabled         = true,
      retention_duration = 30,
      defined_tags       = local.flow_logs_defined_tags,
      freeform_tags      = local.flow_logs_freeform_tags
    }
  }

  #------------------------------------------------------------------------
  #----- Flow Logs configuration definition. Input to module.
  #------------------------------------------------------------------------
  logging_configuration = {
    default_compartment_id = local.security_compartment_key
    default_defined_tags   = local.flow_logs_defined_tags
    default_freeform_tags  = local.flow_logs_freeform_tags

    log_groups = {
      FLOW-LOGS-GROUP = {
        name        = "${var.service_label}-flow-logs-group"
        description = "Landing Zone ${var.service_label} flow logs group."
      }
    }

    service_logs = local.flow_logs
  }

  ### DON'T TOUCH THESE ###
  default_flow_logs_defined_tags  = null
  default_flow_logs_freeform_tags = local.landing_zone_tags

  flow_logs_defined_tags  = length(local.all_flow_logs_defined_tags) > 0 ? local.all_flow_logs_defined_tags : local.default_flow_logs_defined_tags
  flow_logs_freeform_tags = length(local.all_flow_logs_freeform_tags) > 0 ? merge(local.all_flow_logs_freeform_tags, local.default_flow_logs_freeform_tags) : local.default_flow_logs_freeform_tags

}

module "lz_flow_logs" {
  depends_on              = [module.lz_network, module.lz_compartments]
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-observability//logging?ref=v0.1.8"
  logging_configuration   = local.logging_configuration
  compartments_dependency = module.lz_compartments[0].compartments
  tenancy_ocid            = var.tenancy_ocid
}