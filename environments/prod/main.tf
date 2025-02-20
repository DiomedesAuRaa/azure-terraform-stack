module "aks" {
  count  = var.enable_aks ? 1 : 0
  source = "../../modules/aks"
  location = var.location
  resource_group_name = var.resource_group_name
}

module "vm" {
  count  = var.enable_vm ? 1 : 0
  source = "../../modules/vm"
  location = var.location
  resource_group_name = var.resource_group_name
}

module "blob_storage" {
  count  = var.enable_blob_storage ? 1 : 0
  source = "../../modules/blob_storage"
  location = var.location
  resource_group_name = var.resource_group_name
}

module "functions" {
  count  = var.enable_functions ? 1 : 0
  source = "../../modules/functions"
  location = var.location
  resource_group_name = var.resource_group_name
}

module "sql" {
  count  = var.enable_sql ? 1 : 0
  source = "../../modules/sql"
  location = var.location
  resource_group_name = var.resource_group_name
}

module "cosmosdb" {
  count  = var.enable_cosmosdb ? 1 : 0
  source = "../../modules/cosmosdb"
  location = var.location
  resource_group_name = var.resource_group_name
}

module "databricks" {
  count  = var.enable_databricks ? 1 : 0
  source = "../../modules/databricks"
  location = var.location
  resource_group_name = var.resource_group_name
}
