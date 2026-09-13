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
  public_subnets = XXX # 힌트: slice() 함수로 var.public_subnets 중 number_of_subnets 개수만큼만 사용

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
  base64_encode = false  # user_data가 이 값을 다시 base64 인코딩하므로 false. (true면 이중 인코딩되어 cloud-init이 스크립트를 인식 못 한다)

  part {
    filename     = "userdata.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/script/userdata.sh")
  }
}

# 실습: 아래 단일 인스턴스 리소스를 count 메타 인수를 사용하는 하나의 블록으로 바꾸세요.
# - count: number_of_subnets * number_of_instances_per_subnet
# - subnet_id: count.index를 number_of_subnets로 나눈 나머지를 사용해 서브넷에 고르게 분산
resource "aws_instance" "instance" {
  depends_on = [module.vpc]

  XXX

  ami           = data.aws_ami.ubuntu_linux.id
  instance_type = var.instance_type

  subnet_id                   = XXX
  vpc_security_group_ids      = [module.instance_security_group.security_group_id]
  associate_public_ip_address = true

  user_data = data.cloudinit_config.init.rendered

  tags = {
    Name = "instance-XXX-${local.suffix_name}"
  }
}
