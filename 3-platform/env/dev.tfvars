# Development environment variables for platform layer (AKS)
# Replace these values with your actual development environment settings

# Azure subscription and tenant details are managed through GitHub Actions secrets
# and should be passed as environment variables or through Azure OIDC authentication
# subscription_id = Managed by GHA_AZURE_SUBSCRIPTION_ID secret
# tenant_id = Managed by GHA_AZURE_TENANT_ID secret

# Resource naming and location
location = "eastus"              # Primary region for dev
prefix   = "dev"                # Prefix for all resources

# AKS Configuration
kubernetes_version = "1.31.3"    # AKS version 1.31.3 as requested

# Network configuration - Development CIDR ranges
aks_vnet_cidr           = ["10.1.0.0/16"]     # AKS Virtual Network
aks_subnet_cidr         = ["10.1.0.0/22"]     # AKS Subnet
aks_service_cidr        = "10.0.0.0/16"       # Kubernetes Services
aks_dns_service_ip      = "10.0.0.10"         # Kubernetes DNS Service
aks_docker_bridge_cidr  = "172.17.0.1/16"     # Docker Bridge Network

# Default node pool configuration - Minimal testing sizing
aks_default_node_pool = {
  name                = "default"              # Node pool name
  vm_size            = "Standard_B2s"         # Burstable VM size, cheaper for testing
  enable_auto_scaling = false                 # Disable autoscaling for testing
  node_count         = 1                      # Single node for testing
  min_count          = 1                      # Not used when autoscaling is disabled
  max_count          = 1                      # Not used when autoscaling is disabled
  os_disk_size_gb    = 30                    # Minimum OS disk size
  max_pods           = 30                     # Default pod count for testing
}

# Resource tagging
tags = {
  environment  = "development"
  managed_by   = "terraform"
  cost_center  = "dev-infrastructure"
  project     = "azure-infrastructure"
}
