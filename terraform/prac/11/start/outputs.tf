# 실습: for 표현식으로 module.ec2(for_each로 만들어진, "프로젝트 이름 -> 모듈 인스턴스" 맵)를
# "프로젝트 이름 -> 그 프로젝트의 출력값" 형태의 새 맵으로 가공하세요.
# 예: { for name, m in module.ec2 : name => m.instance_public_ips }

output "instance_public_ips" {
  description = "Map of project name to its list of instance public IPs"
  value       = XXX
}

output "instance_private_ips" {
  description = "Map of project name to its list of instance private IPs"
  value       = XXX
}

output "instance_ids" {
  description = "Map of project name to its list of instance IDs"
  value       = XXX
}
