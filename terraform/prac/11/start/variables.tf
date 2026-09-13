variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public Subnets for VPC"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

# 실습: for_each로 반복할 프로젝트 맵 변수를 추가하세요.
# 키는 프로젝트 이름, 값은 인스턴스 타입/개수/환경 등을 담은 객체입니다.
# variable "project" {
#   type = map(any)
#   default = {
#     proj-alpha = {
#       number_of_instances_per_subnet = 2,
#       number_of_subnets              = 2,
#       instance_type                  = "t3.micro",
#       project_environment            = "dev"
#     },
#     proj-beta = {
#       number_of_instances_per_subnet = 1,
#       number_of_subnets              = 2,
#       instance_type                  = "t3.micro",
#       project_environment            = "test"
#     }
#   }
# }
