# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


locals {
  deploy_new_ipsec = (length(regexall("IPSEC", upper(var.on_premises_connection_option))) > 0) && local.chosen_hub_option != 0

  cpe = local.deploy_new_ipsec ? {
    customer_premises_equipments = {
      LZ-CPE = {
        compartment_id               = local.network_compartment_id,
        ip_address                   = var.cpe_ip_address,
        display_name                 = length(var.cpe_name) > 0 ? var.cpe_name : "${var.service_label}-cpe",
        cpe_device_shape_vendor_name = var.cpe_device_shape_vendor
      }
    }
  } : null

  ipsec = local.deploy_new_ipsec ? {
    ipsecs = {
      LZ-IPSEC-VPN = {
        cpe_key = local.deploy_new_ipsec ? "LZ-CPE" : null
        drg_key = local.deploy_new_drg == true ? "HUB-DRG" : null
        drg_id  = local.use_existing_drg == true ? var.existing_drg_ocid : null

        display_name  = length(var.ipsec_vpn_name) > 0 ? var.ipsec_vpn_name : "${var.service_label}-oci-ipsec-vpn",
        static_routes = var.onprem_cidrs
        tunnels_management = {
          tunnel_1 = {
            routing = "BGP",
            bgp_session_info = {
              customer_bgp_asn      = var.ipsec_customer_bgp_asn,
              customer_interface_ip = var.ipsec_tunnel1_customer_interface_ip,
              oracle_interface_ip   = var.ipsec_tunnel1_oracle_interface_ip
            }
            shared_secret = var.ipsec_tunnel1_shared_secret
            ike_version   = var.ipsec_tunnel1_ike_version
          }
          tunnel_2 = {
            routing = "BGP",
            bgp_session_info = {
              customer_bgp_asn      = var.ipsec_customer_bgp_asn,
              customer_interface_ip = var.ipsec_tunnel2_customer_interface_ip,
              oracle_interface_ip   = var.ipsec_tunnel2_oracle_interface_ip
            }
            shared_secret = var.ipsec_tunnel2_shared_secret
            ike_version   = var.ipsec_tunnel2_ike_version
          }
        }
      }
    }
  } : null
}
