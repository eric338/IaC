locals {
  suffix_name = "${var.project_name}-${var.project_environment}"
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
  count = var.number_of_subnets * var.number_of_instances_per_subnet

  ami           = data.aws_ami.ubuntu_linux.id
  instance_type = var.instance_type

  # 실습: 루트 모듈에서 넘겨받은 변수(var.instance_subnet_ids, var.instance_sg_ids)를 참조하세요.
  # 루트 모듈처럼 module.vpc, module.instance_security_group을 직접 참조할 수 없습니다 (모듈 밖의 것이므로).
  subnet_id                   = XXX
  vpc_security_group_ids      = XXX
  associate_public_ip_address = true

  user_data = data.cloudinit_config.init.rendered

  tags = {
    Name = "instance-${count.index}-${local.suffix_name}"
  }
}
