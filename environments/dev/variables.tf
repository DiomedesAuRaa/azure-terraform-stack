variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "my-resource-group"
}

variable "enable_aks" {
  default = true
}

variable "enable_vm" {
  default = true
}

variable "enable_blob_storage" {
  default = true
}

variable "enable_functions" {
  default = true
}

variable "enable_sql" {
  default = true
}

variable "enable_cosmosdb" {
  default = true
}

variable "enable_databricks" {
  default = true
}
