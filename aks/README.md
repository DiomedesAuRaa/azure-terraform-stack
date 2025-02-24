# Azure AKS Terraform Setup

This repository contains Terraform configurations to deploy and manage an Azure Kubernetes Service (AKS) cluster on Microsoft Azure.

## Prerequisites

Before using this Terraform configuration, ensure you have the following tools and credentials:

- [Terraform](https://www.terraform.io/downloads.html) version `1.x` or higher
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) version `2.x` or higher
- An Azure account and appropriate permissions (such as Contributor role) in the Azure Subscription where the resources will be deployed

### Azure Service Principal (SP) Credentials

You'll need the following Azure Service Principal (SP) credentials to allow Terraform to interact with Azure:

- **ARM_CLIENT_ID**: The Client ID (App ID) of the Service Principal.
- **ARM_CLIENT_SECRET**: The Client Secret associated with the Service Principal.
- **ARM_SUBSCRIPTION_ID**: The Azure Subscription ID.
- **ARM_TENANT_ID**: The Azure Tenant ID.

Store these credentials in your GitHub repository secrets for use in CI/CD workflows.

## Setting Up Terraform

### 1. Clone the Repository

Clone this repository to your local machine to start working with the Terraform configuration.

```bash
git clone https://github.com/DiomedesAuRaa/azure-terraform-stack.git
cd azure-terraform-stack
```

### 2. Configure Azure Credentials

Make sure to set up the Azure Service Principal credentials as environment variables on your local machine or as GitHub Actions secrets. You can export them in your terminal (for local use) or configure them in the GitHub Actions workflow file:

```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

Alternatively, in the **GitHub Actions workflow**, add the secrets to the repository:

- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

### 3. Terraform Initialization

In the **aks** directory, initialize the Terraform configuration:

```bash
cd azure-terraform-stack/aks
terraform init
```

This will download the necessary provider plugins and initialize the working directory.

### 4. Terraform Plan

Run the following command to see what changes Terraform will make to your infrastructure:

```bash
terraform plan -out=tfplan
```

This will show you the resources that will be created and managed by Terraform.

### 5. Apply Terraform Configuration

Once you're happy with the plan, apply the configuration to create the resources in Azure:

```bash
terraform apply -auto-approve tfplan
```

This will create the AKS cluster and other required resources (e.g., Resource Group, Virtual Network, Subnet).

### 6. Terraform Destroy

If you want to destroy the infrastructure, you can run the following:

```bash
terraform destroy -auto-approve
```

This will tear down all resources created by the Terraform configuration.