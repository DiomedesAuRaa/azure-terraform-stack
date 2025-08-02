terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Create the state storage account
resource "azurerm_resource_group" "terraform_state" {
  name     = "${var.prefix}-terraform-state"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "${var.prefix}tfstate"
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version         = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }

  tags = var.tags
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

# Create Key Vault for shared secrets
resource "azurerm_key_vault" "terraform" {
  name                = "${var.prefix}-tf-kv"
  location            = azurerm_resource_group.terraform_state.location
  resource_group_name = azurerm_resource_group.terraform_state.name
  tenant_id          = var.tenant_id
  sku_name           = "standard"

  purge_protection_enabled   = true
  soft_delete_retention_days = 90
  enable_rbac_authorization = false  # Using access policies for backwards compatibility

  access_policy {
    tenant_id = var.tenant_id
    object_id = azuread_group.terraform_admins.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Recover", "Purge"
    ]
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.allowed_ip_ranges
  }

  tags = var.tags
}
