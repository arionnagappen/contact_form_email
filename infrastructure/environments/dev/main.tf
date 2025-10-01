// --- FRONTEND --- //
module "frontend" {
  source = "../../modules/s3-static-site"
  frontend_bucket_name = "contact-form-email-frontend"
}

// --- IAM ROLES --- //
module "my_roles" {
  source = "../../modules/iam-roles"
  table_arn = module.my_dynambodb.table_arn
}

// --- LAMBDA FUNCTION --- //
module "my_lambda_function" {
  source = "../../modules/lambda"

  lambda_role_arn = module.my_roles.lambda_role_arn
}

// --- API GATEWAY --- //
module "my_api_gateway" {
  source = "../../modules/api-gateway"

  lambda_email_function_arn = module.my_lambda_function.lambda_email_function_arn

  lambda_invoke_arn = module.my_lambda_function.lambda_invoke_arn

  cloudfront_domain_name = module.frontend.cloudfront_domain_name
}

// --- CLOUDWATCH --- //
module "my_cloudwatch_monitoring" {
  source = "../../modules/cloudwatch"

  # CloudWatch Log Group
  num_retention_days = 14
  environment_tag = "development"
  application_tag = "serviceA"

  # Num Lambda Errors Alarm
  num_lambda_evaluation_periods = 1
  lambda_alarm_period = 300
  lambda_alarm_threshold = 0

  # From Other Modules
  sns_topic_arn = module.my_sns.sns_topic_arn
  function_name = module.my_lambda_function.function_name
}

// --- SNS --- //
module "my_sns" {
  source = "../../modules/sns"
}

// --- DYNAMO DB --- //
module "my_dynambodb" {
  source = "../../modules/dynamodb"
}

// --- SES --- //
module "my_ses" {
  source = "../../modules/ses"
  lambda_alert_arn = module.my_sns.sns_topic_arn
} 

// --- WAF --- //
module "my_waf" {
  source = "../../modules/waf"
  apigateway_stage_arn = module.my_api_gateway.apigateway_stage_arn
}

