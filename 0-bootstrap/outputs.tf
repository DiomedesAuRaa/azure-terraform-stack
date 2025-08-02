output "terraform_state_account_name" {
  description = "Name of the storage account containing terraform state"
  value       = azurerm_storage_account.terraform_state.name
}

output "terraform_state_container_name" {
  description = "Name of the container containing terraform state"
  value       = azurerm_storage_container.terraform_state.name
}

output "terraform_state_resource_group_name" {
  description = "Name of the resource group containing terraform state storage"
  value       = azurerm_resource_group.bootstrap.name
}

output "key_vault_name" {
  description = "Name of the Key Vault for terraform secrets"
  value       = azurerm_key_vault.terraform.name
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault"
  value       = azurerm_key_vault.terraform.id
}

output "terraform_admins_group_id" {
  description = "Object ID of the Terraform Admins Azure AD group"
  value       = azuread_group.terraform_admins.object_id
}
