locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.project_environment
  }
}

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

data "aws_ami" "ubuntu_linux" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu 공식 게시자) 계정 ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "cloudinit_config" "init" {
  gzip          = false
  base64_encode = false # user_data가 이 값을 다시 base64 인코딩하므로 false. (true면 이중 인코딩되어 cloud-init이 스크립트를 인식 못 한다)

  part {
    filename     = "userdata.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/script/userdata.sh")
  }
}

resource "aws_instance" "instance" {
  depends_on = [module.vpc]

  count = var.number_of_subnets * var.number_of_instances_per_subnet

  ami           = data.aws_ami.ubuntu_linux.id
  instance_type = var.instance_type

  subnet_id                   = module.vpc.public_subnets[count.index % var.number_of_subnets]
  vpc_security_group_ids      = [module.instance_security_group.security_group_id]
  associate_public_ip_address = true

  user_data = data.cloudinit_config.init.rendered

  tags = {
    Name = "instance-${count.index}-${local.suffix_name}"
  }
}
