variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource Group for the project"
  type        = string
  default     = "my-terraform-rg"
}
