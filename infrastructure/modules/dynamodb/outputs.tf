output "table_arn" {
  value = aws_dynamodb_table.contact_submissions.arn
}

output "contact_submissions_name" {
  value = aws_dynamodb_table.contact_submissions.name
}