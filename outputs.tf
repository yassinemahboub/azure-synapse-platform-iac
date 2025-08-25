output "resource_group_name" {
  value = module.rg.name
}

output "synapse_workspace_name" {
  value = module.synapse.name
}

output "storage_account_name" {
  value = module.storage.account_name
}

output "log_analytics_workspace_name" {
  value = module.diagnostics.law_name
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "private_dns_zone_ids" {
  value       = try(module.private_endpoints[0].dns_zone_ids, null)
  description = "Only populated when enable_private_networking=true"
}
