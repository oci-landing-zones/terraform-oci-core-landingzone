# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  use_existing_fastconnect_virtual_circuit = (length(regexall("FASTCONNECT", upper(var.on_premises_connection_option))) > 0) && local.chosen_hub_option != 0 && (length(regexall("USE EXISTING", upper(var.fastconnect_virtual_circuit_config))) > 0) && length(trimspace(var.existing_fastconnect_virtual_circuit_ocid)) > 0
  deploy_fastconnect                       = (length(regexall("FASTCONNECT", upper(var.on_premises_connection_option))) > 0) && local.chosen_hub_option != 0 && (length(regexall("CREATE NEW FASTCONNECT VIRTUAL CIRCUIT", upper(var.fastconnect_virtual_circuit_config))) > 0)

  fastconnect = local.deploy_fastconnect ? {
    fast_connect_virtual_circuits = {
      FASTCONNECT = {
        compartment_id = local.network_compartment_id
        display_name   = coalesce(var.fastconnect_virtual_circuit_name, "${var.service_label}-fastconnect-virtual-circuit")
        gateway_key    = local.deploy_new_drg == true ? "HUB-DRG" : null
        gateway_id     = local.use_existing_drg == true ? trimspace(var.existing_drg_ocid) : null
        type           = var.fastconnect_virtual_circuit_type

        provision_fc_virtual_circuit                = true
        show_available_fc_virtual_circuit_providers = false

        bandwidth_shape_name      = var.fastconnect_virtual_circuit_bandwidth_shape
        provider_service_id       = var.fastconnect_virtual_circuit_provider_service_id
        provider_service_key_name = var.fastconnect_virtual_circuit_provider_service_key_name

        customer_asn = var.fastconnect_virtual_circuit_customer_asn

        cross_connect_mappings = {
          CC-MAPPING-1 = {
            bgp_md5auth_key                         = var.fastconnect_virtual_circuit_bgp_md5auth_key
            cross_connect_or_cross_connect_group_id = var.fastconnect_virtual_circuit_cross_connect_or_cross_connect_group_id
            customer_bgp_peering_ip                 = var.fastconnect_virtual_circuit_customer_bgp_peering_ip
            oracle_bgp_peering_ip                   = var.fastconnect_virtual_circuit_oracle_bgp_peering_ip
            vlan                                    = var.fastconnect_virtual_circuit_vlan
          }
        }
        is_bfd_enabled = var.fastconnect_virtual_circuit_is_bfd_enabled
        routing_policy = var.fastconnect_virtual_circuit_routing_policy
        ip_mtu         = var.fastconnect_virtual_circuit_ip_mtu
      }
    }
  } : {}
}