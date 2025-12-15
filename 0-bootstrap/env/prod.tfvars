# Production environment variables for bootstrap layer
# Replace these values with your actual production environment settings

# Azure subscription and tenant details
subscription_id = "prod-00000000-0000-0000-0000-000000000000" # Prod subscription
tenant_id       = "00000000-0000-0000-0000-000000000000"      # Your tenant ID

# Resource naming and location
location           = "eastus2" # Primary region for prod
prefix             = "prod"    # Prefix for all resources
environment_suffix = "prod"    # Suffix for globally unique names

# Network security - Restrict to production networks only
allowed_ip_ranges = [
  "203.0.113.0/24",  # Example: Prod Office Network
  "198.51.100.0/24", # Example: Prod VPN Network
  "192.168.1.0/24"   # Example: Prod Data Center
]

# Resource tagging
tags = {
  environment = "production"
  managed_by  = "terraform"
  cost_center = "prod-infrastructure"
  project     = "azure-infrastructure"
  owner       = "ops-team"
  compliance  = "hipaa" # Example compliance tag
  backup      = "daily" # Example backup policy tag
}
