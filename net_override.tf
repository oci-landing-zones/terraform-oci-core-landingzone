# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# SAMPLE DUMMY override values
# Uncomment the variables and assign them appropriate values per your use case requirements.

locals {

  #     #-----------------------------------------------
  #     # Hub VCN overrides:
  #     #-----------------------------------------------
  #     # Whether HUB VCN Outdoor subnet is private (default) or public.
  #     # Override it to false for SD-WAN connectivity into a 3rd-party firewall deployed in the Hub VCN.
  #     hub_vcn_outdoor_subnet_private = false
  #     # List of allowed CIDRs to access the Hub VCN outdoor subnet if it is public.
  #     # This is useful for deployments with sd-wan connectivity into a 3rd-party firewall deployed in the Hub VCN, where the firewall is expected to have a public IP address and be accessible from the internet.
  #     # This variable is only applicable if hub_vcn_outdoor_subnet_private is set to false.
  #     hub_vcn_outdoor_allowed_public_cidrs = ["88.11.88.11/32"]
  #     # Hub VCN subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
  #     hub_vcn_web_subnet_security_list = {
  #       display_name = "web-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
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
  #     hub_vcn_mgmt_subnet_security_list = {
  #       display_name = "mgmt-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     hub_vcn_jumphost_subnet_security_list = {
  #       display_name = "jumphost-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     hub_vcn_app_load_balancer_nsg_ingress_rules = {
  #       "INGRESS-FROM-MY-LAPTOP-RULE" = {
  #           description  = "Ingress from my laptop."
  #           stateless    = false
  #           protocol     = "TCP"
  #           src          = "X.X.X.X/X" # Provide CIDR range.
  #           src_type     = "CIDR_BLOCK"
  #           dst_port_min = 80
  #           dst_port_max = 80
  #       }
  #     }
  #     hub_vcn_app_load_balancer_nsg_egress_rules = {
  #       "EGRESS-TO-TT-VCN-1-APP-SUBNET-RULE" = {
  #           description  = "Egress to three-tier-vcn-1 app subnet."
  #           stateless    = false
  #           protocol     = "TCP"
  #           dst          = local.tt_vcn1_app_subnet_cidr
  #           dst_type     = "CIDR_BLOCK"
  #           dst_port_min = 80
  #           dst_port_max = 80
  #       }
  #     }

  #     # Whether CIS checks for hub_vcn VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     hub_vcn_cis_checks_enabled = false

  #     #-----------------------------------------------
  #     # TT VCN1 overrides:
  #     #-----------------------------------------------
  #     # TT VCN1 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
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
  #     tt_vcn1_bastion_subnet_security_list = {
  #       display_name = "bastion-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Whether CIS checks for tt_vcn1 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     tt_vcn1_cis_checks_enabled = false
  #     # Whether traffic between subnets of tt_vcn1 is routed through DRG.
  #     tt_vcn1_enable_intra_vcn_drg_route = true

  #     #-----------------------------------------------
  #     # TT VCN2 overrides:
  #     #-----------------------------------------------
  #     # TT VCN2 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
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
  #     tt_vcn2_bastion_subnet_security_list = {
  #       display_name = "bastion-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Whether CIS checks for tt_vcn2 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     tt_vcn2_cis_checks_enabled = false
  #     # Whether traffic between subnets of tt_vcn2 is routed through DRG.
  #     tt_vcn2_enable_intra_vcn_drg_route = true

  #     #-----------------------------------------------
  #     # TT VCN3 overrides:
  #     #-----------------------------------------------
  #     # TT VCN3 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
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
  #     tt_vcn3_bastion_subnet_security_list = {
  #       display_name = "bastion-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Whether CIS checks for tt_vcn3 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     tt_vcn3_cis_checks_enabled = false
  #     # Whether traffic between subnets of tt_vcn3 is routed through DRG.
  #     tt_vcn3_enable_intra_vcn_drg_route = true

  #     #-----------------------------------------------
  #     # OKE VCN1 overrides:
  #     #-----------------------------------------------
  #     # OKE VCN1 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
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
  #     oke_vcn1_db_subnet_security_list       = {
  #       display_name = "db-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Whether CIS checks for oke_vcn1 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     oke_vcn1_cis_checks_enabled = false
  #     # Whether traffic between subnets of oke_vcn1 is routed through DRG.
  #     oke_vcn1_enable_intra_vcn_drg_route = true

  #     #-----------------------------------------------
  #     # OKE VCN2 overrides:
  #     #-----------------------------------------------
  #     # OKE VCN2 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
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
  #     # Whether CIS checks for oke_vcn2 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     oke_vcn2_cis_checks_enabled = false
  #     # Whether traffic between subnets of oke_vcn2 is routed through DRG.
  #     oke_vcn2_enable_intra_vcn_drg_route = true

  #     #-----------------------------------------------
  #     # OKE VCN3 overrides:
  #     #-----------------------------------------------
  #     # OKE VCN3 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
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
  #     # Whether CIS checks for oke_vcn3 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     oke_vcn3_cis_checks_enabled = false
  #     # Whether traffic between subnets of oke_vcn3 is routed through DRG.
  #     oke_vcn3_enable_intra_vcn_drg_route = true

  #     #-----------------------------------------------
  #     # EXA VCN1 overrides:
  #     #-----------------------------------------------
  #     # EXA VCN1 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
  #     exa_vcn1_client_subnet_security_list = {
  #       display_name  = "client-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Only applied when add_exa_vcn1_backup_subnet = true.
  #     exa_vcn1_backup_subnet_security_list = {
  #       display_name  = "backup-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Only applied when add_exa_vcn1_integration_subnet = true.
  #     exa_vcn1_integration_subnet_security_list = {
  #       display_name  = "integration-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Whether CIS checks for exa_vcn1 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     exa_vcn1_cis_checks_enabled = false
  #     # Whether traffic between EXA VCN1 client and integration subnets is routed through DRG.
  #     exa_vcn1_enable_intra_vcn_drg_route = true
  #
  #     #-----------------------------------------------
  #     # EXA VCN2 overrides:
  #     #-----------------------------------------------
  #     # EXA VCN2 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
  #     exa_vcn2_client_subnet_security_list = {
  #       display_name  = "client-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Only applied when add_exa_vcn2_backup_subnet = true.
  #     exa_vcn2_backup_subnet_security_list = {
  #       display_name  = "backup-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Only applied when add_exa_vcn2_integration_subnet = true.
  #     exa_vcn2_integration_subnet_security_list = {
  #       display_name  = "integration-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Whether CIS checks for exa_vcn2 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     exa_vcn2_cis_checks_enabled = false
  #     # Whether traffic between EXA VCN2 client and integration subnets is routed through DRG.
  #     exa_vcn2_enable_intra_vcn_drg_route = true
  #
  #     #-----------------------------------------------
  #     # EXA VCN3 overrides:
  #     #-----------------------------------------------
  #     # EXA VCN3 subnet security list overrides. Non-null values replace or attach the matching subnet security lists.
  #     exa_vcn3_client_subnet_security_list = {
  #       display_name  = "client-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Only applied when add_exa_vcn3_backup_subnet = true.
  #     exa_vcn3_backup_subnet_security_list = {
  #       display_name  = "backup-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Only applied when add_exa_vcn3_integration_subnet = true.
  #     exa_vcn3_integration_subnet_security_list = {
  #       display_name  = "integration-subnet-security-list"
  #       ingress_rules = local.security_lists_default_ingress_rules
  #       egress_rules  = local.security_lists_default_egress_rules
  #     }
  #     # Whether CIS checks for exa_vcn3 VCN are enabled.
  #     # This override is honored only when oci_nfw_ip_ocid is configured, or when both hub_vcn_east_west_entry_point_ocid and hub_vcn_north_south_entry_point_ocid are configured.
  #     exa_vcn3_cis_checks_enabled = false
  #     # Whether traffic between EXA VCN3 client and integration subnets is routed through DRG.
  #     exa_vcn3_enable_intra_vcn_drg_route = true

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
}
