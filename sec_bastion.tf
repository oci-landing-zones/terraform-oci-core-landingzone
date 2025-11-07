locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local vars can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  #-- Bastion
  custom_bastion_service_type          = null
  custom_bastion_service_defined_tags  = null
  custom_bastion_service_freeform_tags = null
  # custom_bastion_target_compartments = null

  jump_host_marketplace_image_map = {
    "Oracle Linux 8 STIG (Free)"                          = "Oracle Linux 8 STIG",                         # default latest version
    "CIS Hardened Image Level 1 on Oracle Linux 8 (Paid)" = "CIS Hardened Image Level 1 on Oracle Linux 8" # default latest version
  }

  ### Bastion Service
  default_bastion_service_name          = "${var.service_label}-bastion-service"
  default_bastion_service_type          = "STANDARD"
  default_bastion_service_defined_tags  = null
  default_bastion_service_freeform_tags = local.landing_zone_tags

  bastion_service_name          = var.bastion_service_name != null ? var.bastion_service_name : local.default_bastion_service_name
  bastion_service_type          = local.custom_bastion_service_type != null ? local.custom_bastion_service_type : local.default_bastion_service_type
  bastion_service_defined_tags  = local.custom_bastion_service_defined_tags != null ? merge(local.custom_bastion_service_defined_tags, local.default_bastion_service_defined_tags) : local.default_bastion_service_defined_tags
  bastion_service_freeform_tags = local.custom_bastion_service_freeform_tags != null ? merge(local.custom_bastion_service_freeform_tags, local.default_bastion_service_freeform_tags) : local.default_bastion_service_freeform_tags
  enable_bastion_proxy_status   = false

  bastions_configuration = var.deploy_bastion_jump_host == true && var.deploy_bastion_service ? {
    bastions = {
      LZ-BASTION = {
        bastion_type          = local.bastion_service_type
        compartment_id        = local.security_compartment_id
        subnet_id             = module.lz_network.provisioned_networking_resources.subnets["JUMPHOST-SUBNET"].id
        defined_tags          = local.bastion_service_defined_tags
        freeform_tags         = local.bastion_service_freeform_tags
        cidr_block_allow_list = var.bastion_service_allowed_cidrs
        enable_dns_proxy      = local.enable_bastion_proxy_status
        name                  = local.bastion_service_name
      }
    }
  } : {}

  ### Bastion Jump Host

  jump_host_instances_configuration = {
    default_compartment_id      = local.security_compartment_id
    default_ssh_public_key_path = var.bastion_jump_host_ssh_public_key_path

    instances = {
      JUMP-HOST-INSTANCE = {
        shape = var.bastion_jump_host_instance_shape
        name  = var.bastion_jump_host_instance_name # default values based off of nfw

        boot_volume = {
          size                          = var.bastion_jump_host_boot_volume_size
          preserve_on_instance_deletion = true
          measured_boot                 = true
        }

        flex_shape_settings = {
          memory = var.bastion_jump_host_flex_shape_memory
          ocpus  = var.bastion_jump_host_flex_shape_cpu
        }

        custom_image = var.bastion_jump_host_custom_image_ocid != null ? {
          ocid = var.bastion_jump_host_custom_image_ocid
        } : null

        marketplace_image = var.cis_level == "1" && var.bastion_jump_host_marketplace_image_option != null ? {
          name = local.jump_host_marketplace_image_map[var.bastion_jump_host_marketplace_image_option]
        } : null

        platform_image = var.cis_level == "2" && var.bastion_jump_host_custom_image_ocid == null ? {
          ocid = data.oci_core_images.platform_oel_images.images[0].id
        } : null

        security = local.enable_zpr == true ? { zpr_attributes = [{ namespace : "${local.zpr_namespace_name}", attr_name : "bastion", attr_value : local.zpr_label }] } : null

        networking = {
          hostname                = "${var.service_label}-jump-host-instance"
          subnet_id               = var.deploy_bastion_jump_host ? module.lz_network.provisioned_networking_resources.subnets["JUMPHOST-SUBNET"].id : null
          network_security_groups = var.deploy_bastion_jump_host ? [module.lz_network.flat_map_of_provisioned_networking_resources["HUB-VCN-JUMP-HOST-NSG"].id] : null
        }

        cloud_agent = var.deploy_bastion_service == true ? { plugins = [{ name : "Bastion", enabled : true }] } : null

        encryption = {
          kms_key_id                            = var.cis_level == "2" && var.deploy_bastion_jump_host ? module.lz_vault[0].keys["JUMPHOST-KEY"].id : null
          encrypt_in_transit_on_instance_create = true
        }
        disable_legacy_imds_endpoints = true
        cis_level                     = var.cis_level
        platform_type                 = var.cis_level == "2" ? (length(regexall("VM.Standard", var.bastion_jump_host_instance_shape)) > 0 ? (length(regexall("VM.Standard.E", var.bastion_jump_host_instance_shape)) > 0 ? "AMD_VM" : "INTEL_VM") : null) : null ## VM.Standard.E[0-9] = AMD_VM ### VM.Standard[0-9] = INTEL_VM
      }
    }
  }
}

module "lz_bastion" {
  source                 = "github.com/oci-landing-zones/terraform-oci-modules-security//bastion?ref=v0.2.3"
  bastions_configuration = local.bastions_configuration
  count                  = var.deploy_bastion_service ? 1 : 0
}

module "lz_bastion_jump_host" {

  source = "github.com/oci-landing-zones/terraform-oci-modules-workloads//cis-compute-storage?ref=v0.2.2"
  count  = (local.hub_with_vcn == true && var.deploy_bastion_jump_host == true) ? 1 : 0

  providers = {
    oci                                  = oci.home
    oci.block_volumes_replication_region = oci.home
  }

  instances_configuration = local.jump_host_instances_configuration
  tenancy_ocid            = var.tenancy_ocid
}