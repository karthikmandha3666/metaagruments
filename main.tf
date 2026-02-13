terraform {
  required_version = ">=1.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
  subscription_id = "0bb9ef1c-c301-4845-b9a6-21a4e9b5ce8a"
}



# terraform import azurerm_resource_group.rg /subscriptions/eb2e4db4-1889-4351-9b48-102efd8a3a57/resourceGroups/import-demo-rg

# terraform import azurerm_storage_account.sa /subscriptions/eb2e4db4-1889-4351-9b48-102efd8a3a57/resourceGroups/import-demo-rg/providers/Microsoft.Storage/storageAccounts/importdemostorage12345
