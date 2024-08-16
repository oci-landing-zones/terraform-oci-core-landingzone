# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

### This Terraform configuration provisions Identity Domains.

# module "lz_identity_domains" {
#   count                = var.extend_landing_zone_to_new_region == false && var.deploy_id_domain == true
#   source               = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//identity_domains?ref=v0.1.7"
#   providers            = { oci = oci.home }
#   tenancy_ocid         = var.tenancy_ocid
#   identity_domains_configuration       = local.identity_domains_configuration
#   identity_domain_groups_configuration = var.use_id_domain_groups_to_manage_tenancy == true ? local.identity_domain_groups_configuration : local.empty_identity_domain_groups_configuration
# }

locals {
#   #------------------------------------------------------------------------
#   #----- Identity Domains
#   #------------------------------------------------------------------------
#   identity_domains_configuration = {
#     default_compartment_id : local.enclosing_compartment_id
#     identity_domains : {  
#       CUSTOM-DOMAIN  : { 
#         display_name = var.id_domain_name
#         description  = "Landing Zone Custom Identity Domain"
#         license_type = var.id_domain_type
#         is_hidden_on_login        = false
#         is_notification_bypassed  = false
#         is_primary_email_required = true
#       }
#     }  
#   }

#   #------------------------------------------------------------------------
#   #----- Identity Domains Groups
#   #------------------------------------------------------------------------
#   identity_domain_groups_configuration = {
#     default_identity_domain_id  : "CUSTOM-DOMAIN"
#     groups : merge(local.iam_admin_group, local.cred_admin_group, local.cost_admin_group,
#       local.network_admin_group, local.security_admin_group,
#       local.appdev_admin_group, local.database_admin_group, local.exainfra_admin_group,
#     local.storage_admin_group, local.auditor_group, local.announcement_reader_group)
#   }

#   empty_identity_domain_groups_configuration = {
#     default_identity_domain_id : null
#     groups : {}
#   }

  custom_id_domain_policy_prefix = "${var.custom_id_domain_name}/"

}

