# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Logging Variables
#-------------------------------------------------------


locals {
  nfw_forwarding_ip_ocid = [try(module.native_oci_firewall[0].provisioned_networking_resources.oci_network_firewall_network_firewalls["FIREWALL-VCN"].id, ""), ""][local.chosen_firewall_option == "OCINFW" ? 0 : 1]

  default_log_group_name           = "DEFAULT_LOG_GROUP_NAME"
  default_log_group_desc           = "DEFAULT_LOG_GROUP_DESCRIPATION"
  single_firewall_threat_log_name  = "CORE-LZ-OCI-NATIVE-NFW-THREAT-LOG"
  single_firewall_traffic_log_name = "CORE-LZ-OCI-NATIVE--TRAFFIC-LOG"

  logging_configuration_nfw = {
    default_compartment_id = local.security_compartment_id

    log_groups = {
      DEFAULT_LOG_GROUP = {
        name           = "${local.default_log_group_name}"
        compartment_id = local.security_compartment_id
        description    = "${local.default_log_group_desc}"
      }
    }
    service_logs = {
      FIREWALL_THREAT_LOG = {
        name         = "${var.firewall_threat_log_name}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.firewall_threat_log_type}"
        category     = "${var.firewall_threat_log_category}"
        resource_id  = local.nfw_forwarding_ip_ocid
        service      = "${var.firewall_threat_log_service}"
      }
      FIREWALL_TRAFFIC_LOG = {
        name         = "${var.firewall_traffic_log_name}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.firewall_traffic_log_type}"
        category     = "${var.firewall_traffic_log_category}"
        resource_id  = local.nfw_forwarding_ip_ocid
        service      = "${var.firewall_traffic_log_service}"
      }
    }
  }

  logging_configuration_nfw_no_log = {
    default_compartment_id = local.security_compartment_id

    log_groups = {
      DEFAULT_LOG_GROUP = {
        name           = "${local.default_log_group_name}"
        compartment_id = local.security_compartment_id
        description    = "${local.default_log_group_desc}"
      }
    }
     service_logs = {}  
  }

  logging_configuration_nfw_traffic_log = {
    default_compartment_id = local.security_compartment_id

    log_groups = {
      DEFAULT_LOG_GROUP = {
        name           = "${local.default_log_group_name}"
        compartment_id = local.security_compartment_id
        description    = "${local.default_log_group_desc}"
      }
    }

    service_logs = {
        FIREWALL_TRAFFIC_LOG = {
        name         = "${var.firewall_traffic_log_name}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.firewall_traffic_log_type}"
        category     = "${var.firewall_traffic_log_category}"
        resource_id  = local.nfw_forwarding_ip_ocid
        service      = "${var.firewall_traffic_log_service}"
        }
    }
  }


  logging_configuration_nfw_threat_log = {
    default_compartment_id = local.security_compartment_id

    log_groups = {
      DEFAULT_LOG_GROUP = {
        name           = "${local.default_log_group_name}"
        compartment_id = local.security_compartment_id
        description    = "${local.default_log_group_desc}"
      }
    }
    service_logs = {
      FIREWALL_THREAT_LOG = {
        name         = "${var.firewall_threat_log_name}"
        log_group_id = "DEFAULT_LOG_GROUP"
        log_type     = "${var.firewall_threat_log_type}"
        category     = "${var.firewall_threat_log_category}"
        resource_id  = local.nfw_forwarding_ip_ocid
        service      = "${var.firewall_threat_log_service}"
      }
    }
  }


}

module "oci_native_firewall_logs" {
  count  = local.chosen_firewall_option == "OCINFW" ? 1 : 0
  source = "github.com/oci-landing-zones/terraform-oci-modules-observability//logging?ref=v0.1.9"

  logging_configuration = var.enable_native_firewall_threat_log && var.enable_native_firewall_traffic_log ? local.logging_configuration_nfw : var.enable_native_firewall_threat_log ? local.logging_configuration_nfw_threat_log : var.enable_native_firewall_traffic_log ? local.logging_configuration_nfw_traffic_log  : local.logging_configuration_nfw_no_log


  tenancy_ocid = var.tenancy_ocid
}
