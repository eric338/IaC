output "instance_public_ips" {
  description = "Public IP of Instances"
  value       = aws_instance.instance[*].public_ip
}

output "instance_private_ips" {
  description = "Private IP of Instances"
  value       = aws_instance.instance[*].private_ip
}

output "instance_ids" {
  description = "List of Instance IDs"
  value       = aws_instance.instance[*].id
}
