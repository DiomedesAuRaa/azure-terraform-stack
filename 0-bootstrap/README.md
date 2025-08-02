# Terraform Bootstrap Layer

This layer sets up the foundational infrastructure required to manage Terraform state and secrets in Azure. It creates:

1. A resource group for Terraform management
2. A storage account for Terraform state files
3. A Key Vault for storing sensitive values
4. An Azure AD group for Terraform administrators
5. Necessary RBAC permissions

## Prerequisites

- Azure CLI installed and logged in
- Terraform 1.0 or later
- Contributor access to the Azure subscription
- Azure AD permissions to create groups and assign roles

## First-time Setup

1. Log in to Azure CLI:
```bash
az login
az account set --subscription "Your Subscription Name"
```

2. Initialize Terraform:
```bash
terraform init
```

3. Create a terraform.tfvars file with your specific values (see terraform.tfvars.example)

4. Apply the configuration:
```bash
terraform plan -out bootstrap.tfplan
terraform apply bootstrap.tfplan
```

5. After successful creation, uncomment the backend configuration in backend.tf and reinitialize:
```bash
terraform init -migrate-state
```

## Security Notes

- The storage account and Key Vault are configured with network rules to restrict access
- RBAC is used for Key Vault access control
- Soft delete and purge protection are enabled for Key Vault
- Storage account has versioning enabled
- TLS 1.2 is enforced

## Next Steps

After this layer is deployed:
1. Add your Terraform administrators to the created Azure AD group
2. Use the created storage account for state files in subsequent Terraform layers
3. Use the Key Vault for storing sensitive values needed by other layers

## Outputs

- Storage account name and container for state files
- Key Vault name and resource ID
- Terraform Admins group ID
