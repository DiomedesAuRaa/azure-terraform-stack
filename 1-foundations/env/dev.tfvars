# Development environment variables for foundations layer
# Replace these values with your actual development environment settings

# Azure subscription and tenant details are managed through GitHub Actions secrets
# and should be passed as environment variables or through Azure OIDC authentication
# subscription_id = Managed by GHA_AZURE_SUBSCRIPTION_ID secret
# tenant_id = Managed by GHA_AZURE_TENANT_ID secret

# Resource naming and location
location = "eastus"              # Primary region for dev
prefix   = "dev"                # Prefix for all resources

# Network configuration - Development CIDR ranges
hub_address_space       = ["10.0.0.0/16"]           # Development address space
gateway_subnet_prefix   = ["10.0.0.0/24"]           # VPN Gateway subnet
firewall_subnet_prefix  = ["10.0.1.0/24"]           # Azure Firewall subnet
management_subnet_prefix = ["10.0.2.0/24"]          # Management subnet

management_nsg_rules = [
  {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "22"
    source_address_prefix     = "VirtualNetwork"
    destination_address_prefix = "*"
  },
  {
    name                       = "allow_rdp"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "3389"
    source_address_prefix     = "VirtualNetwork"
    destination_address_prefix = "*"
  }
]

tags = {
  environment = "development"
  managed_by  = "terraform"
  cost_center = "dev-infrastructure"
  project     = "azure-infrastructure"
}
