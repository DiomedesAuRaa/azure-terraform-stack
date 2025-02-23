terraform {
  backend "azurerm" {
    resource_group_name   = "my-terraform-azure"
    storage_account_name  = "terraformstate1740341154"
    container_name        = "aks-state"
    key                   = "terraform.tfstate"
  }
}
