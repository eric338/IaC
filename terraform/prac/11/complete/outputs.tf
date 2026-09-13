output "instance_public_ips" {
  description = "Map of project name to its list of instance public IPs"
  value       = { for name, m in module.ec2 : name => m.instance_public_ips }
}

output "instance_private_ips" {
  description = "Map of project name to its list of instance private IPs"
  value       = { for name, m in module.ec2 : name => m.instance_private_ips }
}

output "instance_ids" {
  description = "Map of project name to its list of instance IDs"
  value       = { for name, m in module.ec2 : name => m.instance_ids }
}
