terraform {
  required_version = ">= 1.3.0"

  backend "azurerm" {
    resource_group_name  = "my-terraform-rg"
    storage_account_name = "mytfstateaccount"
    container_name       = "tfstate"
    key                  = "azure/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
