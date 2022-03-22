variable "location" {
  type = string
  description = "Location for resources"
}

variable "resource_group_name" {
  type = string
  description = "Resource group name to be used"
}

variable "secret" {
  type = string
}
variable "storage_account_name" {
  type = string
}
variable "dapi_url" {
  type = string
}

variable "subscription_id" {
  type = string
}
variable "client_id" {
  type = string
}
variable "tenant_id" {
  type = string
}