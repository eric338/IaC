terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  #access_key = "AKI"
  #secret_key = "Gtk"
  profile = "default"
  region  = "ap-northeast-2"
}

resource "aws_instance" "instance" {
  ami           = "ami-0abcdef1234567890" # 콘솔에서 확인한 Ubuntu 24.04 AMI ID로 교체
  instance_type = "t3.micro"

  tags = {
    Name = "instance"
  }
}
