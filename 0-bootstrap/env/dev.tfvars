# Development environment variables for bootstrap layer
# Replace these values with your actual development environment settings

# Azure subscription and tenant details
subscription_id = "dev-00000000-0000-0000-0000-000000000000"  # Dev subscription
tenant_id       = "00000000-0000-0000-0000-000000000000"      # Your tenant ID

# Resource naming and location
location            = "eastus"              # Primary region for dev
prefix              = "dev"                 # Prefix for all resources
environment_suffix  = "dev"                # Suffix for globally unique names

# Network security
allowed_ip_ranges = [
  "203.0.113.0/24",  # Example: Dev Office Network
  "198.51.100.0/24"  # Example: Dev VPN Network
]

# Resource tagging
tags = {
  environment = "development"
  managed_by  = "terraform"
  cost_center = "dev-infrastructure"
  project     = "azure-infrastructure"
  owner       = "dev-team"
}
