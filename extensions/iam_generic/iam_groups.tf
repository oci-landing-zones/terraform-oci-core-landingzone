# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  default_domain_groups_configuration = {
    groups : merge(local.default_workload_admin_group, local.default_workload_app_admin_group, local.default_workload_db_admin_group)
  }

  custom_domain_groups_configuration = {
    groups : merge(local.custom_workload_admin_group, local.custom_workload_app_admin_group, local.custom_workload_db_admin_group)
  }

  default_workload_admin_group = {
    DEFAULT-WKL-ADMIN-GROUP = {
      name        = "${var.service_label}-${var.workload_admin_group_name}"
      description = "Workload admin group."
    }
  }

  default_workload_app_admin_group = var.isolate_workload ? {
    DEFAULT-WKL-APP-ADMIN-GROUP = {
      name        = "${var.service_label}-${var.workload_app_admin_group_name}"
      description = "Workload admin group for app resources management."
    }
  } : {}

  default_workload_db_admin_group = var.isolate_workload && var.enable_db_admin_group ? {
    DEFAULT-WKL-DB-ADMIN-GROUP = {
      name        = "${var.service_label}-${var.workload_db_admin_group_name}"
      description = "Workload admin group for database resources management."
    }
  } : {}

  custom_workload_admin_group = {
    CUSTOM-WKL-ADMIN-GROUP = {
      identity_domain_id = trimspace(var.custom_identity_domain_ocid)
      name               = "${var.service_label}-${var.workload_admin_group_name}"
      description        = "Workload admin group."
    }
  }

  custom_workload_app_admin_group = var.isolate_workload ? {
    CUSTOM-WKL-APP-ADMIN-GROUP = {
      identity_domain_id = trimspace(var.custom_identity_domain_ocid)
      name               = "${var.service_label}-${var.workload_app_admin_group_name}"
      description        = "Workload admin group for app resources management."
    }
  } : {}

  custom_workload_db_admin_group = var.isolate_workload && var.enable_db_admin_group ? {
    CUSTOM-WKL-DB-ADMIN-GROUP = {
      identity_domain_id = trimspace(var.custom_identity_domain_ocid)
      name               = "${var.service_label}-${var.workload_db_admin_group_name}"
      description        = "Workload admin group for database resources management."
    }
  } : {}


}
module "workload_default_domain_groups" {
  source               = "github.com/oci-landing-zones/terraform-oci-modules-iam//groups?ref=v0.2.7"
  count                = !var.use_custom_identity_domain && var.deploy_default_groups ? 1 : 0
  tenancy_ocid         = var.tenancy_ocid
  groups_configuration = local.default_domain_groups_configuration
}

module "workload_custom_domain_groups" {
  source                               = "github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains?ref=v0.2.4"
  count                                = var.use_custom_identity_domain ? 1 : 0
  tenancy_ocid                         = var.tenancy_ocid
  identity_domain_groups_configuration = local.custom_domain_groups_configuration
}