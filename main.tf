# Configure the Azure provider
terraform {
  backend "azurerm" {
    resource_group_name  = "perudotnet-rg"
    storage_account_name = "terraformstpdn"
    container_name       = "tfstatedevops"
    key                  = "tfstatedevops.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "perudotnet-apps-rg"
  location = "westeurope"
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "perudotnet-apps"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "F1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                = "perudotnetwa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  site_config {
    use_32_bit_worker = true
    always_on         = false
  }
}

# Deploying sourec code from GitHub app!
# resource "azurerm_app_service_source_control" "sourcecontrol" {
#   app_id             = azurerm_linux_web_app.webapp.id
#   repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
#   branch             = "master"
#   use_manual_integration = true
#   use_mercurial      = false
# }
