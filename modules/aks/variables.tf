variable "name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use"
  type        = string
}

variable "network_plugin" {
  description = "Network plugin to use for networking (azure or kubenet)"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy to use (azure or calico)"
  type        = string
  default     = "azure"
}

variable "vnet_subnet_id" {
  description = "ID of the subnet where the AKS cluster will be deployed"
  type        = string
}

variable "service_cidr" {
  description = "CIDR range for service IPs"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address within the service CIDR for the DNS service"
  type        = string
  default     = "10.0.0.10"
}

variable "docker_bridge_cidr" {
  description = "CIDR range for the Docker bridge network"
  type        = string
  default     = "172.17.0.1/16"
}

variable "default_node_pool" {
  description = "Default node pool configuration"
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
}

variable "additional_node_pools" {
  description = "Additional node pool configurations"
  type = map(object({
    vm_size            = string
    enable_auto_scaling = bool
    node_count         = number
    min_count          = number
    max_count          = number
    os_disk_size_gb    = number
    max_pods           = number
    node_labels        = map(string)
    node_taints        = list(string)
  }))
  default = {}
}

variable "acr_id" {
  description = "Resource ID of the Azure Container Registry"
  type        = string
}

variable "key_vault_id" {
  description = "Resource ID of the Key Vault"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace"
  type        = string
}

variable "private_cluster_enabled" {
  description = "Enable private cluster"
  type        = bool
  default     = true
}

variable "private_dns_zone_id" {
  description = "Resource ID of the private DNS zone"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "maintenance_window" {
  description = "Maintenance window configuration for the AKS cluster"
  type = object({
    allowed = list(object({
      day   = string
      hours = list(number)
    }))
    not_allowed = list(object({
      start = string
      end   = string
    }))
  })
  default = null
}

variable "auto_upgrade_channel" {
  description = "The auto upgrade channel for the AKS cluster"
  type        = string
  default     = "stable"  # Options: none, patch, stable, rapid, node-image
}

variable "workload_identity_enabled" {
  description = "Enable workload identity"
  type        = bool
  default     = true
}

variable "oidc_issuer_enabled" {
  description = "Enable OIDC issuer"
  type        = bool
  default     = true
}

variable "azure_policy_enabled" {
  description = "Enable Azure Policy Add-on"
  type        = bool
  default     = true
}

variable "host_encryption_enabled" {
  description = "Enable host encryption for default and additional node pools"
  type        = bool
  default     = true
}

variable "automatic_channel_upgrade" {
  description = "The upgrade channel for this Kubernetes Cluster"
  type        = string
  default     = "stable"  # Options: none, patch, rapid, stable
}

variable "enable_monitoring" {
  description = "Enable monitoring and alerts for the AKS cluster"
  type        = bool
  default     = true
}

variable "action_group_id" {
  description = "ID of the action group for alerts"
  type        = string
  default     = null  # Should be provided if enable_monitoring is true
}

variable "alert_settings" {
  description = "Alert settings for the AKS cluster"
  type = object({
    node_cpu_percentage_threshold    = number
    node_memory_percentage_threshold = number
    pod_cpu_percentage_threshold     = number
    pod_memory_percentage_threshold  = number
    disk_usage_percentage_threshold  = number
  })
  default = {
    node_cpu_percentage_threshold    = 80
    node_memory_percentage_threshold = 80
    pod_cpu_percentage_threshold     = 80
    pod_memory_percentage_threshold  = 80
    disk_usage_percentage_threshold  = 80
  }
}
