# ===== Core =====
environment = "dev"
location    = "francecentral" # close to Morocco
name_prefix = "ym"            # <your short org/project prefix> / "ym" -> Yassine MAHBOUB

tags = {
  owner      = "data-team"
  env        = "dev"
  costCenter = "BI"
  workload   = "synapse-platform"
}

# ===== Remote state (pre-created once) =====
tfstate_rg_name   = "iac-state-rg"
tfstate_sa_name   = "iacstateweu1093"
tfstate_container = "tfstate"

# ===== Synapse admin (DO NOT COMMIT PASSWORDS) =====
synapse_sql_admin_login    = "sqladmin"
synapse_sql_admin_password = "Testing2025" # synapse_sql_admin_password comes from env var TF_VAR_synapse_sql_admin_password or DevOps secret

# ===== SKUs / Sizing =====
create_dedicated_sql_pool = false # dev usually serverless + Spark
synapse_dedicated_sql_sku = "DW100c"
spark_node_size           = "Small" # Small | Medium | Large
spark_min_nodes           = 3
spark_max_nodes           = 6

# ===== Networking =====
enable_private_networking = true # uses Private Endpoints + Private DNS

# ===== Storage =====
adls_sku = "Standard_GZRS"
