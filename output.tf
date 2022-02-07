output "subnet_name" {
  value       = azurerm_subnet.subnet.name
  description = "Subnet name"
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "Subnet id"
}

output "subnet_cidr" {
  value       = azurerm_subnet.subnet.address_prefixes
  description = "Subnet id"
}