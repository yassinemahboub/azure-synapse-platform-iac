# Synapse Managed Identity -> Storage (ADLS) data access
resource "azurerm_role_assignment" "syn_to_storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.synapse_principal_id
}

# Synapse Managed Identity -> Key Vault secrets read (RBAC)
resource "azurerm_role_assignment" "syn_to_kv" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.synapse_principal_id
}
