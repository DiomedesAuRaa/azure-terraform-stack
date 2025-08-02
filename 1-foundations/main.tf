provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource Group for Hub Network
resource "azurerm_resource_group" "hub" {
  name     = "${var.prefix}-hub-network"
  location = var.location
  tags     = var.tags
}

# Hub Network
module "hub_network" {
  source = "../modules/vnet"

  name                = "${var.prefix}-hub"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  address_space       = var.hub_address_space

  subnets = {
    "GatewaySubnet" = {
      address_prefixes = var.gateway_subnet_prefix
    }
    "AzureFirewallSubnet" = {
      address_prefixes = var.firewall_subnet_prefix
    }
    "management" = {
      address_prefixes = var.management_subnet_prefix
      nsg_rules       = var.management_nsg_rules
    }
  }

  tags = var.tags
}

# Public IPs
resource "azurerm_public_ip" "fw" {
  name                = "${var.prefix}-hub-fw-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                = "Standard"

  tags = var.tags
}

resource "azurerm_public_ip" "vpn" {
  name                = "${var.prefix}-hub-vpn-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                = "Standard"

  tags = var.tags
}

# Log Analytics Workspace for network monitoring
resource "azurerm_log_analytics_workspace" "hub" {
  name                = "${var.prefix}-hub-logs"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Azure Firewall
resource "azurerm_firewall" "hub" {
  name                = "${var.prefix}-hub-fw"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_name           = "Standard"
  sku_tier           = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.hub_network.subnet_ids["AzureFirewallSubnet"]
    public_ip_address_id = azurerm_public_ip.fw.id
  }

  tags = var.tags
}

# Enable Azure Firewall diagnostics
resource "azurerm_monitor_diagnostic_setting" "fw_diagnostics" {
  name                       = "fw-diagnostics"
  target_resource_id         = azurerm_firewall.hub.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.hub.id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  enabled_log {
    category = "AzureFirewallDnsProxy"
  }
}

# VPN Gateway
resource "azurerm_virtual_network_gateway" "hub" {
  name                = "${var.prefix}-hub-vpn"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name
  type               = "Vpn"
  vpn_type           = "RouteBased"
  sku                = "VpnGw1"
  
  ip_configuration {
    name                 = "default"
    subnet_id            = module.hub_network.subnet_ids["GatewaySubnet"]
    public_ip_address_id = azurerm_public_ip.vpn.id
  }

  tags = var.tags
}

# Enable VPN Gateway diagnostics
resource "azurerm_monitor_diagnostic_setting" "vpn_diagnostics" {
  name                       = "vpn-diagnostics"
  target_resource_id         = azurerm_virtual_network_gateway.hub.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.hub.id

  enabled_log {
    category = "GatewayDiagnosticLog"
  }

  enabled_log {
    category = "TunnelDiagnosticLog"
  }

  enabled_log {
    category = "RouteDiagnosticLog"
  }

  enabled_log {
    category = "IKEDiagnosticLog"
  }
}
