variable "storage_account_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "role_assignments" {
  type = list(object({ principal_id = string }))
  # default = [{}]
}
