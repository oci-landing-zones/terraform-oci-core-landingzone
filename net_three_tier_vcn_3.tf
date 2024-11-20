# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

    add_tt_vcn3 = var.define_net == true && var.add_tt_vcn3 == true

    tt_vcn_3 = local.add_tt_vcn3 == true ? {
        "TT-VCN-3" = {
            display_name                     = coalesce(var.tt_vcn3_name,"${var.service_label}-three-tier-vcn-3")
            is_ipv6enabled                   = false
            is_oracle_gua_allocation_enabled = false
            cidr_blocks                      = var.tt_vcn3_cidrs,
            dns_label                        = substr(replace(coalesce(var.tt_vcn3_name,"three-tier-vcn-3"),"/[^\\w]/",""),0,14)
            block_nat_traffic                = false
            security                         = local.enable_zpr == true ? {zpr_attributes = [{namespace:"${local.zpr_namespace_name}",attr_name:"net", attr_value:"tt-vcn-3"}]} : null

            subnets = merge(
                {
                    "TT-VCN-3-WEB-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn3_web_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,0))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn3_web_subnet_name,"${var.service_label}-three-tier-vcn-3-web-subnet")
                        dns_label                  = substr(replace(coalesce(var.tt_vcn3_web_subnet_name,"web-subnet"),"/[^\\w]/",""),0,14)
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = (local.hub_with_vcn == true && var.tt_vcn3_attach_to_drg == true) ? true : var.tt_vcn3_web_subnet_is_private
                        route_table_key            = "TT-VCN-3-WEB-SUBNET-ROUTE-TABLE"
                    }
                },
                {    
                    "TT-VCN-3-APP-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,1))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn3_app_subnet_name,"${var.service_label}-three-tier-vcn-3-app-subnet")
                        dns_label                  = substr(replace(coalesce(var.tt_vcn3_app_subnet_name,"app-subnet"),"/[^\\w]/",""),0,14)
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = true
                        route_table_key            = "TT-VCN-3-APP-SUBNET-ROUTE-TABLE"
                    }
                },
                {    
                    "TT-VCN-3-DB-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,2))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn3_db_subnet_name,"${var.service_label}-three-tier-vcn-3-db-subnet")
                        dns_label                  = substr(replace(coalesce(var.tt_vcn3_db_subnet_name,"db-subnet"),"/[^\\w]/",""),0,14)
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = true
                        route_table_key            = "TT-VCN-3-DB-SUBNET-ROUTE-TABLE"
                    }
                },
                var.deploy_tt_vcn3_bastion_subnet == true ? {    
                    "TT-VCN-3-BASTION-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn3_bastion_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],9,96))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn3_bastion_subnet_name,"${var.service_label}-three-tier-vcn-3-bastion-subnet")
                        dns_label                  = substr(replace(coalesce(var.tt_vcn3_bastion_subnet_name,"bastion-subnet"),"/[^\\w]/",""),0,14)
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = var.tt_vcn3_bastion_is_access_via_public_endpoint == true ? false : true
                        route_table_key            = "TT-VCN-3-BASTION-SUBNET-ROUTE-TABLE"
                        security_list_keys         = var.tt_vcn3_bastion_is_access_via_public_endpoint == false ? ["TT-VCN-3-BASTION-SUBNET-SL"] : []
                    }
                } : {}    
            ) # merge function

            security_lists = var.deploy_tt_vcn3_bastion_subnet == true && var.tt_vcn3_bastion_is_access_via_public_endpoint == false ? { 
              # The bastion subnet security list is only applicable to Bastion service endpoints, which are private.
              "TT-VCN-3-BASTION-SUBNET-SL" = {
                display_name = "${coalesce(var.tt_vcn3_bastion_subnet_name,"${var.service_label}-three-tier-vcn-3-bastion-subnet")}-security-list"
                ingress_rules = [
                  {
                    description  = "Ingress on UDP type 3 code 4."
                    stateless    = false
                    protocol     = "UDP"
                    src          = "0.0.0.0/0"
                    src_type     = "CIDR_BLOCK"
                    icmp_type    = 3
                    icmp_code    = 4
                  },
                  {
                    description  = "Ingress from ${coalesce(var.tt_vcn3_bastion_subnet_name,"${var.service_label}-three-tier-vcn-3-bastion-subnet")} on SSH port. Required for connecting Bastion service endpoint to Bastion host."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.tt_vcn3_bastion_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],9,96))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 22
                    dst_port_max = 22
                  }
                ]
                egress_rules = [
                  {
                    description  = "Egress to ${coalesce(var.tt_vcn3_bastion_subnet_name,"${var.service_label}-three-tier-vcn-3-bastion-subnet")} on SSH port. Required for connecting Bastion service endpoint to Bastion host."
                    stateless    = false
                    protocol     = "TCP"
                    dst          = coalesce(var.tt_vcn3_bastion_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],9,96))
                    dst_type     = "CIDR_BLOCK"
                    dst_port_min = 22
                    dst_port_max = 22
                  }
                ]
              }
            } : null

            route_tables = merge(
                {
                    "TT-VCN-3-WEB-SUBNET-ROUTE-TABLE" = {
                        display_name = "web-subnet-rtable"
                        route_rules = merge(
                            (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
                                "INTERNET-RULE" = {
                                    network_entity_key = var.tt_vcn1_web_subnet_is_private == false ? "TT-VCN-3-INTERNET-GATEWAY" : "TT-VCN-3-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                },
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-3-SERVICE-GATEWAY"
                                    description        = "To Service Gateway."
                                    destination        = "objectstorage"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            } : {},
                            local.tt_cross_vcn_3_drg_routing
                        )
                    }
                },
                {    
                    "TT-VCN-3-APP-SUBNET-ROUTE-TABLE" = {
                        display_name = "app-subnet-rtable"
                        route_rules = merge(
                            (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
                                "INTERNET-RULE" = {
                                    network_entity_key = "TT-VCN-3-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                },
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-3-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = "all-services"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            } : {},  
                            local.tt_cross_vcn_3_drg_routing  
                        )
                    }
                },
                {    
                    "TT-VCN-3-DB-SUBNET-ROUTE-TABLE" = {
                        display_name = "db-subnet-rtable"
                        route_rules = merge(
                            (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
                                "INTERNET-RULE" = {
                                    network_entity_key = "TT-VCN-3-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                },
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-3-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = "all-services"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            } : {},  
                            local.tt_cross_vcn_3_drg_routing   
                        )
                    }
                },
                var.deploy_tt_vcn3_bastion_subnet == true ? {    
                    "TT-VCN-3-BASTION-SUBNET-ROUTE-TABLE" = {
                        display_name = "bastion-subnet-route-table"
                        route_rules = merge(
                            (local.chosen_hub_option != 3 && local.chosen_hub_option != 4) ? {
                                "INTERNET-RULE" = {
                                    network_entity_key = var.tt_vcn3_bastion_is_access_via_public_endpoint == false ? "TT-VCN-3-NAT-GATEWAY" : "TT-VCN-3-INTERNET-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                },
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-3-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = var.tt_vcn3_bastion_is_access_via_public_endpoint == false ? "all-services" : "objectstorage"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            } : {},
                            local.tt_cross_vcn_3_drg_routing   
                        )
                    }
                } : {}    
            ) # merge function
            
            network_security_groups = merge(
                {    
                    "TT-VCN-3-LBR-NSG" = {
                        display_name = "lbr-nsg"
                        ingress_rules = merge(
                            {
                                "INGRESS-FROM-ANYWHERE-HTTP-RULE" = {
                                    description  = "Ingress from 0.0.0.0/0 on HTTP port 443."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "0.0.0.0/0"
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 443
                                    dst_port_max = 443
                                }
                            },
                            var.deploy_tt_vcn3_bastion_subnet == true ? {    
                                "INGRESS-FROM-BASTION-NSG-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-3-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {},
                            local.vcn_3_to_web_subnet_cross_vcn_ingress    
                        ),
                        egress_rules = merge(
                            {
                                "EGRESS-TO-APP-RULE" = {
                                    description = "Egress to App NSG."
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "TT-VCN-3-APP-NSG"
                                    dst_type    = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            },
                            {    
                                "EGRESS-TO-OSN-RULE" = {
                                    description = "Egress to Oracle Services Network."
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "all-services"
                                    dst_type    = "SERVICE_CIDR_BLOCK"
                                    dst_port_min = 443
                                    dst_port_max = 443
                                }
                            },
                            local.vcn_3_to_hub_indoor_subnet_cross_vcn_egress,  
                            local.vcn_3_to_app_subnet_cross_vcn_egress    
                        )
                    }
                },
                {    
                    "TT-VCN-3-APP-NSG" = {
                        display_name = "app-nsg"
                        ingress_rules = merge(
                            {
                                "INGRESS-FROM-LBR-NSG-RULE" = {
                                    description  = "Ingress from LBR NSG"
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-3-LBR-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            },
                            var.deploy_tt_vcn3_bastion_subnet == true ? {    
                                "INGRESS-FROM-BASTION-NSG-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-3-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {},
                            local.vcn_3_to_app_subnet_cross_vcn_ingress    
                        ),  
                        egress_rules = merge(
                            {
                                "EGRESS-TO-DB-NSG-RULE" = {
                                    description = "Egress to DB NSG"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "TT-VCN-3-DB-NSG"
                                    dst_type    = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            },
                            {    
                                "EGRESS-TO-OSN-RULE" = {
                                    description = "Egress to Oracle Services Network."
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "all-services"
                                    dst_type    = "SERVICE_CIDR_BLOCK"
                                    dst_port_min = 443
                                    dst_port_max = 443
                                }
                            },
                            {
                                "EGRESS-TO-ALL" = { 
                                    description = "Egress to All." 
                                    stateless = false 
                                    protocol = "TCP" 
                                    dst = "0.0.0.0/0" 
                                    dst_type = "CIDR_BLOCK" 
                                    dst_port_min = null
                                    dst_port_max = null 
                                }
                            },
                            local.vcn_3_to_hub_indoor_subnet_cross_vcn_egress,    
                            local.vcn_3_to_web_subnet_cross_vcn_egress,
                            local.vcn_3_to_app_subnet_cross_vcn_egress,
                            local.vcn_3_to_db_subnet_cross_vcn_egress,
                            local.vcn_3_to_oke_cross_vcn_egress,
                            local.vcn_3_to_exa_cross_vcn_egress
                        )
                    }
                },
                {    
                    "TT-VCN-3-DB-NSG" = {
                        display_name = "db-nsg"
                        ingress_rules = merge(
                            {
                                "INGRESS-FROM-APP-RULE" = {
                                    description  = "Ingress from App NSG"
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-3-APP-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            },    
                            var.deploy_tt_vcn3_bastion_subnet == true ? {
                                "INGRESS-FROM-BASTION-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-3-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {},
                            local.vcn_3_to_db_subnet_cross_vcn_ingress    
                        ),  
                        egress_rules = merge(
                            {
                                "EGRESS-TO-OSN-RULE" = {
                                    description = "Egress to Oracle Services Network."
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "all-services"
                                    dst_type    = "SERVICE_CIDR_BLOCK"
                                    dst_port_min = 443
                                    dst_port_max = 443
                                }
                            },
                            local.vcn_3_to_hub_indoor_subnet_cross_vcn_egress,
                            local.vcn_3_to_web_subnet_cross_vcn_egress,
                            local.vcn_3_to_app_subnet_cross_vcn_egress,
                            local.vcn_3_to_db_subnet_cross_vcn_egress,
                            local.vcn_3_to_oke_cross_vcn_egress,
                            local.vcn_3_to_exa_cross_vcn_egress
                        )
                    }
                },
                var.deploy_tt_vcn3_bastion_subnet == true ? {
                    "TT-VCN-3-BASTION-NSG" = {
                        display_name = "bastion-nsg"
                        ingress_rules = { 
                            for cidr in var.tt_vcn3_bastion_subnet_allowed_cidrs : "INGRESS-FROM-${cidr}-RULE" => {
                                description  = "Ingress from ${cidr} on port 22."
                                stateless    = false
                                protocol     = "TCP"
                                src          = cidr
                                src_type     = "CIDR_BLOCK"
                                dst_port_min = 22
                                dst_port_max = 22
                            } if var.tt_vcn3_bastion_is_access_via_public_endpoint == true # Ingress rule only for jump hosts later deployed in the bastion public subnet.
                        },
                        egress_rules = merge(
                            {
                                "EGRESS-TO-LBR-RULE" = {
                                    description = "Egress to LBR NSG."
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "TT-VCN-3-LBR-NSG"
                                    dst_type    = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            },
                            {    
                                "EGRESS-TO-APP-RULE" = {
                                    description = "Egress to App NSG."
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "TT-VCN-3-APP-NSG"
                                    dst_type    = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            },  
                            {  
                                "EGRESS-TO-DB-RULE" = {
                                    description = "Egress to DB NSG."
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "TT-VCN-3-DB-NSG"
                                    dst_type    = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            },
                            {    
                                "EGRESS-TO-OSN-RULE" = {
                                    description = "Egress to Oracle Services Network."
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "all-services"
                                    dst_type    = "SERVICE_CIDR_BLOCK"
                                    dst_port_min = 443
                                    dst_port_max = 443
                                }
                            },
                            {for cidr in var.tt_vcn3_bastion_subnet_allowed_cidrs : "EGRESS-TO-${cidr}-RULE" => {
                                    description  = "Egress to ${cidr}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    dst          = cidr
                                    dst_type     = "CIDR_BLOCK"
                                } if var.tt_vcn3_bastion_is_access_via_public_endpoint == true
                            } # Ingress rule only for jump hosts later deployed in the bastion public subnet.
                        ) # inner merge function    
                   }
                } : {}    
            ) # merge function

            vcn_specific_gateways = {
                internet_gateways = {
                    "TT-VCN-3-INTERNET-GATEWAY" = {
                        enabled      = true
                        display_name = "Internet Gateway"
                    }
                }
                nat_gateways = {
                    "TT-VCN-3-NAT-GATEWAY" = {
                        block_traffic = false
                        display_name  = "NAT Gateway"
                    }
                }
                service_gateways = {
                    "TT-VCN-3-SERVICE-GATEWAY" = {
                        display_name = "Service Gateway"
                        services = "all-services"
                    }
                }
            }
        }
    } : {}

    ## VCN routing thru DRG is dependent on some factors:
    ## 1) If there's a Hub VCN (3 or 4), the route to DRG is always enabled, because the Firewall in the Hub VCN will constrain traffic appropriately.
    ## 2) If there's no Hub VCN (1 or 2), the route to DRG is enabled by default or if explicitly configured via the 'tt_vcn1_routable_vcns' attribute.
    ## Explicitly setting 'tt_vcn3_routable_vcns' constrains routing to provided VCNs only.
    tt_cross_vcn_3_drg_routing = merge(
        ## Route to HUB-VCN
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && local.hub_with_vcn == true) ? { 
            "DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to TT-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")))) ? { 
            for cidr in var.tt_vcn1_cidrs : "TT-VCN-1-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to TT-VCN-2                    
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")))) ? {
            for cidr in var.tt_vcn2_cidrs : "TT-VCN-2-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to OKE-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"OKE-VCN-1")))) ? { 
            for cidr in var.oke_vcn1_cidrs : "OKE-VCN-1-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to OKE-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"OKE-VCN-2")))) ? { 
            for cidr in var.oke_vcn2_cidrs : "OKE-VCN-2-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to OKE-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"OKE-VCN-3")))) ? { 
            for cidr in var.oke_vcn3_cidrs : "OKE-VCN-3-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to EXA-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"EXA-VCN-1")))) ? { 
            for cidr in var.exa_vcn1_cidrs : "EXA-VCN-1-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to EXA-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"EXA-VCN-2")))) ? { 
            for cidr in var.exa_vcn2_cidrs : "EXA-VCN-2-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to EXA-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"EXA-VCN-3")))) ? { 
            for cidr in var.exa_vcn3_cidrs : "EXA-VCN-3-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "To DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {},
        ## Route to on-premises CIDRs
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && length(var.onprem_cidrs) > 0) &&
        (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? {
            for cidr in var.onprem_cidrs : "ONPREM-${replace(replace(cidr,".",""),"/","")}-RULE" => {
                network_entity_key = "HUB-DRG"
                description        = "Traffic destined to on-premises ${cidr} CIDR range goes to DRG."
                destination        = cidr
                destination_type   = "CIDR_BLOCK"
            }
        } : {}
    )

    #### Cross VCN NSG Rules
    ### TT-VCN-3:
    ## Egress Rules
    ## These rules are subject to the same conditions as the routing for TT-VCN-2, also expressed in tt_vcn_2_drg_routing variable.
    
    ## Egress to Hub-VCN indoor subnet
    vcn_3_to_hub_indoor_subnet_cross_vcn_egress = merge(
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true &&
        local.hub_with_vcn == true) ? {
            "EGRESS-TO-HUB-VCN-INDOOR-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.hub_vcn_indoor_subnet_name, "${var.service_label}-hub-vcn-indoor-subnet")}."
                stateless   = false
                protocol    = "ALL"
                dst         = coalesce(var.hub_vcn_indoor_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 2, 2))
                dst_type    = "CIDR_BLOCK"
            }
        } : {}
    )
    ## Egress to VCN-1 and VCN-2 web subnet
    vcn_3_to_web_subnet_cross_vcn_egress = merge(
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")))) ? {
            "EGRESS-TO-VCN-1-WEB-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.tt_vcn1_web_subnet_name,"${var.service_label}-three-tier-vcn-1-web-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.tt_vcn1_web_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,0))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
            }
        } : {},    
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")))) ? {
            "EGRESS-TO-VCN-2-WEB-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.tt_vcn2_web_subnet_name,"${var.service_label}-three-tier-vcn-2-web-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.tt_vcn2_web_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,0))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
            }
        } : {}   
    )
    ## Egress to VCN-1 and VCN-2 app subnet
    vcn_3_to_app_subnet_cross_vcn_egress = merge(
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")))) ? {
            "EGRESS-TO-VCN-1-APP-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 80
                dst_port_max = 80
            }
        } : {},    
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")))) ? {
            "EGRESS-TO-VCN-2-APP-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 80
                dst_port_max = 80
            }
        } : {}   
    )
    ## Egress to VCN-1 and VCN-2 db subnet
    vcn_3_to_db_subnet_cross_vcn_egress = merge(
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")))) ? {
            "EGRESS-TO-VCN-1-DB-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.tt_vcn1_db_subnet_name,"${var.service_label}-three-tier-vcn-1-db-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            }
        } : {},    
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")))) ? {
            "EGRESS-TO-VCN-2-DB-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.tt_vcn2_db_subnet_name,"${var.service_label}-three-tier-vcn-2-db-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            }
        } : {}   
    )  
    ## Egress to OKE-VCNs:
    vcn_3_to_oke_cross_vcn_egress = merge(
        ## Egress to OKE-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"OKE-VCN-1")))) ? merge(
            {
                "EGRESS-TO-OKE-VCN-1-SERVICES-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn1_services_subnet_name,"${var.service_label}-oke-vcn-1-services-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn1_services_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 2))
                    dst_type    = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                },
                "EGRESS-TO-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn1_workers_subnet_name,"${var.service_label}-oke-vcn-1-workers-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
                    dst_type    = "CIDR_BLOCK"
                    dst_port_min = 30000
                    dst_port_max = 32767
                }
            },    
            upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "EGRESS-TO-OKE-VCN-1-PODS-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn1_pods_subnet_name,"${var.service_label}-oke-vcn-1-pods-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn1_pods_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 3, 1))
                    dst_type    = "CIDR_BLOCK"
                }
            } : {}
        ) : {},
        ## Egress to OKE-VCN-2 
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"OKE-VCN-2")))) ? merge(
            {
                "EGRESS-TO-OKE-VCN-2-SERVICES-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn2_services_subnet_name,"${var.service_label}-oke-vcn-2-services-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn2_services_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 2))
                    dst_type    = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                },
                "EGRESS-TO-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn2_workers_subnet_name,"${var.service_label}-oke-vcn-2-workers-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
                    dst_type    = "CIDR_BLOCK"
                    dst_port_min = 30000
                    dst_port_max = 32767
                }
            },    
            upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "EGRESS-TO-OKE-VCN-2-PODS-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn2_pods_subnet_name,"${var.service_label}-oke-vcn-2-pods-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))
                    dst_type    = "CIDR_BLOCK"
                }
            } : {}
        ) : {},
        ## Egress to OKE-VCN-3 
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"OKE-VCN-3")))) ? merge(
            {
                "EGRESS-TO-OKE-VCN-3-SERVICES-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn3_services_subnet_name,"${var.service_label}-oke-vcn-3-services-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn3_services_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 2))
                    dst_type    = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                },
                "EGRESS-TO-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn3_workers_subnet_name,"${var.service_label}-oke-vcn-3-workers-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
                    dst_type    = "CIDR_BLOCK"
                    dst_port_min = 30000
                    dst_port_max = 32767
                }
            },    
            upper(var.oke_vcn3_cni_type) == "NATIVE" ? {
                "EGRESS-TO-OKE-VCN-3-PODS-SUBNET-RULE" = {
                    description = "Egress to ${coalesce(var.oke_vcn3_pods_subnet_name,"${var.service_label}-oke-vcn-3-pods-subnet")}."
                    stateless   = false
                    protocol    = "TCP"
                    dst         = coalesce(var.oke_vcn3_pods_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 3, 1))
                    dst_type    = "CIDR_BLOCK"
                }
            } : {}
        ) : {}
    )
    ## Egress to EXA-VCNs
    vcn_3_to_exa_cross_vcn_egress = merge(
        ## Egress to EXA-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"EXA-VCN-1")))) ? {
            "EGRESS-TO-EXA-VCN-1-CLIENT-SUBNET-RULE" = { 
                description = "Egress to ${coalesce(var.exa_vcn1_client_subnet_name, "${var.service_label}-exadata-vcn-1-client-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            }
        } : {},
        ## Egress to EXA-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"EXA-VCN-2")))) ? {
            "EGRESS-TO-EXA-VCN-2-CLIENT-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.exa_vcn2_client_subnet_name, "${var.service_label}-exadata-vcn-2-client-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            }
        } : {},
        ## Egress to EXA-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"EXA-VCN-3")))) ? {
            "EGRESS-TO-EXA-VCN-3-CLIENT-SUBNET-RULE" = {
                description = "Egress to ${coalesce(var.exa_vcn3_client_subnet_name, "${var.service_label}-exadata-vcn-3-client-subnet")}."
                stateless   = false
                protocol    = "TCP"
                dst         = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
                dst_type    = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            }
        } : {}
    )

    ## Ingress rules into TT-VCN-3 web subnet
    vcn_3_to_web_subnet_cross_vcn_ingress = merge(
        ## Ingress from TT-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")))) ? {
            "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
            },
            "INGRESS-FROM-TT-VCN-1-DB-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn1_db_subnet_name,"${var.service_label}-three-tier-vcn-1-db-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
            }
        } : {},
        ## Ingress from TT-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")))) ? {   
            "INGRESS-FROM-TT-VCN-2-APP-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
            },
            "INGRESS-FROM-TT-VCN-2-DB-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn2_db_subnet_name,"${var.service_label}-three-tier-vcn-2-db-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
            }
        } : {},
        ## Ingress from OKE-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn1_workers_subnet_name,"${var.service_label}-oke-vcn-1-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            },    
            upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-1-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn1_pods_subnet_name,"${var.service_label}-oke-vcn-1-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn1_pods_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            } : {} 
        ) : {},
        ## Ingress from OKE-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn2_workers_subnet_name,"${var.service_label}-oke-vcn-2-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            },    
            upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-2-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn2_pods_subnet_name,"${var.service_label}-oke-vcn-2-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            } : {} 
        ) : {},
        ## Ingress from OKE-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn3_workers_subnet_name,"${var.service_label}-oke-vcn-3-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            },    
            upper(var.oke_vcn3_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-3-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn3_pods_subnet_name,"${var.service_label}-oke-vcn-3-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn3_pods_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            } : {} 
        ) : {}, 
        ## Ingress from EXA-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-1-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn1_client_subnet_name,"${var.service_label}-exa-vcn-1-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            } 
        ) : {},
        ## Ingress from EXA-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-2-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn2_client_subnet_name,"${var.service_label}-exa-vcn-2-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            } 
        ) : {},
        ## Ingress from EXA-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-3-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn3_client_subnet_name,"${var.service_label}-exa-vcn-3-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
                }
            } 
        ) : {},
        ## Ingress from on-premises CIDRs into TT-VCN-3 web subnet
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && length(var.onprem_cidrs) > 0) &&
        (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? {
            for cidr in var.onprem_cidrs : "INGRESS-FROM-ONPREM--${replace(replace(cidr,".",""),"/","")}-RULE" => {
                    description  = "Ingress from onprem ${cidr}"
                    stateless    = false
                    protocol     = "TCP"
                    src          = cidr
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 443
                    dst_port_max = 443
            }
        } : {}
    )
     ## Ingress rules into TT-VCN-3 app subnet
    vcn_3_to_app_subnet_cross_vcn_ingress = merge(
        ## Ingress from TT-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")))) ? {
            "INGRESS-FROM-TT-VCN-1-WEB-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn1_web_subnet_name,"${var.service_label}-three-tier-vcn-1-web-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn1_web_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,0))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 80
                dst_port_max = 80
            },
            "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 80
                dst_port_max = 80
            },
            "INGRESS-FROM-TT-VCN-1-DB-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn1_db_subnet_name,"${var.service_label}-three-tier-vcn-1-db-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 80
                dst_port_max = 80
            }
        } : {},
        ## Ingress from TT-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")))) ? {
            "INGRESS-FROM-TT-VCN-2-WEB-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn2_web_subnet_name,"${var.service_label}-three-tier-vcn-2-web-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn2_web_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,0))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 80
                dst_port_max = 80
            },
            "INGRESS-FROM-TT-VCN-2-APP-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 80
                dst_port_max = 80
            },
            "INGRESS-FROM-TT-VCN-2-DB-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn2_db_subnet_name,"${var.service_label}-three-tier-vcn-2-db-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 80
                dst_port_max = 80
            }
        } : {},
        ## Ingress from OKE-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn1_workers_subnet_name,"${var.service_label}-oke-vcn-1-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            },    
            upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-1-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn1_pods_subnet_name,"${var.service_label}-oke-vcn-1-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn1_pods_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            } : {} 
        ) : {},
        ## Ingress from OKE-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn2_workers_subnet_name,"${var.service_label}-oke-vcn-2-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            },    
            upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-2-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn2_pods_subnet_name,"${var.service_label}-oke-vcn-2-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            } : {} 
        ) : {},
        ## Ingress from OKE-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn3_workers_subnet_name,"${var.service_label}-oke-vcn-3-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            },    
            upper(var.oke_vcn3_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-3-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn3_pods_subnet_name,"${var.service_label}-oke-vcn-3-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn3_pods_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            } : {} 
        ) : {},
        ## Ingress from EXA-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-1-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn1_client_subnet_name,"${var.service_label}-exa-vcn-1-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            } 
        ) : {},
        ## Ingress from EXA-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-2-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn2_client_subnet_name,"${var.service_label}-exa-vcn-2-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            } 
        ) : {},
        ## Ingress from EXA-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-3-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn3_client_subnet_name,"${var.service_label}-exa-vcn-3-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
                }
            } 
        ) : {},
        ## Ingress from on-premises CIDRs into TT-VCN-3 app subnet
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && length(var.onprem_cidrs) > 0) &&
        (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? {
            for cidr in var.onprem_cidrs : "INGRESS-FROM-ONPREM--${replace(replace(cidr,".",""),"/","")}-RULE" => {
                    description  = "Ingress from onprem ${cidr}"
                    stateless    = false
                    protocol     = "TCP"
                    src          = cidr
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 80
                    dst_port_max = 80
            }
        } : {}
    )
     ## Ingress rules into TT-VCN-3 db subnet
    vcn_3_to_db_subnet_cross_vcn_ingress = merge(
        ## Ingress from TT-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")))) ? {
            "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            },
            "INGRESS-FROM-TT-VCN-1-DB-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn1_db_subnet_name,"${var.service_label}-three-tier-vcn-1-db-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            }
        } : {},
        ## Ingress from TT-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")))) ? {
            "INGRESS-FROM-TT-VCN-2-APP-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            },
            "INGRESS-FROM-TT-VCN-2-DB-SUBNET-RULE" = {
                description  = "Ingress from ${coalesce(var.tt_vcn2_db_subnet_name,"${var.service_label}-three-tier-vcn-2-db-subnet")}."
                stateless    = false
                protocol     = "TCP"
                src          = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                src_type     = "CIDR_BLOCK"
                dst_port_min = 1521
                dst_port_max = 1522
            }
        } : {},
        ## Ingress from OKE-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn1_routable_vcns) == 0 || contains(var.oke_vcn1_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn1_workers_subnet_name,"${var.service_label}-oke-vcn-1-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn1_workers_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            },    
            upper(var.oke_vcn1_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-1-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn1_pods_subnet_name,"${var.service_label}-oke-vcn-1-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn1_pods_subnet_cidr, cidrsubnet(var.oke_vcn1_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            } : {} 
        ) : {},
        ## Ingress from OKE-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-2-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn2_workers_subnet_name,"${var.service_label}-oke-vcn-2-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            },    
            upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-2-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn2_pods_subnet_name,"${var.service_label}-oke-vcn-2-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            } : {} 
        ) : {},
        ## Ingress from OKE-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn3_routable_vcns) == 0 || contains(var.oke_vcn3_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn3_workers_subnet_name,"${var.service_label}-oke-vcn-3-workers-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn3_workers_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 8, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            },    
            upper(var.oke_vcn3_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-OKE-VCN-3-PODS-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.oke_vcn3_pods_subnet_name,"${var.service_label}-oke-vcn-3-pods-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.oke_vcn3_pods_subnet_cidr, cidrsubnet(var.oke_vcn3_cidrs[0], 3, 1))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            } : {} 
        ) : {},
        ## Ingress from EXA-VCN-1
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn1_routable_vcns) == 0 || contains(var.exa_vcn1_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-1-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn1_client_subnet_name,"${var.service_label}-exa-vcn-1-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            } 
        ) : {},
        ## Ingress from EXA-VCN-2
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn2_routable_vcns) == 0 || contains(var.exa_vcn2_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-2-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn2_client_subnet_name,"${var.service_label}-exa-vcn-2-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            } 
        ) : {},
        ## Ingress from EXA-VCN-3
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
        (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.exa_vcn3_routable_vcns) == 0 || contains(var.exa_vcn3_routable_vcns,"TT-VCN-3")))) ? merge(
            {
                "INGRESS-FROM-EXA-VCN-3-CLIENT-SUBNET-RULE" = {
                    description  = "Ingress from ${coalesce(var.exa_vcn3_client_subnet_name,"${var.service_label}-exa-vcn-3-client-subnet")}."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
                }
            } 
        ) : {},
        ## Ingress from on-premises CIDRs into TT-VCN-3 db subnet
        (local.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && length(var.onprem_cidrs) > 0) &&
        (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? {
            for cidr in var.onprem_cidrs : "INGRESS-FROM-ONPREM--${replace(replace(cidr,".",""),"/","")}-RULE" => {
                    description  = "Ingress from onprem ${cidr}"
                    stateless    = false
                    protocol     = "TCP"
                    src          = cidr
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 1521
                    dst_port_max = 1522
            }
        } : {}
    )
}