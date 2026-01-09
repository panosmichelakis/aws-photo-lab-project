variable "project" {
  type        = string
  description = "Project name for tagging and naming."
}

variable "env" {
  type        = string
  description = "Environment name for tagging and naming."
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name for photo data."
}

variable "bucket_arn" {
  type        = string
  description = "S3 bucket ARN."
}

variable "table_name" {
  type        = string
  description = "DynamoDB table name."
}

variable "table_arn" {
  type        = string
  description = "DynamoDB table ARN."
}

variable "lambda_source_path" {
  type        = string
  description = "Path to the Lambda handler source file."
}

variable "processed_prefix" {
  type        = string
  description = "Prefix for processed S3 objects."
  default     = "processed/"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply to resources."
  default     = {}
}
