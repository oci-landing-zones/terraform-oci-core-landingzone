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
  landing_zone_tags    = { "oci-core-landing-zone" : "${var.service_label}/core/${local.lz_core_version}${local.lz_provenant_info}" }

  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true

  void = "__VOID__"

  all_onprem_cidrs = distinct(concat(var.allowed_onprem_cidrs_to_app_endpoints, var.allowed_onprem_cidrs_to_fw_mgmt_interface, var.allowed_onprem_cidrs_to_jump_hosts))
  
  # Cross-vcn and on-prem routes
  tt_vcn1_route_rule = local.hub_with_drg_only == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true ? {
    for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.tt_vcn1_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    } 
  } : {}

  tt_vcn2_route_rule = local.hub_with_drg_only == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true ? {
    for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.tt_vcn2_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    } 
  } : {}

  tt_vcn3_route_rule = local.hub_with_drg_only == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true ? {
    for cidr in var.tt_vcn3_cidrs : "TT-VCN-3-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.tt_vcn3_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  oke_vcn1_route_rule = local.hub_with_drg_only == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true ? {
    for cidr in var.oke_vcn1_cidrs : "OKE-VCN-1-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.oke_vcn1_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  oke_vcn2_route_rule = local.hub_with_drg_only == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true ? {
    for cidr in var.oke_vcn2_cidrs : "OKE-VCN-2-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.oke_vcn2_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  oke_vcn3_route_rule = local.hub_with_drg_only == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true ? {
    for cidr in var.oke_vcn3_cidrs : "OKE-VCN-3-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.oke_vcn3_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn1_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true ? {
    for cidr in var.exa_vcn1_cidrs : "EXA-VCN-1-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.exa_vcn1_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn2_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true ? {
    for cidr in var.exa_vcn2_cidrs : "EXA-VCN-2-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.exa_vcn2_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn3_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true ? {
    for cidr in var.exa_vcn3_cidrs : "EXA-VCN-3-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.exa_vcn3_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  on_prem_route_rule = local.hub_with_drg_only == true ? {
    for cidr in local.all_onprem_cidrs : "ONPREM-${cidr}-RULE" =>  {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for on-premises ${cidr} CIDR range is routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}


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
