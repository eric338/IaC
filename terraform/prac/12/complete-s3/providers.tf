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

  backend "s3" {
    bucket       = "terraform-tfstate-XXXXXXXXXX" # 12.s3_backend 로 만든 실제 버킷 이름으로 교체
    key          = "tfstate/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}
