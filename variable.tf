variable "resource_group_name" {
  description = "Resource group name to allocate subnet"
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual network name to allocate subnet"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "module" {
  description = "Project module name"
  type        = string
}

variable "slot" {
  description = "Project slot name. Available values: shared, blue, green"
  type        = string
}

variable "subnet_cidr" {
  description = "The address spaces that is used by the subnet"
  type        = list(string)
}

variable "custom_tags" {
  description = "Custom tags to add"
  type        = map(string)
  default     = {}
}
