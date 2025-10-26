# API GATEWAY
# Defines the HTTP API Container
# Needed as the public entrypoint for client requests (Lambda function is not directly exposed)
resource "aws_apigatewayv2_api" "my_apigateway" {
  name          = "my-lambda-http-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.dist_aliases
    allow_methods = [ "POST" ]
    allow_headers = [ "Content-Type" ]
  }
}

# API INTEGRATION
# Connects API Gateway to the Lambda function.
# Tells API Gateway *where* to send matching requests
resource "aws_apigatewayv2_integration" "my_apigateway_integration" {
  api_id = aws_apigatewayv2_api.my_apigateway.id
  integration_type = "AWS_PROXY"
  payload_format_version = "2.0"

  description = "Points to Lambda Function"
  integration_method = "POST"
  integration_uri = var.lambda_invoke_arn
}

# API ROUTE
# Defines which HTTP requests map to an integration.
# makes sure POST requests to /contact are sent to our function.
resource "aws_apigatewayv2_route" "my_apigateway_route" {
  api_id = aws_apigatewayv2_api.my_apigateway.id
  route_key = "POST /contact"
  target = "integrations/${aws_apigatewayv2_integration.my_apigateway_integration.id}"
}

# API Stage
# Deploys the API so it has a real URL.
# Without a stage, the API can’t be called from the internet.
resource "aws_apigatewayv2_stage" "my_apigateway_stage" {
  api_id = aws_apigatewayv2_api.my_apigateway.id
  name   = "$default"
  auto_deploy = true
}

# LAMBDA PERMISSION
# Lets API Gateway call the Lambda.
# By default Lambda is private — this grants access only to this API route.
resource "aws_lambda_permission" "my_lambda_permission" {
  statement_id  = "AllowMyAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_email_function_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.my_apigateway.execution_arn}/*/POST/contact"
}