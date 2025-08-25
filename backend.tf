terraform {
  backend "azurerm" {
    resource_group_name  = var.tfstate_rg_name
    storage_account_name = var.tfstate_sa_name
    container_name       = var.tfstate_container
    key                  = "synapse-platform-${var.environment}.tfstate"
  }
}
