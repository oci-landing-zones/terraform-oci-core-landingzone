# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  hub_options = {
    "No"                                    = 0,
    "Yes, new DRG as hub"                   = 1,
    "Yes, existing DRG as hub"              = 2,
    "Yes, new VCN as hub with new DRG"      = 3
    "Yes, new VCN as hub with existing DRG" = 4
  }

  lz_network_configuration = {
    default_compartment_id = local.network_compartment_id
    network_configuration_categories = {
      "THREE-TIER-VCN" = {
        vcns                      = merge(local.tt_vcn_1, local.tt_vcn_2, local.tt_vcn_3, local.exa_vcn_1, local.exa_vcn_2, local.exa_vcn_3, local.oke_vcn_1, local.oke_vcn_2, local.oke_vcn_3, local.hub_vcn)
        non_vcn_specific_gateways = local.drg
      }
    }
  }
}

module "lz_network" {
  source                = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking?ref=v0.6.7"
  network_configuration = local.lz_network_configuration
}