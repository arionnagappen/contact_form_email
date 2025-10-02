variable "table_name" {
  type = string
  description = "DynamoDB table name"
}

variable "my_hash_key" {
  type = string
  description = "DynamoDB Hash Key"
}

variable "my_range_key" {
  type = string
  description = "DynamoDB range key"
}

variable "table_env_tag" {
  type = string
  description = "DynamoDB environment tag"
}

variable "table_app_tag" {
  type = string
  description = "DynamoDB application tag"
}