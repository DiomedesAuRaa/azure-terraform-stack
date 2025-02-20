resource "azurerm_storage_account" "blob_storage" {
  name                     = "mystorageaccount"
  resource_group_name      = var.resource_group_name
  location                = var.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blob_container" {
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.blob_storage.name
  container_access_type = "private"
}
