output "storage_rbac_id" { value = azurerm_role_assignment.syn_to_storage.id }
output "kv_rbac_id" { value = azurerm_role_assignment.syn_to_kv.id }
