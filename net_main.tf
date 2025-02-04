# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  lz_network_configuration = {
    default_compartment_id = local.network_compartment_id
    network_configuration_categories = {
      "${var.service_label}-network" = {
        vcns                      = merge(local.tt_vcn_1, local.tt_vcn_2, local.tt_vcn_3, local.exa_vcn_1, local.exa_vcn_2, local.exa_vcn_3, local.oke_vcn_1, local.oke_vcn_2, local.oke_vcn_3, local.hub_vcn)
        non_vcn_specific_gateways = merge(local.drg, local.cpe, local.ipsec, local.fastconnect)
      }
    }
  }
}

module "lz_network" {
  source                = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=release-0.7.3"
  depends_on            = [ module.lz_zpr ]
  network_configuration = local.lz_network_configuration
  network_dependency    = local.use_existing_drg ? {
    "dynamic_routing_gateways" = {
      "HUB-DRG" = {"id" : trimspace(var.existing_drg_ocid)}
    }
  } : null
  tenancy_ocid = var.tenancy_ocid
}