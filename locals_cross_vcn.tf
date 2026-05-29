locals {
  all_onprem_cidrs = distinct(concat(var.onprem_cidrs, var.allowed_onprem_cidrs_to_fw_mgmt_interface))

  # Cross-VCN, on-prem, external network routes
  tt_vcn1_route_rule = local.hub_with_drg_only == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true ? {
    for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.tt_vcn1_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  tt_vcn2_route_rule = local.hub_with_drg_only == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true ? {
    for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.tt_vcn2_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  tt_vcn3_route_rule = local.hub_with_drg_only == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true ? {
    for cidr in var.tt_vcn3_cidrs : "TT-VCN-3-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.tt_vcn3_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  oke_vcn1_route_rule = local.hub_with_drg_only == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true ? {
    for cidr in var.oke_vcn1_cidrs : "OKE-VCN-1-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.oke_vcn1_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  oke_vcn2_route_rule = local.hub_with_drg_only == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true ? {
    for cidr in var.oke_vcn2_cidrs : "OKE-VCN-2-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.oke_vcn2_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  oke_vcn3_route_rule = local.hub_with_drg_only == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true ? {
    for cidr in var.oke_vcn3_cidrs : "OKE-VCN-3-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.oke_vcn3_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn1_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true ? {
    for cidr in var.exa_vcn1_cidrs : "EXA-VCN-1-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.exa_vcn1_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn1_external_networks_into_client_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true ? {
    for cidr in var.exa_vcn1_external_allowed_cidrs_into_client_tier : "EXA-VCN-1-EXTERNAL-NETWORK-CLIENT-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for external network ${cidr} is routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn1_external_networks_into_integration_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true ? {
    for cidr in var.exa_vcn1_external_allowed_cidrs_into_integration_tier : "EXA-VCN-1-EXTERNAL-NETWORK-INTEGRATION-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for external network ${cidr} is routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn2_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true ? {
    for cidr in var.exa_vcn2_cidrs : "EXA-VCN-2-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.exa_vcn2_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn2_external_networks_into_client_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true ? {
    for cidr in var.exa_vcn2_external_allowed_cidrs_into_client_tier : "EXA-VCN-2-EXTERNAL-NETWORK-CLIENT-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for external network ${cidr} is routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn2_external_networks_into_integration_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true ? {
    for cidr in var.exa_vcn2_external_allowed_cidrs_into_integration_tier : "EXA-VCN-2-EXTERNAL-NETWORK-INTEGRATION-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for external network ${cidr} is routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn3_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true ? {
    for cidr in var.exa_vcn3_cidrs : "EXA-VCN-3-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for ${local.exa_vcn3_display_name} in routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn3_external_networks_into_client_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true ? {
    for cidr in var.exa_vcn3_external_allowed_cidrs_into_client_tier : "EXA-VCN-3-EXTERNAL-NETWORK-CLIENT-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for external network ${cidr} is routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  exa_vcn3_external_networks_into_integration_route_rule = local.hub_with_drg_only == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true ? {
    for cidr in var.exa_vcn3_external_allowed_cidrs_into_integration_tier : "EXA-VCN-3-EXTERNAL-NETWORK-INTEGRATION-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for external network ${cidr} is routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  on_prem_route_rule = local.hub_with_drg_only == true ? {
    for cidr in local.all_onprem_cidrs : "ONPREM-${cidr}-RULE" => {
      network_entity_key = "HUB-DRG"
      description        = "Traffic destined for on-premises ${cidr} CIDR range is routed through the DRG."
      destination        = cidr
      destination_type   = "CIDR_BLOCK"
    }
  } : {}

  icmp_path_discovery_security_rule = {
    description = "Ingress for ICMP path discovery."
    stateless   = false
    protocol    = "ICMP"
    src         = "0.0.0.0/0"
    src_type    = "CIDR_BLOCK"
    icmp_type   = 3
    icmp_code   = 4
  }

  # Open network security rules
  # Ingress
  ingress_from_hub_jumphost_subnet_security_rule = (local.hub_with_vcn == true && var.add_hub_vcn_jumphost_subnet == true) ? {
    "INGRESS-FROM-HUB-JUMPHOST-SUBNET-RULE" = {
      description  = "Ingress from Hub VCN Jumphost subnet."
      stateless    = false
      protocol     = "TCP"
      src          = local.hub_vcn_jumphost_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = 22
      dst_port_max = 22
    }
  } : {}

  ingress_from_hub_web_subnet_into_tt_vcn1_web_security_rule = (local.hub_with_vcn == true && local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? {
    for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-TT-VCN1-WEB-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  ingress_from_hub_web_subnet_into_tt_vcn1_app_security_rule = (local.hub_with_vcn == true && local.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) ? {
    for port in var.tt_vcn1_app_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-TT-VCN1-APP-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  ingress_from_hub_web_subnet_into_tt_vcn2_web_security_rule = (local.hub_with_vcn == true && local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? {
    for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-TT-VCN2-WEB-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  ingress_from_hub_web_subnet_into_tt_vcn2_app_security_rule = (local.hub_with_vcn == true && local.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) ? {
    for port in var.tt_vcn2_app_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-TT-VCN2-APP-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  ingress_from_hub_web_subnet_into_tt_vcn3_web_security_rule = (local.hub_with_vcn == true && local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? {
    for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-TT-VCN3-WEB-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  ingress_from_hub_web_subnet_into_tt_vcn3_app_security_rule = (local.hub_with_vcn == true && local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) ? {
    for port in var.tt_vcn3_app_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-TT-VCN3-APP-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  ingress_from_hub_web_subnet_into_oke_vcn1_services_security_rule = (local.hub_with_vcn == true && local.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) ? {
    for port in var.oke_vcn1_services_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-OKE-VCN1-SERVICES-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  ingress_from_hub_web_subnet_into_oke_vcn2_services_security_rule = (local.hub_with_vcn == true && local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? {
    for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-OKE-VCN2-SERVICES-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  ingress_from_hub_web_subnet_into_oke_vcn3_services_security_rule = (local.hub_with_vcn == true && local.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) ? {
    for port in var.oke_vcn3_services_ingress_destination_ports : "INGRESS-FROM-HUB-WEB-ON-OKE-VCN3-SERVICES-${port}-RULE" => {
      description  = "Ingress from ${local.hub_vcn_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
      stateless    = false
      protocol     = split(":", port)[0]
      src          = local.hub_vcn_web_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
      icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
      icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
    }
  } : {}

  from_hub_vcn_ingress_security_rules = { for cidr in var.hub_vcn_cidrs : "INGRESS-FROM-HUB-VCN-${cidr}-RULE" => {
    description = "Ingress from ${local.hub_vcn_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_tt_vcn_1_ingress_security_rules = { for cidr in var.tt_vcn1_cidrs : "INGRESS-FROM-TT-VCN1-${cidr}-RULE" => {
    description = "Ingress from ${local.tt_vcn1_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_tt_vcn_2_ingress_security_rules = { for cidr in var.tt_vcn2_cidrs : "INGRESS-FROM-TT-VCN2-${cidr}-RULE" => {
    description = "Ingress from ${local.tt_vcn2_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_tt_vcn_3_ingress_security_rules = { for cidr in var.tt_vcn3_cidrs : "INGRESS-FROM-TT-VCN3-${cidr}-RULE" => {
    description = "Ingress from ${local.tt_vcn3_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_oke_vcn_1_ingress_security_rules = { for cidr in var.oke_vcn1_cidrs : "INGRESS-FROM-OKE-VCN1-${cidr}-RULE" => {
    description = "Ingress from ${local.oke_vcn1_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_oke_vcn_2_ingress_security_rules = { for cidr in var.oke_vcn2_cidrs : "INGRESS-FROM-OKE-VCN2-${cidr}-RULE" => {
    description = "Ingress from ${local.oke_vcn2_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_oke_vcn_3_ingress_security_rules = { for cidr in var.oke_vcn3_cidrs : "INGRESS-FROM-OKE-VCN3${cidr}-RULE" => {
    description = "Ingress from ${local.oke_vcn3_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_exa_vcn_1_ingress_security_rules = { for cidr in var.exa_vcn1_cidrs : "INGRESS-FROM-EXA-VCN1-${cidr}-RULE" => {
    description = "Ingress from ${local.exa_vcn1_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_exa_vcn_2_ingress_security_rules = { for cidr in var.exa_vcn2_cidrs : "INGRESS-FROM-EXA-VCN2-${cidr}-RULE" => {
    description = "Ingress from ${local.exa_vcn2_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_exa_vcn_3_ingress_security_rules = { for cidr in var.exa_vcn3_cidrs : "INGRESS-FROM-EXA-VCN3-${cidr}-RULE" => {
    description = "Ingress from ${local.exa_vcn3_display_name}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  from_onprem_ingress_security_rules = { for cidr in var.onprem_cidrs : "INGRESS-FROM-ONPREM-${cidr}-RULE" => {
    description = "Ingress from on-premises CIDR ${cidr}."
    stateless   = false
    protocol    = "ALL"
    src         = cidr
    src_type    = "CIDR_BLOCK"
  } }

  # Egress 
  to_hub_vcn_egress_security_rules = { for cidr in var.hub_vcn_cidrs : "EGRESS-TO-HUB-VCN-${cidr}-RULE" => {
    description = "Egress to ${local.hub_vcn_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_tt_vcn_1_egress_security_rules = { for cidr in var.tt_vcn1_cidrs : "EGRESS-TO-TT-VCN1-${cidr}-RULE" => {
    description = "Egress to ${local.tt_vcn1_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_tt_vcn_2_egress_security_rules = { for cidr in var.tt_vcn2_cidrs : "EGRESS-TO-TT-VCN2-${cidr}-RULE" => {
    description = "Egress to ${local.tt_vcn2_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_tt_vcn_3_egress_security_rules = { for cidr in var.tt_vcn3_cidrs : "EGRESS-TO-TT-VCN3-${cidr}-RULE" => {
    description = "Egress to ${local.tt_vcn3_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_oke_vcn_1_egress_security_rules = { for cidr in var.oke_vcn1_cidrs : "EGRESS-TO-OKE-VCN1-${cidr}-RULE" => {
    description = "Egress to ${local.oke_vcn1_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_oke_vcn_2_egress_security_rules = { for cidr in var.oke_vcn2_cidrs : "EGRESS-TO-OKE-VCN2-${cidr}-RULE" => {
    description = "Egress to ${local.oke_vcn2_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_oke_vcn_3_egress_security_rules = { for cidr in var.oke_vcn3_cidrs : "EGRESS-TO-OKE-VCN3-${cidr}-RULE" => {
    description = "Egress to ${local.oke_vcn3_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_exa_vcn_1_egress_security_rules = { for cidr in var.exa_vcn1_cidrs : "EGRESS-TO-EXA-VCN1-${cidr}-RULE" => {
    description = "Egress to ${local.exa_vcn1_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_exa_vcn_2_egress_security_rules = { for cidr in var.exa_vcn2_cidrs : "EGRESS-TO-EXA-VCN2-${cidr}-RULE" => {
    description = "Egress to ${local.exa_vcn2_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_exa_vcn_3_egress_security_rules = { for cidr in var.exa_vcn3_cidrs : "EGRESS-TO-EXA-VCN3-${cidr}-RULE" => {
    description = "Egress to ${local.exa_vcn3_display_name}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  to_onprem_egress_security_rules = { for cidr in var.onprem_cidrs : "EGRESS-TO-ON-PREM-${cidr}-RULE" => {
    description = "Egress to on-premises CIDR ${cidr}."
    stateless   = false
    protocol    = "ALL"
    dst         = cidr
    dst_type    = "CIDR_BLOCK"
  } }

  # Constrained network security rules
  tt_vcn_1_web_subnet_egress_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "EGRESS-TO-TT-VCN1-ON-${port}-RULE" => {
    description  = "Egress to ${local.tt_vcn1_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.tt_vcn1_web_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_web_subnet_egress_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "EGRESS-TO-TT-VCN2-ON-${port}-RULE" => {
    description  = "Egress to ${local.tt_vcn2_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.tt_vcn2_web_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_web_subnet_egress_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "EGRESS-TO-TT-VCN3-ON-${port}-RULE" => {
    description  = "Egress to ${local.tt_vcn3_web_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.tt_vcn3_web_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_1_db_subnet_egress_security_rules = { for port in var.tt_vcn1_db_ingress_destination_ports : "EGRESS-TO-TT-VCN1-ON-${port}-RULE" => {
    description  = "Egress to ${local.tt_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.tt_vcn1_db_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_db_subnet_egress_security_rules = { for port in var.tt_vcn2_db_ingress_destination_ports : "EGRESS-TO-TT-VCN2-ON-${port}-RULE" => {
    description  = "Egress to ${local.tt_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.tt_vcn2_db_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_db_subnet_egress_security_rules = { for port in var.tt_vcn3_db_ingress_destination_ports : "EGRESS-TO-TT-VCN3-ON-${port}-RULE" => {
    description  = "Egress to ${local.tt_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.tt_vcn3_db_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_services_subnet_egress_security_rules = { for port in var.oke_vcn1_services_ingress_destination_ports : "EGRESS-TO-OKE-VCN1-ON-${port}-RULE" => {
    description  = "Egress to ${local.oke_vcn1_services_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.oke_vcn1_services_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_services_subnet_egress_security_rules = { for port in var.oke_vcn2_services_ingress_destination_ports : "EGRESS-TO-OKE-VCN2-ON-${port}-RULE" => {
    description  = "Egress to ${local.oke_vcn2_services_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.oke_vcn2_services_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_services_subnet_egress_security_rules = { for port in var.oke_vcn3_services_ingress_destination_ports : "EGRESS-TO-OKE-VCN3-ON-${port}-RULE" => {
    description  = "Egress to ${local.oke_vcn3_services_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.oke_vcn3_services_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_db_subnet_egress_security_rules = { for port in var.oke_vcn1_db_ingress_destination_ports : "EGRESS-TO-OKE-VCN1-DB-ON-${port}-RULE" => {
    description  = "Egress to ${local.oke_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.oke_vcn1_db_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn1_db_subnet == true }

  oke_vcn_2_db_subnet_egress_security_rules = { for port in var.oke_vcn2_db_ingress_destination_ports : "EGRESS-TO-OKE-VCN2-DB-ON-${port}-RULE" => {
    description  = "Egress to ${local.oke_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.oke_vcn2_db_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn2_db_subnet == true }

  oke_vcn_3_db_subnet_egress_security_rules = { for port in var.oke_vcn3_db_ingress_destination_ports : "EGRESS-TO-OKE-VCN3-DB-ON-${port}-RULE" => {
    description  = "Egress to ${local.oke_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.oke_vcn3_db_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn3_db_subnet == true }

  exa_vcn_1_client_subnet_egress_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "EGRESS-TO-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Egress to ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.exa_vcn1_client_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_egress_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "EGRESS-TO-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Egress to ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.exa_vcn2_client_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_egress_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "EGRESS-TO-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Egress to ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    dst          = local.exa_vcn3_client_subnet_cidr
    dst_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  # Ingress
  tt_vcn_1_web_subnet_ingress_from_tt_vcn2_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }
  tt_vcn_1_web_subnet_ingress_from_tt_vcn3_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_1_web_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_1_web_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_1_web_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_1_web_subnet_ingress_from_oke_vcn1_pods_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" }

  tt_vcn_1_web_subnet_ingress_from_oke_vcn2_pods_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" }

  tt_vcn_1_web_subnet_ingress_from_oke_vcn3_pods_security_rules = { for port in var.tt_vcn1_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" }

  tt_vcn_1_db_subnet_ingress_from_exa_vcn1_security_rules = { for port in var.tt_vcn1_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn1_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_1_db_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.tt_vcn1_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_1_db_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.tt_vcn1_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_1_web_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.tt_vcn1_web_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.tt_vcn1_web_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  # Cross VCN ingress rules for TT-VCN-2
  tt_vcn_2_web_subnet_ingress_from_tt_vcn1_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_web_subnet_ingress_from_tt_vcn3_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_web_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_web_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_web_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_web_subnet_ingress_from_oke_vcn1_pods_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" }

  tt_vcn_2_web_subnet_ingress_from_oke_vcn2_pods_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" }

  tt_vcn_2_web_subnet_ingress_from_oke_vcn3_pods_security_rules = { for port in var.tt_vcn2_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" }

  tt_vcn_2_web_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.tt_vcn2_web_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.tt_vcn2_web_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  tt_vcn_2_db_subnet_ingress_from_exa_vcn1_security_rules = { for port in var.tt_vcn2_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn1_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_db_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.tt_vcn2_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_2_db_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.tt_vcn2_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  # Cross VCN ingress rules for TT-VCN-3
  tt_vcn_3_web_subnet_ingress_from_tt_vcn1_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_web_subnet_ingress_from_tt_vcn2_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_web_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_web_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_web_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_web_subnet_ingress_from_oke_vcn1_pods_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" }

  tt_vcn_3_web_subnet_ingress_from_oke_vcn2_pods_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" }

  tt_vcn_3_web_subnet_ingress_from_oke_vcn3_pods_security_rules = { for port in var.tt_vcn3_web_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" }

  tt_vcn_3_web_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.tt_vcn3_web_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.tt_vcn3_web_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  tt_vcn_3_db_subnet_ingress_from_exa_vcn1_security_rules = { for port in var.tt_vcn3_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn1_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_db_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.tt_vcn3_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  tt_vcn_3_db_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.tt_vcn3_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  # Cross VCN ingress rules into OKE-VCN-1 services subnet
  oke_vcn_1_services_subnet_ingress_from_tt_vcn1_security_rules = { for port in var.oke_vcn1_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_services_subnet_ingress_from_tt_vcn2_security_rules = { for port in var.oke_vcn1_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_services_subnet_ingress_from_tt_vcn3_security_rules = { for port in var.oke_vcn1_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_services_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.oke_vcn1_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_services_subnet_ingress_from_oke_vcn2_pods_security_rules = upper(var.oke_vcn2_cni_type) == "NATIVE" ? { for port in var.oke_vcn1_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" } : {}

  oke_vcn_1_services_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.oke_vcn1_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_services_subnet_ingress_from_oke_vcn3_pods_security_rules = upper(var.oke_vcn3_cni_type) == "NATIVE" ? { for port in var.oke_vcn1_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" } : {}

  oke_vcn_1_services_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.oke_vcn1_services_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.oke_vcn1_services_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  # Cross VCN ingress rules into OKE-VCN-2 services subnet
  oke_vcn_2_services_subnet_ingress_from_tt_vcn1_security_rules = { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_services_subnet_ingress_from_tt_vcn2_security_rules = { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_services_subnet_ingress_from_tt_vcn3_security_rules = { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_services_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_services_subnet_ingress_from_oke_vcn1_pods_security_rules = upper(var.oke_vcn1_cni_type) == "NATIVE" ? { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" } : {}

  oke_vcn_2_services_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_services_subnet_ingress_from_oke_vcn3_pods_security_rules = upper(var.oke_vcn3_cni_type) == "NATIVE" ? { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" } : {}

  oke_vcn_2_services_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.oke_vcn2_services_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.oke_vcn2_services_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  # Cross VCN ingress rules into OKE-VCN-3 services subnet
  oke_vcn_3_services_subnet_ingress_from_tt_vcn1_security_rules = { for port in var.oke_vcn3_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_services_subnet_ingress_from_tt_vcn2_security_rules = { for port in var.oke_vcn3_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_services_subnet_ingress_from_tt_vcn3_security_rules = { for port in var.oke_vcn3_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_services_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.oke_vcn3_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_services_subnet_ingress_from_oke_vcn1_pods_security_rules = upper(var.oke_vcn1_cni_type) == "NATIVE" ? { for port in var.oke_vcn3_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" } : {}

  oke_vcn_3_services_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.oke_vcn3_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_services_subnet_ingress_from_oke_vcn2_pods_security_rules = upper(var.oke_vcn2_cni_type) == "NATIVE" ? { for port in var.oke_vcn3_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" } : {}

  oke_vcn_3_services_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.oke_vcn3_services_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.oke_vcn3_services_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  # Cross VCN ingress rules into EXA-VCN-1 client subnet
  exa_vcn_1_client_subnet_ingress_from_tt_vcn1_app_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-APP-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_tt_vcn1_db_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_tt_vcn2_app_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-APP-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_tt_vcn2_db_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_tt_vcn3_app_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-APP-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_tt_vcn3_db_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn1_pods_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn1_db_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn1_db_subnet == true }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn2_pods_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn2_db_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn2_db_subnet == true }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn3_pods_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" }

  exa_vcn_1_client_subnet_ingress_from_oke_vcn3_db_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn3_db_subnet == true }

  exa_vcn_1_client_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_client_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.exa_vcn1_client_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.exa_vcn1_client_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  # Cross VCN ingress rules into EXA-VCN-1 integration subnet
  exa_vcn_1_integration_subnet_ingress_from_tt_vcn1_app_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-APP-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_tt_vcn1_db_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_tt_vcn2_app_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-APP-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_tt_vcn2_db_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_tt_vcn3_app_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-APP-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_app_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_tt_vcn3_db_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn1_pods_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn1_db_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn1_db_subnet == true }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn2_pods_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn2_db_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn2_db_subnet == true }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn3_pods_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" }

  exa_vcn_1_integration_subnet_ingress_from_oke_vcn3_db_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn3_db_subnet == true }

  exa_vcn_1_integration_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_1_integration_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.exa_vcn1_integration_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.exa_vcn1_integration_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  # Cross VCN ingress rules into EXA-VCN-2 client subnet
  exa_vcn_2_client_subnet_ingress_from_tt_vcn1_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_ingress_from_tt_vcn2_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_ingress_from_tt_vcn3_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn1_pods_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn1_db_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn1_db_subnet == true }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn2_pods_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn2_db_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn2_db_subnet == true }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn3_pods_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" }

  exa_vcn_2_client_subnet_ingress_from_oke_vcn3_db_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn3_db_subnet == true }

  exa_vcn_2_client_subnet_ingress_from_exa_vcn1_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn1_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.exa_vcn2_client_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_2_client_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.exa_vcn2_client_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.exa_vcn2_client_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  exa_vcn_2_integration_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.exa_vcn2_integration_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.exa_vcn2_integration_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  # Cross VCN ingress rules into EXA-VCN-3 client subnet
  exa_vcn_3_client_subnet_ingress_from_tt_vcn1_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn1_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_ingress_from_tt_vcn2_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn2_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_ingress_from_tt_vcn3_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.tt_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.tt_vcn3_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn1_workers_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn1_pods_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn1_cni_type) == "NATIVE" }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn1_db_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn1_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn1_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn1_db_subnet == true }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn2_workers_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn2_pods_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn2_cni_type) == "NATIVE" }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn2_db_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN2-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn2_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn2_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn2_db_subnet == true }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn3_workers_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-WORKERS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_workers_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn3_pods_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-PODS-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_pods_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_pods_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if upper(var.oke_vcn3_cni_type) == "NATIVE" }

  exa_vcn_3_client_subnet_ingress_from_oke_vcn3_db_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-DB-ON-${port}-RULE" => {
    description  = "Ingress from ${local.oke_vcn3_db_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.oke_vcn3_db_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } if var.add_oke_vcn3_db_subnet == true }

  exa_vcn_3_client_subnet_ingress_from_exa_vcn1_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn1_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.exa_vcn3_client_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  exa_vcn_3_client_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.exa_vcn3_client_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.exa_vcn3_client_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  exa_vcn_3_integration_subnet_ingress_from_onprem_security_rules = { for cidr_port_pair in flatten([for cidr in var.onprem_cidrs : [for port in var.exa_vcn3_integration_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}"] if length(var.onprem_cidrs) > 0 && length(var.exa_vcn3_integration_ingress_destination_ports) > 0]) : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
    description  = "Ingress from onprem ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
    stateless    = false
    protocol     = split(":", split(",", cidr_port_pair)[1])[0]
    src          = split(",", cidr_port_pair)[0]
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
    icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
    icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
  } }

  # Cross VCN ingress rules for OKE-VCN-1
  oke_vcn_1_db_subnet_ingress_from_exa_vcn1_security_rules = { for port in var.oke_vcn1_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn1_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_db_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.oke_vcn1_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_1_db_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.oke_vcn1_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_db_subnet_ingress_from_exa_vcn1_security_rules = { for port in var.oke_vcn2_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn1_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_db_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.oke_vcn2_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_2_db_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.oke_vcn2_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_db_subnet_ingress_from_exa_vcn1_security_rules = { for port in var.oke_vcn3_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN1-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn1_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn1_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_db_subnet_ingress_from_exa_vcn2_security_rules = { for port in var.oke_vcn3_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN2-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn2_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn2_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }

  oke_vcn_3_db_subnet_ingress_from_exa_vcn3_security_rules = { for port in var.oke_vcn3_db_ingress_destination_ports : "INGRESS-FROM-EXA-VCN3-ON-${port}-RULE" => {
    description  = "Ingress from ${local.exa_vcn3_client_subnet_display_name} over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
    stateless    = false
    protocol     = split(":", port)[0]
    src          = local.exa_vcn3_client_subnet_cidr
    src_type     = "CIDR_BLOCK"
    dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
    icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
    icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
  } }
}
