terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"
}

resource "aws_instance" "instance" {
  ami           = "ami-0fad23d064f9e8330"
  instance_type = "t3.micro"

  tags = {
    Name = "PracticeInstance-01"
  }
}