terraform {
  required_version = ">=1.1.7"  # Atualize para a versão mais recente do Terraform

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"  # Atualize para a série 3.x do provedor AzureRM
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
