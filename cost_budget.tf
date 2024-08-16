# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


locals {
  #--------------------------------------------------------------------------
  #-- Any of these custom variables can be overriden in a _override.tf file.
  #--------------------------------------------------------------------------       
  ### Cost Management
  custom_cost_management_defined_tags  = null
  custom_cost_management_freeform_tags = null
  custom_budget_display_name           = null
}

module "lz_budgets" {
  count                 = var.extend_landing_zone_to_new_region == false && var.create_budget ? 1 : 0
  source                = "github.com/oci-landing-zones/terraform-oci-modules-governance//budgets?ref=release-0.1.4"
  tenancy_ocid          = var.tenancy_ocid
  budgets_configuration = local.budgets_configuration
}

locals {
  #--------------------------------------------------------------------------
  #-- These variables are NOT meant to be overriden.
  #--------------------------------------------------------------------------

  default_cost_management_defined_tags  = null
  default_cost_management_freeform_tags = local.landing_zone_tags

  cost_management_defined_tags  = local.custom_cost_management_defined_tags != null ? merge(local.custom_cost_management_defined_tags, local.default_cost_management_defined_tags) : local.default_cost_management_defined_tags
  cost_management_freeform_tags = local.custom_cost_management_freeform_tags != null ? merge(local.custom_cost_management_freeform_tags, local.default_cost_management_freeform_tags) : local.default_cost_management_freeform_tags

  #--------------------------------------------------------------------------
  # Budgets - Compartments
  #--------------------------------------------------------------------------
  compartment_based_budget = {
    COMPARTMENT-BASED-BUDGET = {
      name : local.custom_budget_display_name != null ? local.custom_budget_display_name : "${var.service_label}-main-budget"
      description : local.use_enclosing_compartment == true ? "Tracks spending from the enclosing compartment level and down" : "Tracks spending across the tenancy"
      target : {
        type : "COMPARTMENT"
        values : local.use_enclosing_compartment ? [local.enclosing_compartment_id] : [var.tenancy_ocid]
      }
      amount : var.budget_amount
      defined_tags  = local.cost_management_defined_tags
      freeform_tags = local.cost_management_freeform_tags
      alert_rule : {
        threshold_metric : "FORECAST"
        threshold_type : "PERCENTAGE"
        threshold_value : var.budget_alert_threshold
        name : "${var.service_label}-alert-on-forecasted-spent"
        recipients : join(", ", [for s in var.budget_alert_email_endpoints : s])
        message : "Forecasted spending above ${var.budget_alert_threshold}% of configured budget."
        defined_tags  = local.cost_management_defined_tags
        freeform_tags = local.cost_management_freeform_tags
      }
    }
  }

  #--------------------------------------------------------------------------
  #----- Cost Management - Budget configuration definition. Input to module.
  #--------------------------------------------------------------------------
  budgets_configuration = {
    default_defined_tags  = local.default_cost_management_defined_tags
    default_freeform_tags = local.default_cost_management_freeform_tags
    budgets : local.compartment_based_budget
  }
}