output "first_instance_ip" {
  value = aws_instance.mini_project_instance[0].public_ip
}

output "second_instance_ip" {
  value = aws_instance.mini_project_instance[1].public_ip
}

output "third_instance_ip" {
  value = aws_instance.mini_project_instance[2].public_ip
}
