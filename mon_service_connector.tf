# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local vars can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  custom_service_connector_name                      = null
  custom_service_connector_target_bucket_name        = null
  custom_service_connector_target_bucket_key         = null
  custom_service_connector_target_object_name_prefix = null
  custom_service_connector_target_stream_name        = null
  custom_service_connector_target_stream_key         = null
  custom_service_connector_target_log_group_name     = null
  custom_service_connector_target_policy_name        = null

  custom_service_connector_defined_tags  = null
  custom_service_connector_freeform_tags = null

  custom_target_defined_tags  = null
  custom_target_freeform_tags = null

  custom_policy_defined_tags  = null
  custom_policy_freeform_tags = null

  flow_logs_sources = [for k, log in module.lz_flow_logs.service_logs : {
    cmp_id       = local.security_compartment_id
    log_group_id = log.log_group_id
    log_id       = log.id
  }]
}

locals {
  #------------------------------------------------------------------------------------------------------
  #-- These variables are not meant to be overriden
  #------------------------------------------------------------------------------------------------------
  #-- Service Connector tags
  default_service_connector_defined_tags  = null
  default_service_connector_freeform_tags = local.landing_zone_tags
  service_connector_defined_tags          = local.custom_service_connector_defined_tags != null ? merge(local.custom_service_connector_defined_tags, local.default_service_connector_defined_tags) : local.default_service_connector_defined_tags
  service_connector_freeform_tags         = local.custom_service_connector_freeform_tags != null ? merge(local.custom_service_connector_freeform_tags, local.default_service_connector_freeform_tags) : local.default_service_connector_freeform_tags

  #-- Service Connector Target tags
  default_target_defined_tags  = null
  default_target_freeform_tags = local.landing_zone_tags
  target_defined_tags          = local.custom_target_defined_tags != null ? merge(local.custom_target_defined_tags, local.default_target_defined_tags) : local.default_target_defined_tags
  target_freeform_tags         = local.custom_target_freeform_tags != null ? merge(local.custom_target_freeform_tags, local.default_target_freeform_tags) : local.default_target_freeform_tags

  #-- Service Connector Policy tags
  default_policy_defined_tags  = null
  default_policy_freeform_tags = local.landing_zone_tags
  policy_defined_tags          = local.custom_policy_defined_tags != null ? merge(local.custom_policy_defined_tags, local.default_policy_defined_tags) : local.default_policy_defined_tags
  policy_freeform_tags         = local.custom_policy_freeform_tags != null ? merge(local.custom_policy_freeform_tags, local.default_policy_freeform_tags) : local.default_policy_freeform_tags

  #-- Service Connector resources naming
  default_service_connector_name = "${var.service_label}-service-connector"
  service_connector_name         = local.custom_service_connector_name != null ? local.custom_service_connector_name : local.default_service_connector_name

  default_service_connector_target_bucket_name = "${var.service_label}-service-connector-bucket"
  service_connector_target_bucket_name         = local.custom_service_connector_target_bucket_name != null ? local.custom_service_connector_target_bucket_name : local.default_service_connector_target_bucket_name

  default_service_connector_target_bucket_key = "SCH-BUCKET"
  service_connector_target_bucket_key         = local.custom_service_connector_target_bucket_key != null ? local.custom_service_connector_target_bucket_key : local.default_service_connector_target_bucket_key

  default_service_connector_target_stream_name = "${var.service_label}-service-connector-stream"
  service_connector_target_stream_name         = local.custom_service_connector_target_stream_name != null ? local.custom_service_connector_target_stream_name : local.default_service_connector_target_stream_name

  default_service_connector_target_stream_key = "SCH-STREAM"
  service_connector_target_stream_key         = local.custom_service_connector_target_stream_key != null ? local.custom_service_connector_target_stream_key : local.default_service_connector_target_stream_key

  default_service_connector_target_object_name_prefix = "sch"
  service_connector_target_object_name_prefix         = local.custom_service_connector_target_object_name_prefix != null ? local.custom_service_connector_target_object_name_prefix : local.default_service_connector_target_object_name_prefix

  default_service_connector_target_policy_name = "${var.service_label}-service-connector-target-${local.region_key}-policy"
  service_connector_target_policy_name         = local.custom_service_connector_target_policy_name != null ? local.custom_service_connector_target_policy_name : local.default_service_connector_target_policy_name
}

#------------------------------------------------------------------------
#----- Service Connector configuration definition. Input to module.
#------------------------------------------------------------------------
locals {
  service_connectors_configuration = {
    default_compartment_id = local.security_compartment_id
    default_defined_tags   = local.service_connector_defined_tags
    default_freeform_tags  = local.service_connector_freeform_tags

    service_connectors = {
      SERVICE-CONNECTOR-HUB = {
        display_name = local.service_connector_name
        activate     = var.enable_service_connector
        source = {
          kind           = "logging"
          audit_logs     = [{ cmp_id = "ALL" }]
          non_audit_logs = local.flow_logs_sources
        }
        target = {
          kind               = var.service_connector_target_kind
          compartment_id     = local.security_compartment_id
          bucket_name        = var.service_connector_target_kind == "objectstorage" ? local.service_connector_target_bucket_key : null
          object_name_prefix = var.service_connector_target_kind == "objectstorage" ? local.service_connector_target_object_name_prefix : null
          stream_id          = var.service_connector_target_kind == "streaming" ? (var.existing_service_connector_target_stream_id != null ? var.existing_service_connector_target_stream_id : local.service_connector_target_stream_key) : null
          function_id        = var.service_connector_target_kind == "functions" ? var.existing_service_connector_target_function_id : null
          log_group_id       = var.service_connector_target_kind == "logginganalytics" ? local.logging_analytics_log_group_key : null
        }
        policy = {
          name = local.service_connector_target_policy_name
        }
      }
    }
    buckets = var.service_connector_target_kind == "objectstorage" ? {
      (local.service_connector_target_bucket_key) = {
        name       = local.service_connector_target_bucket_name
        cis_level  = var.cis_level
        kms_key_id = var.existing_service_connector_bucket_key_id
      }
    } : {}
    streams = var.service_connector_target_kind == "streaming" && var.existing_service_connector_target_stream_id == null ? {
      (local.service_connector_target_stream_key) = {
        name = local.service_connector_target_stream_name
      }
    } : {}
  }
}

module "lz_service_connector_hub" {
  count                            = var.enable_service_connector ? 1 : 0
  source                           = "github.com/oci-landing-zones/terraform-oci-modules-observability//service-connectors?ref=v0.1.8"
  tenancy_ocid                     = var.tenancy_ocid
  service_connectors_configuration = local.service_connectors_configuration
  logs_dependency                  = var.service_connector_target_kind == "logginganalytics" ? module.lz_logging_analytics[0].logging_analytics_log_groups : null
  providers = {
    oci                  = oci
    oci.home             = oci.home
    oci.secondary_region = oci.secondary_region
  }
}