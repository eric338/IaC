module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "asg-vpc-${local.iam_user_name}"
  cidr = "10.10.0.0/16"

  azs            = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets = ["10.10.1.0/24", "10.10.2.0/24"]

  enable_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "web" {
  name        = "asg-web-sg-${local.iam_user_name}"
  description = "Allow HTTP inbound"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "asg-web-sg-${local.iam_user_name}" }
}

resource "aws_launch_template" "web" {
  name_prefix   = "asg-web-${local.iam_user_name}-"
  image_id      = var.ami_id
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web.id]
    delete_on_termination       = true
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
    systemctl enable --now nginx
  EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-web-${local.iam_user_name}"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "asg-web-${local.iam_user_name}"
  vpc_zone_identifier = module.vpc.public_subnets

  min_size         = 1
  max_size         = 4
  desired_capacity = var.desired_capacity

  health_check_type         = "EC2"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-web-${local.iam_user_name}"
    propagate_at_launch = true
  }
}
