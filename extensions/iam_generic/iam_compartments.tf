# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  // workload compartment
  workload_compartment_configuration = {
    default_parent_id : var.parent_compartment_ocid
    compartments = {
      WKL-CMP = {
        name        = "${var.service_label}-${var.workload_compartment_name}"
        description = var.workload_compartment_description
        children    = {}
      }
    }
  }

  // workload sub-compartments
  workload_sub_compartments_configuration = length(local.all_workload_sub_compartments) > 0 ? {
    default_parent_id : length(module.workload_compartment) > 0 ? module.workload_compartment[0].compartments["WKL-CMP"].id : null
    compartments : local.all_workload_sub_compartments
  } : local.empty_compartments_configuration

  all_workload_sub_compartments = merge(local.network_cmp, local.app_cmp, local.database_cmp)

  empty_compartments_configuration = {
    default_parent_id : null
    compartments : {}
  }

  network_cmp = var.isolate_workload && var.create_workload_network_subcompartment ? {
    WKL-NET-CMP : {
      name : "${var.service_label}-network-cmp"
      description : var.network_compartment_description,
      children : {}
    }
  } : {}

  app_cmp = var.isolate_workload && var.create_workload_app_subcompartment ? {
    WKL-APP-CMP : {
      name : "${var.service_label}-app-cmp"
      description : var.app_compartment_description,
      children : {}
    }
  } : {}

  database_cmp = var.isolate_workload && var.create_workload_database_subcompartment ? {
    WKL-DB-CMP : {
      name : "${var.service_label}-database-cmp"
      description : var.database_compartment_description,
      children : {}
    }
  } : {}

}

module "workload_compartment" {
  count = var.deploy_workload_compartment ? 1 : 0
  source                     = "github.com/oci-landing-zones/terraform-oci-modules-iam//compartments?ref=v0.2.9"
  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = local.workload_compartment_configuration
}

module "workload_sub_compartments" {
  source                     = "github.com/oci-landing-zones/terraform-oci-modules-iam//compartments?ref=v0.2.9"
  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = local.workload_sub_compartments_configuration
}
