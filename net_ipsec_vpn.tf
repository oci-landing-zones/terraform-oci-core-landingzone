# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  deploy_new_cpe = (length(regexall(upper(var.on_premises_connection_option), "CREATE NEW CPE")) > 0) && local.chosen_hub_option != 0 && (length(regexall(upper(var.on_premises_connection_option), "IPSEC VPN")) > 0)
  use_existing_cpe = length(var.existing_cpe_ocid) > 0 && local.chosen_hub_option != 0 && (length(regexall(upper(var.on_premises_connection_option), "IPSEC VPN")) > 0)

  cpe = local.deploy_new_cpe ? {
    customer_premises_equipments = {
      LZ-CPE = {
        compartment_id               = local.network_compartment_id,
        ip_address                   = var.cpe_ip_address,
        display_name                 = length(var.cpe_name) > 0 ? var.cpe_name : "${var.service_label}-cpe",
        cpe_device_shape_vendor_name = var.cpe_device_shape_vendor
      }
    }
  } : null

  ipsec = local.deploy_new_cpe || local.use_existing_cpe ? {
    ipsecs = {
      LZ-IPSEC-VPN = {
        cpe_key            = local.deploy_new_cpe ? "LZ-CPE" : null
        cpe_id             = local.use_existing_cpe ? var.existing_cpe_ocid : null
        drg_key            = local.deploy_new_drg == true ? "HUB-DRG" : null
        drg_id             = local.use_existing_drg == true ? trimspace(var.existing_drg_ocid) : null
        display_name       = length(var.ipsec_tunnel_name) > 0 ? var.ipsec_tunnel_name : "${var.service_label}-oci-ipsec-vpn",
        static_routes      = var.onprem_cidrs
        tunnels_management = {
          tunnel_1 = {
            routing          = "BGP",
            bgp_session_info = {
              customer_bgp_asn      = var.ipsec_customer_bgp_asn,
              customer_interface_ip = var.ipsec_tunnel1_customer_interface_ip,
              oracle_interface_ip   = var.ipsec_tunnel1_oracle_interface_ip
            }
          }
          tunnel_2 = {
            routing          = "BGP",
            bgp_session_info = {
              customer_bgp_asn      = var.ipsec_customer_bgp_asn,
              customer_interface_ip = var.ipsec_tunnel2_customer_interface_ip,
              oracle_interface_ip   = var.ipsec_tunnel2_oracle_interface_ip
            }
          }
        }
      }
    }
  } : null
}
