output "aks_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "vm_public_ip" {
  description = "Public IP of the Virtual Machine"
  value       = module.vm.public_ip
}
