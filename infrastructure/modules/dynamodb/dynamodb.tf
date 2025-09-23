resource "aws_dynamodb_table" "contact_submissions" {
  name = "contact_submissions"
  billing_mode = "PAY_PER_REQUEST"

  # Partition key (submission_id) uniquely identifies each submission
  # Sort key (created_at) allows ordering by timestamp
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

  #  Allows restoring table to any point within the last 35 days
  point_in_time_recovery {
    enabled = true
  }

  # Ensures data is encrypted at rest for security compliance
  server_side_encryption {
    enabled = true
  }

  tags = {
    Environment = "development"
    Application = "Email Form"
  }
}