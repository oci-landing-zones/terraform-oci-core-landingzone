# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

    tt_vcn_1 = var.add_tt_vcn1 == true ? {
        "TT-VCN-1" = {
            display_name                     = coalesce(var.tt_vcn1_name,"${var.service_label}-three-tier-vcn-1")
            is_ipv6enabled                   = false
            is_oracle_gua_allocation_enabled = false
            cidr_blocks                      = var.tt_vcn1_cidrs,
            dns_label                        = replace(coalesce(var.tt_vcn1_dns,"${var.service_label}-three-tier-vcn-1"),"-","")
            block_nat_traffic                = false

            subnets = merge(
                {
                    "TT-VCN-1-WEB-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn1_web_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,0))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn1_web_subnet_name,"${var.service_label}-three-tier-vcn-1-web-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn1_web_subnet_dns,"web-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = var.tt_vcn1_web_subnet_is_private
                        prohibit_public_ip_on_vnic = var.tt_vcn1_web_subnet_is_private
                        route_table_key            = "TT-VCN-1-WEB-SUBNET-ROUTE-TABLE"
                    }
                },
                {    
                    "TT-VCN-1-APP-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn1_app_subnet_dns,"app-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = true
                        prohibit_public_ip_on_vnic = true
                        route_table_key            = "TT-VCN-1-APP-SUBNET-ROUTE-TABLE"
                    }
                },
                {    
                    "TT-VCN-1-DB-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn1_db_subnet_name,"${var.service_label}-three-tier-vcn-1-db-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn1_db_subnet_dns,"db-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = true
                        prohibit_public_ip_on_vnic = true
                        route_table_key            = "TT-VCN-1-DB-SUBNET-ROUTE-TABLE"
                    }
                },
                var.deploy_tt_vcn1_bastion_subnet == true ? {    
                    "TT-VCN-1-BASTION-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn1_bastion_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],9,96))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn1_bastion_subnet_name,"${var.service_label}-three-tier-vcn-1-bastion-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn1_bastion_subnet_dns,"bastion-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = var.tt_vcn1_bastion_is_access_via_public_endpoint == true ? false : true
                        prohibit_public_ip_on_vnic = var.tt_vcn1_bastion_is_access_via_public_endpoint == true ? false : true
                        route_table_key            = "TT-VCN-1-BASTION-SUBNET-ROUTE-TABLE"
                        security_list_key          = var.tt_vcn1_bastion_is_access_via_public_endpoint == false ? "TT-VCN-1-BASTION-SUBNET-SL" : null
                    }
                } : {}    
            ) # merge function

            security_lists = var.deploy_tt_vcn1_bastion_subnet == true && var.tt_vcn1_bastion_is_access_via_public_endpoint == false ? { # The bastion subnet security list is only applicable to Bastion service endpoints, which are private.
              "TT-VCN-1-BASTION-SUBNET-SL" = {
                display_name = "${coalesce(var.tt_vcn1_bastion_subnet_name,"${var.service_label}-three-tier-vcn-1-bastion-subnet")}-security-list"
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
                    description  = "Ingress from ${coalesce(var.tt_vcn1_bastion_subnet_name,"${var.service_label}-three-tier-vcn-1-bastion-subnet")} on SSH port. Required for connecting Bastion service endpoint to Bastion host."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.tt_vcn1_bastion_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],9,96))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 22
                    dst_port_max = 22
                  }
                ]
                egress_rules = [
                  {
                    description  = "Egress to ${coalesce(var.tt_vcn1_bastion_subnet_name,"${var.service_label}-three-tier-vcn-1-bastion-subnet")} on SSH port. Required for connecting Bastion service endpoint to Bastion host."
                    stateless    = false
                    protocol     = "TCP"
                    dst          = coalesce(var.tt_vcn1_bastion_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],9,96))
                    dst_type     = "CIDR_BLOCK"
                    dst_port_min = 22
                    dst_port_max = 22
                  }
                ]
              }
            } : null

            route_tables = merge(
                {
                    "TT-VCN-1-WEB-SUBNET-ROUTE-TABLE" = {
                        display_name = "web-subnet-route-table"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = var.tt_vcn1_web_subnet_is_private == false ? "TT-VCN-1-INTERNET-GATEWAY" : "TT-VCN-1-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            }, 
                            {   
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                                    description        = "To Service Gateway."
                                    destination        = "objectstorage"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            }
                        )
                    }   
                },
                {     
                    "TT-VCN-1-APP-SUBNET-ROUTE-TABLE" = {
                        display_name = "app-subnet-route-table"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = "TT-VCN-1-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = "all-services"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            },  
                            ## For App subnet route table, we route to App subnet in the routable VCN. Routes thru DRG are dependent on some factors. See the if clause.
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-2")) ? {
                                "tt-VCN-2-APP-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {},  
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")) ? {
                                "tt-VCN-3-APP-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,1))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {}  
                        )
                    }
                },
                {    
                    "TT-VCN-1-DB-SUBNET-ROUTE-TABLE" = {
                        display_name = "db-subnet-route-table"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = "TT-VCN-1-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = "all-services"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            },  
                            ## For DB subnet route table, we route to DB subnet in the routable VCN. Routes thru DRG are dependent on some factors. See the if clause.
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-2")) ? {
                                "tt-VCN-2-DB-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {},  
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")) ? {
                                "tt-VCN-3-DB-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,2))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {}  
                        )
                    }
                },
                var.deploy_tt_vcn1_bastion_subnet == true ? {    
                    "TT-VCN-1-BASTION-SUBNET-ROUTE-TABLE" = {
                        display_name = "bastion-subnet-route-table"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = var.tt_vcn1_bastion_is_access_via_public_endpoint == false ? "TT-VCN-1-NAT-GATEWAY" : "TT-VCN-1-INTERNET-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-1-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = var.tt_vcn1_bastion_is_access_via_public_endpoint == false ? "all-services" : "objectstorage"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            }  
                        )
                    }
                } : {}    
            ) # merge function
            
            network_security_groups = merge(
                {    
                    "TT-VCN-1-LBR-NSG" = {
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
                            var.deploy_tt_vcn1_bastion_subnet == true ? {    
                                "INGRESS-FROM-BASTION-NSG-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-1-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {}    
                        ),
                        egress_rules = {
                            "EGRESS-TO-APP-NSG-RULE" = {
                                description = "Egress to App NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-1-APP-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 80
                                dst_port_max = 80
                            },
                            "EGRESS-TO-OSN-RULE" = {
                                description = "Egress to Oracle Services Network."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "all-services"
                                dst_type    = "SERVICE_CIDR_BLOCK"
                                dst_port_min = 443
                                dst_port_max = 443
                            }
                        }
                    }
                },
                {    
                    "TT-VCN-1-APP-NSG" = {
                        display_name = "app-nsg"
                        ingress_rules = merge(
                            {
                                "INGRESS-FROM-LBR-NSG-RULE" = {
                                    description  = "Ingress from LBR NSG"
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-1-LBR-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            },
                            var.deploy_tt_vcn1_bastion_subnet == true ? {    
                                "INGRESS-FROM-BASTION-NSG-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-1-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-1")) ? {
                                "INGRESS-FROM-TT-VCN-2-APP-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")) ? {
                                "INGRESS-FROM-TT-VCN-3-APP-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn3_app_subnet_name,"${var.service_label}-three-tier-vcn-3-app-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,1))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {}     
                        )  
                        egress_rules = merge(
                            {
                                "EGRESS-TO-DB-NSG-RULE" = {
                                    description = "Egress to DB NSG"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "TT-VCN-1-DB-NSG"
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-2")) ? 
                            {  
                                "EGRESS-TO-TT-VCN-2-APP-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")) ?
                            {   
                                "EGRESS-TO-TT-VCN-3-APP-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn3_app_subnet_name,"${var.service_label}-three-tier-vcn-3-app-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,1))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {}
                        )
                    }
                },
                {    
                    "TT-VCN-1-DB-NSG" = {
                        display_name = "db-nsg"
                        ingress_rules = merge(
                            {
                                "INGRESS-FROM-APP-NSG-RULE" = {
                                    description  = "Ingress from App NSG"
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-1-APP-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            },
                            var.deploy_tt_vcn1_bastion_subnet == true ? {    
                                "INGRESS-FROM-BASTION-NSG-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-1-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-1")) ? {
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")) ? {
                                "INGRESS-FROM-TT-VCN-3-DB-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn3_db_subnet_name,"${var.service_label}-three-tier-vcn-3-db-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,2))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {}    
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-2")) ? 
                            {  
                                "EGRESS-TO-TT-VCN-2-DB-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn2_db_subnet_name,"${var.service_label}-three-tier-vcn-2-db-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn1_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")) ?
                            {   
                                "EGRESS-TO-TT-VCN-3-DB-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn3_db_subnet_name,"${var.service_label}-three-tier-vcn-3-db-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,2))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {}
                        )    
                    }
                },
                var.deploy_tt_vcn1_bastion_subnet == true ? {
                    "TT-VCN-1-BASTION-NSG" = {
                        display_name = "bastion-nsg"
                        ingress_rules = { 
                            for cidr in var.tt_vcn1_bastion_subnet_allowed_cidrs : "INGRESS-FROM-${cidr}-RULE" => {
                                description  = "Ingress from ${cidr} on port 22."
                                stateless    = false
                                protocol     = "TCP"
                                src          = cidr
                                src_type     = "CIDR_BLOCK"
                                dst_port_min = 22
                                dst_port_max = 22
                            } if var.tt_vcn1_bastion_is_access_via_public_endpoint == true # Ingress rule only for jump hosts later deployed in the bastion public subnet.
                        }    
                        egress_rules = {
                            "EGRESS-TO-LBR-NSG-RULE" = {
                                description = "Egress to LBR NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-1-LBR-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-APP-NSG-RULE" = {
                                description = "Egress to App NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-1-APP-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-DB-NSG-RULE" = {
                                description = "Egress to DB NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-1-DB-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-OSN-RULE" = {
                                description = "Egress to Oracle Services Network."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "all-services"
                                dst_type    = "SERVICE_CIDR_BLOCK"
                                dst_port_min = 443
                                dst_port_max = 443
                            }
                        }
                    }
                } : {}    
            ) # merge function
            
            vcn_specific_gateways = {
                internet_gateways = {
                    "TT-VCN-1-INTERNET-GATEWAY" = {
                        enabled      = true
                        display_name = "internet-gateway"
                    }
                }
                nat_gateways = {
                    "TT-VCN-1-NAT-GATEWAY" = {
                        block_traffic = false
                        display_name  = "nat-gateway"
                    }
                }
                service_gateways = {
                    "TT-VCN-1-SERVICE-GATEWAY" = {
                        display_name = "service-gateway"
                        services = "all-services"
                    }
                }
            }
        }   
    } : {}  

    tt_vcn_2 = var.add_tt_vcn2 == true ? {
        "TT-VCN-2" = {
            display_name                     = coalesce(var.tt_vcn2_name,"${var.service_label}-three-tier-vcn-2")
            is_ipv6enabled                   = false
            is_oracle_gua_allocation_enabled = false
            cidr_blocks                      = var.tt_vcn2_cidrs,
            dns_label                        = replace(coalesce(var.tt_vcn2_dns,"${var.service_label}-three-tier-vcn-2"),"-","")
            block_nat_traffic                = false

            subnets = merge(
                {
                    "TT-VCN-2-WEB-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn2_web_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,0))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn2_web_subnet_name,"${var.service_label}-three-tier-vcn-2-web-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn2_web_subnet_dns,"web-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = var.tt_vcn2_web_subnet_is_private
                        prohibit_public_ip_on_vnic = var.tt_vcn2_web_subnet_is_private
                        route_table_key            = "TT-VCN-2-WEB-SUBNET-ROUTE-TABLE"
                    }
                },    
                {    
                    "TT-VCN-2-APP-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn2_app_subnet_dns,"app-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = true
                        prohibit_public_ip_on_vnic = true
                        route_table_key            = "TT-VCN-2-APP-SUBNET-ROUTE-TABLE"
                    }
                },
                {    
                    "TT-VCN-2-DB-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn2_db_subnet_name,"${var.service_label}-three-tier-vcn-2-db-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn2_db_subnet_dns,"db-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = true
                        prohibit_public_ip_on_vnic = true
                        route_table_key            = "TT-VCN-2-DB-SUBNET-ROUTE-TABLE"
                    }
                },
                var.deploy_tt_vcn2_bastion_subnet == true ? {    
                    "TT-VCN-2-BASTION-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn2_bastion_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],9,96))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn2_bastion_subnet_name,"${var.service_label}-three-tier-vcn-2-bastion-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn2_bastion_subnet_dns,"bastion-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = var.tt_vcn2_bastion_is_access_via_public_endpoint == true ? false : true
                        prohibit_public_ip_on_vnic = var.tt_vcn2_bastion_is_access_via_public_endpoint == true ? false : true
                        route_table_key            = "TT-VCN-2-BASTION-SUBNET-ROUTE-TABLE"
                        security_list_key          = var.tt_vcn2_bastion_is_access_via_public_endpoint == false ? "TT-VCN-2-BASTION-SUBNET-SL" : null
                    }
                } : {}    
            ) # merge function    

            security_lists = var.deploy_tt_vcn2_bastion_subnet == true && var.tt_vcn2_bastion_is_access_via_public_endpoint == false ? { # The bastion subnet security list is only applicable to Bastion service endpoints, which are private.
              "TT-VCN-2-BASTION-SUBNET-SL" = {
                display_name = "${coalesce(var.tt_vcn2_bastion_subnet_name,"${var.service_label}-three-tier-vcn-2-bastion-subnet")}-security-list"
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
                    description  = "Ingress from ${coalesce(var.tt_vcn2_bastion_subnet_name,"${var.service_label}-three-tier-vcn-2-bastion-subnet")} on SSH port. Required for connecting Bastion service endpoint to Bastion host."
                    stateless    = false
                    protocol     = "TCP"
                    src          = coalesce(var.tt_vcn2_bastion_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],9,96))
                    src_type     = "CIDR_BLOCK"
                    dst_port_min = 22
                    dst_port_max = 22
                  }
                ]
                egress_rules = [
                  {
                    description  = "Egress to ${coalesce(var.tt_vcn2_bastion_subnet_name,"${var.service_label}-three-tier-vcn-2-bastion-subnet")} on SSH port. Required for connecting Bastion service endpoint to Bastion host."
                    stateless    = false
                    protocol     = "TCP"
                    dst          = coalesce(var.tt_vcn2_bastion_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],9,96))
                    dst_type     = "CIDR_BLOCK"
                    dst_port_min = 22
                    dst_port_max = 22
                  }
                ]
              }
            } : null

            route_tables = merge(
                {
                    "TT-VCN-2-WEB-SUBNET-ROUTE-TABLE" = {
                        display_name = "web-subnet-rtable"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = var.tt_vcn2_web_subnet_is_private == false ? "TT-VCN-2-INTERNET-GATEWAY" : "TT-VCN-2-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            }, 
                            {   
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-2-SERVICE-GATEWAY"
                                    description        = "To Service Gateway."
                                    destination        = "objectstorage"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            }
                        )
                    }  
                },
                {      
                    "TT-VCN-2-APP-SUBNET-ROUTE-TABLE" = {
                        display_name = "app-subnet-rtable"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = "TT-VCN-2-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-2-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = "all-services"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            },  
                            ## For App subnet route table, we route to App subnet in the routable VCN. Routes thru DRG are dependent on some factors. See the if clause.
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-1")) ? {
                                "tt-VCN-2-APP-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {},  
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")) ? {
                                "tt-VCN-3-APP-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,1))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {}   
                        )
                    }
                },
                {    
                    "TT-VCN-2-DB-SUBNET-ROUTE-TABLE" = {
                        display_name = "db-subnet-rtable"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = "TT-VCN-2-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-2-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = "all-services"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            },  
                            ## For DB subnet route table, we route to DB subnet in the routable VCN. Routes thru DRG are dependent on some factors. See the if clause.
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-1")) ? {
                                "tt-VCN-2-DB-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {},  
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")) ? {
                                "tt-VCN-3-DB-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,2))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {}  
                        )
                    }
                },
                var.deploy_tt_vcn2_bastion_subnet == true ? {    
                    "TT-VCN-2-BASTION-SUBNET-ROUTE-TABLE" = {
                        display_name = "bastion-subnet-route-table"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = var.tt_vcn2_bastion_is_access_via_public_endpoint == false ? "TT-VCN-2-NAT-GATEWAY" : "TT-VCN-2-INTERNET-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-2-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = var.tt_vcn2_bastion_is_access_via_public_endpoint == false ? "all-services" : "objectstorage"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            }  
                        )
                    }
                } : {}   
            ) # merge function

            network_security_groups = merge(
                {
                    "TT-VCN-2-LBR-NSG" = {
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
                            var.deploy_tt_vcn2_bastion_subnet == true ? {  
                                "INGRESS-FROM-BASTION-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-2-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {}    
                        ),
                        egress_rules = {
                            "EGRESS-TO-APP-RULE" = {
                                description = "Egress to App NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-2-APP-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 80
                                dst_port_max = 80
                            },
                            "EGRESS-TO-OSN-RULE" = {
                                description = "Egress to Oracle Services Network."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "all-services"
                                dst_type    = "SERVICE_CIDR_BLOCK"
                                dst_port_min = 443
                                dst_port_max = 443
                            }
                        }
                    }
                },
                {    
                    "TT-VCN-2-APP-NSG" = {
                        display_name = "app-nsg"
                        ingress_rules = merge(
                            {
                                "INGRESS-FROM-LBR-RULE" = {
                                    description  = "Ingress from LBR NSG"
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-2-LBR-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            },    
                            var.deploy_tt_vcn2_bastion_subnet == true ? {
                                "INGRESS-FROM-BASTION-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-2-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn3 && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-2")) ? {
                                "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn3 && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")) ? {
                                "INGRESS-FROM-TT-VCN-3-APP-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn3_app_subnet_name,"${var.service_label}-three-tier-vcn-3-app-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,1))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {}   
                        ),
                        egress_rules = merge(
                            {
                                "EGRESS-TO-DB-NSG-RULE" = {
                                    description = "Egress to DB NSG"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = "TT-VCN-2-DB-NSG"
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-1")) ? 
                            {  
                                "EGRESS-TO-TT-VCN-2-APP-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")) ?
                            {   
                                "EGRESS-TO-TT-VCN-3-APP-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn3_app_subnet_name,"${var.service_label}-three-tier-vcn-3-app-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,1))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {}
                        )
                    }
                },
                {    
                    "TT-VCN-2-DB-NSG" = {
                        display_name = "db-nsg"
                        ingress_rules = merge(
                            {
                                "INGRESS-FROM-APP-RULE" = {
                                    description  = "Ingress from App NSG"
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-2-APP-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            },    
                            var.deploy_tt_vcn2_bastion_subnet == true ? {
                                "INGRESS-FROM-BASTION-RULE" = {
                                    description  = "Ingress from Bastion NSG."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = "TT-VCN-2-BASTION-NSG"
                                    src_type     = "NETWORK_SECURITY_GROUP"
                                    dst_port_min = 22
                                    dst_port_max = 22
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn1 && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-2")) ? {
                                "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn1_db_subnet_name,"${var.service_label}-three-tier-vcn-1-db-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn3 && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")) ? {
                                "INGRESS-FROM-TT-VCN-3-APP-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn3_db_subnet_name,"${var.service_label}-three-tier-vcn-3-db-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,2))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {}
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-1")) ? 
                            {  
                                "EGRESS-TO-TT-VCN-1-DB-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn1_db_subnet_name,"${var.service_label}-three-tier-vcn-1-db-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")) ?
                            {   
                                "EGRESS-TO-TT-VCN-3-DB-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn3_db_subnet_name,"${var.service_label}-three-tier-vcn-3-db-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,2))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {}
                        )
                    }
                },
                var.deploy_tt_vcn2_bastion_subnet == true ? {
                    "TT-VCN-2-BASTION-NSG" = {
                        display_name = "bastion-nsg"
                        ingress_rules = { 
                            for cidr in var.tt_vcn2_bastion_subnet_allowed_cidrs : "INGRESS-FROM-${cidr}-RULE" => {
                                description  = "Ingress from ${cidr} on port 22."
                                stateless    = false
                                protocol     = "TCP"
                                src          = cidr
                                src_type     = "CIDR_BLOCK"
                                dst_port_min = 22
                                dst_port_max = 22
                            } if var.tt_vcn2_bastion_is_access_via_public_endpoint == true # Ingress rule only for jump hosts later deployed in the bastion public subnet.
                        },
                        egress_rules = {
                            "EGRESS-TO-LBR-RULE" = {
                                description = "Egress to LBR NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-2-LBR-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-APP-RULE" = {
                                description = "Egress to App NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-2-APP-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-DB-RULE" = {
                                description = "Egress to DB NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-2-DB-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-OSN-RULE" = {
                                description = "Egress to Oracle Services Network."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "all-services"
                                dst_type    = "SERVICE_CIDR_BLOCK"
                                dst_port_min = 443
                                dst_port_max = 443
                            }
                        }
                    }
                } : {}    
            ) # merge function

            vcn_specific_gateways = {
                internet_gateways = {
                    "TT-VCN-2-INTERNET-GATEWAY" = {
                        enabled      = true
                        display_name = "Internet Gateway"
                    }
                }
                nat_gateways = {
                    "TT-VCN-2-NAT-GATEWAY" = {
                        block_traffic = false
                        display_name  = "NAT Gateway"
                    }
                }
                service_gateways = {
                    "TT-VCN-2-SERVICE-GATEWAY" = {
                        display_name = "Service Gateway"
                        services = "all-services"
                    }
                }
            }
        }
    } : {}

    tt_vcn_3 = var.add_tt_vcn3 == true ? {
        "TT-VCN-3" = {
            display_name                     = coalesce(var.tt_vcn3_name,"${var.service_label}-three-tier-vcn-3")
            is_ipv6enabled                   = false
            is_oracle_gua_allocation_enabled = false
            cidr_blocks                      = var.tt_vcn3_cidrs,
            dns_label                        = replace(coalesce(var.tt_vcn3_dns,"${var.service_label}-three-tier-vcn-3"),"-","")
            block_nat_traffic                = false

            subnets = merge(
                {
                    "TT-VCN-3-WEB-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn3_web_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,0))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn3_web_subnet_name,"${var.service_label}-three-tier-vcn-3-web-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn3_web_subnet_dns,"web-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = var.tt_vcn3_web_subnet_is_private
                        prohibit_public_ip_on_vnic = var.tt_vcn3_web_subnet_is_private
                        route_table_key            = "TT-VCN-3-WEB-SUBNET-ROUTE-TABLE"
                    }
                },
                {    
                    "TT-VCN-3-APP-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn3_app_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,1))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn3_app_subnet_name,"${var.service_label}-three-tier-vcn-3-app-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn3_app_subnet_dns,"app-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = true
                        prohibit_public_ip_on_vnic = true
                        route_table_key            = "TT-VCN-3-APP-SUBNET-ROUTE-TABLE"
                    }
                },
                {    
                    "TT-VCN-3-DB-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn3_db_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],4,2))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn3_db_subnet_name,"${var.service_label}-three-tier-vcn-3-db-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn3_db_subnet_dns,"db-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = true
                        prohibit_public_ip_on_vnic = true
                        route_table_key            = "TT-VCN-3-DB-SUBNET-ROUTE-TABLE"
                    }
                },
                var.deploy_tt_vcn3_bastion_subnet == true ? {    
                    "TT-VCN-3-BASTION-SUBNET" = {
                        cidr_block                 = coalesce(var.tt_vcn3_bastion_subnet_cidr, cidrsubnet(var.tt_vcn3_cidrs[0],9,96))
                        dhcp_options_key           = "default_dhcp_options"
                        display_name               = coalesce(var.tt_vcn3_bastion_subnet_name,"${var.service_label}-three-tier-vcn-3-bastion-subnet")
                        dns_label                  = replace(coalesce(var.tt_vcn3_bastion_subnet_dns,"bastion-subnet"),"-","")
                        ipv6cidr_blocks            = []
                        prohibit_internet_ingress  = var.tt_vcn3_bastion_is_access_via_public_endpoint == true ? false : true
                        prohibit_public_ip_on_vnic = var.tt_vcn3_bastion_is_access_via_public_endpoint == true ? false : true
                        route_table_key            = "TT-VCN-3-BASTION-SUBNET-ROUTE-TABLE"
                        security_list_key          = var.tt_vcn3_bastion_is_access_via_public_endpoint == false ? "TT-VCN-3-BASTION-SUBNET-SL" : null
                    }
                } : {}    
            ) # merge function

            security_lists = var.deploy_tt_vcn3_bastion_subnet == true && var.tt_vcn3_bastion_is_access_via_public_endpoint == false ? { # The bastion subnet security list is only applicable to Bastion service endpoints, which are private.
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
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = var.tt_vcn1_web_subnet_is_private == false ? "TT-VCN-3-INTERNET-GATEWAY" : "TT-VCN-3-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            }, 
                            {   
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-3-SERVICE-GATEWAY"
                                    description        = "To Service Gateway."
                                    destination        = "objectstorage"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            }
                        )
                    }
                },
                {    
                    "TT-VCN-3-APP-SUBNET-ROUTE-TABLE" = {
                        display_name = "app-subnet-rtable"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = "TT-VCN-3-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-3-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = "all-services"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            },  
                            ## For App subnet route table, we route to App subnet in the routable VCN. Routes thru DRG are dependent on some factors. See the if clause.
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")) ? {
                                "tt-VCN-2-APP-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {},  
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")) ? {
                                "tt-VCN-3-APP-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {}  
                        )
                    }
                },
                {    
                    "TT-VCN-3-DB-SUBNET-ROUTE-TABLE" = {
                        display_name = "db-subnet-rtable"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = "TT-VCN-3-NAT-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-3-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = "all-services"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            },  
                            ## For DB subnet route table, we route to DB subnet in the routable VCN. Routes thru DRG are dependent on some factors. See the if clause.
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")) ? {
                                "tt-VCN-2-APP-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {},  
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")) ? {
                                "tt-VCN-3-APP-SUBNET-RULE" = {
                                    network_entity_key = "HUB-DRG"
                                    description        = "To DRG."
                                    destination        = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                                    destination_type   = "CIDR_BLOCK"
                                }
                            } : {}   
                        )
                    }
                },
                var.deploy_tt_vcn3_bastion_subnet == true ? {    
                    "TT-VCN-3-BASTION-SUBNET-ROUTE-TABLE" = {
                        display_name = "bastion-subnet-route-table"
                        route_rules = merge(
                            {
                                "INTERNET-RULE" = {
                                    network_entity_key = var.tt_vcn3_bastion_is_access_via_public_endpoint == false ? "TT-VCN-3-NAT-GATEWAY" : "TT-VCN-3-INTERNET-GATEWAY"
                                    description        = "To Internet."
                                    destination        = "0.0.0.0/0"
                                    destination_type   = "CIDR_BLOCK"
                                }
                            },
                            {    
                                "OSN-RULE" = {
                                    network_entity_key = "TT-VCN-3-SERVICE-GATEWAY"
                                    description        = "To Oracle Services Network."
                                    destination        = var.tt_vcn3_bastion_is_access_via_public_endpoint == false ? "all-services" : "objectstorage"
                                    destination_type   = "SERVICE_CIDR_BLOCK"
                                }
                            }  
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
                            } : {}    
                        ),
                        egress_rules = {
                            "EGRESS-TO-APP-RULE" = {
                                description = "Egress to App NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-3-APP-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 80
                                dst_port_max = 80
                            },
                            "EGRESS-TO-OSN-RULE" = {
                                description = "Egress to Oracle Services Network."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "all-services"
                                dst_type    = "SERVICE_CIDR_BLOCK"
                                dst_port_min = 443
                                dst_port_max = 443
                            }
                        }
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")) ? {
                                "INGRESS-FROM-TT-VCN-1-APP-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")) ? {
                                "INGRESS-FROM-TT-VCN-2-APP-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {}    
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")) ? 
                            {  
                                "EGRESS-TO-TT-VCN-1-APP-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn1_app_subnet_name,"${var.service_label}-three-tier-vcn-1-app-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn1_app_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,1))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")) ?
                            {   
                                "EGRESS-TO-TT-VCN-2-APP-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn2_app_subnet_name,"${var.service_label}-three-tier-vcn-2-app-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn2_app_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,1))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 80
                                    dst_port_max = 80
                                }
                            } : {}
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn1_routable_vcns) == 0 || contains(var.tt_vcn1_routable_vcns,"TT-VCN-3")) ? {
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn2_routable_vcns) == 0 || contains(var.tt_vcn2_routable_vcns,"TT-VCN-3")) ? {
                                "INGRESS-FROM-TT-VCN-2-DB-SUBNET-RULE" = {
                                    description  = "Ingress from ${coalesce(var.tt_vcn2_db_subnet_name,"${var.service_label}-three-tier-vcn-2-db-subnet")}."
                                    stateless    = false
                                    protocol     = "TCP"
                                    src          = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                                    src_type     = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {}    
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
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-1")) ? 
                            {  
                                "EGRESS-TO-TT-VCN-1-DB-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn1_db_subnet_name,"${var.service_label}-three-tier-vcn-1-db-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0],4,2))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {},
                            local.hub_options[var.hub_options] != 0 && var.tt_vcn3_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns,"TT-VCN-2")) ?
                            {   
                                "EGRESS-TO-TT-VCN-2-DB-SUBNET-RULE" = {
                                    description = "Egress to ${coalesce(var.tt_vcn2_db_subnet_name,"${var.service_label}-three-tier-vcn-2-db-subnet")}"
                                    stateless   = false
                                    protocol    = "TCP"
                                    dst         = coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0],4,2))
                                    dst_type    = "CIDR_BLOCK"
                                    dst_port_min = 1521
                                    dst_port_max = 1522
                                }
                            } : {}
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
                        egress_rules = {
                            "EGRESS-TO-LBR-RULE" = {
                                description = "Egress to LBR NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-3-LBR-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-APP-RULE" = {
                                description = "Egress to App NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-3-APP-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-DB-RULE" = {
                                description = "Egress to DB NSG."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "TT-VCN-3-DB-NSG"
                                dst_type    = "NETWORK_SECURITY_GROUP"
                                dst_port_min = 22
                                dst_port_max = 22
                            },
                            "EGRESS-TO-OSN-RULE" = {
                                description = "Egress to Oracle Services Network."
                                stateless   = false
                                protocol    = "TCP"
                                dst         = "all-services"
                                dst_type    = "SERVICE_CIDR_BLOCK"
                                dst_port_min = 443
                                dst_port_max = 443
                            }
                        }
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
}