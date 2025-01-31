# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
locals {

  ### Discovering the home region name and region key.
  regions_map         = { for r in data.oci_identity_regions.these.regions : r.key => r.name } # All regions indexed by region key.
  regions_map_reverse = { for r in data.oci_identity_regions.these.regions : r.name => r.key } # All regions indexed by region name.
  home_region_key     = data.oci_identity_tenancy.this.home_region_key                         # Home region key obtained from the tenancy data source
  region_key          = lower(local.regions_map_reverse[var.region])                           # Region key obtained from the region name

  ### Network
  anywhere                    = "0.0.0.0/0"
  valid_service_gateway_cidrs = ["all-${local.region_key}-services-in-oracle-services-network", "oci-${local.region_key}-objectstorage"]

  # Notifications
  iam_events_rule_name     = "${var.service_label}-notify-on-iam-changes-rule"
  network_events_rule_name = "${var.service_label}-notify-on-network-changes-rule"
  # Whether compartments should be deleted upon resource destruction.
  enable_cmp_delete = false

  # Delay in seconds for slowing down resource creation
  delay_in_secs = 70

  # Outputs display
  display_outputs = true

  # Tags
  lz_core_version      = fileexists("${path.module}/release.txt") ? "${file("${path.module}/release.txt")}" : "undefined"
  lz_provenant_version = coalesce(var.lz_provenant_version, "undefined")
  lz_provenant_info    = var.lz_provenant_prefix != "core" ? "/${var.lz_provenant_prefix}${local.lz_provenant_version}" : ""
  landing_zone_tags    = {"oci-core-landing-zone" : "${var.service_label}/core/${local.lz_core_version}${local.lz_provenant_info}"}

  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true

  void = "__VOID__"

}

# resource "null_resource" "wait_on_compartments" {
#   depends_on = [module.lz_compartments]
#   provisioner "local-exec" {
#     interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
#     command     = local.is_windows ? "Start-Sleep ${local.delay_in_secs}" : "sleep ${local.delay_in_secs}"
#   }
# }

# resource "null_resource" "wait_on_services_policy" {
#   depends_on = [module.lz_services_policy]
#   provisioner "local-exec" {
#     interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
#     command     = local.is_windows ? "Start-Sleep ${local.delay_in_secs}" : "sleep ${local.delay_in_secs}"
#   }
# }
