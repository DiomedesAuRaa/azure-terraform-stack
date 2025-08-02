output "aks_cluster_id" {
  description = "Resource ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "kube_config" {
  description = "Kubeconfig for the AKS cluster"
  value       = module.aks.kube_config
  sensitive   = true
}

output "aks_node_resource_group" {
  description = "Name of the resource group containing AKS nodes"
  value       = module.aks.node_resource_group
}

output "kubelet_identity" {
  description = "Identity used by the AKS kubelet"
  value       = module.aks.kubelet_identity
  sensitive   = true
}

output "cluster_private_fqdn" {
  description = "Private FQDN of the AKS cluster"
  value       = module.aks.cluster_private_fqdn
}
