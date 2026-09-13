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
  ami           = "ami-08a4fd517a4872931" # Ubuntu 22.04 20251212
  instance_type = "t3.micro"

  tags = {
    Name = "instance"
  }
}
