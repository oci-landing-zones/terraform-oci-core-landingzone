locals {
  identity_domains_configuration = {
    identity_domains : {
      NEW-DOMAIN : {
        compartment_id                   = local.enclosing_compartment_id
        display_name                     = var.new_identity_domain_name
        description                      = "identity domain for ${var.new_identity_domain_name}"
        license_type                     = var.new_identity_domain_license_type
        allow_signing_cert_public_access = false
      }
    }
  }
  identity_domain_groups_configuration = {
    default_identity_domain_id : "NEW-DOMAIN"
    groups : merge(local.iam_admin_group, local.cred_admin_group, local.cost_admin_group,
              local.network_admin_group, local.security_admin_group,
              local.appdev_admin_group, local.database_admin_group, local.exainfra_admin_group,
              local.storage_admin_group, local.auditor_group, local.announcement_reader_group,
              local.ag_admin_group)
  }

  identity_domain_dynamic_groups_configuration = {
    default_identity_domain_id : "NEW-DOMAIN"
    dynamic_groups : merge(local.security_functions_dynamic_group, local.appdev_functions_dynamic_group,
    local.appdev_computeagent_dynamic_group, local.database_kms_dynamic_group, local.net_fw_app_dynamic_group)

  }
}

module "lz_new_identity_domain" {
  source                                       = "github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains?ref=release-0.2.9"
  count                                        = var.identity_domain_option == "New Identity Domain" ? 1 : 0
  providers                                    = { oci = oci.home }
  tenancy_ocid                                 = var.tenancy_ocid
  identity_domains_configuration               = local.identity_domains_configuration
  identity_domain_groups_configuration         = local.identity_domain_groups_configuration
  identity_domain_dynamic_groups_configuration = local.identity_domain_dynamic_groups_configuration
}