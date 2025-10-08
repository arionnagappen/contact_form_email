output "apigateway_stage_arn" {
  value = aws_apigatewayv2_stage.my_apigateway_stage.arn
}

output "api_gateway_invoke_url" {
  description = "Invoke URL for the API Gateway"
  value       = aws_apigatewayv2_api.my_apigateway.api_endpoint
}
