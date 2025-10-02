resource "aws_dynamodb_table" "contact_submissions" {
  name = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  # Partition key (submission_id) uniquely identifies each submission
  # Sort key (created_at) allows ordering by timestamp
  hash_key = var.my_hash_key
  range_key = var.my_range_key

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
    Environment = var.table_env_tag
    Application = var.table_app_tag
  }
}