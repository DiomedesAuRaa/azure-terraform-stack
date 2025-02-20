output "aks_name" {
  value = module.aks.cluster_name
}

output "vm_public_ip" {
  value = module.vm.public_ip
}
