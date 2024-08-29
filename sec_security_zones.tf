# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  ### These variables can be overriden.
  custom_security_zones_defined_tags       = null
  custom_security_zones_freeform_tags      = null
  custom_security_zone_target_compartments = null
}

locals {

  default_security_zones_defined_tags  = null
  default_security_zones_freeform_tags = local.landing_zone_tags

  security_zones_defined_tags  = local.custom_security_zones_defined_tags != null ? merge(local.custom_security_zones_defined_tags, local.default_security_zones_defined_tags) : local.default_security_zones_defined_tags
  security_zones_freeform_tags = local.custom_security_zones_freeform_tags != null ? merge(local.custom_security_zones_freeform_tags, local.default_security_zones_freeform_tags) : local.default_security_zones_freeform_tags

  security_zones_configuration = {
    reporting_region = var.security_zones_reporting_region

    security_zones = {
      SECURITY-ZONE = {
        name           = "${var.service_label}-lz-security-zone"
        compartment_id = local.enclosing_compartment_id
        recipe_key     = var.cis_level == "1" ? "CIS-L1-RECIPE" : "CIS-L2-RECIPE"
      }
    }
    recipes = {
      CIS-L1-RECIPE = {
        name                    = "lz-security-zone-cis-level-1-recipe"
        description             = "CIS Level 1 recipe"
        compartment_id          = local.enclosing_compartment_id
        cis_level               = "1"
        security_policies_ocids = var.sz_security_policies
      }
      CIS-L2-RECIPE = {
        name                    = "lz-security-zone-cis-level-2-recipe"
        description             = "CIS Level 2 recipe"
        compartment_id          = local.enclosing_compartment_id
        cis_level               = "2"
        security_policies_ocids = var.sz_security_policies
      }
    }
  }
}

module "lz_security_zones" {
  count                        = var.enable_security_zones && var.extend_landing_zone_to_new_region == false ? 1 : 0
  source                       = "github.com/oci-landing-zones/terraform-oci-modules-security//security-zones?ref=v0.1.7"
  tenancy_ocid                 = var.tenancy_ocid
  security_zones_configuration = local.security_zones_configuration
}
