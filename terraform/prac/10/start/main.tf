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

# 실습: 아래 데이터 소스/리소스를 modules/instance/ 로 옮기고,
# 여기서는 그 모듈을 호출하는 코드만 남기세요.

# data "aws_ami" "ubuntu_linux" {
#   most_recent = true
#   owners      = ["099720109477"]
#
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
#   }
# }
#
# data "cloudinit_config" "init" {
#   gzip          = false
#   base64_encode = false  # user_data가 다시 인코딩하므로 false
#
#   part {
#     filename     = "userdata.sh"
#     content_type = "text/x-shellscript"
#     content      = file("${path.module}/script/userdata.sh")
#   }
# }
#
# resource "aws_instance" "instance" {
#   count = var.number_of_subnets * var.number_of_instances_per_subnet
#   ...
# }

module "ec2" {
  source = "./modules/instance"

  depends_on = [module.vpc]

  project_name        = XXX
  project_environment = XXX

  instance_type                  = XXX
  number_of_instances_per_subnet = XXX
  number_of_subnets              = XXX

  instance_subnet_ids = XXX
  instance_sg_ids     = XXX
}
