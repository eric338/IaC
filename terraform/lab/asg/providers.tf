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
  region  = var.aws_region

  default_tags {
    tags = {
      Project = "terraform-lab-asg"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  iam_user_name = replace(split("/", data.aws_caller_identity.current.arn)[1], "_", "-")
}
