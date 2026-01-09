variable "project" {
  type        = string
  description = "Project name for tagging and naming."
}

variable "env" {
  type        = string
  description = "Environment name for tagging and naming."
}

variable "table_name" {
  type        = string
  description = "DynamoDB table name."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply to resources."
  default     = {}
}
