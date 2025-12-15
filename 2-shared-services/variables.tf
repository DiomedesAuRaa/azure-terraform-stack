variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}

variable "backend_resource_group_name" {
  description = "Resource group name for Terraform state storage"
  type        = string
  default     = "rg-terraform-bootstrap"
}

variable "backend_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
}

variable "backend_container_name" {
  description = "Container name for Terraform state"
  type        = string
  default     = "tfstate"
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

variable "acr_sku" {
  description = "SKU for Azure Container Registry (Basic, Standard, or Premium)"
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "acr_admin_enabled" {
  description = "Enable admin user for ACR (not recommended for production)"
  type        = bool
  default     = false
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

variable "log_analytics_retention_days" {
  description = "Log Analytics workspace retention in days (30-730)"
  type        = number
  default     = 30

  validation {
    condition     = var.log_analytics_retention_days >= 30 && var.log_analytics_retention_days <= 730
    error_message = "Log Analytics retention must be between 30 and 730 days."
  }
}

variable "log_analytics_daily_quota_gb" {
  description = "Daily quota for Log Analytics workspace in GB (use -1 for unlimited)"
  type        = number
  default     = -1
}
