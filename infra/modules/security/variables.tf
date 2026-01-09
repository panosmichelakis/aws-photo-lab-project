variable "project" {
  type        = string
  description = "Project name for tagging and naming."
}

variable "env" {
  type        = string
  description = "Environment name for tagging and naming."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "app_port" {
  type        = number
  description = "Application port for EC2 service."
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply to resources."
  default     = {}
}
