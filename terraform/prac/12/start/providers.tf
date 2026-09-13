terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3"
    }
  }

  # 실습: 아래 중 하나를 골라 backend 블록을 완성하세요.

  # S3 백엔드 (최신 방식: DynamoDB 없이 use_lockfile로 락 관리)
  # backend "s3" {
  #   bucket       = "terraform-tfstate-XXXXXXXXXX"
  #   key          = "tfstate/terraform.tfstate"
  #   region       = "ap-northeast-2"
  #   encrypt      = true
  #   use_lockfile = true
  # }

  # HCP Terraform (구 Terraform Cloud)
  # cloud {
  #   organization = "<ORGANIZATION_NAME>"
  #   workspaces {
  #     name = "<WORKSPACE_NAME>"
  #   }
  # }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}
