provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Get outputs from previous layers
data "terraform_remote_state" "foundations" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-bootstrap"
    storage_account_name = "stterraformstateprod"
    container_name      = "tfstate"
    key                 = "foundations.tfstate"
    use_azuread_auth    = true
  }
}

data "terraform_remote_state" "shared" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-bootstrap"
    storage_account_name = "stterraformstateprod"
    container_name      = "tfstate"
    key                 = "shared-services.tfstate"
    use_azuread_auth    = true
  }
}

# Resource Group for AKS clusters
resource "azurerm_resource_group" "platform" {
  name     = "${var.prefix}-platform"
  location = var.location
  tags     = var.tags
}

# Spoke Network for AKS
module "aks_network" {
  source = "../modules/vnet"

  name                = "${var.prefix}-aks"
  resource_group_name = azurerm_resource_group.platform.name
  location            = var.location
  address_space       = var.aks_vnet_cidr

  subnets = {
    "aks-1" = {
      address_prefixes = var.aks_subnet_cidr
    }
  }

  tags = var.tags
}

# Peering from AKS to Hub
resource "azurerm_virtual_network_peering" "aks_to_hub" {
  name                         = "aks-to-hub"
  resource_group_name          = azurerm_resource_group.platform.name
  virtual_network_name         = module.aks_network.vnet_name
  remote_virtual_network_id    = data.terraform_remote_state.foundations.outputs.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  use_remote_gateways         = true
}

# AKS Cluster
module "aks" {
  source = "../modules/aks"

  name                = "${var.prefix}-aks"
  resource_group_name = azurerm_resource_group.platform.name
  location            = var.location
  kubernetes_version  = var.kubernetes_version

  vnet_subnet_id      = module.aks_network.subnet_ids["aks-1"]
  service_cidr        = var.aks_service_cidr
  dns_service_ip      = var.aks_dns_service_ip
  docker_bridge_cidr  = var.aks_docker_bridge_cidr

  network_plugin      = "azure"
  network_policy      = "azure"

  default_node_pool   = var.aks_default_node_pool

  acr_id                     = data.terraform_remote_state.shared.outputs.container_registry_id
  key_vault_id              = data.terraform_remote_state.shared.outputs.key_vault_id
  log_analytics_workspace_id = data.terraform_remote_state.shared.outputs.log_analytics_workspace_id
  private_dns_zone_id       = data.terraform_remote_state.shared.outputs.aks_private_dns_zone_id

  tags = var.tags
}
