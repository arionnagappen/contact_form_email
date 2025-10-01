variable "sns_topic_arn" {
  type = string
  description = "SNS Topic ARN"
}

// --- LAMBDA CLOUDWATCH LOG GROUP --- //
variable "function_name" {
  type = string
  description = "Name of Lambda Function"
}

variable "num_retention_days" {
  type = number
  description = "Number of retention days"
}

variable "environment_tag" {
  type = string
  description = "Environment tag name"
}

variable "application_tag" {
  type = string
  description = "Application tag name"
}

// --- LAMBDA CLOUDWATCH ALARM
variable "num_lambda_evaluation_periods" {
  type = number
  description = "Number of evaluation periods"
}

variable "lambda_alarm_period" {
  type = number
  description = "Length of time over which data is collected"
}

variable "lambda_alarm_threshold" {
  type = number
  description = "Percentage of failed requests that will trigger the alarm"
}