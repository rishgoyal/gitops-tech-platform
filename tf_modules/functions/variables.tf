variable "resource_group_name" {
  type = string
}

variable "function_app_names" {
  type        = list(string)
  description = "List of function app names to create"
  default     = ["app1", "app2", "app3"]
}