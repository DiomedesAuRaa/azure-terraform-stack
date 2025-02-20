variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "my-resource-group"
}

variable "enable_aks" {
  description = "Enable or disable the AKS module"
  type        = bool
  default     = true
}

variable "enable_vm" {
  description = "Enable or disable the Virtual Machines module"
  type        = bool
  default     = true
}

variable "enable_blob_storage" {
  description = "Enable or disable the Blob Storage module"
  type        = bool
  default     = true
}

variable "enable_functions" {
  description = "Enable or disable the Azure Functions module"
  type        = bool
  default     = true
}

variable "enable_sql" {
  description = "Enable or disable the Azure SQL module"
  type        = bool
  default     = true
}

variable "enable_cosmosdb" {
  description = "Enable or disable the CosmosDB module"
  type        = bool
  default     = true
}

variable "enable_databricks" {
  description = "Enable or disable the Databricks module"
  type        = bool
  default     = true
}
