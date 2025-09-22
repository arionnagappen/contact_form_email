resource "aws_dynamodb_table" "contact_submissions" {
  name = "contact_submissions"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "submission_id"
  range_key = "created_at"

  attribute {
    name = "submission_id"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Environment = "development"
    Application = "Email Form"
  }
}