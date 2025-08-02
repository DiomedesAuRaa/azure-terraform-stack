# Development environment variables for shared services layer
# Replace these values with your actual development environment settings

# Azure subscription and tenant details are managed through GitHub Actions secrets
# and should be passed as environment variables or through Azure OIDC authentication
# subscription_id = Managed by GHA_AZURE_SUBSCRIPTION_ID secret
# tenant_id = Managed by GHA_AZURE_TENANT_ID secret

# Resource naming and location
location = "eastus"              # Primary region for dev
prefix   = "dev"                # Prefix for all resources

# Access Control - Development Networks
admin_ip_ranges = [
  "203.0.113.0/24",            # Office Network
  "198.51.100.0/24"            # VPN Network
]

# Resource tagging
tags = {
  environment  = "development"
  managed_by   = "terraform"
  cost_center  = "dev-infrastructure"
  project      = "azure-infrastructure"
  owner        = "dev-team"
  backup       = "weekly"
}
