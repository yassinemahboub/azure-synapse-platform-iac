# ===== Core =====
environment = "prod"
location    = "francecentral"
name_prefix = "ym" # <your short org/project prefix> / "ym" -> Yassine MAHBOUB

tags = {
  owner       = "data-team"
  env         = "prod"
  costCenter  = "BI"
  workload    = "synapse-platform"
  criticality = "high"
}

# ===== Remote state =====
tfstate_rg_name   = "iac-state-rg"
tfstate_sa_name   = "iacstateweu001"
tfstate_container = "tfstate"

# ===== Synapse admin (MANDATORY: secret only) =====
synapse_sql_admin_login    = "sqladmin"
synapse_sql_admin_password = "Testing2025" # synapse_sql_admin_password comes from env var TF_VAR_synapse_sql_admin_password or DevOps secret

# ===== SKUs / Sizing =====
create_dedicated_sql_pool = true     # enable dedicated pool for PROD workloads
synapse_dedicated_sql_sku = "DW300c" # adjust to workload/cost
spark_node_size           = "Medium"
spark_min_nodes           = 4
spark_max_nodes           = 10

# ===== Networking =====
enable_private_networking = true # PROD should be private-only

# ===== Storage =====
adls_sku = "Standard_GZRS"
