variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "name_prefix" { type = string }
variable "environment" { type = string }

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication" {
  type    = string
  default = "GZRS"
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Containers (filesystems) to create for our Medallion Architecture
variable "lake_filesystems" {
  type    = list(string)
  default = ["bronze", "silver", "gold", "tmp", "logs"]
}
