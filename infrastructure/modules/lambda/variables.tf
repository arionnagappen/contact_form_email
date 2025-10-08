// --- ARCHIVE FILE --- //
variable "source_file_location" {
  type = string
  description = "location of source file"
}

// --- LAMBDA FUNCTION --- //
variable "my_function_name" {
  type = string
  description = "Name of function"
}

variable "lambda_role_arn" {
  type = string
  description = "ARN value of Lambda Role"
}

variable "function_handler" {
  type = string
  description = "Lambda Function Handler"
}

variable "lambda_runtime" {
  type = string
  description = "Runtime environment"
}

variable "environment_variable" {
  type = string
  description = "environment variable"
}

variable "log_level_variable" {
  type = string
  description = "log level variable"
}

variable "environment_tag" {
  type = string
  description = "Environment tag"
}

variable "application_tag" {
  type = string
  description = "Application tag"
}

// --- ENVIRONMENT VARIABLES --- //
variable "table_name" { 
  type = string 
}

variable "sender_email" { 
  type = string 
}

variable "recipient_email" { 
  type = string 
}

variable "cfg_set_name" { 
  type = string
}
