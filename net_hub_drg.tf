# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  hub_options = {
    "No cross-VCN or on-premises connectivity"                                                                                                         = 0,
    "VCN or on-premises connectivity routing via DRG (DRG will be created)"                                                                            = 1,
    "VCN or on-premises connectivity routing via DRG (existing DRG)"                                                                                   = 2,
    "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"                         = 3,
    "VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)" = 4
  }

  chosen_hub_option = var.hub_deployment_option == "" ? var.hub_deployment : local.hub_options[var.hub_deployment_option]
  deploy_new_drg    = var.define_net == true && (local.chosen_hub_option == 1 || local.chosen_hub_option == 3)
  use_existing_drg  = var.define_net == true && (local.chosen_hub_option == 2 || local.chosen_hub_option == 4)
  hub_with_drg_only = var.define_net == true && (local.chosen_hub_option == 1 || local.chosen_hub_option == 2)
  hub_with_vcn      = var.define_net == true && (local.chosen_hub_option == 3 || local.chosen_hub_option == 4)

  # enable_hub_vcn_route = ((local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && length(var.tt_vcn1_routable_vcns) > 0) ||
  #                         (local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && length(var.tt_vcn2_routable_vcns) > 0) ||
  #                         (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && length(var.tt_vcn3_routable_vcns) > 0) ||
  #                         (local.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true && length(var.exa_vcn1_routable_vcns) > 0) ||
  #                         (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true && length(var.exa_vcn2_routable_vcns) > 0) ||
  #                         (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true && length(var.exa_vcn3_routable_vcns) > 0) ||
  #                         (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true && length(var.oke_vcn1_routable_vcns) > 0) ||
  #                         (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && length(var.oke_vcn2_routable_vcns) > 0) ||
  #                         (local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true && length(var.oke_vcn3_routable_vcns) > 0))

  drg = (local.chosen_hub_option != 0) ? {
    # "dynamic_routing_gateways" is for creating a new DRG.
    # "inject_into_existing_drgs" is for reusing an existing DRG.
    local.deploy_new_drg == true ? "dynamic_routing_gateways" : "inject_into_existing_drgs" = {
      "HUB-DRG" = {
        display_name = local.deploy_new_drg == true ? "${var.service_label}-hub-drg" : null
        drg_id       = local.use_existing_drg == true ? trimspace(var.existing_drg_ocid) : null

        drg_attachments = merge(
          local.hub_with_vcn == true ? {
            "HUB-VCN-ATTACHMENT" = {
              display_name = "${coalesce(var.hub_vcn_name, "${var.service_label}-hub-vcn")}-attachment"
              # DRG route table for the Hub VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "HUB-VCN-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "HUB-VCN"
                type                  = "VCN"
                # HuB VCN ingress route table for the DRG. It defines how traffic that leaves the DRG is routed within the VCN.
                route_table_key = (coalesce(var.hub_vcn_east_west_entry_point_ocid,local.void) != local.void || coalesce(var.oci_nfw_ip_ocid,local.void) != local.void) ? "HUB-VCN-INGRESS-ROUTE-TABLE" : null
              }
            }
          } : {},
          (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? {
            "TT-VCN-1-ATTACHMENT" = {
              display_name = "${coalesce(var.tt_vcn1_name, "${var.service_label}-three-tier-vcn-1")}-attachment"
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
              display_name = "${coalesce(var.tt_vcn2_name, "${var.service_label}-three-tier-vcn-2")}-attachment"
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
              display_name = "${coalesce(var.tt_vcn3_name, "${var.service_label}-three-tier-vcn-3")}-attachment"
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
              display_name = "${coalesce(var.exa_vcn1_name, "${var.service_label}-exadata-vcn-1")}-attachment"
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
              display_name = "${coalesce(var.exa_vcn2_name, "${var.service_label}-exadata-vcn-2")}-attachment"
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
              display_name = "${coalesce(var.exa_vcn3_name, "${var.service_label}-exadata-vcn-3")}-attachment"
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
              display_name = "${coalesce(var.oke_vcn1_name, "${var.service_label}-oke-vcn-1")}-attachment"
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
              display_name = "${coalesce(var.oke_vcn2_name, "${var.service_label}-oke-vcn-2")}-attachment"
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
              display_name = "${coalesce(var.oke_vcn3_name, "${var.service_label}-oke-vcn-3")}-attachment"
              # DRG route table for the VCN attachment. It defines the next hop for traffic that enters the DRG via this attachment.
              drg_route_table_key = "OKE-VCN-3-DRG-ROUTE-TABLE"
              network_details = {
                attached_resource_key = "OKE-VCN-3"
                type                  = "VCN"
              }
            }
          } : {}
        )

        ## IMPORTANT: We only create DRG route tables when the hub is DRG (var.hub_deployment_option 1 and 2). Otherwise, i.e., when the Hub is a VCN, we implement a full mesh with Auto Generated Route Tables and expect the Firewall in the Hub VCN to control routing.
        drg_route_tables = merge(
          (local.hub_with_vcn == true) ? {
            "HUB-VCN-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.hub_vcn_name, "${var.service_label}-hub-vcn")}-drg-route-table"
              import_drg_route_distribution_key = "HUB-VCN-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? {
            "TT-VCN-1-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.tt_vcn1_name, "${var.service_label}-three-tier-vcn-1")}-drg-route-table"
              import_drg_route_distribution_key = "TT-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? {
            "TT-VCN-2-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.tt_vcn2_name, "${var.service_label}-three-tier-vcn-2")}-drg-route-table"
              import_drg_route_distribution_key = "TT-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? {
            "TT-VCN-3-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.tt_vcn3_name, "${var.service_label}-three-tier-vcn-3")}-drg-route-table"
              import_drg_route_distribution_key = "TT-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) ? {
            "EXA-VCN-1-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.exa_vcn1_name, "${var.service_label}-exadata-vcn-1")}-drg-route-table"
              import_drg_route_distribution_key = "EXA-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? {
            "EXA-VCN-2-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.exa_vcn2_name, "${var.service_label}-exadata-vcn-2")}-drg-route-table"
              import_drg_route_distribution_key = "EXA-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? {
            "EXA-VCN-3-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.exa_vcn3_name, "${var.service_label}-exadata-vcn-3")}-drg-route-table"
              import_drg_route_distribution_key = "EXA-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? {
            "OKE-VCN-1-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.oke_vcn1_name, "${var.service_label}-oke-vcn-1")}-drg-route-table"
              import_drg_route_distribution_key = "OKE-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? {
            "OKE-VCN-2-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.oke_vcn2_name, "${var.service_label}-oke-vcn-2")}-drg-route-table"
              import_drg_route_distribution_key = "OKE-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {},
          (local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? {
            "OKE-VCN-3-DRG-ROUTE-TABLE" = {
              display_name                      = "${coalesce(var.oke_vcn3_name, "${var.service_label}-oke-vcn-3")}-drg-route-table"
              import_drg_route_distribution_key = "OKE-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION"
            }
          } : {}
        )

        ## IMPORTANT: We only create DRG route distributions when the hub is DRG (var.hub_deployment_option 1 and 2). Otherwise, i.e., when the Hub is a VCN, we implement a full mesh with Auto Generated Route Tables and expect the Firewall in the Hub VCN to control routing.
        drg_route_distributions = merge(
          (local.hub_with_vcn == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, since there's no "VCN ingress route table for the DRG", the VCN CIDRs and subnet CIDRs of the underlying VCN are imported by those DRG route tables.
            "HUB-VCN-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.hub_vcn_name, "${var.service_label}-hub-vcn")}-drg-import-route-distribution" # TBD
              distribution_type = "IMPORT"
              statements = merge(
                local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true ? {
                  "HUB-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true ? {
                  "HUB-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true ? {
                  "HUB-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                local.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true ? {
                  "HUB-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true ? {
                  "HUB-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true ? {
                  "HUB-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true ? {
                  "HUB-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true ? {
                  "HUB-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true ? {
                  "HUB-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "TT-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.tt_vcn1_name, "${var.service_label}-three-tier-vcn-1")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "TT-VCN-1-TO-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-1-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-1-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-1-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-1-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-1-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-1-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-1-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-1-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "TT-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.tt_vcn2_name, "${var.service_label}-three-tier-vcn-2")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "TT-VCN-2-TO-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "TT-VCN-1")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-2-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-2-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-2-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-2-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-2-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-2-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-2-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-2-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "TT-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.tt_vcn3_name, "${var.service_label}-three-tier-vcn-3")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "TT-VCN-3-TO-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-3-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-3-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-3-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-3-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-3-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-3-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-3-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "TT-VCN-3-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "EXA-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.exa_vcn1_name, "${var.service_label}-exadata-vcn-1")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "EXA-VCN-1-TO-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-1-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-1-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-1-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-1-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-1-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-1-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-1-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-1-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "EXA-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.exa_vcn2_name, "${var.service_label}-exadata-vcn-2")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "EXA-VCN-2-TO-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-2-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-2-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-2-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-2-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-2-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-2-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-2-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-2-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "EXA-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.exa_vcn3_name, "${var.service_label}-exadata-vcn-3")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "EXA-VCN-3-TO-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-3-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-3-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-3-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-3-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-3-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-3-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-3-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "EXA-VCN-3-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "OKE-VCN-1-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.oke_vcn1_name, "${var.service_label}-oke-vcn-1")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "OKE-VCN-1-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-1-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-1-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-1-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-1-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-1-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-1-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-1-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-1-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "OKE-VCN-2-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.oke_vcn2_name, "${var.service_label}-oke-vcn-2")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "OKE-VCN-2-TO-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-2-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")) && var.oke_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-2-TO-OKE-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-2-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-2-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-2-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-2-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-2-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-2-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {},
          (local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? {
            # This import distribution makes its importing DRG route tables to have the referred drg_attachment_key as the next-hop attachment.
            # In this case, the "Hub VCN ingress route table for the DRG" is imported by those DRG route tables.
            "OKE-VCN-3-DRG-IMPORT-ROUTE-DISTRIBUTION" = {
              display_name      = "${coalesce(var.oke_vcn3_name, "${var.service_label}-oke-vcn-3")}-drg-import-route-distribution"
              distribution_type = "IMPORT"
              statements = merge(
                local.hub_with_vcn == true ? {
                  "OKE-VCN-3-TO-HUB-VCN-STMT" = {
                    action   = "ACCEPT",
                    priority = 1,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "HUB-VCN-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "OKE-VCN-1")) && var.oke_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-3-TO-OKE-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 2,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "OKE-VCN-2")) && var.oke_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-3-TO-OKE-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 3,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "OKE-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "EXA-VCN-1")) && var.exa_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-3-TO-EXA-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 4,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "EXA-VCN-2")) && var.exa_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-3-TO-EXA-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 5,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "EXA-VCN-3")) && var.exa_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-3-TO-EXA-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 6,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "EXA-VCN-3-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "TT-VCN-1")) && var.tt_vcn1_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-3-TO-TT-VCN-1-STMT" = {
                    action   = "ACCEPT",
                    priority = 7,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-1-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "TT-VCN-2")) && var.tt_vcn2_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-3-TO-TT-VCN-2-STMT" = {
                    action   = "ACCEPT",
                    priority = 8,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-2-ATTACHMENT"
                    }
                  }
                } : {},
                (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns, "TT-VCN-3")) && var.tt_vcn3_attach_to_drg == true && local.hub_with_drg_only == true ? {
                  "OKE-VCN-3-TO-TT-VCN-3-STMT" = {
                    action   = "ACCEPT",
                    priority = 9,
                    match_criteria = {
                      match_type         = "DRG_ATTACHMENT_ID",
                      attachment_type    = "VCN",
                      drg_attachment_key = "TT-VCN-3-ATTACHMENT"
                    }
                  }
                } : {}
              )
            }
          } : {}
        )
      }
    }
  } : null
}