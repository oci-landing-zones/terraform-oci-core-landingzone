# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
/*

locals {
  ### These variables can be overriden.
  custom_security_zones_defined_tags       = null
  custom_security_zones_freeform_tags      = null
  custom_security_zone_target_compartments = null
}

locals {
  ### These variables are NOT meant to be overriden.
  managed_enclosing_target_sz_compartment = length(module.lz_top_compartment) > 0 ? {
    "${local.enclosing_compartment_key}-security-zone" = {
      "sz_compartment_name" : module.lz_top_compartment[0].compartments[local.enclosing_compartment_key].name,
      "sz_compartment_id" : module.lz_top_compartment[0].compartments[local.enclosing_compartment_key].id
    }
  } : {}
  existing_enclosing_target_sz_compartment = length(module.lz_top_compartment) == 0 && local.enclosing_compartment_id != var.tenancy_ocid ? {
    "${local.enclosing_compartment_key}-security-zone" = {
      "sz_compartment_name" : local.network_compartment_name,
      "sz_compartment_id" : local.enclosing_compartment_id
    }
  } : {}

  auto_security_zone_target_compartments = length(local.managed_enclosing_target_sz_compartment) > 0 ? local.managed_enclosing_target_sz_compartment : (length(local.existing_enclosing_target_sz_compartment) > 0 ? local.existing_enclosing_target_sz_compartment : {})
  security_zone_target_compartments      = local.custom_security_zone_target_compartments != null ? local.custom_security_zone_target_compartments : local.auto_security_zone_target_compartments

  default_security_zones_defined_tags  = null
  default_security_zones_freeform_tags = local.landing_zone_tags

  security_zones_defined_tags  = local.custom_security_zones_defined_tags != null ? merge(local.custom_security_zones_defined_tags, local.default_security_zones_defined_tags) : local.default_security_zones_defined_tags
  security_zones_freeform_tags = local.custom_security_zones_freeform_tags != null ? merge(local.custom_security_zones_freeform_tags, local.default_security_zones_freeform_tags) : local.default_security_zones_freeform_tags

  security_zones_configuration = {
    #reporting_region = "<REPLACE-BY-REPORTING-REGION-NAME>" # It defaults to tenancy home region if undefined.

    security_zones = {
      SECURITY-ZONE = {
        name           = "lz-security-zone"
        compartment_id = local.security_zone_target_compartments
        recipe_key     = "CIS-L1-RECIPE"
      }
    }
    recipes = {
      CIS-L1-RECIPE = {
        name                    = "lz-security-zone-cis-level-1-recipe"
        description             = "CIS Level 1 recipe"
        compartment_id          = local.security_zone_target_compartments
        security_policies_ocids = var.sz_security_policies
        cis_level               = "1"
      }
      CIS-L2-RECIPE = {
        name                    = "lz-security-zone-cis-level-2-recipe"
        description             = "CIS Level 2 recipe"
        compartment_id          = local.security_zone_target_compartments
        security_policies_ocids = var.sz_security_policies
        cis_level               = "2"
      }
    }
  }
}

module "lz_security_zones" {
  count                        = var.enable_security_zones && length(local.security_zone_target_compartments) > 0 && var.extend_landing_zone_to_new_region == false ? 1 : 0
  source                       = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/security-zones?ref=v0.1.6"
  tenancy_ocid                 = var.tenancy_ocid
  security_zones_configuration = local.security_zones_configuration
} 
*/