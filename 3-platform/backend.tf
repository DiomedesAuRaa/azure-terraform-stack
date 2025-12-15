terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Backend configuration is provided via -backend-config flags in CI/CD
  # This allows for environment-specific state storage
  backend "azurerm" {}
}
