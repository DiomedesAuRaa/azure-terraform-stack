# Production environment variables for foundations layer
# Replace these values with your actual production environment settings

# Azure subscription and tenant details are managed through GitHub Actions secrets
# and should be passed as environment variables or through Azure OIDC authentication
# subscription_id = Managed by GHA_AZURE_SUBSCRIPTION_ID secret
# tenant_id = Managed by GHA_AZURE_TENANT_ID secret

# Resource naming and location
location = "eastus2" # Primary region for prod
prefix   = "prod"    # Prefix for all resources

# Network configuration - Production CIDR ranges
hub_address_space        = ["10.100.0.0/16"] # Larger range for prod
gateway_subnet_prefix    = ["10.100.0.0/24"] # VPN Gateway subnet
firewall_subnet_prefix   = ["10.100.1.0/24"] # Azure Firewall subnet
management_subnet_prefix = ["10.100.2.0/24"] # Management subnet

# NSG Rules - More restrictive for production
management_nsg_rules = [
  {
    name                       = "allow_ssh_restricted"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.100.2.0/24" # Only from management subnet
    destination_address_prefix = "*"
  },
  {
    name                       = "allow_rdp_restricted"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.100.2.0/24" # Only from management subnet
    destination_address_prefix = "*"
  }
]

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
