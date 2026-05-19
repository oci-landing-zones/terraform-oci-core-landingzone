# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  hub_options = {
    "No cross-VCN or on-premises connectivity"                                                                                                         = 0,
    "VCN or on-premises connectivity routing via DRG (DRG will be created)"                                                                            = 1,
    "VCN or on-premises connectivity routing via DRG (existing DRG)"                                                                                   = 2,
    "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"                         = 3,
    "VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)" = 4,
    "No cross-VCN with on-premises connectivity using a new DRG"                                                                                       = 5,
    "No cross-VCN with on-premises connectivity using an existing DRG"                                                                                 = 6
  }

  chosen_hub_option = var.hub_deployment_option == "" ? var.hub_deployment : local.hub_options[var.hub_deployment_option]
  deploy_new_drg    = var.define_net == true && (local.chosen_hub_option == 1 || local.chosen_hub_option == 3 || local.chosen_hub_option == 5)
  use_existing_drg  = var.define_net == true && (local.chosen_hub_option == 2 || local.chosen_hub_option == 4 || local.chosen_hub_option == 6)
  #hub_with_drg_only = var.define_net == true && ((local.chosen_hub_option == 1 || local.chosen_hub_option == 2 || local.chosen_hub_option == 5 || local.chosen_hub_option == 6) || ((local.chosen_hub_option == 3 || local.chosen_hub_option == 4) && local.chosen_firewall_option == "NO"))
  hub_with_drg_only = var.define_net == true && (local.chosen_hub_option == 1 || local.chosen_hub_option == 2 || local.chosen_hub_option == 5 || local.chosen_hub_option == 6)
  hub_with_vcn      = var.define_net == true && (local.chosen_hub_option == 3 || local.chosen_hub_option == 4)
  no_drg            = var.define_net == true && local.chosen_hub_option == 0

  drg = (local.chosen_hub_option != 0) ? {
    # "dynamic_routing_gateways" is for creating a new DRG.
    # "inject_into_existing_drgs" is for reusing an existing DRG.
    local.deploy_new_drg == true ? "dynamic_routing_gateways" : "inject_into_existing_drgs" = {
      "HUB-DRG" = {
        display_name = local.deploy_new_drg == true ? "${var.service_label}-hub-drg" : null
        drg_id       = local.use_existing_drg == true ? trimspace(var.existing_drg_ocid) : null

        # DRG attachments
        drg_attachments = merge(
          local.hub_with_vcn == true ? {
            "HUB-VCN-ATTACHMENT" = {
              display_name = "${local.hub_vcn_display_name}-attachment"
              # DRG route table for the Hub VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "HUB-VCN-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "HUB-VCN"
                type                  = "VCN"
                # HuB VCN ingress route table for the DRG. It defines how traffic that leaves the DRG is routed within the VCN.
                route_table_key = "HUB-VCN-INGRESS-ROUTE-TABLE"
              }
            }
          } : {},
          (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? {
            "TT-VCN-1-ATTACHMENT" = {
              display_name = "${local.tt_vcn1_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "TT-VCN-1-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "TT-VCN-1"
                type                  = "VCN"
              }
            }
          } : {},
          (local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? {
            "TT-VCN-2-ATTACHMENT" = {
              display_name = "${local.tt_vcn2_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "TT-VCN-2-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "TT-VCN-2"
                type                  = "VCN"
              }
            }
          } : {},
          (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? {
            "TT-VCN-3-ATTACHMENT" = {
              display_name = "${local.tt_vcn3_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "TT-VCN-3-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "TT-VCN-3"
                type                  = "VCN"
              }
            }
          } : {},
          (local.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) ? {
            "EXA-VCN-1-ATTACHMENT" = {
              display_name = "${local.exa_vcn1_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "EXA-VCN-1-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "EXA-VCN-1"
                type                  = "VCN"
              }
            }
          } : {},
          (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? {
            "EXA-VCN-2-ATTACHMENT" = {
              display_name = "${local.exa_vcn2_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "EXA-VCN-2-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "EXA-VCN-2"
                type                  = "VCN"
              }
            }
          } : {},
          (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? {
            "EXA-VCN-3-ATTACHMENT" = {
              display_name = "${local.exa_vcn3_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "EXA-VCN-3-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "EXA-VCN-3"
                type                  = "VCN"
              }
            }
          } : {},
          (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? {
            "OKE-VCN-1-ATTACHMENT" = {
              display_name = "${local.oke_vcn1_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "OKE-VCN-1-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "OKE-VCN-1"
                type                  = "VCN"
              }
            }
          } : {},
          (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? {
            "OKE-VCN-2-ATTACHMENT" = {
              display_name = "${local.oke_vcn2_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "OKE-VCN-2-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "OKE-VCN-2"
                type                  = "VCN"
              }
            }
          } : {},
          (local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? {
            "OKE-VCN-3-ATTACHMENT" = {
              display_name = "${local.oke_vcn3_display_name}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "OKE-VCN-3-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "OKE-VCN-3"
                type                  = "VCN"
              }
            }
          } : {},
          (local.deploy_new_ipsec) ? {
            "IPSEC-TUNNEL-1-ATTACHMENT" = {
              display_name        = "${coalesce(var.ipsec_vpn_name, "${var.service_label}-ipsec-vpn")}-tunnel-1-attachment"
              drg_route_table_key = "IPSEC-TUNNEL-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "LZ-IPSEC-VPN-TUNNEL-1-KEY"
                type                  = "IPSEC_TUNNEL"
              }
            },
            "IPSEC-TUNNEL-2-ATTACHMENT" = {
              display_name        = "${coalesce(var.ipsec_vpn_name, "${var.service_label}-ipsec-vpn")}-tunnel-2-attachment"
              drg_route_table_key = "IPSEC-TUNNEL-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "LZ-IPSEC-VPN-TUNNEL-2-KEY"
                type                  = "IPSEC_TUNNEL"
              }
            }
          } : {},
          (local.deploy_fastconnect) ? {
            "FC-VIRTUAL-CIRCUIT-1-ATTACHMENT" = {
              display_name        = "${coalesce(var.fastconnect_virtual_circuit_name, "${var.service_label}-fastconnect-virtual-circuit-1")}-attachment"
              drg_route_table_key = "FC-VIRTUAL-CIRCUIT-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "FASTCONNECT"
                type                  = "VIRTUAL_CIRCUIT"
              }
            }
          } : {},
          local.additional_vcns_attachments
        )

        # DRG route tables
        drg_route_tables = merge(
          (local.hub_with_vcn == true) ? {
            "HUB-VCN-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.hub_vcn_display_name}-drg-route-table"
              import_drg_route_distribution_key = "HUB-VCN-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          # Route rules in spoke attachments are dynamic (import_drg_route_distribution_key) only if there is no Hub VCN. If there is a Hub VCN, the route rules are static (route_rules), sending any traffic to the Hub VCN attachment.
          (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? {
            "TT-VCN-1-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.tt_vcn1_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "TT-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "TT-VCN-1-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? {
            "TT-VCN-2-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.tt_vcn2_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "TT-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "TT-VCN-2-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? {
            "TT-VCN-3-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.tt_vcn3_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "TT-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "TT-VCN-3-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) ? {
            "EXA-VCN-1-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.exa_vcn1_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "EXA-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "EXA-VCN-1-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? {
            "EXA-VCN-2-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.exa_vcn2_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "EXA-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "EXA-VCN-2-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? {
            "EXA-VCN-3-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.exa_vcn3_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "EXA-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "EXA-VCN-3-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? {
            "OKE-VCN-1-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.oke_vcn1_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "OKE-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "OKE-VCN-1-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? {
            "OKE-VCN-2-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.oke_vcn2_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "OKE-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "OKE-VCN-2-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? {
            "OKE-VCN-3-DRG-ROUTE-TABLE" = {
              display_name                      = "${local.oke_vcn3_display_name}-drg-route-table"
              import_drg_route_distribution_key = local.hub_with_vcn == false ? "OKE-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" : null
              route_rules                       = local.hub_with_vcn == true ? { "OKE-VCN-3-TO-ANYWHERE-ROUTE-RULE" = local.anywhere_drg_route_rule } : null
            }
          } : {},
          (local.deploy_new_ipsec) ? {
            "IPSEC-TUNNEL-DRG-ROUTE-TABLE" = {
              display_name = "${coalesce(var.ipsec_vpn_name, "${var.service_label}-ipsec-vpn")}-tunnel-drg-route-table"
              route_rules = merge(
                local.hub_with_vcn == true ? {
                  for cidr in var.hub_vcn_cidrs : "IPSEC-HUB-VCN-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = "HUB-VCN-ATTACHMENT"
                  }
                } : {},
                var.tt_vcn1_onprem_route_enable ? {
                  for cidr in var.tt_vcn1_cidrs : "IPSEC-TT-VCN-1-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "TT-VCN-1-ATTACHMENT"
                  }
                } : {},
                var.tt_vcn2_onprem_route_enable ? {
                  for cidr in var.tt_vcn2_cidrs : "IPSEC-TT-VCN-2-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "TT-VCN-2-ATTACHMENT"
                  }
                } : {},
                var.tt_vcn3_onprem_route_enable ? {
                  for cidr in var.tt_vcn3_cidrs : "IPSEC-TT-VCN-3-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "TT-VCN-3-ATTACHMENT"
                  }
                } : {},
                var.exa_vcn1_onprem_route_enable ? {
                  for cidr in var.exa_vcn1_cidrs : "IPSEC-EXA-VCN-1-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "EXA-VCN-1-ATTACHMENT"
                  }
                } : {},
                var.exa_vcn2_onprem_route_enable ? {
                  for cidr in var.exa_vcn2_cidrs : "IPSEC-EXA-VCN-2-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "EXA-VCN-2-ATTACHMENT"
                  }
                } : {},
                var.exa_vcn3_onprem_route_enable ? {
                  for cidr in var.exa_vcn3_cidrs : "IPSEC-EXA-VCN-3-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "EXA-VCN-3-ATTACHMENT"
                  }
                } : {},
                var.oke_vcn1_onprem_route_enable ? {
                  for cidr in var.oke_vcn1_cidrs : "IPSEC-OKE-VCN-1-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "OKE-VCN-1-ATTACHMENT"
                  }
                } : {},
                var.oke_vcn2_onprem_route_enable ? {
                  for cidr in var.oke_vcn2_cidrs : "IPSEC-OKE-VCN-2-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "OKE-VCN-2-ATTACHMENT"
                  }
                } : {},
                var.oke_vcn3_onprem_route_enable ? {
                  for cidr in var.oke_vcn3_cidrs : "IPSEC-OKE-VCN-3-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "OKE-VCN-3-ATTACHMENT"
                  }
                } : {},
                local.workload_cidrs_onprem != null ? {
                  for cidr in local.workload_cidrs_onprem : "IPSEC-ADDITIONAL-VCN-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = "HUB-VCN-ATTACHMENT"
                  }
                } : {},
              )
            }
          } : {},
          (local.deploy_fastconnect) ? {
            "FC-VIRTUAL-CIRCUIT-DRG-ROUTE-TABLE" = {
              display_name = "${coalesce(var.fastconnect_virtual_circuit_name, "${var.service_label}-fastconnect-virtual-circuit")}-drg-route-table"
              route_rules = merge(
                local.hub_with_vcn == true ? {
                  for cidr in var.hub_vcn_cidrs : "FC-VIRTUAL-CIRCUIT-HUB-VCN-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = "HUB-VCN-ATTACHMENT"
                  }
                } : {},
                var.tt_vcn1_onprem_route_enable ? {
                  for cidr in var.tt_vcn1_cidrs : "FC-VIRTUAL-CIRCUIT-TT-VCN-1-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "TT-VCN-1-ATTACHMENT"
                  }
                } : {},
                var.tt_vcn2_onprem_route_enable ? {
                  for cidr in var.tt_vcn2_cidrs : "FC-VIRTUAL-CIRCUIT-TT-VCN-2-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "TT-VCN-2-ATTACHMENT"
                  }
                } : {},
                var.tt_vcn3_onprem_route_enable ? {
                  for cidr in var.tt_vcn3_cidrs : "FC-VIRTUAL-CIRCUIT-TT-VCN-3-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "TT-VCN-3-ATTACHMENT"
                  }
                } : {},
                var.exa_vcn1_onprem_route_enable ? {
                  for cidr in var.exa_vcn1_cidrs : "FC-VIRTUAL-CIRCUIT-EXA-VCN-1-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "EXA-VCN-1-ATTACHMENT"
                  }
                } : {},
                var.exa_vcn2_onprem_route_enable ? {
                  for cidr in var.exa_vcn2_cidrs : "FC-VIRTUAL-CIRCUIT-EXA-VCN-2-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "EXA-VCN-2-ATTACHMENT"
                  }
                } : {},
                var.exa_vcn3_onprem_route_enable ? {
                  for cidr in var.exa_vcn3_cidrs : "FC-VIRTUAL-CIRCUIT-EXA-VCN-3-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "EXA-VCN-3-ATTACHMENT"
                  }
                } : {},
                var.oke_vcn1_onprem_route_enable ? {
                  for cidr in var.oke_vcn1_cidrs : "FC-VIRTUAL-CIRCUIT-OKE-VCN-1-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "OKE-VCN-1-ATTACHMENT"
                  }
                } : {},
                var.oke_vcn2_onprem_route_enable ? {
                  for cidr in var.oke_vcn2_cidrs : "FC-VIRTUAL-CIRCUIT-OKE-VCN-2-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "OKE-VCN-2-ATTACHMENT"
                  }
                } : {},
                var.oke_vcn3_onprem_route_enable ? {
                  for cidr in var.oke_vcn3_cidrs : "FC-VIRTUAL-CIRCUIT-OKE-VCN-3-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = local.hub_with_vcn == true ? "HUB-VCN-ATTACHMENT" : "OKE-VCN-3-ATTACHMENT"
                  }
                } : {},
                local.workload_cidrs_onprem != null ? {
                  for cidr in local.workload_cidrs_onprem : "FC-VIRTUAL-CIRCUIT-ADDITIONAL-VCN-${cidr}-RULE" => {
                    destination                 = cidr
                    destination_type            = "CIDR_BLOCK"
                    next_hop_drg_attachment_key = "HUB-VCN-ATTACHMENT"
                  }
                } : {},
              )
            }
          } : {},
          local.additional_vcns_drg_route_tables
        )

        # DRG dynamic route rules
        drg_route_distributions = merge(
          (local.hub_with_vcn == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "HUB-VCN-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.hub_vcn_display_name}-drg-import-route-distribution" # TBD
              distribution_type = "IMPORT"
              # statements = {
              #   "MATCH-ALL-STMT" = {
              #     action   = "ACCEPT",
              #     priority = 1,
              #     match_criteria = {
              #       match_type = "MATCH_ALL"
              #     }
              #   }
              # }
              statements = merge( # Here we make the Hub VCN attachment aware of all other LZ managed DRG attachments, including LZ managed VCNs, IPSec tunnels, FastConnect virtual circuit, and externally managed VCN. This is needed to make sure the traffic from the Hub VCN can route to those attachments via the DRG. 
                (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? { "HUB-VCN-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? { "HUB-VCN-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? { "HUB-VCN-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                (local.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) ? { "HUB-VCN-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? { "HUB-VCN-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? { "HUB-VCN-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? { "HUB-VCN-TO-OKE-VCN-1-STMT" = local.oke_vcn1_statement } : {},
                (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? { "HUB-VCN-TO-OKE-VCN-2-STMT" = local.oke_vcn2_statement } : {},
                (local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? { "HUB-VCN-TO-OKE-VCN-3-STMT" = local.oke_vcn3_statement } : {},
                (local.deploy_new_ipsec == true) ? { "HUB-VCN-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                (local.deploy_fastconnect == true) ? { "HUB-VCN-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {},
                local.external_vcn_statements
              )
            }
          } : {},
          (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "TT-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.tt_vcn1_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "TT-VCN-1-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-1-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-1-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-1-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-1-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-1-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-1-TO-OKE-VCN-1-STMT" = local.oke_vcn1_statement } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-1-TO-OKE-VCN-2-STMT" = local.oke_vcn2_statement } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-1-TO-OKE-VCN-3-STMT" = local.oke_vcn3_statement } : {},
                var.tt_vcn1_onprem_route_enable == true && var.tt_vcn1_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "TT-VCN-1-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.tt_vcn1_onprem_route_enable == true && var.tt_vcn1_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "TT-VCN-1-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          (local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "TT-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.tt_vcn2_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "TT-VCN-2-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "TT-VCN-1")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-2-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-2-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-2-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-2-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-2-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-2-TO-OKE-VCN-1-STMT" = local.oke_vcn1_statement } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-2-TO-OKE-VCN-2-STMT" = local.oke_vcn2_statement } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-2-TO-OKE-VCN-3-STMT" = local.oke_vcn3_statement } : {},
                var.tt_vcn2_onprem_route_enable == true && var.tt_vcn2_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "TT-VCN-2-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.tt_vcn2_onprem_route_enable == true && var.tt_vcn2_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "TT-VCN-2-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "TT-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.tt_vcn3_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "TT-VCN-3-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-3-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-3-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-3-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-3-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-3-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-3-TO-OKE-VCN1-STMT" = local.oke_vcn1_statement } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-3-TO-OKE-VCN2-STMT" = local.oke_vcn2_statement } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "TT-VCN-3-TO-OKE-VCN3-STMT" = local.oke_vcn3_statement } : {},
                var.tt_vcn3_onprem_route_enable == true && var.tt_vcn3_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "TT-VCN-3-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.tt_vcn3_onprem_route_enable == true && var.tt_vcn3_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "TT-VCN-3-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          (local.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "EXA-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.exa_vcn1_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "EXA-VCN-1-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-1-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-1-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-1-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-1-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-1-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-1-TO-OKE-VCN-1-STMT" = local.oke_vcn1_statement } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-1-TO-OKE-VCN-2-STMT" = local.oke_vcn2_statement } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-1-TO-OKE-VCN-3-STMT" = local.oke_vcn3_statement } : {},
                var.exa_vcn1_onprem_route_enable == true && var.exa_vcn1_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "EXA-VCN-1-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.exa_vcn1_onprem_route_enable == true && var.exa_vcn1_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "EXA-VCN-1-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "EXA-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.exa_vcn2_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "EXA-VCN-2-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-2-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-2-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-2-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-2-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-2-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-2-TO-OKE-VCN-1-STMT" = local.oke_vcn1_statement } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-2-TO-OKE-VCN-2-STMT" = local.oke_vcn2_statement } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-2-TO-OKE-VCN-3-STMT" = local.oke_vcn3_statement } : {},
                var.exa_vcn2_onprem_route_enable == true && var.exa_vcn2_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "EXA-VCN-2-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.exa_vcn2_onprem_route_enable == true && var.exa_vcn2_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "EXA-VCN-2-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "EXA-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.exa_vcn3_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "EXA-VCN-3-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-3-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-3-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-3-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-3-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-3-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-3-TO-OKE-VCN-1-STMT" = local.oke_vcn1_statement } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-3-TO-OKE-VCN-2-STMT" = local.oke_vcn2_statement } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "EXA-VCN-3-TO-OKE-VCN-3-STMT" = local.oke_vcn3_statement } : {},
                var.exa_vcn3_onprem_route_enable == true && var.exa_vcn3_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "EXA-VCN-3-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.exa_vcn3_onprem_route_enable == true && var.exa_vcn3_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "EXA-VCN-3-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "OKE-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.oke_vcn1_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "OKE-VCN-1-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-1-TO-OKE-VCN-2-STMT" = local.oke_vcn2_statement } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-1-TO-OKE-VCN-3-STMT" = local.oke_vcn3_statement } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-1-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-1-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-1-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-1-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-1-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-1-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                var.oke_vcn1_onprem_route_enable == true && var.oke_vcn1_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "OKE-VCN-1-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.oke_vcn1_onprem_route_enable == true && var.oke_vcn1_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "OKE-VCN-1-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "OKE-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.oke_vcn2_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "OKE-VCN-2-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-2-TO-OKE-VCN-1-STMT" = local.oke_vcn1_statement } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-2-TO-OKE-VCN-3-STMT" = local.oke_vcn3_statement } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-2-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-2-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-2-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-2-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-2-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-2-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                var.oke_vcn2_onprem_route_enable == true && var.oke_vcn2_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "OKE-VCN-2-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.oke_vcn2_onprem_route_enable == true && var.oke_vcn2_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "OKE-VCN-2-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          (local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            "OKE-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${local.oke_vcn3_display_name}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                # local.hub_with_vcn == true ? {
                #   "OKE-VCN-3-TO-HUB-VCN-STMT" = {
                #     action   = "ACCEPT",
                #     priority = 1,
                #     match_criteria = {
                #       match_type         = "DRG_ATTACHMENT_ID",
                #       attachment_type    = "VCN",
                #       drg_attachment_key = "HUB-VCN-ATTACHMENT"
                #     }
                #   }
                # } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-3-TO-OKE-VCN-1-STMT" = local.oke_vcn1_statement } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-3-TO-OKE-VCN-2-STMT" = local.oke_vcn2_statement } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-3-TO-EXA-VCN-1-STMT" = local.exa_vcn1_statement } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-3-TO-EXA-VCN-2-STMT" = local.exa_vcn2_statement } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-3-TO-EXA-VCN-3-STMT" = local.exa_vcn3_statement } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-3-TO-TT-VCN-1-STMT" = local.tt_vcn1_statement } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-3-TO-TT-VCN-2-STMT" = local.tt_vcn2_statement } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? { "OKE-VCN-3-TO-TT-VCN-3-STMT" = local.tt_vcn3_statement } : {},
                var.oke_vcn3_onprem_route_enable == true && var.oke_vcn3_attach_to_drg && local.hub_with_drg_only == true && local.deploy_new_ipsec == true ? { "OKE-VCN-3-TO-IPSEC-STMT" = merge(local.ipsec_tunnel_1_statement, local.ipsec_tunnel_2_statement) } : {},
                var.oke_vcn3_onprem_route_enable == true && var.oke_vcn3_attach_to_drg && local.hub_with_drg_only == true && local.deploy_fastconnect == true ? { "OKE-VCN-3-TO-FASTCONNECT-STMT" = local.fc_vc_1_statement } : {}
              )
            }
          } : {},
          local.additional_vcns_drg_route_distributions
        )

      }
    }
  } : null

  anywhere_drg_route_rule = {
    destination                 = "0.0.0.0/0"
    destination_type            = "CIDR_BLOCK"
    next_hop_drg_attachment_key = "HUB-VCN-ATTACHMENT"
  }

  tt_vcn1_statement = {
    action   = "ACCEPT",
    priority = 10,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
    }
  }

  tt_vcn2_statement = {
    action   = "ACCEPT",
    priority = 20,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
    }
  }

  tt_vcn3_statement = {
    action   = "ACCEPT",
    priority = 30,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
    }
  }

  exa_vcn1_statement = {
    action   = "ACCEPT",
    priority = 40,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
    }
  }

  exa_vcn2_statement = {
    action   = "ACCEPT",
    priority = 50,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
    }
  }

  exa_vcn3_statement = {
    action   = "ACCEPT",
    priority = 60,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
    }
  }

  oke_vcn1_statement = {
    action   = "ACCEPT",
    priority = 70,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
    }
  }

  oke_vcn2_statement = {
    action   = "ACCEPT",
    priority = 80,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
    }
  }

  oke_vcn3_statement = {
    action   = "ACCEPT",
    priority = 90,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VCN",
      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
    }
  }

  ipsec_tunnel_1_statement = {
    action   = "ACCEPT",
    priority = 100,
    match_criteria = {
      match_type      = "DRG_ATTACHMENT_TYPE",
      attachment_type = "IPSEC_TUNNEL",
      #drg_attachment_key = "IPSEC-TUNNEL-1-ATTACHMENT"
    }
  }

  ipsec_tunnel_2_statement = {
    action   = "ACCEPT",
    priority = 110,
    match_criteria = {
      match_type      = "DRG_ATTACHMENT_TYPE",
      attachment_type = "IPSEC_TUNNEL",
      #drg_attachment_key = "IPSEC-TUNNEL-2-ATTACHMENT"
    }
  }

  fc_vc_1_statement = {
    action   = "ACCEPT",
    priority = 120,
    match_criteria = {
      match_type      = "DRG_ATTACHMENT_TYPE",
      attachment_type = "VIRTUAL_CIRCUIT",
      #drg_attachment_key = "FC-VIRTUAL-CIRCUIT-1-ATTACHMENT"
    }
  }

  # Not used, reserved for the second FastConnect virtual circuit if needed in the future.
  fc_vc_2_statement = {
    action   = "ACCEPT",
    priority = 130,
    match_criteria = {
      match_type         = "DRG_ATTACHMENT_ID",
      attachment_type    = "VIRTUAL_CIRCUIT",
      drg_attachment_key = "FC-VIRTUAL-CIRCUIT-ATTACHMENT"
    }
  }

  external_vcn_statements = { for ocid in local.combined_workload_ocids :
    "EXTERNAL-VCN-${ocid}-STMT" => {
      action   = "ACCEPT"
      priority = 300 + index(local.combined_workload_ocids, ocid)
      match_criteria = {
        match_type         = "DRG_ATTACHMENT_ID"
        attachment_type    = "VCN"
        drg_attachment_key = "VCN-${upper(substr(ocid, -10, 10))}-ATTACHMENT"
      }
    }
  }
}
