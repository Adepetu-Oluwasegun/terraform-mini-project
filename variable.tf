variable "aws_region" {
  description = "AWS region"
  default = "eu-north-1"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Machine Image (AMI) ID"
}

variable "key_name"{
  description = "Name of EC2 key pair"
}

variable "security_group_ID" {
  description = "Security Group ID"
}

variable "subnet_ID" {
  description = "Subnet ID"
}

variable "vpc_ID" {
  description = "VPC ID"
}