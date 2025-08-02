terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-bootstrap"
    storage_account_name = "stterraformstateprod"
    container_name      = "tfstate"
    key                 = "shared-services.tfstate"
    use_azuread_auth    = true
  }
}
