variable "project" {
  type        = string
  description = "Project name."
  default     = "aws-photo-lab"
}

variable "env" {
  type        = string
  description = "Environment name."
  default     = "dev"
}

variable "region" {
  type        = string
  description = "AWS region."
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR."
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  type        = string
  description = "Second public subnet CIDR for the ALB."
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Private subnet CIDR."
  default     = "10.0.2.0/24"
}

variable "az" {
  type        = string
  description = "Availability zone."
  default     = "eu-central-1a"
}

variable "az2" {
  type        = string
  description = "Second availability zone for the ALB public subnet."
  default     = "eu-central-1b"
}

variable "app_port" {
  type        = number
  description = "App port for the API."
  default     = 8000
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}
