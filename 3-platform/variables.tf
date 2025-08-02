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

variable "kubernetes_version" {
  description = "Version of Kubernetes to use for the AKS cluster"
  type        = string
  default     = "1.26.3"
}

variable "aks_vnet_cidr" {
  description = "Address space for AKS VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "aks_subnet_cidr" {
  description = "Address space for AKS subnet"
  type        = list(string)
  default     = ["10.1.0.0/22"]
}

variable "aks_service_cidr" {
  description = "CIDR range for Kubernetes services"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
  default     = "10.0.0.10"
}

variable "aks_docker_bridge_cidr" {
  description = "CIDR range for the Docker bridge network"
  type        = string
  default     = "172.17.0.1/16"
}

variable "aks_default_node_pool" {
  description = "Default node pool configuration for AKS"
  type = object({
    name                = string
    vm_size            = string
    enable_auto_scaling = bool
    node_count         = number
    min_count          = number
    max_count          = number
    os_disk_size_gb    = number
    max_pods           = number
  })
  default = {
    name                = "default"
    vm_size            = "Standard_DS2_v2"
    enable_auto_scaling = true
    node_count         = 2
    min_count          = 1
    max_count          = 3
    os_disk_size_gb    = 128
    max_pods           = 30
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "production"
    managed_by  = "terraform"
  }
}
