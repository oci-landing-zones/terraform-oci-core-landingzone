# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local variables can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  # Tags
  custom_topics_defined_tags  = null
  custom_topics_freeform_tags = null
}

module "lz_home_region_topics" {
  count  = var.extend_landing_zone_to_new_region == false ? 1 : 0
  source = "github.com/oci-landing-zones/terraform-oci-modules-observability//notifications?ref=release-0.1.8"
  # depends_on = [ null_resource.wait_on_compartments ]
  providers                   = { oci = oci.home }
  notifications_configuration = local.home_region_notifications_configuration
}

module "lz_regional_topics" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-observability//notifications?ref=release-0.1.8"
  # depends_on = [ null_resource.wait_on_compartments ]
  notifications_configuration = local.regional_notifications_configuration
}

locals {
  #------------------------------------------------------------------------------------------------------
  #-- These variables are not meant to be overriden
  #------------------------------------------------------------------------------------------------------

  #-----------------------------------------------------------
  #----- Tags to apply to topics
  #-----------------------------------------------------------
  default_topics_defined_tags  = null
  default_topics_freeform_tags = local.landing_zone_tags

  topics_defined_tags  = local.custom_topics_defined_tags != null ? merge(local.custom_topics_defined_tags, local.default_topics_defined_tags) : local.default_topics_defined_tags
  topics_freeform_tags = local.custom_topics_freeform_tags != null ? merge(local.custom_topics_freeform_tags, local.default_topics_freeform_tags) : local.default_topics_freeform_tags

  #--------------------------------------------------------------------
  #-- Security Topic
  #--------------------------------------------------------------------
  security_topic_key = "SECURITY-TOPIC"
  security_topic = length(var.security_admin_email_endpoints) > 0 ? {
    (local.security_topic_key) = {
      compartment_id = local.security_compartment_id
      name           = "${var.service_label}-security-topic"
      description    = "Landing Zone topic for security related notifications."
      defined_tags   = local.topics_defined_tags
      freeform_tags  = local.topics_freeform_tags
      subscriptions = [
        { protocol = "EMAIL"
          values   = var.security_admin_email_endpoints
        }
      ]
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Cloud Guard Topic
  #--------------------------------------------------------------------
  cloudguard_topic_key = "CLOUDGUARD-TOPIC"
  cloudguard_topic = length(var.cloud_guard_admin_email_endpoints) > 0 ? {
    (local.cloudguard_topic_key) = {
      compartment_id = local.security_compartment_id
      name           = "${var.service_label}-cloudguard-topic"
      description    = "Landing Zone topic for Cloud Guard related notifications."
      defined_tags   = local.topics_defined_tags
      freeform_tags  = local.topics_freeform_tags
      subscriptions = [
        { protocol = "EMAIL"
          values   = var.cloud_guard_admin_email_endpoints
        }
      ]
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Network Topic
  #--------------------------------------------------------------------
  network_topic_key = "NETWORK-TOPIC"
  network_topic = length(var.network_admin_email_endpoints) > 0 ? {
    (local.network_topic_key) = {
      compartment_id = local.network_compartment_id
      name           = "${var.service_label}-network-topic"
      description    = "Landing Zone topic for network related notifications."
      defined_tags   = local.topics_defined_tags
      freeform_tags  = local.topics_freeform_tags
      subscriptions = [
        { protocol = "EMAIL"
          values   = var.network_admin_email_endpoints
        }
      ]
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Compute Topic
  #--------------------------------------------------------------------
  compute_topic_key = "COMPUTE-TOPIC"
  compute_topic = length(var.compute_admin_email_endpoints) > 0 ? {
    (local.compute_topic_key) = {
      compartment_id = local.app_compartment_id
      name           = "${var.service_label}-compute-topic"
      description    = "Landing Zone topic for compute performance related notifications."
      defined_tags   = local.topics_defined_tags
      freeform_tags  = local.topics_freeform_tags
      subscriptions = [
        { protocol = "EMAIL"
          values   = var.compute_admin_email_endpoints
        }
      ]
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Database Topic
  #--------------------------------------------------------------------
  database_topic_key = "DATABASE-TOPIC"
  database_topic = length(var.database_admin_email_endpoints) > 0 ? {
    (local.database_topic_key) = {
      compartment_id = local.database_compartment_id
      name           = "${var.service_label}-database-topic"
      description    = "Landing Zone topic for database performance related notifications."
      defined_tags   = local.topics_defined_tags
      freeform_tags  = local.topics_freeform_tags
      subscriptions = [
        { protocol = "EMAIL"
          values   = var.database_admin_email_endpoints
        }
      ]
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Storage Topic
  #--------------------------------------------------------------------
  storage_topic_key = "STORAGE-TOPIC"
  storage_topic = length(var.storage_admin_email_endpoints) > 0 ? {
    (local.storage_topic_key) = {
      compartment_id = local.app_compartment_id
      name           = "${var.service_label}-storage-topic"
      description    = "Landing Zone topic for storage performance related notifications."
      defined_tags   = local.topics_defined_tags
      freeform_tags  = local.topics_freeform_tags
      subscriptions = [
        { protocol = "EMAIL"
          values   = var.storage_admin_email_endpoints
        }
      ]
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Budget Topic
  #--------------------------------------------------------------------
  budget_topic_key = "BUDGET-TOPIC"
  budget_topic = length(var.budget_admin_email_endpoints) > 0 ? {
    (local.budget_topic_key) = {
      compartment_id = var.tenancy_ocid
      name           = "${var.service_label}-budget-topic"
      description    = "Landing Zone topic for budget related notifications."
      defined_tags   = local.topics_defined_tags
      freeform_tags  = local.topics_freeform_tags
      subscriptions = [
        { protocol = "EMAIL"
          values   = var.budget_admin_email_endpoints
        }
      ]
    }
  } : {}

  #--------------------------------------------------------------------
  #-- Exadata Topic
  #--------------------------------------------------------------------
  exainfra_topic_key = "EXAINFRA-TOPIC"
  exainfra_topic = length(var.exainfra_admin_email_endpoints) > 0 && var.deploy_exainfra_cmp == true ? {
    (local.exainfra_topic_key) = {
      compartment_id = local.exainfra_compartment_id
      name           = "${var.service_label}-exainfra-topic"
      description    = "Landing Zone topic for Exadata infrastructure notifications."
      defined_tags   = local.topics_defined_tags
      freeform_tags  = local.topics_freeform_tags
      subscriptions = [
        { protocol = "EMAIL"
          values   = var.exainfra_admin_email_endpoints
        }
      ]
    }
  } : {}

  #------------------------------------------------------------------------
  #----- Notifications configuration definition. Input to module.
  #------------------------------------------------------------------------
  home_region_topics = merge(local.security_topic, local.cloudguard_topic)
  regional_topics    = merge(local.network_topic, local.compute_topic, local.database_topic, local.storage_topic, local.budget_topic, local.exainfra_topic)

  home_region_notifications_configuration = {
    default_compartment_id = null
    default_defined_tags   = local.default_topics_defined_tags
    default_freeform_tags  = local.default_topics_freeform_tags
    topics                 = local.home_region_topics
  }

  regional_notifications_configuration = {
    default_compartment_id = null
    default_defined_tags   = local.default_topics_defined_tags
    default_freeform_tags  = local.default_topics_freeform_tags
    topics                 = local.regional_topics
  }
}
