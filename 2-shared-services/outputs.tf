output "container_registry_id" {
  description = "Resource ID of the Azure Container Registry"
  value       = azurerm_container_registry.main.id
}

output "container_registry_login_server" {
  description = "Login server for the Azure Container Registry"
  value       = azurerm_container_registry.main.login_server
}

output "key_vault_id" {
  description = "Resource ID of the AKS Key Vault"
  value       = azurerm_key_vault.aks.id
}

output "key_vault_uri" {
  description = "URI of the AKS Key Vault"
  value       = azurerm_key_vault.aks.vault_uri
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace for containers"
  value       = azurerm_log_analytics_workspace.containers.id
}

output "acr_private_dns_zone_id" {
  description = "Resource ID of the private DNS zone for ACR"
  value       = azurerm_private_dns_zone.acr.id
}

output "aks_private_dns_zone_id" {
  description = "Resource ID of the private DNS zone for AKS"
  value       = azurerm_private_dns_zone.aks.id
}
