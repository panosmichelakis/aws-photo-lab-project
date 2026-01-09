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

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet."
}

variable "public_subnet_cidr_2" {
  type        = string
  description = "CIDR block for the second public subnet."
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet."
}

variable "az" {
  type        = string
  description = "Availability zone for subnets."
}

variable "az2" {
  type        = string
  description = "Second availability zone for the ALB public subnet."
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply to resources."
  default     = {}
}
