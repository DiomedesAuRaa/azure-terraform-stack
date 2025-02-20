resource "azurerm_function_app" "functions" {
  name                       = "my-function-app"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.functions_plan.id
  storage_account_name       = azurerm_storage_account.functions_storage.name
  storage_account_access_key = azurerm_storage_account.functions_storage.primary_access_key
}

resource "azurerm_app_service_plan" "functions_plan" {
  name                = "functions-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_storage_account" "functions_storage" {
  name                     = "mystorageaccount"
  resource_group_name      = var.resource_group_name
  location                = var.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
}
