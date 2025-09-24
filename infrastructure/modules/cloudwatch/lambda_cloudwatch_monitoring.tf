resource "aws_cloudwatch_log_group" "lambda_cloudwatch_log_group" {
  name = "/aws/lambda/my_email_function"

  retention_in_days = 14

  tags = {
    Environment = "development"
    Application = "serviceA"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name = "Lambda-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  metric_name = "Errors"
  namespace = "AWS/Lambda"
  period = 300
  statistic = "Sum"
  threshold = 0

  alarm_description = "Lambda Errors"

  dimensions = { FunctionName = "my_email_function" }

  treat_missing_data = "notBreaching"

  alarm_actions = [ var.sns_topic_arn ]
}