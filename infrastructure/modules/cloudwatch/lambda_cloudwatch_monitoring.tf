resource "aws_cloudwatch_log_group" "lambda_cloudwatch_log_group" {
  name = "/aws/lambda/${var.function_name}"

  retention_in_days = var.num_retention_days

  tags = {
    Environment = var.environment_tag
    Application = var.application_tag
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name = "Lambda-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = var.num_lambda_evaluation_periods
  metric_name = "Errors"
  namespace = "AWS/Lambda"
  period = var.lambda_alarm_period
  statistic = "Sum"
  threshold = var.lambda_alarm_threshold

  alarm_description = "Lambda Errors"

  dimensions = { FunctionName = var.function_name }

  treat_missing_data = "notBreaching"

  alarm_actions = [ var.sns_topic_arn ]
}