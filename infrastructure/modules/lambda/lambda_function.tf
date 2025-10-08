# Package Lambda Function Code
data "archive_file" "email_function_package" {
  type = "zip"
  source_file = var.source_file_location
  output_path = "${path.module}/lambda/function.zip"
}

# Lambda Function
resource "aws_lambda_function" "email_function" {
  filename = data.archive_file.email_function_package.output_path
  function_name = var.my_function_name
  role = var.lambda_role_arn
  handler = var.function_handler
  source_code_hash = data.archive_file.email_function_package.output_base64sha256

  runtime = var.lambda_runtime

  environment {
  variables = {
    ENVIRONMENT     = "development"
    LOG_LEVEL       = "info"
    TABLE_NAME      = var.table_name
    SENDER_EMAIL    = var.sender_email
    RECIPIENT_EMAIL = var.recipient_email
    CFG_SET_NAME    = var.cfg_set_name
  }
}


  tags = {
    Environment = var.environment_tag
    Application = var.application_tag
  }
}