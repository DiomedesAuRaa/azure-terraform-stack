# Production environment variables for shared services layer
# Replace these values with your actual production environment settings

# Azure subscription and tenant details are managed through GitHub Actions secrets
# and should be passed as environment variables or through Azure OIDC authentication
# subscription_id = Managed by GHA_AZURE_SUBSCRIPTION_ID secret
# tenant_id = Managed by GHA_AZURE_TENANT_ID secret

# Backend state configuration
backend_storage_account_name = "prodtfstate25xyz" # Must match your bootstrap storage account

# Resource naming and location
location = "eastus2" # Primary region for prod
prefix   = "prod"    # Prefix for all resources

# Access Control - Production Networks (more restrictive)
admin_ip_ranges = [
  "203.0.113.0/24",  # Office Network (Primary)
  "198.51.100.0/24", # VPN Network (Backup)
  "192.0.2.0/24"     # DR Site Network
]

# Container Registry Configuration
acr_sku           = "Premium" # Use Premium for production (enables network rules, geo-replication)
acr_admin_enabled = false     # Disable admin in production for security

# Operations team email for alerts
ops_team_email = "ops-team@example.com"

# Resource tagging
tags = {
  environment = "production"
  managed_by  = "terraform"
  cost_center = "prod-infrastructure"
  project     = "azure-infrastructure"
  owner       = "ops-team"
  compliance  = "hipaa"
  backup      = "daily"
}
