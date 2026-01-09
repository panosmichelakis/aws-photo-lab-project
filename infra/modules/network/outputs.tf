output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID."
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "Public subnet ID."
}

output "public_subnet_ids" {
  value       = [aws_subnet.public.id, aws_subnet.public_b.id]
  description = "Public subnet IDs for the ALB."
}

output "private_subnet_id" {
  value       = aws_subnet.private.id
  description = "Private subnet ID."
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "Public route table ID."
}

output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "Private route table ID."
}
