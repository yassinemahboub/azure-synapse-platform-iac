# -------- Private DNS Zones (dfs + blob), Key Vault, Synapse (dev/sql) --------

resource "azurerm_private_dns_zone" "dfs" {
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone" "syn_d" {
  name                = "privatelink.dev.azuresynapse.net"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone" "syn_s" {
  name                = "privatelink.sql.azuresynapse.net"
  resource_group_name = var.resource_group_name
}

# Link all zones to your VNet
resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each = {
    dfs   = azurerm_private_dns_zone.dfs
    blob  = azurerm_private_dns_zone.blob
    kv    = azurerm_private_dns_zone.kv
    syn_d = azurerm_private_dns_zone.syn_d
    syn_s = azurerm_private_dns_zone.syn_s
  }

  name                  = "${var.name_prefix}-${var.environment}-link-${each.key}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# -------- Private Endpoints --------
resource "azurerm_private_endpoint" "adls_dfs" {
  name                = "${var.name_prefix}-${var.environment}-pe-adls-dfs"
  location            = var.location            # <—
  resource_group_name = var.resource_group_name # <—
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = "adls-dfs"
    private_connection_resource_id = var.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }
  private_dns_zone_group {
    name                 = "adls-dfs-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.dfs.id]
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "adls_blob" {
  name                = "${var.name_prefix}-${var.environment}-pe-adls-blob"
  location            = var.location            # <—
  resource_group_name = var.resource_group_name # <—
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = "adls-blob"
    private_connection_resource_id = var.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "adls-blob-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "kv" {
  name                = "${var.name_prefix}-${var.environment}-pe-kv"
  location            = var.location            # <—
  resource_group_name = var.resource_group_name # <—
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = "kv"
    private_connection_resource_id = var.key_vault_id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
  private_dns_zone_group {
    name                 = "kv-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
  }
  tags = var.tags
}

# Synapse Dev endpoint
resource "azurerm_private_endpoint" "syn_dev" {
  name                = "${var.name_prefix}-${var.environment}-pe-syn-dev"
  location            = var.location            # <—
  resource_group_name = var.resource_group_name # <—
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = "syn-dev"
    private_connection_resource_id = var.synapse_workspace_id
    is_manual_connection           = false
    subresource_names              = ["dev"]
  }
  private_dns_zone_group {
    name                 = "syn-dev-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.syn_d.id]
  }
  tags = var.tags
}

# Synapse SQL (dedicated/serverless hostname zone is same "sql.azuresynapse.net")
resource "azurerm_private_endpoint" "syn_sql" {
  name                = "${var.name_prefix}-${var.environment}-pe-syn-sql"
  location            = var.location            # <—
  resource_group_name = var.resource_group_name # <—
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = "syn-sql"
    private_connection_resource_id = var.synapse_workspace_id
    is_manual_connection           = false
    subresource_names              = ["sql"]
  }
  private_dns_zone_group {
    name                 = "syn-sql-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.syn_s.id]
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "syn_sqlondemand" {
  name                = "${var.name_prefix}-${var.environment}-pe-syn-sqld"
  location            = var.location            # <—
  resource_group_name = var.resource_group_name # <—
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = "syn-sqlondemand"
    private_connection_resource_id = var.synapse_workspace_id
    is_manual_connection           = false
    subresource_names              = ["sqlOnDemand"]
  }
  private_dns_zone_group {
    name                 = "syn-sqld-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.syn_s.id]
  }
  tags = var.tags
}
