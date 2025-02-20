output "aks_cluster_name" {
  value = var.enable_aks ? module.aks[0].cluster_name : "AKS module disabled"
}

output "vm_public_ip" {
  value = var.enable_vm ? module.vm[0].public_ip : "VM module disabled"
}

output "blob_storage_account_name" {
  value = var.enable_blob_storage ? module.blob_storage[0].storage_account_name : "Blob Storage module disabled"
}

output "functions_app_name" {
  value = var.enable_functions ? module.functions[0].app_name : "Functions module disabled"
}

output "sql_server_name" {
  value = var.enable_sql ? module.sql[0].server_name : "SQL module disabled"
}

output "cosmosdb_account_name" {
  value = var.enable_cosmosdb ? module.cosmosdb[0].account_name : "CosmosDB module disabled"
}

output "databricks_workspace_name" {
  value = var.enable_databricks ? module.databricks[0].workspace_name : "Databricks module disabled"
}
