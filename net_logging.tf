# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Logging Variables
#-------------------------------------------------------


locals {
    nfw_forwarding_ip_ocid = [try(module.native_oci_firewall[0].provisioned_networking_resources.oci_network_firewall_network_firewalls["OCI-NFW-KEY"].id, ""), ""][local.chosen_firewall_option == "OCINFW" ? 0 : 1]

    default_log_group_name           = "${var.service_label}-oci-firewall-log"
    default_log_group_desc           = "Core Landing Zone OCi Firewall Log group."
    firewall_threat_log_name         = "${var.service_label}-oci-firewall-threat-log"
    firewall_traffic_log_name        = "${var.service_label}-oci-firewall-traffic-log"

    logging_configuration_nfw = {
        default_compartment_id = local.security_compartment_id
        log_groups = {
            DEFAULT-LOG-GROUP = {
                name           = "${local.default_log_group_name}"
                compartment_id = local.security_compartment_id
                description    = "${local.default_log_group_desc}"
            }
        }
        service_logs = merge(
            var.enable_native_firewall_threat_log ? {
                FIREWALL-THREAT-LOG = {
                    name         = "${local.firewall_threat_log_name}"
                    log_group_id = "DEFAULT-LOG-GROUP"
                    log_type     = "${var.firewall_threat_log_type}"
                    category     = "${var.firewall_threat_log_category}"
                    resource_id  = local.nfw_forwarding_ip_ocid
                    service      = "${var.firewall_threat_log_service}"
                }
            } : {},
            var.enable_native_firewall_traffic_log ? {       
                FIREWALL-TRAFFIC-LOG = {
                    name         = "${local.firewall_traffic_log_name}"
                    log_group_id = "DEFAULT-LOG-GROUP"
                    log_type     = "${var.firewall_traffic_log_type}"
                    category     = "${var.firewall_traffic_log_category}"
                    resource_id  = local.nfw_forwarding_ip_ocid
                    service      = "${var.firewall_traffic_log_service}"
                }
            } : {}
        )    
    }
}

module "oci_native_firewall_logs" {
    count  = local.chosen_firewall_option == "OCINFW" ? 1 : 0
    
    source = "github.com/oci-landing-zones/terraform-oci-modules-observability//logging?ref=v0.1.9"
    logging_configuration = local.logging_configuration_nfw
    tenancy_ocid = var.tenancy_ocid

    depends_on = [ module.native_oci_firewall[0].provisioned_networking_resources ]
}
