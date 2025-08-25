resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-${var.environment}-dp-rg"
  location = var.location
  tags     = var.tags
}
