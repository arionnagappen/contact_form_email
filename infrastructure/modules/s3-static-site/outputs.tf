output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_frontend_distribution.domain_name
}

