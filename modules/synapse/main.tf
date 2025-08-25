resource "azurerm_synapse_workspace" "this" {
  name                                 = "${var.name_prefix}-${var.environment}-syn"
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.workspace_filesystem_id
  sql_administrator_login              = var.sql_admin_login
  sql_administrator_login_password     = var.sql_admin_password
  managed_virtual_network_enabled      = true
  public_network_access_enabled        = var.public_network_access_enabled
  identity { type = "SystemAssigned" }
  tags = var.tags
}

locals {
  # Build a base name and sanitize it step by step (no regex).
  base = lower("spk${var.name_prefix}${var.environment}")

  safe1 = replace(local.base, "-", "")
  safe2 = replace(local.safe1, "_", "")
  safe3 = replace(local.safe2, ".", "")
  safe4 = replace(local.safe3, " ", "")
  safe5 = replace(local.safe4, "/", "")
  safe6 = replace(local.safe5, "\\", "")
  safe7 = replace(local.safe6, ":", "")

  # Ensure it starts with a letter and <= 15 chars
  spark_pool_name = substr("s${local.safe7}", 0, 15)
}


resource "azurerm_synapse_spark_pool" "default" {
  name                 = local.spark_pool_name
  synapse_workspace_id = azurerm_synapse_workspace.this.id

  node_size_family = "MemoryOptimized"
  node_size        = var.spark_node_size
  spark_version    = var.spark_version # e.g., "3.3"

  # Scale settings (use EITHER auto_scale OR node_count)
  auto_scale {
    min_node_count = var.spark_min_nodes
    max_node_count = var.spark_max_nodes
  }

  auto_pause {
    delay_in_minutes = 15
  }

  tags = var.tags
}




resource "azurerm_synapse_sql_pool" "dedicated" {
  count                = var.create_dedicated_sql_pool ? 1 : 0
  name                 = "${var.name_prefix}_${var.environment}_dw"
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  sku_name             = var.dedicated_sql_sku
  create_mode          = "Default"

  storage_account_type = var.sql_pool_storage_account_type

  tags = var.tags
}
