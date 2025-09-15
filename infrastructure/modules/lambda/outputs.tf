output "lambda_invoke_arn" {
  value = aws_lambda_function.email_function.invoke_arn
}

output "lambda_email_function_arn" {
  value = aws_lambda_function.email_function.arn
}