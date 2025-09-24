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
  sns_topic_arn = module.my_sns.sns_topic_arn
}

// -- SNS --- //
module "my_sns" {
  source = "../../modules/sns"
}

// --- DYNAMO DB --- //
module "my_dynambodb" {
  source = "../../modules/dynamodb"
}