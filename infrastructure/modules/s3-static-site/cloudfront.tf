// --- CloudFront Origin Access Control --- //
resource "aws_cloudfront_origin_access_control" "frontend_oac" {
  name = "origin-access-control-frontend"
  description = "Origin Access Control for frontend bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

// --- CloudFront Distribution --- //
resource "aws_cloudfront_distribution" "s3_frontend_distribution" {

  # Sets S3 Bucket as origin and use OAI to access it
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id = "S3-frontend-bucket"

    # Attach Origin Access Control
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend_oac.id

  }

  aliases = [
  for a in var.dist_aliases :
  trim(replace(replace(a, "https://", ""), "http://", ""), "")
  ]

  # Activate or Disable content distribution
  enabled = true

  # Enable support for IPv6
  is_ipv6_enabled = true

  comment = "Frontend Site"

  # Default file to serve
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"] # HTTP methods allowed for caching behaviour
    cached_methods = ["GET", "HEAD"] # Methods to be cached (The actual reads)
    target_origin_id = "S3-frontend-bucket" # Links cache behaviour to the origin

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

    }

    viewer_protocol_policy = "redirect-to-https" # Ensures secure connection between CDN & Client
    min_ttl = 0 # Min. amount of time an object is cached
    default_ttl = 3600 # Default amount of time an object is cached
    max_ttl = 86400 # Max. amount of time an object is cached
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" # All geographic locations are allowed
    }
  }

  viewer_certificate {
    # Configure SSL and TSL settings
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}