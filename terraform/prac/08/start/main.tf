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
  XXX
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "vpc-${local.suffix_name}"
  XXX
  # 힌트: cidr, azs, public_subnets, map_public_ip_on_launch, enable_nat_gateway(반드시 false), enable_vpn_gateway
}

module "instance_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 5.0"

  name        = "instance-sg-${local.suffix_name}"
  description = "Security group for Instance with HTTP 80"
  vpc_id      = XXX

  ingress_cidr_blocks = XXX
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
  gzip = false
  # user_data가 다시 base64 인코딩하므로 여기서는 false로 둔다 (true면 이중 인코딩).
  base64_encode = false

  part {
    filename     = "userdata.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/script/userdata.sh")
  }
}

resource "aws_instance" "instance_a" {
  depends_on = [module.vpc]

  ami           = data.aws_ami.ubuntu_linux.id
  instance_type = var.instance_type

  subnet_id                   = XXX
  vpc_security_group_ids      = XXX
  associate_public_ip_address = true

  user_data = data.cloudinit_config.init.rendered

  tags = {
    Name = "instance-a-${local.suffix_name}"
  }
}

resource "aws_instance" "instance_b" {
  depends_on = [module.vpc]

  ami           = data.aws_ami.ubuntu_linux.id
  instance_type = var.instance_type

  subnet_id                   = XXX
  vpc_security_group_ids      = XXX
  associate_public_ip_address = true

  user_data = data.cloudinit_config.init.rendered

  tags = {
    Name = "instance-b-${local.suffix_name}"
  }
}
