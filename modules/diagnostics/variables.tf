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


variable "target_resources" {
  type = map(string) # e.g., { storage = "...", keyvault = "...", synapse = "..." }
}


variable "tags" {
  type    = map(string)
  default = {}
}
