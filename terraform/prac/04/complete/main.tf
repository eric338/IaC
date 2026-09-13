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
  ami           = "ami-096dce0fcb85a808f" # Ubuntu 24.04 20260203
  instance_type = "t3.micro"

  tags = {
    Name = "instance"
  }
}
