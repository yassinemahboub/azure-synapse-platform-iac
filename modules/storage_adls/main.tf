locals {
  sa_name           = replace(lower("${var.name_prefix}${var.environment}adls"), "/[^a-z0-9]/", "")
  workspace_fs_name = "synfs" # for Synapse workspace binding
}

resource "azurerm_storage_account" "this" {
  name                            = substr(local.sa_name, 0, 24)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication
  is_hns_enabled                  = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
}

# Synapse workspace filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "workspace" {
  name               = local.workspace_fs_name
  storage_account_id = azurerm_storage_account.this.id
}

# Medallion containers (no folder structure)
resource "azurerm_storage_data_lake_gen2_filesystem" "lake" {
  for_each           = toset(var.lake_filesystems)
  name               = each.value
  storage_account_id = azurerm_storage_account.this.id
}
