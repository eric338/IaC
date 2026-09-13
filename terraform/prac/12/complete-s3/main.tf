data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  for_each = var.project

  name = "vpc-${each.key}-${each.value.project_environment}"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.available.names
  public_subnets = slice(var.public_subnets, 0, each.value.number_of_subnets)

  map_public_ip_on_launch = true

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

module "instance_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 5.0"

  for_each = var.project

  name        = "instance-sg-${each.key}-${each.value.project_environment}"
  description = "Security group for Instance with HTTP 80"
  vpc_id      = module.vpc[each.key].vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ec2" {
  source = "./modules/instance"

  depends_on = [module.vpc]

  for_each = var.project

  project_name        = each.key
  project_environment = each.value.project_environment

  instance_type                  = each.value.instance_type
  number_of_instances_per_subnet = each.value.number_of_instances_per_subnet
  number_of_subnets              = each.value.number_of_subnets

  instance_subnet_ids = module.vpc[each.key].public_subnets
  instance_sg_ids     = [module.instance_security_group[each.key].security_group_id]
}
