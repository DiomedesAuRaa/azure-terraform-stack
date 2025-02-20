terraform {
  required_version = ">= 1.3.0"

  backend "azurerm" {
    resource_group_name   = "terraform-state-rg"
    storage_account_name  = "terraformstate12345"
    container_name        = "tfstate"
    key                   = "azure/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
