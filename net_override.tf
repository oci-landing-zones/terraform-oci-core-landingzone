# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# SAMPLE DUMMY override values
# Uncomment the variables and assign them appropriate values per your use case requirements.

# locals {
    
#     #-----------------------------------------------
#     # Hub VCB overrides:
#     #-----------------------------------------------
#     # Whether HUB VCN Outdoor subnet is private (default) or public. 
#     #Override it to true for enabling sd-wan connectivity into a 3rd-party firewall deployed in the Hub VCN.
#     hub_vcn_outdoor_subnet_private = false
#     # List of allowed CIDRs to access the Hub VCN outdoor subnet if it is public. 
#     # This is useful for deployments with sd-wan connectivity into a 3rd-party firewall deployed in the Hub VCN, where the firewall is expected to have a public IP address and be accessible from the internet. 
#     # This variable is only applicable if hub_vcn_outdoor_subnet_private is set to false.
#     hub_vcn_outdoor_allowed_public_cidrs = ["88.11.88.11/32"] 
#     # Hub VCN security lists
#     hub_vcn_outdoor_subnet_security_list = {
#       display_name  = "outdoor-subnet-security-list"
#       ingress_rules = [
#       {
#         description  = "Ingress from ${local.hub_vcn_outdoor_allowed_public_cidrs[0]}"
#         stateless    = false
#         protocol     = "ALL"
#         src          = local.hub_vcn_outdoor_allowed_public_cidrs[0]
#         src_type     = "CIDR_BLOCK"
#       }
#     ]
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     hub_vcn_indoor_subnet_security_list = {
#       display_name = "indoor-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }

#     hub_vcn_additional_nsgs = {
#       "MY-ADDITIONAL-NSG" = {
#         display_name = "my-additional-nsg"
#         ingress_rules = {
#           "INGRESS-FROM-MGMT-NSG-ICMP-RULE" = {
#             description  = "Ingress from MGMT NSG for ICMP protocol."
#             stateless    = false
#             protocol     = "ICMP"
#             src          = "HUB-VCN-MGMT-NSG"
#             src_type     = "NETWORK_SECURITY_GROUP"
#           },
#           "INGRESS-FROM-CIDR-ICMP-RULE" = {
#             description  = "Ingress from 88.11.88.11/32 for ICMP protocol."
#             stateless    = false
#             protocol     = "ICMP"
#             src          = "88.11.88.11/32"
#             src_type     = "CIDR_BLOCK"
#           }
#         }
#       }
#     }

#     # whether CIS checks for hub_vcn VCN are enabled.
#     hub_vcn_cis_checks_enabled = false

#     #-----------------------------------------------
#     # TT VCN1 overrides:
#     #-----------------------------------------------
#     # TT VCN1 security lists: only overridable for private subnets or when in Hub/Spoke topology. 
#     tt_vcn1_web_subnet_security_list = {
#       display_name = "web-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     tt_vcn1_app_subnet_security_list = {
#       display_name = "app-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     tt_vcn1_db_subnet_security_list = {
#       display_name = "db-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # TT VCN1 additional NSGs:
#     tt_vcn1_additional_nsgs = {}
#     # Whether CIS checks for tt_vcn1 VCN are enabled.
#     tt_vcn1_cis_checks_enabled = false
#     # Whether traffic between subnets of tt_vcn1 is routed through DRG. 
#     tt_vcn1_enable_intra_vcn_drg_route = true

#     #-----------------------------------------------
#     # TT VCN2 overrides:
#     #-----------------------------------------------
#     # TT VCN2 security lists: only overridable for private subnets or when in Hub/Spoke topology. 
#     tt_vcn2_web_subnet_security_list = {
#       display_name = "web-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     } 
#     tt_vcn2_app_subnet_security_list = {
#       display_name = "app-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     tt_vcn2_db_subnet_security_list  = {
#       display_name = "db-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # TT VCN2 additional NSGs:
#     tt_vcn2_additional_nsgs = {}
#     # Whether CIS checks for tt_vcn2 VCN are enabled.
#     tt_vcn2_cis_checks_enabled = false
#     # Whether traffic between subnets of tt_vcn2 is routed through DRG. 
#     tt_vcn2_enable_intra_vcn_drg_route = true

#     #-----------------------------------------------
#     # TT VCN3 overrides:
#     #-----------------------------------------------
#     # TT VCN3 security lists: only overridable for private subnets or when in Hub/Spoke topology. 
#     tt_vcn3_web_subnet_security_list = {
#       display_name = "web-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     } 
#     tt_vcn3_app_subnet_security_list = {
#       display_name = "app-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     tt_vcn3_db_subnet_security_list  = {
#       display_name = "db-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # TT VCN3 additional NSGs:
#     tt_vcn3_additional_nsgs = {}
#     # Whether CIS checks for tt_vcn3 VCN are enabled.
#     tt_vcn3_cis_checks_enabled = false
#     # Whether traffic between subnets of tt_vcn3 is routed through DRG. 
#     tt_vcn3_enable_intra_vcn_drg_route = true

#     #-----------------------------------------------
#     # OKE VCN1 overrides:
#     #-----------------------------------------------
#     # OKE VCN1 security lists.
#     oke_vcn1_api_subnet_security_list = {
#       display_name = "api-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn1_workers_subnet_security_list = {
#       display_name = "workers-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn1_services_subnet_security_list = {
#       display_name = "services-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn1_mgmt_subnet_security_list = {
#       display_name = "mgmt-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn1_pods_subnet_security_list = {
#       display_name = "pods-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # OKE VCN1 additional NSGs.
#     oke_vcn1_additional_nsgs = {
#       "OKE-VCN-1-CUSTOM-NSG" = {
#         display_name = "oke-vcn-1-custom-nsg"
#         ingress_rules = {
#           "INGRESS-FROM-CIDR-TCP-RULE" = {
#             description  = "Ingress from 10.10.0.0/24 on SSH."
#             stateless    = false
#             protocol     = "TCP"
#             src          = "10.10.0.0/24"
#             src_type     = "CIDR_BLOCK"
#             dst_port_min = 22
#             dst_port_max = 22
#           }
#         }
#         egress_rules = {}
#       }
#     }
#     # Whether CIS checks for oke_vcn1 VCN are enabled.
#     # Core Landing Zone performs CIS network checks by default. DISABLING THEM MAY PUT YOUR OCI NETWORK AT RISK OF EXPOSING SSH PORTS. USE AT YOUR OWN RISK.
#     oke_vcn1_cis_checks_enabled = false
#     # Whether traffic between subnets of oke_vcn1 is routed through DRG.
#     oke_vcn1_enable_intra_vcn_drg_route = true

#     #-----------------------------------------------
#     # OKE VCN2 overrides:
#     #-----------------------------------------------
#     # OKE VCN2 security lists.
#     oke_vcn2_api_subnet_security_list = {
#       display_name = "api-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn2_workers_subnet_security_list = {
#       display_name = "workers-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn2_services_subnet_security_list = {
#       display_name = "services-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn2_mgmt_subnet_security_list = {
#       display_name = "mgmt-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn2_pods_subnet_security_list = {
#       display_name = "pods-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # OKE VCN2 additional NSGs.
#     oke_vcn2_additional_nsgs = {
#       "OKE-VCN-2-CUSTOM-NSG" = {
#         display_name = "oke-vcn-2-custom-nsg"
#         ingress_rules = {
#           "INGRESS-FROM-CIDR-ICMP-RULE" = {
#             description = "Allow ICMP from monitoring network."
#             stateless   = false
#             protocol    = "ICMP"
#             src         = "10.20.0.0/24"
#             src_type    = "CIDR_BLOCK"
#             icmp_type   = 3
#             icmp_code   = 4
#           }
#         }
#         egress_rules = {}
#       }
#     }
#     # Whether CIS checks for oke_vcn2 VCN are enabled.
#     oke_vcn2_cis_checks_enabled = false
#     # Whether traffic between subnets of oke_vcn2 is routed through DRG.
#     oke_vcn2_enable_intra_vcn_drg_route = true

#     #-----------------------------------------------
#     # OKE VCN3 overrides:
#     #-----------------------------------------------
#     # OKE VCN3 security lists.
#     oke_vcn3_api_subnet_security_list = {
#       display_name = "api-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn3_workers_subnet_security_list = {
#       display_name = "workers-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn3_services_subnet_security_list = {
#       display_name = "services-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn3_mgmt_subnet_security_list = {
#       display_name = "mgmt-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     oke_vcn3_pods_subnet_security_list = {
#       display_name = "pods-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # OKE VCN3 additional NSGs.
#     oke_vcn3_additional_nsgs = {
#       "OKE-VCN-3-CUSTOM-NSG" = {
#         display_name = "oke-vcn-3-custom-nsg"
#         ingress_rules = {}
#         egress_rules = {
#           "EGRESS-TO-CIDR-HTTPS-RULE" = {
#             description  = "Allow HTTPS egress to updates network."
#             stateless    = false
#             protocol     = "TCP"
#             dst          = "10.30.0.0/24"
#             dst_type     = "CIDR_BLOCK"
#             dst_port_min = 443
#             dst_port_max = 443
#           }
#         }
#       }
#     }
#     # Whether CIS checks for oke_vcn3 VCN are enabled.
#     oke_vcn3_cis_checks_enabled = false
#     # Whether traffic between subnets of oke_vcn3 is routed through DRG.
#     oke_vcn3_enable_intra_vcn_drg_route = true

#     #-----------------------------------------------
#     # Default security lists rules. 
#     #-----------------------------------------------
#     # Useful for simplifying overrides, avoiding repetition.
#     security_lists_default_ingress_rules = [
#       {
#         description  = "Ingress from 0.0.0.0/0"
#         stateless    = false
#         protocol     = "ALL"
#         src          = "0.0.0.0/0"
#         src_type     = "CIDR_BLOCK"
#       }
#     ]
#     security_lists_default_egress_rules = [
#       {
#         description  = "Egress to 0.0.0.0/0"
#         stateless    = false
#         protocol     = "ALL"
#         dst          = "0.0.0.0/0"
#         dst_type     = "CIDR_BLOCK"
#       }
#     ]
# }    
