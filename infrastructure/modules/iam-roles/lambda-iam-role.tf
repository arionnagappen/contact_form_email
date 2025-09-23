// --- LAMBDA IAM ROLE--- //
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

// -- LAMBDA IAM POLICY DOCUMENT -- //
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  # Defines who can assume this role
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

// --- REGION & ID --- //
data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

// --- LAMBDA IAM ROLE POLICY --- //
resource "aws_iam_policy" "cloudwatch_log_writes_policy" {
  name = "cloudwatch-log-writes-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Action = ["logs:CreateLogGroup"]
        Effect = "Allow"
        Resource = "*" 
      },
      {
        Action = ["logs:CreateLogStream", "logs:PutLogEvents"]
        Effect = "Allow"
        Resource = "arn:aws:logs:${data.aws_region.this.region}:${data.aws_caller_identity.this.account_id}:log-group:/aws/lambda/*:*"
      },
      {
        Action = ["dynamodb:PutItem", "dynamodb:GetItem", "dynamodb:DescribeTable"]
        Effect = "Allow"
        Resource = var.table_arn
      }
    ]
  })
}

// --- LAMBDA IAM ROLE POLICY ATTACHEMENT --- //
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_log_writes_policy.arn
}
