# ========== Resource Group ==========
module "rg" {
  source      = "./modules/rg"
  name_prefix = var.name_prefix
  environment = var.environment
  location    = var.location
  tags        = var.tags
}

# ========== Network (VNet + PE Subnet) ==========
module "network" {
  source              = "./modules/network"
  resource_group_name = module.rg.name
  location            = var.location
  name_prefix         = var.name_prefix
  environment         = var.environment
  tags                = var.tags
}

# ========== Key Vault ==========
module "keyvault" {
  source              = "./modules/keyvault"
  resource_group_name = module.rg.name
  location            = var.location
  name_prefix         = var.name_prefix
  environment         = var.environment
  tags                = var.tags
}

# ========== Storage (ADLS Gen2) ==========
module "storage" {
  source              = "./modules/storage_adls"
  resource_group_name = module.rg.name
  location            = var.location
  name_prefix         = var.name_prefix
  environment         = var.environment
  account_tier        = "Standard"
  account_replication = "GZRS"
  tags                = var.tags

}


# ========== Synapse Workspace + Pools ==========
module "synapse" {
  source              = "./modules/synapse"
  resource_group_name = module.rg.name
  location            = var.location
  name_prefix         = var.name_prefix
  environment         = var.environment

  sql_admin_login    = var.synapse_sql_admin_login
  sql_admin_password = var.synapse_sql_admin_password

  workspace_filesystem_id       = module.storage.workspace_filesystem_id
  create_dedicated_sql_pool     = var.create_dedicated_sql_pool
  dedicated_sql_sku             = var.synapse_dedicated_sql_sku
  sql_pool_storage_account_type = var.sql_pool_storage_account_type

  spark_node_size = var.spark_node_size
  spark_min_nodes = var.spark_min_nodes
  spark_max_nodes = var.spark_max_nodes
  spark_version   = var.spark_version

  public_network_access_enabled = var.enable_private_networking ? false : true
  tags                          = var.tags
}

# ========== Private Endpoints + Private DNS ==========
module "private_endpoints" {
  source = "./modules/private_endpoints"
  count  = var.enable_private_networking ? 1 : 0

  resource_group_name  = module.rg.name
  location             = var.location
  vnet_id              = module.network.vnet_id
  subnet_id            = module.network.pe_subnet_id
  name_prefix          = var.name_prefix
  environment          = var.environment
  storage_account_id   = module.storage.account_id
  key_vault_id         = module.keyvault.id
  synapse_workspace_id = module.synapse.id
  tags                 = var.tags
}

# ========== Diagnostics (Log Analytics + Diagnostic Settings) ==========
module "diagnostics" {
  source              = "./modules/diagnostics"
  resource_group_name = module.rg.name
  location            = var.location
  name_prefix         = var.name_prefix
  environment         = var.environment
  tags                = var.tags

  # pass a MAP with stable keys
  target_resources = {
    storage  = module.storage.account_id
    keyvault = module.keyvault.id
    synapse  = module.synapse.id
  }
}


# ========== RBAC (Synapse MI to ADLS/KV) ==========
module "role_assignments" {
  source               = "./modules/role_assignments"
  synapse_principal_id = module.synapse.principal_id
  storage_account_id   = module.storage.account_id
  key_vault_id         = module.keyvault.id
}
