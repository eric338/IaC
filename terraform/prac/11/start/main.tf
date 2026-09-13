data "aws_availability_zones" "available" {
  state = "available"
}

# 실습: vpc, instance_security_group, ec2 세 모듈 모두에 for_each = var.project 를 추가하고,
# 하드코딩되어 있던 값들을 each.key / each.value.<필드> 로 바꾸세요.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  for_each = XXX

  name = "vpc-XXX"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.available.names
  public_subnets = XXX # 힌트: slice(var.public_subnets, 0, each.value.number_of_subnets)

  map_public_ip_on_launch = true

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

module "instance_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 5.0"

  for_each = XXX

  name        = "instance-sg-XXX"
  description = "Security group for Instance with HTTP 80"
  vpc_id      = XXX # 힌트: module.vpc[each.key].vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ec2" {
  source = "./modules/instance"

  depends_on = [module.vpc]

  for_each = XXX

  project_name        = XXX # 힌트: each.key
  project_environment = XXX

  instance_type                  = XXX
  number_of_instances_per_subnet = XXX
  number_of_subnets              = XXX

  instance_subnet_ids = XXX # 힌트: module.vpc[each.key].public_subnets
  instance_sg_ids     = XXX
}
