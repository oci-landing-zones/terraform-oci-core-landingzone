locals {
  #------------------------------------------------------------------------------------------------------
  #-- Any of these local vars can be overriden in a _override.tf file
  #------------------------------------------------------------------------------------------------------
  #-- Bastion
  custom_bastion_service_type           = null
  custom_bastion_service_defined_tags   = null
  custom_bastion_service_freeform_tags  = null
  # custom_bastion_target_compartments = null

  #-- Jump host access options map
  jump_host_access_options = {
    "On-Premises Through Fast-Connect" = 0,
    "Bastion Service"                  = 1
  }

  chosen_jump_host_option = local.jump_host_access_options[var.jump_host_access_option]
  deploy_bastion_service  = var.deploy_bastion_jump_host == true && (local.chosen_jump_host_option == 1)
}


### Bastion Service
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


### Bastion Jump Host
locals {
  tenancy_ocid = var.tenancy_ocid

  jump_host_instances_configuration = {
    default_compartment_id = local.security_compartment_id
    default_ssh_public_key_path = var.bastion_jump_host_ssh_public_key_path

    instances = {
      JUMP-HOST-MGMT-SUBNET-INSTANCE = {
        shape = var.bastion_jump_host_instance_shape
        name  = var.bastion_jump_host_instance_name # default values based off of nfw

        boot_volume = {
          size = var.bastion_jump_host_boot_volume_size
          preserve_on_instance_deletion = true
          measured_boot                 = true
        }

        flex_shape_settings = {
          memory = var.bastion_jump_host_flex_shape_memory
          ocpus = var.bastion_jump_host_flex_shape_cpu
        }

        custom_image = var.bastion_jump_host_custom_image_ocid ? {
          ocid = var.bastion_jump_host_custom_image_ocid
        } : null

        platform_image = var.bastion_jump_host_custom_image_ocid ? null : {
          name = var.bastion_jump_host_platform_image_name   # Default platform image Oracle-Linux-8.10-2024.08.29-0
        }
        
        security = local.enable_zpr == true ? {zpr_attributes = [{namespace:"${local.zpr_namespace_name}",attr_name:"bastion", attr_value:local.zpr_label}]} : null
        
        networking = {
          hostname  = "${var.service_label}-bastion-jump-host-mgmt-instance"
          subnet_id = module.lz_network.provisioned_networking_resources.subnets["MGMT-SUBNET"].id
          network_security_groups = [module.lz_network.flat_map_of_provisioned_networking_resources["HUB-VCN-JUMP-HOST-NSG"].id]
        }

        cloud_agent = local.deploy_bastion_service == true ? {plugins = [{name:"Bastion",enabled:true}]} : null
      }
    }
  }
}

module "lz_bastion" {
  source                = "github.com/oci-landing-zones/terraform-oci-modules-security/tree/main/bastion?ref=v0.1.9"
  bastion_configuration = local.bastion_configuration
  count = local.deploy_bastion_service ? 1 : 0
}

module "lz_bastion_jump_host" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-workloads//cis-compute-storage?ref=v0.1.8"
  depends_on = [time_sleep.wait_on_services_policy]
  count = ( local.hub_with_vcn == true && deploy_bastion_jump_host == true) ? 1 : 0
  providers = {
    oci      = oci
    oci.home = oci.home
  }
  
  instances_configuration = local.jump_host_instances_configuration
} 

# ----------------------------------------------------------------------------
# -- Creating time sleep delays to slow down resource creation
# ----------------------------------------------------------------------------
resource "time_sleep" "wait_on_compartments" {
  depends_on      = [module.lz_compartments]
  create_duration = "70s"
}

resource "time_sleep" "wait_on_services_policy" {
  depends_on      = [module.lz_policies]
  create_duration = "70s"
}