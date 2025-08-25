output "id" { value = azurerm_synapse_workspace.this.id }
output "name" { value = azurerm_synapse_workspace.this.name }
output "principal_id" { value = azurerm_synapse_workspace.this.identity[0].principal_id }
