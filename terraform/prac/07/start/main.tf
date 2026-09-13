locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.project_environment
  }
}

locals {
  suffix_name = "${var.project_name}-${var.project_environment}"
}

data "aws_ami" "ubuntu_linux" {
  XXX
}

data "cloudinit_config" "init" {
  XXX
}

resource "aws_instance" "instance_a" {
  ami           = var.ami_image[var.aws_region]
  instance_type = var.instance_type

  user_data = XXX

  tags = {
    Name = "instance-a-${local.suffix_name}"
  }
}

resource "aws_instance" "instance_b" {
  ami           = var.ami_image[var.aws_region]
  instance_type = var.instance_type

  user_data = XXX

  tags = {
    Name = "instance-b-${local.suffix_name}"
  }
}

resource "aws_eip" "eip_a" {
  domain   = "vpc"
  instance = aws_instance.instance_a.id

  tags = {
    Name = "elastic-ip-instance-a-${local.suffix_name}"
  }
}

resource "aws_eip" "eip_b" {
  domain   = "vpc"
  instance = aws_instance.instance_b.id

  tags = {
    Name = "elastic-ip-instance-b-${local.suffix_name}"
  }
}

resource "aws_security_group" "web" {
  XXX

  tags = {
    Name = "sec-group-web-XXX"
  }
}
