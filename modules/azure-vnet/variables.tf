variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "location" {
  description = "Location of the Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the Virtual Network"
  type        = map(string)
}
