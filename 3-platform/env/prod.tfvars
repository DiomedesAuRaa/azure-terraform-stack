# Production environment variables for platform layer (AKS)
# Replace these values with your actual production environment settings

# Azure subscription and tenant details are managed through GitHub Actions secrets
# and should be passed as environment variables or through Azure OIDC authentication
# subscription_id = Managed by GHA_AZURE_SUBSCRIPTION_ID secret
# tenant_id = Managed by GHA_AZURE_TENANT_ID secret

# Resource naming and location
location = "eastus2"             # Primary region for prod
prefix   = "prod"               # Prefix for all resources

# AKS Configuration
kubernetes_version = "1.31.3"    # AKS version 1.31.3 as requested

# Network configuration - Production CIDR ranges
aks_vnet_cidr           = ["10.101.0.0/16"]   # AKS Virtual Network (Production)
aks_subnet_cidr         = ["10.101.0.0/22"]   # AKS Subnet (Production)
aks_service_cidr        = "10.100.0.0/16"     # Kubernetes Services
aks_dns_service_ip      = "10.100.0.10"       # Kubernetes DNS Service
aks_docker_bridge_cidr  = "172.17.0.1/16"     # Docker Bridge Network

# Default node pool configuration - Production sizing
aks_default_node_pool = {
  name                = "default"              # Node pool name
  vm_size            = "Standard_DS4_v2"      # More powerful VM size for prod
  enable_auto_scaling = true                  # Enable cluster autoscaling
  node_count         = 3                      # Initial node count
  min_count          = 3                      # Minimum nodes for high availability
  max_count          = 10                     # Maximum nodes for scaling
  os_disk_size_gb    = 256                   # Larger OS disk for prod workloads
  max_pods           = 50                     # Higher pod density per node
}

# Resource tagging
tags = {
  environment  = "production"
  managed_by   = "terraform"
  cost_center  = "prod-infrastructure"
  project      = "azure-infrastructure"
  owner        = "ops-team"
  compliance   = "hipaa"
  backup       = "daily"
  tier         = "production"
}
