# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {
  additional_nsgs_inputs_by_vcn = {
    "HUB-VCN" = {
      enabled       = var.define_hub_vcn_additional_nsgs
      value         = var.hub_vcn_additional_nsgs
      variable_name = "hub_vcn_additional_nsgs"
    }
    "TT-VCN-1" = {
      enabled       = var.define_tt_vcn1_additional_nsgs
      value         = var.tt_vcn1_additional_nsgs
      variable_name = "tt_vcn1_additional_nsgs"
    }
    "TT-VCN-2" = {
      enabled       = var.define_tt_vcn2_additional_nsgs
      value         = var.tt_vcn2_additional_nsgs
      variable_name = "tt_vcn2_additional_nsgs"
    }
    "TT-VCN-3" = {
      enabled       = var.define_tt_vcn3_additional_nsgs
      value         = var.tt_vcn3_additional_nsgs
      variable_name = "tt_vcn3_additional_nsgs"
    }
    "OKE-VCN-1" = {
      enabled       = var.define_oke_vcn1_additional_nsgs
      value         = var.oke_vcn1_additional_nsgs
      variable_name = "oke_vcn1_additional_nsgs"
    }
    "OKE-VCN-2" = {
      enabled       = var.define_oke_vcn2_additional_nsgs
      value         = var.oke_vcn2_additional_nsgs
      variable_name = "oke_vcn2_additional_nsgs"
    }
    "OKE-VCN-3" = {
      enabled       = var.define_oke_vcn3_additional_nsgs
      value         = var.oke_vcn3_additional_nsgs
      variable_name = "oke_vcn3_additional_nsgs"
    }
    "EXA-VCN-1" = {
      enabled       = var.define_exa_vcn1_additional_nsgs
      value         = var.exa_vcn1_additional_nsgs
      variable_name = "exa_vcn1_additional_nsgs"
    }
    "EXA-VCN-2" = {
      enabled       = var.define_exa_vcn2_additional_nsgs
      value         = var.exa_vcn2_additional_nsgs
      variable_name = "exa_vcn2_additional_nsgs"
    }
    "EXA-VCN-3" = {
      enabled       = var.define_exa_vcn3_additional_nsgs
      value         = var.exa_vcn3_additional_nsgs
      variable_name = "exa_vcn3_additional_nsgs"
    }
  }

  additional_nsgs_is_empty_string_by_vcn = {
    for vcn_key, cfg in local.additional_nsgs_inputs_by_vcn : vcn_key => try(trimspace(tostring(cfg.value)) == "", false)
  }

  additional_nsgs_normalized_by_vcn = {
    for vcn_key, cfg in local.additional_nsgs_inputs_by_vcn : vcn_key => (
      cfg.value == null || local.additional_nsgs_is_empty_string_by_vcn[vcn_key] ? {} :
      try(jsondecode(cfg.value), cfg.value)
    )
  }

  additional_nsgs_is_object_by_vcn = {
    for vcn_key, value in local.additional_nsgs_normalized_by_vcn : vcn_key => can(keys(value))
  }

  additional_nsgs_maps_by_vcn = {
    for vcn_key, value in local.additional_nsgs_normalized_by_vcn : vcn_key => local.additional_nsgs_is_object_by_vcn[vcn_key] ? {
      for nsg_key, nsg in value : nsg_key => nsg
    } : {}
  }

  additional_nsgs_shape_valid_by_vcn = {
    for vcn_key, nsgs in local.additional_nsgs_maps_by_vcn : vcn_key => local.additional_nsgs_is_object_by_vcn[vcn_key] ? alltrue([
      for nsg_key, nsg in nsgs : try(
        trimspace(tostring(nsg_key)) != "" &&
        trimspace(tostring(nsg.display_name)) != "" &&
        (
          can(keys(try(nsg.ingress_rules, {}))) ? alltrue([
            for rule_key, rule in try(nsg.ingress_rules, {}) : try(
              trimspace(tostring(rule_key)) != "" &&
              trimspace(tostring(rule.protocol)) != "" &&
              trimspace(tostring(rule.src)) != "" &&
              contains(["CIDR_BLOCK", "NETWORK_SECURITY_GROUP"], upper(tostring(rule.src_type))) &&
              can(tobool(rule.stateless)) &&
              (try(rule.dst_port_min, null) == null || can(tonumber(rule.dst_port_min))) &&
              (try(rule.dst_port_max, null) == null || can(tonumber(rule.dst_port_max))) &&
              (try(rule.icmp_type, null) == null || can(tonumber(rule.icmp_type))) &&
              (try(rule.icmp_code, null) == null || can(tonumber(rule.icmp_code)))
            , false)
          ]) : false
        ) &&
        (
          can(keys(try(nsg.egress_rules, {}))) ? alltrue([
            for rule_key, rule in try(nsg.egress_rules, {}) : try(
              trimspace(tostring(rule_key)) != "" &&
              trimspace(tostring(rule.protocol)) != "" &&
              trimspace(tostring(rule.dst)) != "" &&
              contains(["CIDR_BLOCK", "NETWORK_SECURITY_GROUP", "SERVICE_CIDR_BLOCK"], upper(tostring(rule.dst_type))) &&
              can(tobool(rule.stateless)) &&
              (try(rule.dst_port_min, null) == null || can(tonumber(rule.dst_port_min))) &&
              (try(rule.dst_port_max, null) == null || can(tonumber(rule.dst_port_max))) &&
              (try(rule.icmp_type, null) == null || can(tonumber(rule.icmp_type))) &&
              (try(rule.icmp_code, null) == null || can(tonumber(rule.icmp_code)))
            , false)
          ]) : false
        )
      , false)
    ]) : false
  }

  additional_nsgs_by_vcn = {
    for vcn_key, cfg in local.additional_nsgs_inputs_by_vcn : vcn_key => cfg.enabled && local.additional_nsgs_shape_valid_by_vcn[vcn_key] ? local.additional_nsgs_maps_by_vcn[vcn_key] : {}
  }

  additional_nsgs_validation_failures_by_vcn = {
    for vcn_key, cfg in local.additional_nsgs_inputs_by_vcn : vcn_key => cfg.variable_name
    if cfg.enabled && !(local.additional_nsgs_is_object_by_vcn[vcn_key] && local.additional_nsgs_shape_valid_by_vcn[vcn_key])
  }
}

resource "terraform_data" "validate_additional_nsgs" {
  for_each = local.additional_nsgs_validation_failures_by_vcn

  input = sha1(jsonencode(local.additional_nsgs_maps_by_vcn[each.key]))

  lifecycle {
    precondition {
      condition     = local.additional_nsgs_is_object_by_vcn[each.key] && local.additional_nsgs_shape_valid_by_vcn[each.key]
      error_message = "VALIDATION FAILURE: ${each.value} variable must be a JSON object string or HCL map of NSGs. Each NSG key must be non-empty and each NSG must include the \"display_name\" attribute. Attributes \"ingress_rules\" and \"egress_rules\", when provided, must be maps of rule objects. Ingress rules require \"protocol\", \"src\", \"src_type\" and \"stateless\" attributes. Egress rules require \"protocol\", \"dst\", \"dst_type\" and \"stateless\". Optional \"port\", \"icmp_type\", and \"icmp_code\" attributes must be numeric when provided."
    }
  }
}
