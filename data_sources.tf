# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

data "oci_identity_regions" "these" {}

data "oci_identity_region_subscriptions" "these" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_compartment" "existing_enclosing_compartment" {
  id = coalesce(var.existing_enclosing_compartment_ocid, var.tenancy_ocid)
}

data "oci_identity_domain" "existing_identity_domain" {
  count     = var.identity_domain_option == "Use Custom Identity Domain" ? 1 : 0
  domain_id = trimspace(var.custom_id_domain_ocid)
  lifecycle {
    precondition {
      condition     = var.custom_id_domain_ocid != null && length(trimspace(var.custom_id_domain_ocid)) > 0
      error_message = "VALIDATION FAILURE: custom_id_domain_ocid must be provided when identity_domain_option is 'Use Custom Identity Domain'."
    }
    postcondition {
      condition     = try(length(trimspace(self.display_name)) > 0, false) && try(length(trimspace(self.url)) > 0, false)
      error_message = "VALIDATION FAILURE: custom_id_domain_ocid must identify an existing identity domain that is accessible to the executing user. The identity domain lookup returned no display name or URL."
    }
  }
}

data "oci_identity_group" "existing_iam_admin_group" {
  for_each = length(trimspace(var.rm_existing_iam_admin_group_name)) > 0 ? toset([var.rm_existing_iam_admin_group_name]) : toset(var.existing_iam_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_cred_admin_group" {
  for_each = length(trimspace(var.rm_existing_cred_admin_group_name)) > 0 ? toset([var.rm_existing_cred_admin_group_name]) : toset(var.existing_cred_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_security_admin_group" {
  for_each = length(trimspace(var.rm_existing_security_admin_group_name)) > 0 ? toset([var.rm_existing_security_admin_group_name]) : toset(var.existing_security_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_network_admin_group" {
  for_each = length(trimspace(var.rm_existing_network_admin_group_name)) > 0 ? toset([var.rm_existing_network_admin_group_name]) : toset(var.existing_network_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_appdev_admin_group" {
  for_each = length(trimspace(var.rm_existing_appdev_admin_group_name)) > 0 ? toset([var.rm_existing_appdev_admin_group_name]) : toset(var.existing_appdev_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_database_admin_group" {
  for_each = length(trimspace(var.rm_existing_database_admin_group_name)) > 0 ? toset([var.rm_existing_database_admin_group_name]) : toset(var.existing_database_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_auditor_group" {
  for_each = length(trimspace(var.rm_existing_auditor_group_name)) > 0 ? toset([var.rm_existing_auditor_group_name]) : toset(var.existing_auditor_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_announcement_reader_group" {
  for_each = length(trimspace(var.rm_existing_announcement_reader_group_name)) > 0 ? toset([var.rm_existing_announcement_reader_group_name]) : toset(var.existing_announcement_reader_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_exainfra_admin_group" {
  for_each = length(trimspace(var.rm_existing_exainfra_admin_group_name)) > 0 ? toset([var.rm_existing_exainfra_admin_group_name]) : toset(var.existing_exainfra_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_cost_admin_group" {
  for_each = length(trimspace(var.rm_existing_cost_admin_group_name)) > 0 ? toset([var.rm_existing_cost_admin_group_name]) : toset(var.existing_cost_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_storage_admin_group" {
  for_each = length(trimspace(var.rm_existing_storage_admin_group_name)) > 0 ? toset([var.rm_existing_storage_admin_group_name]) : toset(var.existing_storage_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_group" "existing_ag_admin_group" {
  for_each = length(trimspace(var.rm_existing_ag_admin_group_name)) > 0 ? toset([var.rm_existing_ag_admin_group_name]) : toset(var.existing_ag_admin_group_name)
  group_id = length(trimspace(each.value)) > 0 ? each.value : "nogroup"
}

data "oci_identity_dynamic_groups" "all" {
  compartment_id = var.tenancy_ocid
}

/*
data "oci_identity_dynamic_groups" "existing_security_fun_dyn_group" {
  compartment_id = var.tenancy_ocid
  filter {
    name   = "name"
    values = [var.existing_security_fun_dyn_group_name]
  }
}

data "oci_identity_dynamic_groups" "existing_appdev_fun_dyn_group" {
  compartment_id = var.tenancy_ocid
  filter {
    name   = "name"
    values = [var.existing_appdev_fun_dyn_group_name]
  }
}

data "oci_identity_dynamic_groups" "existing_compute_agent_dyn_group" {
  compartment_id = var.tenancy_ocid
  filter {
    name   = "name"
    values = [var.existing_compute_agent_dyn_group_name]
  }
}

data "oci_identity_dynamic_groups" "existing_database_kms_dyn_group" {
  compartment_id = var.tenancy_ocid
  filter {
    name   = "name"
    values = [var.existing_database_kms_dyn_group_name]
  }
} */

data "oci_cloud_guard_cloud_guard_configuration" "this" {
  compartment_id = var.tenancy_ocid
}

data "oci_objectstorage_namespace" "this" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_compartments" "network" {
  compartment_id            = local.enclosing_compartment_id
  compartment_id_in_subtree = local.enclosing_compartment_id == var.tenancy_ocid ? true : false
  filter {
    name   = "name"
    values = [local.provided_network_compartment_name]
  }
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }
}

data "oci_identity_compartments" "security" {
  compartment_id            = local.enclosing_compartment_id
  compartment_id_in_subtree = local.enclosing_compartment_id == var.tenancy_ocid ? true : false
  filter {
    name   = "name"
    values = [local.provided_security_compartment_name]
  }
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }
}

data "oci_identity_compartments" "app" {
  compartment_id            = local.enclosing_compartment_id
  compartment_id_in_subtree = local.enclosing_compartment_id == var.tenancy_ocid ? true : false
  filter {
    name   = "name"
    values = [local.provided_app_compartment_name]
  }
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }
}

data "oci_identity_compartments" "database" {
  compartment_id            = local.enclosing_compartment_id
  compartment_id_in_subtree = local.enclosing_compartment_id == var.tenancy_ocid ? true : false
  filter {
    name   = "name"
    values = [local.provided_database_compartment_name]
  }
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }
}

data "oci_identity_compartments" "exainfra" {
  compartment_id            = local.enclosing_compartment_id
  compartment_id_in_subtree = local.enclosing_compartment_id == var.tenancy_ocid ? true : false
  filter {
    name   = "name"
    values = [local.provided_exainfra_compartment_name]
  }
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }
}

data "oci_identity_tag_namespaces" "this" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "platform_oel_images" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = var.bastion_jump_host_instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_private_ip" "oci_firewall" {
  count         = var.oci_nfw_ip_ocid != null ? 1 : 0
  private_ip_id = var.oci_nfw_ip_ocid
}

data "oci_core_private_ip" "indoor_nlb" {
  count         = var.hub_vcn_east_west_entry_point_ocid != null ? 1 : 0
  private_ip_id = var.hub_vcn_east_west_entry_point_ocid
}

data "oci_core_private_ip" "outdoor_nlb" {
  count         = var.hub_vcn_north_south_entry_point_ocid != null ? 1 : 0
  private_ip_id = var.hub_vcn_north_south_entry_point_ocid
}
