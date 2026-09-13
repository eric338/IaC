variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "ami_id" {
  description = "Ubuntu 24.04 AMI ID (서울)"
  type        = string
  default     = "ami-05fa22e12f2cb12aa"
}

variable "desired_capacity" {
  description = "유지할 인스턴스 수"
  type        = number
  default     = 2
}
