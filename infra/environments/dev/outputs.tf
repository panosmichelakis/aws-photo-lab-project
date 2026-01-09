output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "ALB DNS name."
}

output "data_bucket_name" {
  value       = module.s3.bucket_name
  description = "S3 data bucket name."
}

output "dynamodb_table_name" {
  value       = module.dynamodb.table_name
  description = "DynamoDB table name."
}

output "ec2_instance_id" {
  value       = module.ec2_api.instance_id
  description = "EC2 instance ID for the API server."
}

output "alb_base_url" {
  value       = "http://${module.alb.alb_dns_name}"
  description = "Base URL for the API."
}
