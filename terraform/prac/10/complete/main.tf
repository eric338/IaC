locals {
  suffix_name = "${var.project_name}-${var.project_environment}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "vpc-${local.suffix_name}"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.available.names
  public_subnets = slice(var.public_subnets, 0, var.number_of_subnets)

  map_public_ip_on_launch = true

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

module "instance_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 5.0"

  name        = "instance-sg-${local.suffix_name}"
  description = "Security group for Instance with HTTP 80"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ec2" {
  source = "./modules/instance"

  depends_on = [module.vpc]

  project_name        = var.project_name
  project_environment = var.project_environment

  instance_type                  = var.instance_type
  number_of_instances_per_subnet = var.number_of_instances_per_subnet
  number_of_subnets              = var.number_of_subnets

  instance_subnet_ids = module.vpc.public_subnets
  instance_sg_ids     = [module.instance_security_group.security_group_id]
}
