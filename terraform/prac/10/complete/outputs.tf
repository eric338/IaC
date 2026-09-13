output "instance_public_ips" {
  description = "Public IP of Instances"
  value       = module.ec2.instance_public_ips
}

output "instance_private_ips" {
  description = "Private IP of Instances"
  value       = module.ec2.instance_private_ips
}

output "instance_ids" {
  description = "List of Instance IDs"
  value       = module.ec2.instance_ids
}
