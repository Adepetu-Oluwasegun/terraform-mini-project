terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "mini_project_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "mini-project-vpc"
  }
}

resource "aws_internet_gateway" "mini_project_igw" {
  vpc_id = aws_vpc.mini_project_vpc.id

  tags = {
    Name = "mini-project-igw"
  }
}

resource "aws_route_table" "mini_project_rt" {
  vpc_id = aws_vpc.mini_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mini_project_igw.id
  }

  tags = {
    Name = "mini-project-rt"
  }
}

resource "aws_subnet" "mini_project_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.mini_project_vpc.id
  cidr_block              = cidrsubnet("10.0.1.0/16", 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "mini-project-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "mini_project_association" {
  count          = 3
  subnet_id      = aws_subnet.mini_project_subnet[count.index].id
  route_table_id = aws_route_table.mini_project_rt.id
}

resource "aws_security_group" "mini_project_sg" {
  name        = "mini-project-sg"
  description = "Allow inbound HTTP and SSH traffic"
  vpc_id      = aws_vpc.mini_project_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mini-project-sg"
  }
}

resource "aws_instance" "mini_project_instance" {
  count           = 3
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.mini_project_sg.id]
  subnet_id       = aws_subnet.mini_project_subnet[count.index].id
  user_data       = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt-get upgrade -y
                EOF
  tags = {
    Name = "mini-project-instance-${count.index + 1}"
  }
}

resource "aws_lb" "mini_project_lb" {
  name               = "mini-project-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mini_project_sg.id]
  subnets            = aws_subnet.mini_project_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "mini-project-lb"
  }
}


resource "aws_lb_target_group" "mini_project_tg" {
  name     = "mini-project-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mini_project_vpc.id

  tags = {
    Name = "mini-project-tg"
  }
}

resource "aws_lb_listener" "mini_project_listener" {
  load_balancer_arn = aws_lb.mini_project_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.mini_project_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "mini_project_attachment" {
  count            = 3
  target_group_arn = aws_lb_target_group.mini_project_tg.arn
  target_id        = aws_instance.mini_project_instance[count.index].id
  port             = 80
}

resource "aws_route53_zone" "mini_project_r53" {
  name = var.domain_name
}

resource "aws_route53_record" "mini_project_r53_record" {
  zone_id = aws_route53_zone.mini_project_r53.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.mini_project_lb.dns_name
    zone_id                = aws_lb.mini_project_lb.zone_id
    evaluate_target_health = true
  }
}