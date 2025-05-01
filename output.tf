output "first_instance_ip" {
  value = aws_instance.mini_project_instance[0].public_ip
}

output "second_instance_ip" {
  value = aws_instance.mini_project_instance[1].public_ip
}

output "third_instance_ip" {
  value = aws_instance.mini_project_instance[2].public_ip
}

output "name_servers" {
  description = "Route 53 name servers for your domain"
  value       = aws_route53_zone.mini_project_r53
}

output "domain_url" {
  description = "Website URL"
  value       = "https://${var.domain_name}"
}

output "subdomain_url" {
  description = "Terraform test subdomain URL"
  value       = "https://terraform-test.${var.domain_name}"
}