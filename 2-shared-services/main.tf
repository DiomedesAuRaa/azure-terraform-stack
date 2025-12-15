provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Get the foundation layer outputs
data "terraform_remote_state" "foundations" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = "foundations.tfstate"
    use_azuread_auth     = true
  }
}

# Resource Group for shared services
resource "azurerm_resource_group" "shared" {
  name     = "${var.prefix}-shared-services"
  location = var.location
  tags     = var.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = replace("${var.prefix}acr", "-", "")
  resource_group_name = azurerm_resource_group.shared.name
  location            = azurerm_resource_group.shared.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled

  # Network rules only available with Premium SKU
  dynamic "network_rule_set" {
    for_each = var.acr_sku == "Premium" ? [1] : []
    content {
      default_action = "Deny"
      ip_rule {
        action   = "Allow"
        ip_range = var.admin_ip_ranges[0]
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Key Vault for AKS
resource "azurerm_key_vault" "aks" {
  name                = "${var.prefix}-aks-kv"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true
  purge_protection_enabled   = true

  network_acls {
    default_action = "Deny"
    ip_rules       = var.admin_ip_ranges
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# Log Analytics for Container Insights
resource "azurerm_log_analytics_workspace" "containers" {
  name                = "${var.prefix}-container-logs"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days
  daily_quota_gb      = var.log_analytics_daily_quota_gb

  tags = var.tags
}

# Enable container monitoring solution
resource "azurerm_log_analytics_solution" "containers" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.shared.location
  resource_group_name   = azurerm_resource_group.shared.name
  workspace_resource_id = azurerm_log_analytics_workspace.containers.id
  workspace_name        = azurerm_log_analytics_workspace.containers.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

# Private DNS Zones
resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.shared.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = azurerm_resource_group.shared.name
  tags                = var.tags
}

# Link DNS zones to Hub VNet
resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                  = "acr-hub-link"
  resource_group_name   = azurerm_resource_group.shared.name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = data.terraform_remote_state.foundations.outputs.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  name                  = "aks-hub-link"
  resource_group_name   = azurerm_resource_group.shared.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = data.terraform_remote_state.foundations.outputs.hub_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

# Private Endpoint for ACR
resource "azurerm_private_endpoint" "acr" {
  name                = "${var.prefix}-acr-pe"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  subnet_id           = data.terraform_remote_state.foundations.outputs.hub_subnet_ids["management"]

  private_service_connection {
    name                           = "acr-connection"
    private_connection_resource_id = azurerm_container_registry.main.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "acr-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
  }

  tags = var.tags
}

# Action group for monitoring alerts
resource "azurerm_monitor_action_group" "main" {
  name                = "${var.prefix}-action-group"
  resource_group_name = azurerm_resource_group.shared.name
  short_name          = "aksalerts"

  email_receiver {
    name                    = "ops-team"
    email_address           = var.ops_team_email
    use_common_alert_schema = true
  }

  tags = var.tags
}

# Add the variable to outputs.tf so other layers can reference it
output "monitoring_action_group_id" {
  description = "ID of the monitoring action group"
  value       = azurerm_monitor_action_group.main.id
}
