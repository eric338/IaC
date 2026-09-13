resource "aws_instance" "web" {
  for_each = var.instances

  ami               = var.ami_image[var.aws_region]
  instance_type     = each.value.instance_type
  availability_zone = each.value.az

  tags = {
    Name = each.key
    AZ   = each.value.az
  }
}
