# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"
#     }
#   }
# }

# provider "aws" {
#   #access_key = "AKI"
#   #secret_key = "Gtk"
#   profile = "default"
#   region  = "ap-northeast-2"
# }

# resource "aws_instance" "instance" {
#   ami           = "ami-096dce0fcb85a808f" # Ubuntu 24.04 20260203
#   instance_type = "t3.micro"

#   tags = {
#     Name = "instance"
#   }
# }

resource "aws_instance" "instance_a" {

}

resource "aws_instance" "instance_b" {

}

resource "aws_eip" "eip" {

}

resource "random_string" "random" {

}

resource "aws_s3_bucket" "bucket" {

}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {

}

resource "aws_s3_bucket_acl" "bucket_acl" {

}

resource "aws_s3_object" "object" {

}
