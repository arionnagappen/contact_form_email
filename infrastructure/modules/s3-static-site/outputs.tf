output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_frontend_distribution.domain_name
}

output "distribution_id" {
  value = aws_cloudfront_distribution.s3_frontend_distribution.id
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_frontend_distribution.domain_name
}

output "dist_aliases" {
  value = var.dist_aliases
}

