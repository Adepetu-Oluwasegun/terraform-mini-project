variable "aws_region" {
  #description = "AWS region"
  default = "eu-north-1"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Amazon Machine Image (AMI) ID"
  default     = "ami-0c1ac8a41498c1a9c"
}

variable "key_name" {
  description = "Name of EC2 key pair"
  default     = "miniproject"
}

variable "cidr_block" {
  description = "cidr block"
  default     = "10.0.0.0/16"

}

variable "domain_name" {
  description = "my domain name"
  default     = "oluwasegun.me"

}
#variable "security_group_ID" {
#description = "Security Group ID"
#}

#variable "subnet_ID" {
#description = "Subnet ID"
#}

#variable "vpc_ID" {
#description = "VPC ID"