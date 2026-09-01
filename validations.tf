# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {
  private_endpoint_validation_configs = {
    "TT-VCN-1"  = { requested = var.add_tt_vcn1_private_endpoint_subnet, parent_enabled = local.add_tt_vcn1, cidr = local.tt_vcn1_private_endpoint_subnet_cidr, vcn_cidrs = var.tt_vcn1_cidrs, existing_cidrs = compact([local.tt_vcn1_web_subnet_cidr, local.tt_vcn1_app_subnet_cidr, local.tt_vcn1_db_subnet_cidr, var.deploy_tt_vcn1_bastion_subnet ? local.tt_vcn1_bastion_subnet_cidr : null]) }
    "TT-VCN-2"  = { requested = var.add_tt_vcn2_private_endpoint_subnet, parent_enabled = local.add_tt_vcn2, cidr = local.tt_vcn2_private_endpoint_subnet_cidr, vcn_cidrs = var.tt_vcn2_cidrs, existing_cidrs = compact([local.tt_vcn2_web_subnet_cidr, local.tt_vcn2_app_subnet_cidr, local.tt_vcn2_db_subnet_cidr, var.deploy_tt_vcn2_bastion_subnet ? local.tt_vcn2_bastion_subnet_cidr : null]) }
    "TT-VCN-3"  = { requested = var.add_tt_vcn3_private_endpoint_subnet, parent_enabled = local.add_tt_vcn3, cidr = local.tt_vcn3_private_endpoint_subnet_cidr, vcn_cidrs = var.tt_vcn3_cidrs, existing_cidrs = compact([local.tt_vcn3_web_subnet_cidr, local.tt_vcn3_app_subnet_cidr, local.tt_vcn3_db_subnet_cidr, var.deploy_tt_vcn3_bastion_subnet ? local.tt_vcn3_bastion_subnet_cidr : null]) }
    "OKE-VCN-1" = { requested = var.add_oke_vcn1_private_endpoint_subnet, parent_enabled = local.add_oke_vcn1, cidr = local.oke_vcn1_private_endpoint_subnet_cidr, vcn_cidrs = var.oke_vcn1_cidrs, existing_cidrs = compact([local.oke_vcn1_api_subnet_cidr, local.oke_vcn1_workers_subnet_cidr, local.oke_vcn1_services_subnet_cidr, var.add_oke_vcn1_mgmt_subnet ? local.oke_vcn1_mgmt_subnet_cidr : null, upper(var.oke_vcn1_cni_type) == "NATIVE" ? local.oke_vcn1_pods_subnet_cidr : null, var.add_oke_vcn1_db_subnet ? local.oke_vcn1_db_subnet_cidr : null]) }
    "OKE-VCN-2" = { requested = var.add_oke_vcn2_private_endpoint_subnet, parent_enabled = local.add_oke_vcn2, cidr = local.oke_vcn2_private_endpoint_subnet_cidr, vcn_cidrs = var.oke_vcn2_cidrs, existing_cidrs = compact([local.oke_vcn2_api_subnet_cidr, local.oke_vcn2_workers_subnet_cidr, local.oke_vcn2_services_subnet_cidr, var.add_oke_vcn2_mgmt_subnet ? local.oke_vcn2_mgmt_subnet_cidr : null, upper(var.oke_vcn2_cni_type) == "NATIVE" ? local.oke_vcn2_pods_subnet_cidr : null, var.add_oke_vcn2_db_subnet ? local.oke_vcn2_db_subnet_cidr : null]) }
    "OKE-VCN-3" = { requested = var.add_oke_vcn3_private_endpoint_subnet, parent_enabled = local.add_oke_vcn3, cidr = local.oke_vcn3_private_endpoint_subnet_cidr, vcn_cidrs = var.oke_vcn3_cidrs, existing_cidrs = compact([local.oke_vcn3_api_subnet_cidr, local.oke_vcn3_workers_subnet_cidr, local.oke_vcn3_services_subnet_cidr, var.add_oke_vcn3_mgmt_subnet ? local.oke_vcn3_mgmt_subnet_cidr : null, upper(var.oke_vcn3_cni_type) == "NATIVE" ? local.oke_vcn3_pods_subnet_cidr : null, var.add_oke_vcn3_db_subnet ? local.oke_vcn3_db_subnet_cidr : null]) }
    "EXA-VCN-1" = { requested = var.add_exa_vcn1_private_endpoint_subnet, parent_enabled = local.add_exa_vcn1, cidr = local.exa_vcn1_private_endpoint_subnet_cidr, vcn_cidrs = var.exa_vcn1_cidrs, existing_cidrs = compact([local.exa_vcn1_client_subnet_cidr, local.add_exa_vcn1_backup_subnet ? local.exa_vcn1_backup_subnet_cidr : null, local.add_exa_vcn1_integration_subnet ? local.exa_vcn1_integration_subnet_cidr : null]) }
    "EXA-VCN-2" = { requested = var.add_exa_vcn2_private_endpoint_subnet, parent_enabled = local.add_exa_vcn2, cidr = local.exa_vcn2_private_endpoint_subnet_cidr, vcn_cidrs = var.exa_vcn2_cidrs, existing_cidrs = compact([local.exa_vcn2_client_subnet_cidr, local.add_exa_vcn2_backup_subnet ? local.exa_vcn2_backup_subnet_cidr : null, local.add_exa_vcn2_integration_subnet ? local.exa_vcn2_integration_subnet_cidr : null]) }
    "EXA-VCN-3" = { requested = var.add_exa_vcn3_private_endpoint_subnet, parent_enabled = local.add_exa_vcn3, cidr = local.exa_vcn3_private_endpoint_subnet_cidr, vcn_cidrs = var.exa_vcn3_cidrs, existing_cidrs = compact([local.exa_vcn3_client_subnet_cidr, local.add_exa_vcn3_backup_subnet ? local.exa_vcn3_backup_subnet_cidr : null, local.add_exa_vcn3_integration_subnet ? local.exa_vcn3_integration_subnet_cidr : null]) }
  }

  private_endpoint_candidate_ranges = {
    for key, config in local.private_endpoint_validation_configs : key => {
      start = try(sum([for index, octet in split(".", cidrhost(config.cidr, 0)) : parseint(octet, 10) * pow(256, 3 - index)]), null)
      end   = try(sum([for index, octet in split(".", cidrhost(config.cidr, -1)) : parseint(octet, 10) * pow(256, 3 - index)]), null)
    }
  }

  private_endpoint_vcn_ranges = {
    for key, config in local.private_endpoint_validation_configs : key => [for cidr in config.vcn_cidrs : {
      start = try(sum([for index, octet in split(".", cidrhost(cidr, 0)) : parseint(octet, 10) * pow(256, 3 - index)]), null)
      end   = try(sum([for index, octet in split(".", cidrhost(cidr, -1)) : parseint(octet, 10) * pow(256, 3 - index)]), null)
    }]
  }

  private_endpoint_existing_ranges = {
    for key, config in local.private_endpoint_validation_configs : key => [for cidr in config.existing_cidrs : {
      start = try(sum([for index, octet in split(".", cidrhost(cidr, 0)) : parseint(octet, 10) * pow(256, 3 - index)]), null)
      end   = try(sum([for index, octet in split(".", cidrhost(cidr, -1)) : parseint(octet, 10) * pow(256, 3 - index)]), null)
    }]
  }
}

