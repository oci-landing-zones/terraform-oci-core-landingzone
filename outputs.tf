## Budget outputs
output "created_budgets" {
  description = "Budgets created by Landing Zone"
  value       = var.extend_landing_zone_to_new_region == false && var.create_budget ? module.lz_budgets[0].budgets : null
}

output "created_budget_alert_rules" {
  description = "Budget alert rules created by Landing Zone"
  value       = var.extend_landing_zone_to_new_region == false && var.create_budget ? module.lz_budgets[0].budget_alert_rules : null
}

## Cloud guard outputs
output "created_cloud_guard_targets" {
  description = "Cloud guard targets created by Landing Zone"
  value       = var.enable_cloud_guard ? module.lz_cloud_guard[0].targets : null
}

## Events and alarms outputs
output "created_alarms" {
  description = "Alarms created by Landing Zone"
  value       = module.lz_alarms.alarms
}

output "created_events" {
  description = "Events created by Landing Zone"
  value       = module.lz_notifications.events
}

output "created_home_region_events" {
  description = "Events created by Landing Zone"
  value       = module.lz_home_region_notifications[0].events
}

output "created_topics" {
  description = "Events created by Landing Zone"
  value       = module.lz_regional_topics.topics
}

output "created_home_region_topics" {
  description = "Events created by Landing Zone"
  value       = module.lz_home_region_topics[0].topics
}

## Vault outputs
output "created_vaults" {
  description = "Vaults created by Landing Zone"
  value       = local.enable_vault ? module.lz_vault[0].vaults : null
}

output "created_keys" {
  description = "Keys created by Landing Zone"
  value       = local.enable_vault ? module.lz_vault[0].keys : null
}

## VSS outputs
output "created_scanning_host_targets" {
  description = "The VSS host targets created"
  value       = var.vss_create ? module.lz_scanning[0].scanning_host_targets : null
}

output "created_scanning_host_recipes" {
  description = "The VSS host targets created"
  value       = var.vss_create ? module.lz_scanning[0].scanning_host_recipes : null
}
