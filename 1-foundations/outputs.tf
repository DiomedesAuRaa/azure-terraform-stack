output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network"
  value       = module.hub_network.vnet_id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network"
  value       = module.hub_network.vnet_name
}

output "hub_subnet_ids" {
  description = "Map of subnet names to IDs in the hub network"
  value       = module.hub_network.subnet_ids
}

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall"
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  description = "Public IP address of the Azure Firewall"
  value       = azurerm_public_ip.fw.ip_address
}

output "vpn_gateway_public_ip" {
  description = "Public IP address of the VPN Gateway"
  value       = azurerm_public_ip.vpn.ip_address
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.hub.id
}
