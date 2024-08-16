# Copyright (c) 2022 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

### Creates scanning recipes and targets. All Landing Zone compartments are targets.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local variables can be overridden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  custom_vss_defined_tags  = null
  custom_vss_freeform_tags = null
  custom_vss_recipe_name   = null
}

#-- VSS is a regional service. As such, we must not skip provisioning when extending Landing Zone to a new region.
module "lz_scanning" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-security//vss?ref=release-0.1.7"
  # depends_on = [null_resource.wait_on_services_policy]
  count                  = var.vss_create ? 1 : 0
  scanning_configuration = local.scanning_configuration
}

locals {
  #------------------------------------------------------------------------------------------------------
  #-- These local variables are NOT meant to be overriden
  #------------------------------------------------------------------------------------------------------
  default_vss_defined_tags  = null
  default_vss_freeform_tags = local.landing_zone_tags

  vss_defined_tags  = local.custom_vss_defined_tags != null ? merge(local.custom_vss_defined_tags, local.default_vss_defined_tags) : local.default_vss_defined_tags
  vss_freeform_tags = local.custom_vss_freeform_tags != null ? merge(local.custom_vss_freeform_tags, local.default_vss_freeform_tags) : local.default_vss_freeform_tags

  vss_recipe_name = local.custom_vss_recipe_name != null ? local.custom_vss_recipe_name : "${var.service_label}-default-scan-recipe"

  #--------------------------------------------------------------------
  #-- Scan Recipes
  #--------------------------------------------------------------------
  default_host_recipe = {
    DEFAULT-HOST-RECIPE = {
      name            = local.vss_recipe_name
      port_scan_level = var.vss_port_scan_level
      schedule_settings = {
        type        = var.vss_scan_schedule
        day_of_week = var.vss_scan_day
      }
      agent_settings = {
        port_scan_level          = var.vss_agent_scan_level
        cis_benchmark_scan_level = var.vss_agent_cis_benchmark_settings_scan_level
      }
      file_scan_settings = {
        enable          = var.vss_enable_file_scan
        folders_to_scan = var.vss_folders_to_scan
      }
      defined_tags  = local.vss_defined_tags
      freeform_tags = local.vss_freeform_tags
    }
  }

  #--------------------------------------------------------------------
  #-- Scan Targets
  #--------------------------------------------------------------------
  security_host_target = {
    SECURITY-HOST-TARGET = {
      name                  = "${var.service_label}-security-cmp-scan-target"
      description           = "CIS Landing Zone ${local.security_compartment_name} compartment scanning target."
      target_compartment_id = local.security_compartment_id
      host_recipe_id        = "DEFAULT-HOST-RECIPE"
      defined_tags          = local.vss_defined_tags
      freeform_tags         = local.vss_freeform_tags
    }
  }

  network_host_target = {
    NETWORK-HOST-TARGET = {
      name                  = "${var.service_label}-network-cmp-scan-target"
      description           = "CIS Landing Zone ${local.network_compartment_name} compartment scanning target."
      target_compartment_id = local.network_compartment_id
      host_recipe_id        = "DEFAULT-HOST-RECIPE"
      defined_tags          = local.vss_defined_tags
      freeform_tags         = local.vss_freeform_tags
    }
  }

  app_host_target = local.enable_app_compartment ? {
    APP-HOST-TARGET = {
      name                  = "${var.service_label}-app-cmp-scan-target"
      description           = "CIS Landing Zone ${local.app_compartment_name} compartment scanning target."
      target_compartment_id = local.app_compartment_id
      host_recipe_id        = "DEFAULT-HOST-RECIPE"
      defined_tags          = local.vss_defined_tags
      freeform_tags         = local.vss_freeform_tags
    }
  } : {}

  database_host_target = local.enable_database_compartment ? {
    DATABASE-HOST-TARGET = {
      name                  = "${var.service_label}-database-cmp-scan-target"
      description           = "CIS Landing Zone ${local.database_compartment_name} compartment scanning target."
      target_compartment_id = local.database_compartment_id
      host_recipe_id        = "DEFAULT-HOST-RECIPE"
      defined_tags          = local.vss_defined_tags
      freeform_tags         = local.vss_freeform_tags
    }
  } : {}

  exainfra_host_target = local.enable_exainfra_compartment ? {
    EXAINFRA-HOST-TARGET = {
      name                  = "${var.service_label}-exainfra-cmp-scan-target"
      description           = "CIS Landing Zone ${local.exainfra_compartment_name} compartment scanning target."
      target_compartment_id = local.exainfra_compartment_id
      host_recipe_id        = "DEFAULT-HOST-RECIPE"
      defined_tags          = local.vss_defined_tags
      freeform_tags         = local.vss_freeform_tags
    }
  } : {}

  #------------------------------------------------------------------------
  #----- VSS configuration definition. Input to module.
  #------------------------------------------------------------------------
  host_recipes = merge(local.default_host_recipe)
  vss_targets  = merge(local.app_host_target, local.database_host_target, local.security_host_target, local.network_host_target, local.exainfra_host_target)

  scanning_configuration = {
    default_compartment_id = local.security_compartment_id
    default_defined_tags   = local.default_vss_defined_tags
    default_freeform_tags  = local.default_vss_freeform_tags
    host_recipes           = local.host_recipes
    host_targets           = local.vss_targets
  }
}
