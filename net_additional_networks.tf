# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

data "oci_core_vcn" "additional_vcns" {
  for_each = toset((distinct(concat(var.workloadvcn_ocids_onprem_access, var.workloadvcn_ocids_public_access))))
  vcn_id   = each.value
}

locals {

  additional_vcns = {
    for k, v in data.oci_core_vcn.additional_vcns : k => {
      id           = v.id
      cidr_block   = v.cidr_block
      display_name = v.display_name
    }
  }

  combined_workload_ocids = compact([for k in local.additional_vcns : k.id])                                                    ## list of valid ocid values of all workload vcns
  workload_cidrs_onprem   = compact([for ocid in var.workloadvcn_ocids_onprem_access : local.additional_vcns[ocid].cidr_block]) ## list of workload vcn cidrs allowed on-premises access
  workload_cidrs_public   = compact([for ocid in var.workloadvcn_ocids_public_access : local.additional_vcns[ocid].cidr_block]) ## list of workload vcn cidrs allowed public access
  combined_workload_cidrs = distinct(concat(local.workload_cidrs_onprem, local.workload_cidrs_public))                          ## combined list of all workload vcn cidrs (onprem + public)

  additional_vcns_attachments = {
    for ocid in local.combined_workload_ocids :
    "${upper(local.additional_vcns[ocid].display_name)}-ATTACHMENT" => {
      display_name        = "${local.additional_vcns[ocid].display_name}-attachment"
      drg_route_table_key = "${upper(local.additional_vcns[ocid].display_name)}-DRG-ROUTE-TABLE"
      network_details = {
        attached_resource_id = ocid
        type                 = "VCN"
      }
    }
  }

  additional_vcns_drg_route_tables = {
      for ocid in local.combined_workload_ocids :
      "${upper(local.additional_vcns[ocid].display_name)}-DRG-ROUTE-TABLE" => {
        display_name                      = "${local.additional_vcns[ocid].display_name}-drg-route-table"
        import_drg_route_distribution_key = "${upper(local.additional_vcns[ocid].display_name)}-DRG-IMPORT-ROUTE-DISTRIBUTION"
      }
    }

  additional_vcns_drg_route_distributions = {
    for ocid in local.combined_workload_ocids :
    "${upper(local.additional_vcns[ocid].display_name)}-DRG-IMPORT-ROUTE-DISTRIBUTION" => {
      display_name      = "${local.additional_vcns[ocid].display_name}-drg-import-route-distribution"
      distribution_type = "IMPORT"
      statements = merge(
        local.hub_with_vcn == true ? {
          "${upper(local.additional_vcns[ocid].display_name)}-HUB-VCN-STMT" = {
            action   = "ACCEPT",
            priority = 1,
            match_criteria = {
              match_type         = "DRG_ATTACHMENT_ID",
              attachment_type    = "VCN",
              drg_attachment_key = "HUB-VCN-ATTACHMENT"
            }
          }
        } : {},
        contains(local.workload_cidrs_onprem, local.additional_vcns[ocid].cidr_block) && local.hub_with_drg_only == true && (length(regexall("FASTCONNECT", upper(var.on_premises_connection_option))) > 0) ? {
          "${upper(local.additional_vcns[ocid].display_name)}-TO-FC-VIRTUAL-CIRCUIT-STMT" = {
            action   = "ACCEPT",
            priority = 2,
            match_criteria = {
              match_type      = "DRG_ATTACHMENT_ID",
              attachment_type = "VIRTUAL_CIRCUIT",
            }
          }
        } : {},
        contains(local.workload_cidrs_onprem, local.additional_vcns[ocid].cidr_block) && local.hub_with_drg_only == true && (length(regexall("IPSEC", upper(var.on_premises_connection_option))) > 0) ? {
          "${upper(local.additional_vcns[ocid].display_name)}-IPSEC-STMT" = {
            action   = "ACCEPT",
            priority = 3,
            match_criteria = {
              match_type      = "DRG_ATTACHMENT_ID",
              attachment_type = "IPSEC_TUNNEL",
            }
          }
        } : {}
      )
    }
  }
}