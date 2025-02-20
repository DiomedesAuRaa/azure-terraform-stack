# Azure Terraform Deployment

This repository contains Terraform configurations for deploying **Azure Kubernetes Service (AKS)** and **Azure Virtual Machines (VMs)**.

## Prerequisites
- Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Authenticate with Azure:
  ```sh
  az login
  az account set --subscription \"<subscription-id>\"
  ```

## Deploying AKS Cluster
1. Navigate to the AKS directory:
   ```sh
   cd aks
   ```
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```
4. Terraform will output the cluster name.

## Deploying Virtual Machine
1. Navigate to the VM directory:
   ```sh
   cd vm
   ```
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```
4. The public IP of the VM will be displayed.

## Cleaning Up Resources
To destroy resources:
```sh
terraform destroy -auto-approve
```
Run this from  or  as needed.
# azure-terraform-stack
