variable "app_service_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "service_plan_id" {
  type = string
}

variable "location" {
  type = string
  default = "East US"
}