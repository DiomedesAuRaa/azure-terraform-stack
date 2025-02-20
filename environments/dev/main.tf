module "aks" {
  source              = "../../modules/aks"
  location           = var.location
  resource_group_name = var.resource_group_name
}

module "vm" {
  source              = "../../modules/vm"
  location           = var.location
  resource_group_name = var.resource_group_name
}
