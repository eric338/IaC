variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1" # Tokyo Region
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "myproject"
}

variable "project_environment" {
  description = "Name of the environment"
  type        = string
  default     = "development"
}

variable "ami_image" {
  description = "Ubuntu 24.04 LTS Image"
  type        = map(string)
  default = {
    ap-northeast-1 = "ami-025ece6a3a0e7558f" # Ubuntu 24.04 20260203 in Tokyo Region
    ap-northeast-2 = "ami-096dce0fcb85a808f" # Ubuntu 24.04 20260203 in Seoul Region
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
