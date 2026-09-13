terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"
}

resource "random_string" "random" {
  length  = 10
  special = false
  lower   = true
  upper   = false
  numeric = true
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "terraform-tfstate-${random_string.random.result}"

  # 실습용 버킷: destroy 시 남은 상태 파일과 그 이전 버전까지 비우고 삭제하도록 허용.
  # versioning을 켜기 때문에 이 옵션이 없으면 destroy가 BucketNotEmpty로 실패한다.
  # (실무 상태 버킷에는 절대 쓰지 말 것)
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "tfstate_bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}
