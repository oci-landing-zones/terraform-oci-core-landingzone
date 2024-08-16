# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local vars can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  #-- Vault
  custom_vault_name          = null
  custom_vault_key           = null
  custom_vault_type          = null
  custom_vault_defined_tags  = null
  custom_vault_freeform_tags = null

  #-- Keys
  custom_sch_bucket_key_name        = null
  custom_sch_bucket_key_policy_name = null
  custom_keys_defined_tags          = null
  custom_keys_freeform_tags         = null
}

locals {
  vaults_configuration = {
    default_compartment_id = local.security_compartment_id

    vaults = {
      (local.vault_key) = {
        name          = local.vault_name
        defined_tags  = local.vault_defined_tags
        freeform_tags = local.vault_freeform_tags
      }
    }
    keys                = local.managed_sch_bucket_key
    existing_key_grants = local.existing_sch_bucket_key_grants
  }
}
#---------------------------------------------------------------------------
#-- This module call manages a KMS Vault used throughout Landing Zone and
#-- KMS Keys used by AppDev bucket and Service Connector bucket
#---------------------------------------------------------------------------
module "lz_vault" {
  source     = "github.com/oci-landing-zones/terraform-oci-modules-security//vaults?ref=release-0.1.7"
  depends_on = [time_sleep.wait_on_services_policy]
  count      = local.enable_vault ? 1 : 0
  providers = {
    oci      = oci
    oci.home = oci.home
  }
  vaults_configuration = local.vaults_configuration
}

#----------------------------------------------------------------------------
#-- Creating time sleep delays to slow down resource creation
#----------------------------------------------------------------------------
resource "time_sleep" "wait_on_compartments" {
  depends_on      = [module.lz_compartments]
  create_duration = "70s"
}

resource "time_sleep" "wait_on_services_policy" {
  depends_on      = [module.lz_policies]
  create_duration = "70s"
}

locals {
  ### DON'T TOUCH THESE ###
  #-- Vault
  default_vault_name          = "${var.service_label}-vault"
  default_vault_key           = "VIRTUAL-VAULT"
  default_vault_type          = "DEFAULT"
  default_vault_defined_tags  = null
  default_vault_freeform_tags = local.landing_zone_tags

  vault_name          = local.custom_vault_name != null ? local.custom_vault_name : local.default_vault_name
  vault_key           = local.custom_vault_key != null ? local.custom_vault_key : local.default_vault_key
  vault_type          = local.custom_vault_type != null ? local.custom_vault_type : local.default_vault_type
  vault_defined_tags  = local.custom_vault_defined_tags != null ? local.custom_vault_defined_tags : local.default_vault_defined_tags
  vault_freeform_tags = local.custom_vault_freeform_tags != null ? merge(local.custom_vault_freeform_tags, local.default_vault_freeform_tags) : local.default_vault_freeform_tags

  enable_vault = var.cis_level == "2" ? true : false

  #-- Keys
  default_sch_bucket_key_name = "${var.service_label}-sch-bucket-key"
  sch_bucket_key_name         = local.custom_sch_bucket_key_name != null ? local.custom_sch_bucket_key_name : local.default_sch_bucket_key_name

  default_sch_bucket_key_policy_name = "${var.service_label}-service-connector-key-${local.region_key}-policy"
  sch_bucket_key_policy_name         = local.custom_sch_bucket_key_policy_name != null ? local.custom_sch_bucket_key_policy_name : local.default_sch_bucket_key_policy_name

  default_keys_defined_tags  = null
  default_keys_freeform_tags = local.landing_zone_tags

  keys_defined_tags  = local.custom_keys_defined_tags != null ? merge(local.custom_keys_defined_tags, local.default_keys_defined_tags) : local.default_keys_defined_tags
  keys_freeform_tags = local.custom_keys_freeform_tags != null ? merge(local.custom_keys_freeform_tags, local.default_keys_freeform_tags) : local.default_keys_freeform_tags

  sch_key_mapkey = "SCH-BUCKET-KEY"

  managed_sch_bucket_key = var.existing_service_connector_bucket_key_id == null && var.enable_service_connector && var.service_connector_target_kind == "objectstorage" && var.cis_level == "2" ? {
    (local.sch_key_mapkey) = {
      vault_key        = var.existing_service_connector_bucket_vault_id != null ? var.existing_service_connector_bucket_vault_id : local.vault_key
      name             = local.sch_bucket_key_name
      algorithm        = "AES"
      length           = 32
      service_grantees = ["objectstorage-${var.region}"]
      defined_tags     = local.keys_defined_tags
      freeform_tags    = local.keys_freeform_tags
    }
  } : {}

  existing_sch_bucket_key_grants = var.existing_service_connector_bucket_key_id != null ? {
    (local.sch_key_mapkey) = {
      key_id           = var.existing_service_connector_bucket_key_id
      compartment_id   = var.existing_service_connector_bucket_vault_compartment_id
      service_grantees = ["objectstorage-${var.region}"]
    }
  } : {}
}