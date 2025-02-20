# Azure Terraform Deployment

This repository contains Terraform configurations for deploying:

- Azure Kubernetes Service (AKS)
- Virtual Machines
- Azure Blob Storage
- Azure Functions
- Azure SQL
- CosmosDB
- Databricks

## Prerequisites
- Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Configure Azure credentials:
  ```sh
  az login
  ```

## Deploying All Services
1. Navigate to the environment (`dev` or `prod`):
   ```sh
   cd environments/dev
   ```
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```
4. The output will display service details.

## Selective Module Deployment
To enable or disable specific modules, pass the appropriate variables. For example, to only deploy AKS and Blob Storage:
```sh
terraform apply \
  -var="enable_aks=true" \
  -var="enable_vm=false" \
  -var="enable_blob_storage=true" \
  -var="enable_functions=false" \
  -var="enable_sql=false" \
  -var="enable_cosmosdb=false" \
  -var="enable_databricks=false"
```

## Destroying Resources
```sh
terraform destroy -auto-approve
```
Run this in the environment directory.
