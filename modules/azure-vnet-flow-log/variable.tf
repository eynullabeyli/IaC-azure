variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "network_watcher_name" {
  type        = string
}

variable "flow_log_name" {
  type        = string
}

variable "enabled" {
  type        = bool
  default     = true
}

variable "traffic_analytics_enabled" {
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  type        = string
}

variable "workspace_region" {
  type        = string
}

variable "workspace_resource_id" {
  type        = string
}

variable "storage_account_id" {
  type        = string
}

variable "network_security_group_id" {
  type        = string
}

