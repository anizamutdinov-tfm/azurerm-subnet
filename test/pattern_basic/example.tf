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
  subnets = {
    blue   = 16
    green  = 173
    yellow = 276
  }
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
  for_each             = local.subnets
  source               = "../../"
  depends_on           = [module.rg, module.vnet]
  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  environment          = local.environment
  module               = local.module
  slot                 = each.key
  subnet_cidr          = [cidrsubnet(module.vnet.virtual_network_cidr[0], 13, each.value)]
}

output "subnet_cidr" {
  value = tomap({ for k, v in module.subnet : k => v.subnet_cidr[0] })
}