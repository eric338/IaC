output "asg_name" {
  description = "Auto Scaling 그룹 이름"
  value       = aws_autoscaling_group.web.name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
