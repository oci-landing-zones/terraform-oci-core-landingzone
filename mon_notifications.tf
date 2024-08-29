# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local variables can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  custom_notifications_defined_tags  = null
  custom_notifications_freeform_tags = null
}

module "lz_notifications" {
  # depends_on = [null_resource.wait_on_compartments]
  source               = "github.com/oci-landing-zones/terraform-oci-modules-observability//events?ref=v0.1.8"
  events_configuration = local.regional_events_configuration
  topics_dependency    = module.lz_regional_topics.topics
}

module "lz_home_region_notifications" {
  count = var.extend_landing_zone_to_new_region == false ? 1 : 0
  # depends_on = [null_resource.wait_on_compartments]
  source               = "github.com/oci-landing-zones/terraform-oci-modules-observability//events?ref=v0.1.8"
  providers            = { oci = oci.home }
  events_configuration = local.home_region_events_configuration
  topics_dependency    = module.lz_home_region_topics[0].topics
}

locals {
  #------------------------------------------------------------------------------------------------------
  #-- These variables are not meant to be overriden
  #------------------------------------------------------------------------------------------------------

  #-----------------------------------------------------------
  #----- Tags to apply to notifications
  #-----------------------------------------------------------
  default_notifications_defined_tags  = null
  default_notifications_freeform_tags = local.landing_zone_tags

  notifications_defined_tags  = local.custom_notifications_defined_tags != null ? merge(local.custom_notifications_defined_tags, local.default_notifications_defined_tags) : local.default_notifications_defined_tags
  notifications_freeform_tags = local.custom_notifications_freeform_tags != null ? merge(local.custom_notifications_freeform_tags, local.default_notifications_freeform_tags) : local.default_notifications_freeform_tags

  #--------------------------------------------------------------------
  #-- IAM Events
  #--------------------------------------------------------------------
  iam_events_key = "IAM-EVENTS"
  iam_events = {
    (local.iam_events_key) = {
      compartment_id                  = var.tenancy_ocid
      event_display_name              = "${var.service_label}-notify-on-iam-changes-rule"
      event_description               = "Landing Zone CIS related events rule to detect when IAM resources are created, updated or deleted."
      preconfigured_events_categories = ["iam"]
      destination_topic_ids           = ["SECURITY-TOPIC"]
      is_enabled                      = true
      defined_tags                    = local.notifications_defined_tags
      freeform_tags                   = local.notifications_freeform_tags
    }
  }

  #--------------------------------------------------------------------
  #-- Cloud Guard Events
  #--------------------------------------------------------------------
  cloudguard_events_key = "CLOUDGUARD-EVENTS"
  cloudguard_events = length(var.cloud_guard_admin_email_endpoints) > 0 ? {
    (local.cloudguard_events_key) = {
      compartment_id                  = var.tenancy_ocid
      event_display_name              = "${var.service_label}-notify-on-cloudguard-events-rule"
      event_description               = "Landing Zone events rule to notify when Cloud Guard problems are Detected, Dismissed or Resolved."
      preconfigured_events_categories = ["cloudguard"]
      destination_topic_ids           = ["CLOUDGUARD-TOPIC"]
      is_enabled                      = true
      defined_tags                    = local.notifications_defined_tags
      freeform_tags                   = local.notifications_freeform_tags
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Network Events
  #--------------------------------------------------------------------
  network_events_key = "NETWORK-EVENTS"
  network_events = {
    (local.network_events_key) = {
      compartment_id                  = var.tenancy_ocid
      event_display_name              = "${var.service_label}-notify-on-network-changes-rule"
      event_description               = "Landing Zone events rule to detect when networking resources are created, updated or deleted."
      preconfigured_events_categories = ["network"]
      destination_topic_ids           = ["NETWORK-TOPIC"]
      is_enabled                      = true
      defined_tags                    = local.notifications_defined_tags
      freeform_tags                   = local.notifications_freeform_tags
    }
  }

  #--------------------------------------------------------------------
  #-- Storage Events
  #--------------------------------------------------------------------
  storage_events_key = "STORAGE-EVENTS"
  storage_events = length(var.storage_admin_email_endpoints) > 0 ? {
    (local.storage_events_key) = {
      compartment_id                  = local.app_compartment_id
      event_display_name              = "${var.service_label}-notify-on-storage-changes-rule"
      event_description               = "Landing Zone events rule to detect when storage resources are created, updated or deleted."
      preconfigured_events_categories = ["storage"]
      destination_topic_ids           = ["STORAGE-TOPIC"]
      is_enabled                      = var.create_events_as_enabled
      defined_tags                    = local.notifications_defined_tags
      freeform_tags                   = local.notifications_freeform_tags
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Database Events
  #--------------------------------------------------------------------
  database_events_key = "DATABASE-EVENTS"
  database_events = length(var.database_admin_email_endpoints) > 0 ? {
    (local.storage_events_key) = {
      compartment_id                  = local.database_compartment_id
      event_display_name              = "${var.service_label}-notify-on-database-changes-rule"
      event_description               = "Landing Zone events rule to detect when database resources are created, updated or deleted in the database compartment."
      preconfigured_events_categories = ["database"]
      destination_topic_ids           = ["DATABASE-TOPIC"]
      is_enabled                      = var.create_events_as_enabled
      defined_tags                    = local.notifications_defined_tags
      freeform_tags                   = local.notifications_freeform_tags
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Exainfra Events
  #--------------------------------------------------------------------
  exainfra_events_key = "EXAINFRA-EVENTS"
  exainfra_events = length(var.exainfra_admin_email_endpoints) > 0 && var.deploy_exainfra_cmp == true ? {
    (local.storage_events_key) = {
      compartment_id                 = local.exainfra_compartment_id
      event_display_name             = "${var.service_label}-notify-on-exainfra-changes-rule"
      event_description              = "Landing Zone events rule to detect Exadata infrastructure events."
      reconfigured_events_categories = ["exainfra"]
      destination_topic_ids          = ["EXAINFRA-TOPIC"]
      is_enabled                     = var.create_events_as_enabled
      defined_tags                   = local.notifications_defined_tags
      freeform_tags                  = local.notifications_freeform_tags
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Budget Events
  #--------------------------------------------------------------------
  budget_events_key = "BUDGET-EVENTS"
  budget_events = length(var.budget_admin_email_endpoints) > 0 ? {
    (local.budget_events_key) = {
      compartment_id                  = var.tenancy_ocid
      event_display_name              = "${var.service_label}-notify-on-budget-changes-rule"
      event_description               = "Landing Zone events rule to detect when cost resources such as budgets and financial tracking constructs are created, updated or deleted."
      preconfigured_events_categories = ["budget"]
      destination_topic_ids           = ["BUDGET-TOPIC"]
      is_enabled                      = var.create_events_as_enabled
      defined_tags                    = local.notifications_defined_tags
      freeform_tags                   = local.notifications_freeform_tags
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Compute Events
  #--------------------------------------------------------------------
  compute_events_key = "COMPUTE-EVENTS"
  compute_events = length(var.compute_admin_email_endpoints) > 0 ? {
    (local.compute_events_key) = {
      compartment_id                  = local.app_compartment_id
      event_display_name              = "${var.service_label}-notify-on-compute-changes-rule"
      event_description               = "Landing Zone events rule to detect when compute related resources are created, updated or deleted."
      preconfigured_events_categories = ["compute"]
      destination_topic_ids           = ["COMPUTE-TOPIC"]
      is_enabled                      = var.create_events_as_enabled
      defined_tags                    = local.notifications_defined_tags
      freeform_tags                   = local.notifications_freeform_tags
    }
  } : {}

  #------------------------------------------------------------------------
  #----- Event Rules configuration definition. Input to module.
  #------------------------------------------------------------------------
  home_region_events = merge(local.iam_events, local.cloudguard_events)
  regional_events    = merge(local.network_events, local.storage_events, local.database_events, local.exainfra_events, local.budget_events, local.compute_events)

  home_region_events_configuration = {
    default_compartment_id = null
    default_defined_tags   = local.default_notifications_defined_tags
    default_freeform_tags  = local.default_notifications_freeform_tags
    event_rules            = local.home_region_events
  }

  regional_events_configuration = {
    default_compartment_id = null
    default_defined_tags   = local.default_notifications_defined_tags
    default_freeform_tags  = local.default_notifications_freeform_tags
    event_rules            = local.regional_events
  }
}

