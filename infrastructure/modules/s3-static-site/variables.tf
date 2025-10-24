// --- S3 BUCKET --- //
variable "frontend_bucket_name" {
  type = string
  description = "Name of bucket used to host frontend files"
}

// --- CLOUDFRONT --- //
variable "dist_aliases" {
  type = list(string)
  description = "List of aliases for cloudfront distribution"
}

variable "certificate_arn" {
  type = string
  description = "ARN of ACM certificate"
}