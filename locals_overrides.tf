# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# The variables in this file can be overridden for advanced customization use cases.
# For overriding a variable, redefine the variable within net_override.tf file. DO NOT CHANGE ANY VALUES IN THIS FILE DIRECTLY as it may cause issues with future upgrades.

locals {
    
    ## Hub VCB overrides:
    # Whether HUB VCN Outdoor subnet is private (default) or public. 
    #Override it to true for enabling sd-wan connectivity into a 3rd-party firewall deployed in the Hub VCN.
    hub_vcn_outdoor_subnet_private = true
    # List of allowed CIDRs to access the Hub VCN outdoor subnet if it is public. 
    # This is useful for deployments with sd-wan connectivity into a 3rd-party firewall deployed in the Hub VCN, where the firewall is expected to have a public IP address and be accessible from the internet. 
    # This variable is only applicable if hub_vcn_outdoor_subnet_private is set to false.
    hub_vcn_outdoor_allowed_public_cidrs = [] 
    # Hub VCN security lists:
    hub_vcn_outdoor_subnet_security_list = null
    hub_vcn_indoor_subnet_security_list = null
    # Whether CIS checks for hub VCN are enabled.
    hub_vcn_cis_checks_enabled = true 
   
    ## TT VCN1 overrides:
    # TT VCN1 security lists: only overridable for private subnets or when in Hub/Spoke topology. 
    tt_vcn1_web_subnet_security_list = null 
    tt_vcn1_app_subnet_security_list = null
    tt_vcn1_db_subnet_security_list = null
    # Whether CIS checks for tt_vcn1 VCN are enabled.
    tt_vcn1_cis_checks_enabled    = true 
    # Whether traffic between subnets of tt_vcn1 is routed through DRG. 
    # Note that routing intra-VCN traffic through the DRG may introduce additional latency. 
    # It is recommended to only enable this setting if there is a specific use case that requires it, such as having all traffic inspected by a firewall in the Hub VCN.
    tt_vcn1_enable_intra_vcn_drg_route = false 

    ## TT VCN2 overrides:
    # TT VCN2 security lists: only overridable for private subnets or when in Hub/Spoke topology. 
    tt_vcn2_web_subnet_security_list = null 
    tt_vcn2_app_subnet_security_list = null
    tt_vcn2_db_subnet_security_list = null
    # Whether CIS checks for tt_vcn2 VCN are enabled.
    tt_vcn2_cis_checks_enabled    = true 
    # Whether traffic between subnets of tt_vcn2 is routed through DRG. 
    # Note that routing intra-VCN traffic through the DRG may introduce additional latency. 
    # It is recommended to only enable this setting if there is a specific use case that requires it, such as having all traffic inspected by a firewall in the Hub VCN.
    tt_vcn2_enable_intra_vcn_drg_route = false
    
    ## TT VCN3 overrides:
    # TT VCN3 security lists: only overridable for private subnets or when in Hub/Spoke topology. 
    tt_vcn3_web_subnet_security_list = null
    tt_vcn3_app_subnet_security_list = null
    tt_vcn3_db_subnet_security_list = null
    # Whether CIS checks for tt_vcn3 VCN are enabled.
    tt_vcn3_cis_checks_enabled    = true 
    # Whether traffic between subnets of tt_vcn3 is routed through DRG. 
    # Note that routing intra-VCN traffic through the DRG may introduce additional latency. 
    # It is recommended to only enable this setting if there is a specific use case that requires it, such as having all traffic inspected by a firewall in the Hub VCN.
    tt_vcn3_enable_intra_vcn_drg_route = false

    # Default security lists rules. Useful for simplifying overrides, avoiding repetition.
    security_lists_default_ingress_rules = []
    security_lists_default_egress_rules = []

}