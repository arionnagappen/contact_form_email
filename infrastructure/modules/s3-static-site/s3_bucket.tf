// --- Creates an S3 Bucket --- //
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.frontend_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend_bucket_encryption" {
  bucket = aws_s3_bucket.frontend_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// --- Ownership Controls --- //
resource "aws_s3_bucket_ownership_controls" "static_site_bucket_ownership" {
  bucket = aws_s3_bucket.frontend_bucket.id

  # Ensure only the bucket owner has ownership of all files
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

// --- Bucket Policies --- //
resource "aws_s3_bucket_policy" "front_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  # Only allow CloudFront to read objects
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontOACRead",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*", # Applies to all files in the bucket
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_frontend_distribution.arn
          }
        }
      }
    ]
  })
}

// --- Bucket Public Access Block --- //
resource "aws_s3_bucket_public_access_block" "frontend_public_access_block" {
  bucket = aws_s3_bucket.frontend_bucket.id

  # Blocks all public access to the bucket
  # Only CloudFront can access the bucket
  
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "frontend_versioning" {
  bucket = aws_s3_bucket.frontend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
