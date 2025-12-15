# This backend configuration is commented out initially because we need to create
# the storage account first. After first run, uncomment this and run terraform init again.

# terraform {
#   backend "azurerm" {
#     resource_group_name   = "rg-terraform-bootstrap"
#     storage_account_name  = "stterraformstate"
#     container_name       = "tfstate"
#     key                  = "bootstrap.tfstate"
#     use_azuread_auth    = true
#   }
# }

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
  }
}
