output "lambda_invoke_arn" {
  value = aws_lambda_function.email_function.invoke_arn
}

output "lambda_email_function_arn" {
  value = aws_lambda_function.email_function.arn
}

output "function_name" {
  value = aws_lambda_function.email_function.function_name
}