# ----- Core -----
variable "environment" {
  type = string
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "name_prefix" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# ----- Remote state (bootstrap once) -----
variable "tfstate_rg_name" {
  type = string
}

variable "tfstate_sa_name" {
  type = string
}

variable "tfstate_container" {
  type = string
}

# ----- Synapse admin -----
variable "synapse_sql_admin_login" {
  type = string
}

variable "synapse_sql_admin_password" {
  type      = string
  sensitive = true
}

# ----- Sizing / SKUs -----
variable "create_dedicated_sql_pool" {
  type    = bool
  default = false
}

variable "synapse_dedicated_sql_sku" {
  type    = string
  default = "DW100c"
}

variable "sql_pool_storage_account_type" {
  type    = string
  default = "GRS" # allowed: "LRS" or "GRS"
}

variable "spark_node_size" {
  type    = string
  default = "Small" # Small | Medium | Large
}

variable "spark_min_nodes" {
  type    = number
  default = 3
}

variable "spark_max_nodes" {
  type    = number
  default = 6
}

variable "spark_version" {
  type    = string
  default = "3.3"
}

# ----- Networking -----
variable "enable_private_networking" {
  type    = bool
  default = true
}

# ----- Storage -----
variable "adls_sku" {
  type    = string
  default = "Standard_GZRS"
}
