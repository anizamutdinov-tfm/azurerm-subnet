terraform {
  backend "local" {}
}
provider "azurerm" {
  features {}
}

locals {
  location    = "westeurope"
  environment = "test"
  module      = "app-007"
  slot        = "shared"
}

module "rg" {
  source      = "git@github.com:anizamutdinov-tfm/azurerm-resource-group.git"
  location    = local.location
  environment = local.environment
  module      = local.module
  slot        = local.slot
  custom_tags = { special_tag = "special_value" }
}

module "vnet" {
  source              = "git@github.com:anizamutdinov-tfm/azurerm-virtual-network.git"
  depends_on          = [module.rg]
  resource_group_name = module.rg.resource_group_name
  environment         = local.environment
  module              = local.module
  slot                = local.slot
  vnet_cidr           = ["172.16.0.0/16"]
}

module "subnet" {
  source               = "../../"
  depends_on           = [module.rg, module.vnet]
  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  environment          = local.environment
  module               = local.module
  slot                 = local.slot
  subnet_cidr          = [cidrsubnet(module.vnet.virtual_network_cidr[0], 13, 2)]
}

output "subnet_cidr" {
  value = module.subnet.subnet_cidr[0]
}