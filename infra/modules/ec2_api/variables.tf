variable "project" {
  type        = string
  description = "Project name for tagging and naming."
}

variable "env" {
  type        = string
  description = "Environment name for tagging and naming."
}

variable "region" {
  type        = string
  description = "AWS region."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet ID for EC2."
}

variable "ec2_sg_id" {
  type        = string
  description = "Security group ID for EC2."
}

variable "app_port" {
  type        = number
  description = "Application port for the API server."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for processed objects."
}

variable "table_name" {
  type        = string
  description = "DynamoDB table name for metadata."
}

variable "table_arn" {
  type        = string
  description = "DynamoDB table ARN for IAM policy."
}

variable "target_group_arn" {
  type        = string
  description = "ALB target group ARN."
}

variable "api_app_source" {
  type        = string
  description = "Source code for the API server to write to the instance."
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply to resources."
  default     = {}
}
