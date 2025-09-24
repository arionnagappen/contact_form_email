resource "aws_sns_topic" "lambda_alerts" {
  name = "lambda-error-alert"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.lambda_alerts.arn
  protocol = "email"
  endpoint = "arionnagappen@gmail.com"
}