resource "terraform_data" "validate_private_endpoint_subnets" {
  for_each = { for key, config in local.private_endpoint_validation_configs : key => config if config.requested }

  input = each.value.cidr

  lifecycle {
    precondition {
      condition     = each.value.parent_enabled
      error_message = "VALIDATION FAILURE: ${each.key} must be enabled before its private endpoint subnet can be enabled."
    }
    precondition {
      condition     = each.value.cidr != null && can(cidrhost(each.value.cidr, 0))
      error_message = "VALIDATION FAILURE: ${each.key} private endpoint subnet requires a valid IPv4 CIDR."
    }
    precondition {
      condition = try(anytrue([
        for range in local.private_endpoint_vcn_ranges[each.key] : local.private_endpoint_candidate_ranges[each.key].start >= range.start && local.private_endpoint_candidate_ranges[each.key].end <= range.end
      ]), false)
      error_message = "VALIDATION FAILURE: ${each.key} private endpoint subnet CIDR must be inside a parent VCN CIDR."
    }
    precondition {
      condition = try(alltrue([
        for range in local.private_endpoint_existing_ranges[each.key] : local.private_endpoint_candidate_ranges[each.key].end < range.start || local.private_endpoint_candidate_ranges[each.key].start > range.end
      ]), false)
      error_message = "VALIDATION FAILURE: ${each.key} private endpoint subnet CIDR overlaps an enabled subnet."
    }
  }
}

resource "terraform_data" "validate_enable_generative_ai_infra" {
  count = var.enable_generative_ai_infra ? 1 : 0
  input = var.enable_generative_ai_infra

  lifecycle {
    precondition {
      condition     = var.deploy_app_cmp
      error_message = "VALIDATION FAILURE: enable_generative_ai_infra requires deploy_app_cmp to be true."
    }
  }
}

resource "terraform_data" "validate_enable_data_science_infra" {
  count = var.enable_data_science_infra ? 1 : 0
  input = var.enable_data_science_infra

  lifecycle {
    precondition {
      condition     = var.deploy_app_cmp
      error_message = "VALIDATION FAILURE: enable_data_science_infra requires deploy_app_cmp to be true."
    }
  }
}

resource "terraform_data" "validate_enable_prebuilt_ai_services_infra" {
  count = var.enable_prebuilt_ai_services_infra ? 1 : 0
  input = var.enable_prebuilt_ai_services_infra

  lifecycle {
    precondition {
      condition     = var.deploy_app_cmp
      error_message = "VALIDATION FAILURE: enable_prebuilt_ai_services_infra requires deploy_app_cmp to be true."
    }
  }
}

resource "terraform_data" "validate_enable_ai_compute_infra" {
  count = var.enable_ai_compute_infra ? 1 : 0
  input = var.enable_ai_compute_infra

  lifecycle {
    precondition {
      condition     = var.deploy_app_cmp
      error_message = "VALIDATION FAILURE: enable_ai_compute_infra requires deploy_app_cmp to be true."
    }
  }
}

resource "terraform_data" "validate_enable_aidp_infra" {
  count = var.enable_aidp_infra ? 1 : 0
  input = var.enable_aidp_infra

  lifecycle {
    precondition {
      condition     = var.deploy_app_cmp
      error_message = "VALIDATION FAILURE: enable_aidp_infra requires deploy_app_cmp to be true."
    }
  }
}
