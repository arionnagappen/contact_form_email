variable "lambda_invoke_arn" {
  type = string
  description = "Lambda Invoke ARN"
}

variable "lambda_email_function_arn" {
  type = string
  description = "Lambda email function arn"
}

variable "cloudfront_domain_name" {
  type = string
  description = "CloudFront URL"
}

variable "dist_aliases" {
  type = list(string)
}