output "lambda_function_name" {
  value       = aws_lambda_function.this.function_name
  description = "Lambda function name."
}

output "lambda_function_arn" {
  value       = aws_lambda_function.this.arn
  description = "Lambda function ARN."
}
