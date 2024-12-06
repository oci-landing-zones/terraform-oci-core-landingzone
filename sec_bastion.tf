locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local vars can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  #-- Bastion
  custom_bastion_service_type           = null
  custom_bastion_service_defined_tags   = null
  custom_bastion_service_freeform_tags  = null

  #-- Jump host access options map
  jump_host_access_options = {
    "On-Premises Through Fast-Connect" = 0,
    "Bastion Service"                  = 1
  }

  chosen_jump_host_option = local.jump_host_access_options[var.jump_host_access_option]
  deploy_bastion_service  = var.deploy_bastion_jump_host == true && (local.chosen_jump_host_option == 1)
}

module "lz_bastion" {
  source                = "github.com/oci-landing-zones/terraform-oci-modules-security/tree/main/bastion?ref=v0.1.9"
  bastion_configuration = local.bastion_configuration
  count = local.deploy_bastion_service ? 1 : 0
}

locals {
  default_bastion_service_name          = "${var.service_label}-bastion-service"
  default_bastion_service_type          = "STANDARD"
  default_bastion_service_defined_tags  = null
  default_bastion_service_freeform_tags = local.landing_zone_tags

  bastion_service_name          = var.bastion_service_name != null ? var.bastion_service_name : local.default_bastion_service_name
  bastion_service_type          = local.custom_bastion_service_type != null ? local.custom_bastion_service_type : local.default_bastion_service_type
  bastion_service_defined_tags  = local.custom_bastion_service_defined_tags != null ? merge(local.custom_bastion_service_defined_tags, local.default_bastion_service_defined_tags ): local.default_bastion_service_defined_tags
  bastion_service_freeform_tags = local.custom_bastion_service_freeform_tags != null ? merge(local.custom_vault_freeform_tags, local.default_bastion_service_freeform_tags) : local.default_bastion_service_freeform_tags

  bastion_configuration = {
    bastion_type          = local.bastion_service_type
    compartment_id        = local.security_compartment_id
    subnet_id             = module.lz_network.provisioned_networking_resources.subnets["MGMT-SUBNET"].id
    defined_tags          = local.bastion_service_defined_tags
    freeform_tags         = local.bastion_service_freeform_tags
    cidr_block_allow_list = var.bastion_service_allowed_cidrs
    enable_dns_proxy      = var.enable_bastion_proxy_status
    name                  = local.bastion_service_name
  }
}