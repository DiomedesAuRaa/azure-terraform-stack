resource "azurerm_databricks_workspace" "databricks" {
  name                = "my-databricks-workspace"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "standard"
}
