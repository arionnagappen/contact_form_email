// --- FRONTEND --- //
module "frontend" {
  source = "../../modules/s3-static-site"
  frontend_bucket_name = "contact-form-email-frontend"
}

// --- IAM ROLES --- //
module "my_roles" {
  source = "../../modules/iam-roles"
}

// --- LAMBDA FUNCTION --- //
module "my_lambda_function" {
  source = "../../modules/lambda"

  lambda_role_arn = module.my_roles.lambda_role_arn
}