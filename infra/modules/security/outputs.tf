output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "ALB security group ID."
}

output "ec2_sg_id" {
  value       = aws_security_group.ec2.id
  description = "EC2 security group ID."
}
