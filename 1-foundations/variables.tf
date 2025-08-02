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

variable "hub_address_space" {
  description = "Address space for the hub virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "gateway_subnet_prefix" {
  description = "Address prefix for gateway subnet"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for Azure Firewall subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "management_subnet_prefix" {
  description = "Address prefix for management subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "management_nsg_rules" {
  description = "NSG rules for management subnet"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                  = string
    source_port_range         = string
    destination_port_range    = string
    source_address_prefix     = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "allow_ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "22"
      source_address_prefix     = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow_rdp"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                  = "Tcp"
      source_port_range         = "*"
      destination_port_range    = "3389"
      source_address_prefix     = "VirtualNetwork"
      destination_address_prefix = "*"
    }
  ]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "production"
    managed_by  = "terraform"
  }
}

variable "enable_azure_firewall" {
  description = "Enable or disable Azure Firewall deployment (disable for cost saving in testing)"
  type        = bool
  default     = false
}

variable "firewall_sku_name" {
  description = "SKU name of the Azure Firewall"
  type        = string
  default     = "Basic"  # Using Basic SKU for testing
}

variable "firewall_sku_tier" {
  description = "SKU tier of the Azure Firewall"
  type        = string
  default     = "Basic"  # Using Basic tier for testing
}
