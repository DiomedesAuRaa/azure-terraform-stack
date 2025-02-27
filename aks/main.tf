data "azurerm_resource_group" "existing_rg" {
  name = "my-terraform-azure"
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  location            = data.azurerm_resource_group.existing_rg.location 
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-cluster"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  dns_prefix          = "aks-cluster"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  network_profile {
    network_plugin = "kubenet"   # Keep kubenet
    service_cidr   = "10.1.0.0/16"  # Ensure no overlap with subnet
    dns_service_ip = "10.1.0.10"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}
