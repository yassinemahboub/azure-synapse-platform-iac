output "account_id" { value = azurerm_storage_account.this.id }
output "account_name" { value = azurerm_storage_account.this.name }
output "primary_dfs_endpoint" { value = azurerm_storage_account.this.primary_dfs_endpoint }
output "workspace_filesystem_id" { value = azurerm_storage_data_lake_gen2_filesystem.workspace.id }
output "lake_filesystem_names" { value = [for k, fs in azurerm_storage_data_lake_gen2_filesystem.lake : fs.name] }
