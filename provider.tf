terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.35.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "d4653e11-0a2d-49b3-96c0-98f8a0f03cbb"
  # Configuration options
}