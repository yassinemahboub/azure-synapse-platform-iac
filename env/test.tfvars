# ===== Core =====
environment = "test"
location    = "francecentral"
name_prefix = "ym" # <your short org/project prefix> / "ym" -> Yassine MAHBOUB

tags = {
  owner      = "data-team"
  env        = "test"
  costCenter = "BI"
  workload   = "synapse-platform"
}

# ===== Remote state =====
tfstate_rg_name   = "iac-state-rg"
tfstate_sa_name   = "iacstateweu001"
tfstate_container = "tfstate"

# ===== Synapse admin (set via secret) =====
synapse_sql_admin_login    = "sqladmin"
synapse_sql_admin_password = "Testing2025" # synapse_sql_admin_password comes from env var TF_VAR_synapse_sql_admin_password or DevOps secret

# ===== SKUs / Sizing =====
create_dedicated_sql_pool = false # keep costs low in TEST unless needed
synapse_dedicated_sql_sku = "DW200c"
spark_node_size           = "Medium"
spark_min_nodes           = 3
spark_max_nodes           = 8

# ===== Networking =====
enable_private_networking = true

# ===== Storage =====
adls_sku = "Standard_GZRS"
