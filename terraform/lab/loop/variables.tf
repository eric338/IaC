variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "ami_image" {
  description = "리전 -> Ubuntu 24.04 AMI ID"
  type        = map(string)
  default = {
    ap-northeast-2 = "ami-05fa22e12f2cb12aa"
  }
}

variable "instances" {
  description = "만들 인스턴스 정의 (키 = 이름)"
  type = map(object({
    az            = string
    instance_type = string
  }))
  default = {
    web-a = {
      az            = "ap-northeast-2a"
      instance_type = "t3.micro"
    }
    web-c = {
      az            = "ap-northeast-2c"
      instance_type = "t3.micro"
    }
  }
}
