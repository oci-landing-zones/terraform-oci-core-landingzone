# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

### This Terraform configuration creates a custom tag namespace and tags in the
### specified tag_namespace_compartment_id
### and tag defaults in the specified tag_defaults_compartment_id.
### But only if there are no tag defaults for the oracle default namespace.
### It also creates the architecture center namespace and tags.

locals {
  # These values can be used in an override file.
  tag_namespace_name           = ""
  tag_namespace_compartment_id = var.extend_landing_zone_to_new_region == false ? var.tenancy_ocid : null
  tag_defaults_compartment_id  = var.extend_landing_zone_to_new_region == false ? var.tenancy_ocid : null

  all_tags_defined_tags  = {}
  all_tags_freeform_tags = {}

  tags_configuration = {
    default_compartment_id = local.tag_namespace_compartment_id,
    cis_namespace_name     = length(local.tag_namespace_name) > 0 ? local.tag_namespace_name : local.default_tag_namespace_name
    default_defined_tags   = local.tags_defined_tags,
    default_freeform_tags  = local.tags_freeform_tags

    namespaces = {
      ARCH-CENTER-NAMESPACE = {
        name        = "ArchitectureCenter\\oci-core-landing-zone-${var.service_label}"
        description = "OCI Core Landing Zone tag namespace for OCI Architecture Center."
        is_retired  = false
        tags = {
          ARCH-CENTER-TAG = {
            name        = "release"
            description = "OCI Core Landing Zone tag for OCI Architecture Center."
          }
        }
      }
    }
  }

  ##### DON'T TOUCH ANYTHING BELOW #####
  default_tags_defined_tags  = null
  default_tags_freeform_tags = local.landing_zone_tags

  tags_defined_tags  = length(local.all_tags_defined_tags) > 0 ? local.all_tags_defined_tags : local.default_tags_defined_tags
  tags_freeform_tags = length(local.all_tags_freeform_tags) > 0 ? merge(local.all_tags_freeform_tags, local.default_tags_freeform_tags) : local.default_tags_freeform_tags

  default_tag_namespace_name = "${var.service_label}-namesp"
}

module "lz_tags" {
  source             = "github.com/oci-landing-zones/terraform-oci-modules-governance//tags?ref=v0.1.4"
  count              = var.extend_landing_zone_to_new_region == false ? 1 : 0
  tags_configuration = local.tags_configuration
  tenancy_ocid       = var.tenancy_ocid
}