# Create the AKS cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix         = var.name
  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name                = var.default_node_pool.name
    vm_size            = var.default_node_pool.vm_size
    vnet_subnet_id     = var.vnet_subnet_id
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    node_count         = var.default_node_pool.node_count
    min_count          = var.default_node_pool.min_count
    max_count          = var.default_node_pool.max_count
    os_disk_size_gb    = var.default_node_pool.os_disk_size_gb
    max_pods           = var.default_node_pool.max_pods
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    load_balancer_sku  = "standard"
  }

  private_cluster_enabled = var.private_cluster_enabled
  private_dns_zone_id    = var.private_dns_zone_id

  role_based_access_control_enabled = true
  azure_policy_enabled            = true

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = var.tags
}

# Create additional node pools
resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.additional_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size              = each.value.vm_size
  enable_auto_scaling   = each.value.enable_auto_scaling
  node_count           = each.value.node_count
  min_count            = each.value.min_count
  max_count            = each.value.max_count
  os_disk_size_gb      = each.value.os_disk_size_gb
  max_pods             = each.value.max_pods
  vnet_subnet_id       = var.vnet_subnet_id
  node_labels          = each.value.node_labels
  node_taints          = each.value.node_taints

  tags = var.tags
}

# Grant AKS access to ACR
resource "azurerm_role_assignment" "aks_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

# Grant AKS access to Key Vault
resource "azurerm_role_assignment" "aks_kv" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

# Enable diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "${var.name}-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }
}
