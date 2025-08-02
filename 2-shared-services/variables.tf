variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "The Azure region to deploy resources to"
  type        = string
  default     = "eastus"
}

variable "admin_ip_ranges" {
  description = "List of IP ranges that can access ACR and Key Vault"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "production"
    managed_by  = "terraform"
  }
}

variable "ops_team_email" {
  description = "Email address for the operations team to receive alerts"
  type        = string
}
