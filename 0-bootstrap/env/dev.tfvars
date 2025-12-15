# Development environment variables for bootstrap layer
# Replace these values with your actual development environment settings

# Azure subscription and tenant details
subscription_id = "00072068-5544-4107-bbf9-b1cb49908745" # Dev subscription
tenant_id       = "8ce2fec7-3ed5-4d21-868d-278389aa4fc1" # Your tenant ID

# Resource naming and location
location           = "eastus" # Primary region for dev
prefix             = "dev"    # Prefix for all resources
environment_suffix = "dev"    # Suffix for globally unique names
# Globally unique resource names (do not commit to git)
key_vault_name       = "dev-tf-kv-25xyz" # Must be globally unique
storage_account_name = "devtfstate25xyz" # Must be globally unique

# Network security
allowed_ip_ranges = [
  "203.0.113.0/24", # Example: Dev Office Network
  "198.51.100.0/24" # Example: Dev VPN Network
]

# Resource tagging
tags = {
  environment = "development"
  managed_by  = "terraform"
  cost_center = "dev-infrastructure"
  project     = "azure-infrastructure"
  owner       = "dev-team"
}
