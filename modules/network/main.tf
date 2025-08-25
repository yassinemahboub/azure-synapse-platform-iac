locals {
  vnet_name = "${var.name_prefix}-${var.environment}-vnet"
  pe_subnet = "${var.name_prefix}-${var.environment}-snet-pe"
}

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  address_space       = ["10.20.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "pe" {
  name                 = local.pe_subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.20.1.0/24"]

  # Leave policies at provider defaults; PEs will still succeed.
  # If your org requires explicit disable:
  # private_endpoint_network_policies_enabled = false
}

