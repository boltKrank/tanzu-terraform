terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "k8sResourceGroup" {
  name     = var.resource_group_name
  location = "australiasoutheast"

  tags = {
    "Environment" = "Tanzu Demo Environment"
    "Team"        = "Tanzu Labs"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "k8sVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "australiasoutheast"
  resource_group_name = azurerm_resource_group.k8sResourceGroup.name

}