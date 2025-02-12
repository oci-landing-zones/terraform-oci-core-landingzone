# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  firewall_options = {
    "Don't deploy any network appliance at this time" = "NO",
    "Palo Alto Networks VM-Series Firewall"           = "PALOALTO",
    "Fortinet FortiGate Firewall"                     = "FORTINET",
    "Check Point CloudGuard Firewall"                 = "CHECKPOINT", # Not available
    "Cisco Secure Firewall"                           = "CISCO",      # Not available
    "User-Provided Virtual Network Appliance"         = "CUSTOM",
    "OCI Native Firewall"                             = "OCINFW"
  }

  image_name_database = {
    "PALOALTO" = ["Palo Alto Networks VM-Series Next Generation Firewall", var.net_palo_alto_version]
    "FORTINET" = ["FortiGate Next-Gen Firewall (BYOL)", var.net_fortigate_version ]
  }

  chosen_firewall_option = local.firewall_options[var.hub_vcn_deploy_net_appliance_option]

  health_checkers = {
    "FORTINET" = {
      protocol = "HTTP"
      port = 8008
      return_code = 200
      url_path = "/"
    }
    "PALOALTO" = {
      protocol = "HTTPS"
      port = 443
      return_code = 200
      url_path = "/php/login.php"
    }
    "CUSTOM" = {
      protocol = "HTTP"
      port = 80
      return_code = 200
      url_path = "/"
    }
  }

  #fortigate_image_ocid = "ocid1.image.oc1..aaaaaaaaq57pywudjr5yogjtl6qf3zs3yrwv66b5ooeiqykjgnneuerhfnia"

  # current_image_name     = local.image_name_database[local.chosen_firewall_option][0]
  # current_publisher_name = local.image_name_database[local.chosen_firewall_option][1]

  image_source  = local.chosen_firewall_option == "CUSTOM" ? "custom_image" : "marketplace_image"
  image_options = local.chosen_firewall_option == "CUSTOM" ? {
    "custom_image" = {
      ocid = var.net_appliance_image_ocid
    }
  } : {
    "marketplace_image" = local.chosen_firewall_option != "NO" && local.chosen_firewall_option != "OCINFW" ? {
      name    = local.image_name_database[local.chosen_firewall_option][0]
      version = local.image_name_database[local.chosen_firewall_option][1]
    } : {}
  }
  
  instances_configuration = local.chosen_firewall_option != "NO" && local.chosen_firewall_option != "OCINFW" ? {
    default_compartment_id      = local.network_compartment_id
    default_ssh_public_key_path = var.net_appliance_public_rsa_key
    instances = {
      FW-1 = {
        name  = format("%s-%s", var.net_appliance_name_prefix, "1")
        shape = var.net_appliance_shape
        flex_shape_settings = {
          memory = var.net_appliance_flex_shape_memory
          ocpus  = var.net_appliance_flex_shape_cpu
        }
        (local.image_source) = local.image_options[local.image_source]
        placement = {
          availability_domain = 1
          fault_domain        = 1
        }
        boot_volume = {
          size                          = var.net_appliance_boot_volume_size
          preserve_on_instance_deletion = true
          measured_boot                 = true
        }
        networking = {
          hostname                = "fw-1"
          subnet_id               = module.lz_network.provisioned_networking_resources.subnets["MGMT-SUBNET"].id
          network_security_groups = [module.lz_network.flat_map_of_provisioned_networking_resources["HUB-VCN-MGMT-NSG"].id]
          secondary_vnics = {
            INDOOR = {
              display_name            = "fw-1-indoor"
              hostname                = "fw-1-indoor"
              subnet_id               = module.lz_network.provisioned_networking_resources.subnets["INDOOR-SUBNET"].id
              network_security_groups = [module.lz_network.flat_map_of_provisioned_networking_resources["HUB-VCN-INDOOR-NLB-NSG"].id]
              skip_source_dest_check  = true
            }
            OUTDOOR = {
              display_name            = "fw-1-outdoor"
              hostname                = "fw-1-outdoor"
              subnet_id               = module.lz_network.provisioned_networking_resources.subnets["OUTDOOR-SUBNET"].id
              network_security_groups = [module.lz_network.flat_map_of_provisioned_networking_resources["HUB-VCN-OUTDOOR-NLB-NSG"].id]
              skip_source_dest_check  = true
            }
          }
        }
        encryption = {
          encrypt_in_transit_on_instance_create = null
          encrypt_in_transit_on_instance_update = null
        }
      }
      FW-2 = {
        name  = format("%s-%s", var.net_appliance_name_prefix, "2")
        shape = var.net_appliance_shape
        flex_shape_settings = {
          memory = var.net_appliance_flex_shape_memory
          ocpus  = var.net_appliance_flex_shape_cpu
        },
        (local.image_source) = local.image_options[local.image_source]
        placement = {
          availability_domain = 2
          fault_domain        = 1
        }
        boot_volume = {
          size                          = var.net_appliance_boot_volume_size
          preserve_on_instance_deletion = true
          measured_boot                 = true
        }
        networking = {
          hostname                = "fw-2"
          subnet_id               = module.lz_network.provisioned_networking_resources.subnets["MGMT-SUBNET"].id
          network_security_groups = [module.lz_network.flat_map_of_provisioned_networking_resources["HUB-VCN-MGMT-NSG"].id]
          secondary_vnics = {
            INDOOR = {
              display_name            = "fw-2-indoor"
              hostname                = "fw-2-indoor"
              subnet_id               = module.lz_network.provisioned_networking_resources.subnets["INDOOR-SUBNET"].id
              network_security_groups = [module.lz_network.flat_map_of_provisioned_networking_resources["HUB-VCN-INDOOR-NLB-NSG"].id]
              skip_source_dest_check  = true
            }
            OUTDOOR = {
              display_name            = "fw-2-outdoor"
              hostname                = "fw-2-outdoor"
              subnet_id               = module.lz_network.provisioned_networking_resources.subnets["OUTDOOR-SUBNET"].id
              network_security_groups = [module.lz_network.flat_map_of_provisioned_networking_resources["HUB-VCN-OUTDOOR-NLB-NSG"].id]
              skip_source_dest_check  = true
            }
          }
        }
        encryption = {
          encrypt_in_transit_on_instance_create = null
          encrypt_in_transit_on_instance_update = null
        }
      }
    }
  } : null
  nlb_configuration = local.chosen_firewall_option != "NO" && local.chosen_firewall_option != "OCINFW" ? {
    default_compartment_id = local.network_compartment_id
    nlbs = {
      INDOOR_NLB = {
        display_name = "isv-indoor-nlb"
        is_private   = true
        subnet_id    = module.lz_network.provisioned_networking_resources.subnets["INDOOR-SUBNET"].id
        listeners = {
          LISTENER-1 = {
            port     = 0
            protocol = "ANY"
            backend_set = {
              name = "default-backend-set"
              health_checker = local.health_checkers[local.chosen_firewall_option]
              backends = {
                BACKENDS-1 = {
                  name       = "backend-1"
                  port       = 0
                  ip_address = module.lz_firewall_appliance[0].secondary_vnics["FW-1.INDOOR"].private_ip_address
                }
                BACKENDS-2 = {
                  name       = "backend-2"
                  port       = 0
                  ip_address = module.lz_firewall_appliance[0].secondary_vnics["FW-2.INDOOR"].private_ip_address
                }
              }
            }
          }
        }
      }
      OUTDOOR-NLB = {
        display_name = "isv-outdoor-nlb"
        is_private   = true
        subnet_id    = module.lz_network.provisioned_networking_resources.subnets["OUTDOOR-SUBNET"].id
        listeners = {
          LISTENER-1 = {
            port     = 0
            protocol = "ANY"
            backend_set = {
              name = "default-backend-set"
              health_checker = local.health_checkers[local.chosen_firewall_option]
              backends = {
                BACKEND-1 = {
                  name       = "backend-1"
                  port       = 0
                  ip_address = module.lz_firewall_appliance[0].secondary_vnics["FW-1.OUTDOOR"].private_ip_address
                },
                BACKEND-2 = {
                  name       = "backend-2"
                  port       = 0
                  ip_address = module.lz_firewall_appliance[0].secondary_vnics["FW-2.OUTDOOR"].private_ip_address
                }
              }
            }
          }
        }
      }
    }
    } : null
    
    network_firewall_network_configuration = local.chosen_firewall_option == "OCINFW" ? {
        #default_enable_cis_checks = false
        network_configuration_categories = {
            native_stack = {
                non_vcn_specific_gateways = {
                    network_firewalls_configuration = {
                        network_firewalls = {
                            OCI-NFW-KEY = {
                                network_firewall_policy_id       = var.oci_nfw_policy_ocid != null ? var.oci_nfw_policy_ocid : null
                                network_firewall_policy_key      = var.oci_nfw_policy_ocid == null ? "OCI-NFW-POLICY-KEY" : null
                                display_name                     = "${var.service_label}-oci-firewall"
                                compartment_id                   = local.network_compartment_id
                                subnet_id                        = module.lz_network.provisioned_networking_resources.subnets["INDOOR-SUBNET"].id
                                network_security_group_ids       = [module.lz_network.provisioned_networking_resources.network_security_groups["HUB-VCN-OCI-FIREWALL-NSG"].id]
                            }
                        }
                        network_firewall_policies = var.oci_nfw_policy_ocid == null ? {
                            OCI-NFW-POLICY-KEY = {
                                display_name   = "${var.service_label}-oci-firewall-initial-policy"
                                compartment_id = local.network_compartment_id
                                security_rules = {
                                    OCI-NFW-SECURITY_RULES-1 = {
                                        action = "REJECT"
                                        name   = "reject-all-rule"
                                        conditions = {
                                            prd_cond1_A = {
                                                applications = []
                                                destinations = []
                                                sources      = []
                                                urls         = []
                                            }
                                        }   
                                    }
                                }
                            }
                        } : null
                    }
                }
            }
        }
    } : {}      
    
}

module "lz_firewall_appliance" {
  count                   = local.chosen_firewall_option != "NO" && local.chosen_firewall_option != "OCINFW" ? 1 : 0
  source                  = "github.com/oci-landing-zones/terraform-oci-modules-workloads//cis-compute-storage?ref=v0.1.7"
  instances_configuration = local.instances_configuration
  providers = {
    oci                                  = oci.home
    oci.block_volumes_replication_region = oci.home
  }
}

module "lz_nlb" {
  count             = local.chosen_firewall_option != "NO" && local.chosen_firewall_option != "OCINFW" ? 1 : 0
  source            = "github.com/oci-landing-zones/terraform-oci-modules-networking//modules/nlb?ref=v0.7.1"
  nlb_configuration = local.nlb_configuration
}

module "native_oci_firewall" {
  count                    = local.chosen_firewall_option == "OCINFW" ? 1 : 0
  source                   = "github.com/oci-landing-zones/terraform-oci-modules-networking?ref=v0.7.1"
  network_configuration    = local.network_firewall_network_configuration
}
