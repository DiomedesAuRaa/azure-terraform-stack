# Azure Infrastructure Stack with Terraform

This repository contains a modular Terraform configuration for deploying a production-ish-ready Azure infrastructure with a focus on AKS (Azure Kubernetes Service). The infrastructure is organized in layers, each building upon the previous one to create a complete, secure, and scalable environment.

## Stack Architecture

```
azure-terraform-stack/
├── 0-bootstrap/              # Initial setup and state storage
├── 1-foundations/           # Core networking and security
├── 2-shared-services/      # Shared infrastructure services
├── 3-platform/            # Application infrastructure (AKS)
└── modules/              # Reusable Terraform modules
    ├── vnet/           # Network configuration module
    └── aks/           # AKS cluster module
```

### Layer Details

1. **Bootstrap (0-bootstrap/)**
   - Terraform state storage account
   - Key Vault for sensitive values
   - Azure AD groups for Terraform administration
   - Initial RBAC configuration

2. **Foundations (1-foundations/)**
   - Hub network architecture
   - Azure Firewall
   - VPN Gateway
   - Network security groups
   - Core networking configuration

3. **Shared Services (2-shared-services/)**
   - Azure Container Registry
   - Key Vault for AKS
   - Log Analytics workspace
   - Private DNS zones
   - Monitoring configuration

4. **Platform (3-platform/)**
   - AKS clusters
   - Spoke networks
   - Network peering
   - Application infrastructure

## Prerequisites

- Azure Subscription
- Azure CLI (latest version)
- Terraform (>= 1.0)
- Kubernetes v1.31.3 (AKS)
- Contributor access to the subscription
- Azure AD permissions to create groups and assign roles

## Getting Started

### 1. Initial Setup

```bash
# Login to Azure
az login
az account set --subscription "Your Subscription Name"

# Clone the repository
git clone https://github.com/DiomedesAuRaa/azure-terraform-stack.git
cd azure-terraform-stack
```

### 2. Deploy Each Layer

Deploy the layers in sequence:

#### Bootstrap Layer
```bash
cd 0-bootstrap
terraform init
terraform plan -out=bootstrap.tfplan
terraform apply bootstrap.tfplan
```

#### Foundations Layer
```bash
cd ../1-foundations
terraform init
terraform plan -out=foundations.tfplan
terraform apply foundations.tfplan
```

#### Shared Services Layer
```bash
cd ../2-shared-services
terraform init
terraform plan -out=shared.tfplan
terraform apply shared.tfplan
```

#### Platform Layer
```bash
cd ../3-platform
terraform init
terraform plan -out=platform.tfplan
terraform apply platform.tfplan
```

## Configuration

Each layer has its own set of configuration files:
- `backend.tf` - State storage configuration
- `main.tf` - Main resource definitions
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `env/*.tfvars` - Environment-specific variables

### Environment Configuration

Each layer contains an `env` directory with environment-specific tfvars files:
```
layer/
├── env/
│   ├── dev.tfvars     # Development environment
│   ├── staging.tfvars # Staging environment
│   └── prod.tfvars    # Production environment
```

To apply configuration for a specific environment:
```bash
# For development
terraform plan -var-file="env/dev.tfvars" -out=dev.tfplan
terraform apply dev.tfplan

# For production
terraform plan -var-file="env/prod.tfvars" -out=prod.tfplan
terraform apply prod.tfplan
```

### Example env/dev.tfvars

```hcl
subscription_id = "your-subscription-id"
tenant_id       = "your-tenant-id"
location        = "eastus"
prefix          = "prod"
tags = {
  environment = "production"
  managed_by  = "terraform"
  project     = "infrastructure"
}
```

## Security Features

- Private AKS cluster
- Network isolation with hub-spoke topology
- Azure Firewall for network security
- Private endpoints for PaaS services
- RBAC integration
- Managed identities
- Network security groups

## Monitoring and Logging

- Azure Monitor integration
- Log Analytics workspace
- Container insights
- Network monitoring
- Diagnostic settings

## Best Practices Implemented

1. **State Management**
   - Remote state storage
   - State file separation by layer
   - State access control

2. **Security**
   - Network segmentation
   - Least privilege access
   - Private endpoints
   - Managed identities

3. **Networking**
   - Hub-spoke topology
   - Network security groups
   - Private DNS zones
   - Service isolation

4. **Scalability**
   - Modular design
   - Autoscaling configuration
   - Resource distribution

## Module Usage

### VNet Module
```hcl
module "network" {
  source = "../modules/vnet"
  
  name                = "example-vnet"
  resource_group_name = "example-rg"
  location            = "eastus"
  address_space       = ["10.0.0.0/16"]
  
  subnets = {
    "subnet1" = {
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}
```

### AKS Module
```hcl
module "aks" {
  source = "../modules/aks"
  
  name                = "example-aks"
  resource_group_name = "example-rg"
  location            = "eastus"
  
  default_node_pool = {
    name                = "default"
    vm_size            = "Standard_DS2_v2"
    enable_auto_scaling = true
    node_count         = 2
    min_count          = 1
    max_count          = 3
    os_disk_size_gb    = 128
    max_pods           = 30
  }
}
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Update documentation
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Maintainers

- Your Organization/Team

## Notes

- Always review and test changes in a non-production environment first
- Keep Terraform and provider versions up to date
- Regularly review and update security configurations
- Monitor costs and optimize resource usage
