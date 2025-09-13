# Package Lambda Function Code
data "archive_file" "email_function_package" {
  type = "zip"
  source_file = "../../../lambda/index.py"
  output_path = "${path.module}/lambda/function.zip"
}

# Lambda Function
resource "aws_lambda_function" "email_function" {
  filename = data.archive_file.email_function_package.output_path
  function_name = "my_email_function"
  role = var.lambda_role_arn
  handler = "index.handler"
  source_code_hash = data.archive_file.email_function_package.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      ENVIRONMENT = "development"
      LOG_LEVEL = "info"
    }
  }

  tags = {
    Environment = "development"
    Application = "Email Form"
  }
}