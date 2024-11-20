# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "release" {
  description = "The OCI Core Landing Zone release."
  value       = var.display_output ? (fileexists("${path.module}/release.txt") ? file("${path.module}/release.txt") : "undefined") : null
}

output "region" {
  description = "The region where resources have been deployed."
  value       = var.display_output ? var.region : null
}

output "cis_level" {
  description = "The CIS profile level."
  value       = var.display_output ? var.cis_level : null
}

output "service_label" {
  description = "The prefix to deployed resources."
  value       = var.display_output ? var.service_label : null
}

output "compartments" {
  description = "The deployed compartments."
  value       = var.display_output && var.extend_landing_zone_to_new_region == false ? merge({ for k, v in module.lz_compartments[0].compartments : k => { name : v.name, id : v.id } }, length(module.lz_top_compartment) > 0 ? { for k, v in module.lz_top_compartment[0].compartments : k => { name : v.name, id : v.id } } : {}) : null
}

output "vcns" {
  description = "The deployed virtual cloud networks."
  value       = var.display_output && length(module.lz_network.provisioned_networking_resources) > 0 ? { for k, v in module.lz_network.provisioned_networking_resources.vcns : k => { name : v.display_name, id : v.id } } : null
}

output "subnets" {
  description = "The deployed subnets."
  value       = var.display_output && length(module.lz_network.provisioned_networking_resources) > 0 ? { for k, v in module.lz_network.provisioned_networking_resources.subnets : k => { name : v.display_name, id : v.id } } : null
}

output "network_security_groups" {
  description = "The deployed network security groups."
  value       = var.display_output && length(module.lz_network.provisioned_networking_resources) > 0 ? { for k, v in module.lz_network.provisioned_networking_resources.network_security_groups : k => { name : v.display_name, id : v.id } } : null
}

output "dynamic_routing_gateways" {
  description = "The deployed dynamic routing gateway."
  value       = var.display_output && length(module.lz_network.provisioned_networking_resources) > 0 ? { for k, v in module.lz_network.provisioned_networking_resources.dynamic_routing_gateways : k => { name : v.display_name, id : v.id } } : null
}

output "nlb_private_ip_addresses" {
  description = "The deployed private IP addresses OCIDs."
  value       = var.display_output && length(module.lz_nlb) > 0 ? { for k, v in module.lz_nlb[0].nlbs_primary_private_ips : k => { id : v.private_ips[0].id } } : null
}


# ## Budget outputs
# output "created_budgets" {
#   description = "Budgets created by Landing Zone."
#   value       = var.display_output && var.extend_landing_zone_to_new_region == false && var.create_budget ? module.lz_budgets[0].budgets : null
# }

# output "created_budget_alert_rules" {
#   description = "Budget alert rules created by Landing Zone."
#   value       = var.display_output && var.extend_landing_zone_to_new_region == false && var.create_budget ? module.lz_budgets[0].budget_alert_rules : null
# }

# ## Cloud guard outputs
# output "created_cloud_guard_targets" {
#   description = "Cloud guard targets created by Landing Zone."
#   value       = var.display_output && var.enable_cloud_guard ? module.lz_cloud_guard[0].targets : null
# }

# ## Events and alarms outputs
# output "created_alarms" {
#   description = "Alarms created by Landing Zone."
#   value       = var.display_output ? module.lz_alarms.alarms : null
# }

# output "created_events" {
#   description = "Events created by Landing Zone."
#   value       = var.display_output ? module.lz_notifications.events : null
# }
# output "created_home_region_events" {
#   description = "Events created by Landing Zone."
#   value       = var.display_output && var.extend_landing_zone_to_new_region == false ? module.lz_home_region_notifications[0].events : null
# }

# output "created_topics" {
#   description = "Events created by Landing Zone."
#   value       = var.display_output ? module.lz_regional_topics.topics : null
# }

# output "created_home_region_topics" {
#   description = "Events created by Landing Zone."
#   value       = var.display_output && var.extend_landing_zone_to_new_region == false ? module.lz_home_region_topics[0].topics : null
# }

# ## Vault outputs
# output "created_vaults" {
#   description = "Vaults created by Landing Zone."
#   value       = var.display_output && local.enable_vault ? module.lz_vault[0].vaults : null
# }

# output "created_keys" {
#   description = "Keys created by Landing Zone."
#   value       = var.display_output && local.enable_vault ? module.lz_vault[0].keys : null
# }

# ## VSS outputs
# output "created_scanning_host_targets" {
#   description = "The VSS host targets created."
#   value       = var.display_output && var.vss_create ? module.lz_scanning[0].scanning_host_targets : null
# }

# output "created_scanning_host_recipes" {
#   description = "The VSS host targets created."
#   value       = var.display_output && var.vss_create ? module.lz_scanning[0].scanning_host_recipes : null
# }