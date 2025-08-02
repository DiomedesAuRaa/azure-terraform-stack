terraform {
  required_version = "~> 1.7.0"
  
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
    key                 = "foundations.tfstate"
    use_azuread_auth    = true
    use_microsoft_graph = true  # Required for modern Azure AD authentication
    
    # State locking configuration
    lock_id = "foundations"
    lock_method {
      name = "azurekeyvault"
      configuration = {
        vault_name    = "aztf-tf-kv"  # This should match your Key Vault name from bootstrap
        secret_name   = "terraform-lock-foundations"
      }
    }
  }
}
