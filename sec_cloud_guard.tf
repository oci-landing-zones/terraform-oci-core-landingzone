# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #--------------------------------------------------------------------------
  #-- Any of these custom variables can be overriden in a _override.tf file.
  #--------------------------------------------------------------------------  
  #-- Custom target name
  custom_target_name = null
  #-- Custom prefix for cloned recipes
  custom_cloned_recipes_prefix = null
  #-- Custom tags
  custom_cloud_guard_target_defined_tags  = null
  custom_cloud_guard_target_freeform_tags = null
}

module "lz_cloud_guard" {
  count = var.enable_cloud_guard ? 1 : 0
  # depends_on                = [null_resource.wait_on_services_policy]
  source                    = "github.com/oci-landing-zones/terraform-oci-modules-security//cloud-guard?ref=v0.1.7"
  cloud_guard_configuration = local.cloud_guard_configuration
  tenancy_ocid              = var.tenancy_ocid
  enable_output             = true
  providers                 = { oci = oci.home }
}

locals {
  #--------------------------------------------------------------------------
  #-- These variables are NOT meant to be overriden.
  #--------------------------------------------------------------------------

  default_cloud_guard_target_defined_tags  = null
  default_cloud_guard_target_freeform_tags = local.landing_zone_tags

  cloud_guard_target_defined_tags  = local.custom_cloud_guard_target_defined_tags != null ? merge(local.custom_cloud_guard_target_defined_tags, local.default_cloud_guard_target_defined_tags) : local.default_cloud_guard_target_defined_tags
  cloud_guard_target_freeform_tags = local.custom_cloud_guard_target_freeform_tags != null ? merge(local.custom_cloud_guard_target_freeform_tags, local.default_cloud_guard_target_freeform_tags) : local.default_cloud_guard_target_freeform_tags

  #------------------------------------------------------------------------
  #----- Cloud Guard configuration definition. Input to module.
  #------------------------------------------------------------------------
  cloud_guard_configuration = {
    reporting_region      = var.cloud_guard_reporting_region != null ? var.cloud_guard_reporting_region : local.regions_map[local.home_region_key]
    cloned_recipes_prefix = coalesce(local.custom_cloned_recipes_prefix, var.service_label)
    default_defined_tags  = local.default_cloud_guard_target_defined_tags
    default_freeform_tags = local.default_cloud_guard_target_freeform_tags

    targets = {
      CLOUD-GUARD-ROOT-TARGET = {
        name               = coalesce(local.custom_target_name, "${var.service_label}-cloud-guard-root-target")
        resource_id        = "TENANCY-ROOT"
        use_cloned_recipes = var.enable_cloud_guard_cloned_recipes
        defined_tags       = local.cloud_guard_target_defined_tags
        freeform_tags      = local.cloud_guard_target_freeform_tags
      }
    }
  }
}
