variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "workspace_filesystem_id" {
  type = string # from storage_adls.workspace_filesystem_id
}

variable "create_dedicated_sql_pool" {
  type    = bool
  default = false
}

variable "dedicated_sql_sku" {
  type    = string
  default = "DW100c"
}

variable "sql_pool_storage_account_type" {
  type    = string
  default = "GRS" # allowed: "GRS" or "LRS"
}

variable "spark_version" {
  type    = string
  default = "3.3" # adjust if your region exposes a newer version
}


variable "spark_node_size" {
  type    = string
  default = "Small"
}

variable "spark_min_nodes" {
  type    = number
  default = 3
}

variable "spark_max_nodes" {
  type    = number
  default = 6
}

variable "public_network_access_enabled" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
