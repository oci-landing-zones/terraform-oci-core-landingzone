# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# The variables in this file can be overridden for advanced network customization use cases.
# For overriding a variable, redefine the variable within net_override.tf file. DO NOT CHANGE ANY VALUES IN THIS FILE DIRECTLY as it may cause issues with future upgrades.

locals {

  #-----------------------------------------------
  # Hub VCN overrides:
  #-----------------------------------------------
  # Whether HUB VCN Outdoor subnet is private (default) or public.
  # Override it to true for enabling sd-wan connectivity into a 3rd-party firewall deployed in the Hub VCN.
  hub_vcn_outdoor_subnet_private = true
  # List of allowed CIDRs to access the Hub VCN outdoor subnet if it is public.
  # This is useful for deployments with sd-wan connectivity into a 3rd-party firewall deployed in the Hub VCN, where the firewall is expected to have a public IP address and be accessible from the internet.
  # This variable is only applicable if hub_vcn_outdoor_subnet_private is set to false.
  hub_vcn_outdoor_allowed_public_cidrs = []
  # Hub VCN security lists:
  hub_vcn_outdoor_subnet_security_list = null
  hub_vcn_indoor_subnet_security_list  = null
  # TT VCN1 additional NSGs:
  hub_vcn_additional_nsgs = {}
  # Whether CIS checks for hub VCN are enabled.
  hub_vcn_cis_checks_enabled = true

  #-----------------------------------------------
  # TT VCN1 overrides:
  #-----------------------------------------------
  # TT VCN1 security lists: only overridable for private subnets or when in Hub/Spoke topology.
  tt_vcn1_web_subnet_security_list = null
  tt_vcn1_app_subnet_security_list = null
  tt_vcn1_db_subnet_security_list  = null
  # TT VCN1 additional NSGs:
  tt_vcn1_additional_nsgs = {}
  # Whether CIS checks for tt_vcn1 VCN are enabled.
  tt_vcn1_cis_checks_enabled = true
  # Whether traffic between subnets of tt_vcn1 is routed through DRG.
  # Note that routing intra-VCN traffic through the DRG may introduce additional latency.
  # It is recommended to only enable this setting if there is a specific use case that requires it, such as having all traffic inspected by a firewall in the Hub VCN.
  tt_vcn1_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # TT VCN2 overrides:
  #-----------------------------------------------
  # TT VCN2 security lists: only overridable for private subnets or when in Hub/Spoke topology.
  tt_vcn2_web_subnet_security_list = null
  tt_vcn2_app_subnet_security_list = null
  tt_vcn2_db_subnet_security_list  = null
  # TT VCN2 additional NSGs:
  tt_vcn2_additional_nsgs = {}
  # Whether CIS checks for tt_vcn2 VCN are enabled.
  tt_vcn2_cis_checks_enabled = true
  # Whether traffic between subnets of tt_vcn2 is routed through DRG.
  # Note that routing intra-VCN traffic through the DRG may introduce additional latency.
  # It is recommended to only enable this setting if there is a specific use case that requires it, such as having all traffic inspected by a firewall in the Hub VCN.
  tt_vcn2_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # TT VCN3 overrides:
  #-----------------------------------------------
  # TT VCN3 security lists: only overridable for private subnets or when in Hub/Spoke topology.
  tt_vcn3_web_subnet_security_list = null
  tt_vcn3_app_subnet_security_list = null
  tt_vcn3_db_subnet_security_list  = null
  # TT VCN3 additional NSGs:
  tt_vcn3_additional_nsgs = {}
  # Whether CIS checks for tt_vcn3 VCN are enabled.
  tt_vcn3_cis_checks_enabled = true
  # Whether traffic between subnets of tt_vcn3 is routed through DRG.
  # Note that routing intra-VCN traffic through the DRG may introduce additional latency.
  # It is recommended to only enable this setting if there is a specific use case that requires it, such as having all traffic inspected by a firewall in the Hub VCN.
  tt_vcn3_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # OKE VCN1 overrides:
  #-----------------------------------------------
  # OKE VCN1 security lists:
  oke_vcn1_api_subnet_security_list      = null
  oke_vcn1_workers_subnet_security_list  = null
  oke_vcn1_services_subnet_security_list = null
  oke_vcn1_mgmt_subnet_security_list     = null
  oke_vcn1_pods_subnet_security_list     = null
  oke_vcn1_db_subnet_security_list       = null
  # OKE VCN1 additional NSGs:
  oke_vcn1_additional_nsgs = {}
  # Whether CIS checks for oke_vcn1 VCN are enabled.
  oke_vcn1_cis_checks_enabled = true
  # Whether traffic between subnets of oke_vcn1 is routed through DRG.
  oke_vcn1_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # OKE VCN2 overrides:
  #-----------------------------------------------
  # OKE VCN2 security lists:
  oke_vcn2_api_subnet_security_list      = null
  oke_vcn2_workers_subnet_security_list  = null
  oke_vcn2_services_subnet_security_list = null
  oke_vcn2_mgmt_subnet_security_list     = null
  oke_vcn2_pods_subnet_security_list     = null
  oke_vcn2_db_subnet_security_list       = null
  # OKE VCN2 additional NSGs:
  oke_vcn2_additional_nsgs = {}
  # Whether CIS checks for oke_vcn2 VCN are enabled.
  oke_vcn2_cis_checks_enabled = true
  # Whether traffic between subnets of oke_vcn2 is routed through DRG.
  oke_vcn2_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # OKE VCN3 overrides:
  #-----------------------------------------------
  # OKE VCN3 security lists:
  oke_vcn3_api_subnet_security_list      = null
  oke_vcn3_workers_subnet_security_list  = null
  oke_vcn3_services_subnet_security_list = null
  oke_vcn3_mgmt_subnet_security_list     = null
  oke_vcn3_pods_subnet_security_list     = null
  oke_vcn3_db_subnet_security_list       = null
  # OKE VCN3 additional NSGs:
  oke_vcn3_additional_nsgs = {}
  # Whether CIS checks for oke_vcn3 VCN are enabled.
  oke_vcn3_cis_checks_enabled = true
  # Whether traffic between subnets of oke_vcn3 is routed through DRG.
  oke_vcn3_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # EXA VCN1 overrides:
  #-----------------------------------------------
  # EXA VCN1 security lists:
  exa_vcn1_client_subnet_security_list      = null
  exa_vcn1_backup_subnet_security_list      = null
  exa_vcn1_integration_subnet_security_list = null
  # EXA VCN1 additional NSGs:
  exa_vcn1_additional_nsgs = {}
  # Whether CIS checks for exa_vcn1 VCN are enabled.
  exa_vcn1_cis_checks_enabled = true
  # Whether client/integration intra-VCN traffic for EXA VCN1 is routed through DRG.
  exa_vcn1_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # EXA VCN2 overrides:
  #-----------------------------------------------
  # EXA VCN2 security lists:
  exa_vcn2_client_subnet_security_list      = null
  exa_vcn2_backup_subnet_security_list      = null
  exa_vcn2_integration_subnet_security_list = null
  # EXA VCN2 additional NSGs:
  exa_vcn2_additional_nsgs = {}
  # Whether CIS checks for exa_vcn2 VCN are enabled.
  exa_vcn2_cis_checks_enabled = true
  # Whether client/integration intra-VCN traffic for EXA VCN2 is routed through DRG.
  exa_vcn2_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # EXA VCN3 overrides:
  #-----------------------------------------------
  # EXA VCN3 security lists:
  exa_vcn3_client_subnet_security_list      = null
  exa_vcn3_backup_subnet_security_list      = null
  exa_vcn3_integration_subnet_security_list = null
  # EXA VCN3 additional NSGs:
  exa_vcn3_additional_nsgs = {}
  # Whether CIS checks for exa_vcn3 VCN are enabled.
  exa_vcn3_cis_checks_enabled = true
  # Whether client/integration intra-VCN traffic for EXA VCN3 is routed through DRG.
  exa_vcn3_enable_intra_vcn_drg_route = false

  #-----------------------------------------------
  # Default security lists rules.
  #-----------------------------------------------
  # Useful for simplifying overrides, avoiding repetition.
  security_lists_default_ingress_rules = []
  security_lists_default_egress_rules  = []
}
