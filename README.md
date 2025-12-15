# Azure Infrastructure Stack with Terraform

This repository contains a production-grade Terraform configuration for Azure infrastructure with AKS, optimized to also run in a cost-effective testing environment. While the architecture follows enterprise best practices, it includes configurations for both production and low-cost testing scenarios.

## Cost-Optimized Testing

This infrastructure can be deployed in a cost-effective way for testing:

### Test Mode Features
- Single-node AKS cluster with burstable VM (Standard_B2s)
- Optional Azure Firewall deployment (disabled by default)
- Basic tier Container Registry
- Minimal Log Analytics retention (7 days)
- Reduced monitoring and diagnostics
- Auto-shutdown capabilities

### Estimated Monthly Costs (Test Mode)
- AKS: ~$30-40/month (single node, burstable VM)
- Container Registry (Basic): ~$5/month
- Storage and Networking: ~$10-15/month
- Log Analytics: ~$5/month with quotas
Total: ~$50-65/month

### Production vs Testing Configurations

Component | Production | Test Mode
----------|------------|----------
AKS Nodes | 3+ nodes (DS4_v2) | 1 node (B2s)
Auto-scaling | Enabled | Disabled
Azure Firewall | Premium SKU | Optional/Basic SKU
Container Registry | Premium SKU | Basic SKU
Log Analytics | 30 days retention | 7 days retention
Monitoring | Full suite | Basic metrics

### Switching to Production
To switch to production configuration:
1. Update node pool configurations in `3-platform/env/prod.tfvars`
2. Enable Azure Firewall in `1-foundations/env/prod.tfvars`
3. Upgrade ACR to Premium SKU in shared services
4. Increase Log Analytics retention
5. Enable full monitoring suite

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
- Terraform (>= 1.7.0)
- Kubernetes v1.31.3 (AKS)
- Azure Provider (~> 4.0)
- Contributor access to the subscription
- Azure AD permissions to create groups and assign roles
- (Optional) pre-commit for local validation

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
3. Run pre-commit hooks: `pre-commit run --all-files`
4. Update documentation
5. Submit a pull request

### Pre-commit Setup
```bash
pip install pre-commit
pre-commit install
```

### Terraform Formatting
```bash
# Format all Terraform files
terraform fmt -recursive

# Validate configuration
terraform validate
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Maintainers

- Your Organization/Team

## Notes

- Always review and test changes in a non-production environment first
- Keep Terraform and provider versions up to date
- Regularly review and update security configurations
- Monitor costs and optimize resource usage

## Cost Management

### Cost Optimization Features
1. **Conditional Resource Deployment**
   - Azure Firewall can be disabled for testing
   - Optional components can be turned off when not needed

2. **Resource Sizing**
   - AKS uses burstable B-series VMs in test mode
   - Minimal node count in testing
   - Reduced storage sizes and retention periods

3. **Best Practices for Cost Control**
   - Use auto-shutdown for dev/test environments
   - Monitor resource usage with Azure Cost Management
   - Clean up unused resources regularly
   - Use Azure Reserved Instances for production

### Cost Saving Tips
1. **Development/Testing**
   - Stop AKS cluster during non-working hours
   - Use Azure Dev/Test subscription benefits
   - Monitor and clean up unused images in ACR
   - Set budget alerts in Azure Cost Management

2. **Scaling to Production**
   - Review and adjust resource sizes based on actual usage
   - Enable autoscaling with appropriate boundaries
   - Use Azure Spot instances for non-critical workloads
   - Implement proper tagging for cost allocation

### Monitoring Costs
```bash
# Set up budget alert (using Azure CLI)
az account set --subscription "Your-Sub-Name"
az monitor metrics alert create \
    --name "Monthly Budget Alert" \
    --resource-group "your-rg" \
    --scopes "/subscriptions/your-sub-id" \
    --condition "total cost > 100" \
    --description "Monthly budget exceeded"
```

## Development Environment Setup

### Local Development
1. **Prerequisites**
   ```bash
   az account set --subscription "Your-Sub-Name"
   az feature register --namespace Microsoft.ContainerService --name AKS-ExtensionManager
   az provider register --namespace Microsoft.ContainerService
   ```

2. **Environment Variables**
   ```bash
   export ARM_SUBSCRIPTION_ID="your-subscription-id"
   export ARM_TENANT_ID="your-tenant-id"
   export TF_VAR_subscription_id="$ARM_SUBSCRIPTION_ID"
   export TF_VAR_tenant_id="$ARM_TENANT_ID"
   ```

### Testing Workflow
1. Deploy infrastructure in test mode
2. Validate functionality with minimal resources
3. Test your applications and configurations
4. Destroy resources when not in use:
   ```bash
   # Stop AKS cluster for cost saving
   az aks stop --name your-aks-cluster --resource-group your-rg
   
   # Start when needed again
   az aks start --name your-aks-cluster --resource-group your-rg
   ```

### Moving to Production
When ready to deploy to production:
1. Update tfvars files with production values
2. Enable all security features
3. Scale resources appropriately
4. Enable full monitoring
5. Review and implement all compliance requirements

Remember: The test configuration maintains the same architecture as production but with minimal resource allocation to save costs during development and testing phases.
