output "instance_ids" {
  description = "인스턴스 이름 -> ID"
  value = {
    for name, inst in aws_instance.web : name => inst.id
  }
}
