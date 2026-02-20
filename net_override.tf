# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# Sample override values
# Uncomment the variables and assign them values per your use case requirements.

# locals {
    
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

#     # Whether HUB VCN Outdoor subnet is private (default) or public. Override it to true for enabling sd-wan connectivity into a 3rd-party firewall deployed in the Hub VCN.
#     hub_vcn_outdoor_subnet_private = false
#     hub_vcn_outdoor_allowed_public_cidrs = ["177.235.12.78/32"] 

#     # Security lists
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

    
#     # Spoke VCN security lists are only applicable to private subnets or when in Hub/Spoke topology.
#     # TT VCN1 security lists. 
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
    
#     # TT VCN2 security lists.
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

#     # TT VCN3 security lists.
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

#     # Whether CIS checks for networking are enabled. Use this for overriding network security rules with open rules that would break CIS Benchmark recommendations for networking. 
#     # Core Landing Zone perform CIS network checks by default. DISABLING THEM MAY PUT YOUR OCI NETWORK AT THE RISK OF EXPOSING SSH PORT TO PUBLIC NETWORKS. USE AT YOUR OWN RISK.
#     hub_vcn_cis_checks_enabled = false # whether CIS checks for hub_vcn VCN are enabled.
#     tt_vcn1_cis_checks_enabled = false # whether CIS checks for tt_vcn1 VCN are enabled.
#     tt_vcn2_cis_checks_enabled = false # whether CIS checks for tt_vcn2 VCN are enabled.
#     tt_vcn3_cis_checks_enabled = false # whether CIS checks for tt_vcn3 VCN are enabled.

#     # Intra VCN routing. Use these variables for routing traffic between subnets of the same VCN through DRG.
#     tt_vcn1_enable_intra_vcn_drg_route = true # whether traffic between subnets of tt_vcn1 is routed through DRG. 
#     tt_vcn2_enable_intra_vcn_drg_route = true # whether traffic between subnets of tt_vcn2 is routed through DRG.
#     tt_vcn3_enable_intra_vcn_drg_route = true # whether traffic between subnets of tt_vcn3 is routed through DRG.
# }    