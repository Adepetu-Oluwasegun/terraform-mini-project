provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "miniproject-sg" {
  name        = "miniproject-sg"
  description = "Allow web and SSH traffic"

  ingress = [
    {
      description      = "HTTP access"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "miniproject-sg"
  }
}

resource "aws_instance" "terraform-mini-project" {
  count         = 3
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_ID
  #security_groups = [ var.security_group_ID ]

  tags = {
    Name = "MyEC2Instance-${count.index}"
  }
  # output the public ips into a file
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> host-inventory"
  }
}

resource "aws_lb" "miniproject_lb" {
  name               = "mini-project-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.miniproject-sg.id]
  subnets            = [var.subnet_ID]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "miniproject_tg" {
  name     = "miniproject-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_ID
}
resource "aws_lb_listener" "miniproject_listener" {
  load_balancer_arn = aws_lb.miniproject_lb.arn
  port              = 80
  default_action {
    type = "fixed-response"
    fixed_response {
      status_code  = 200
      content_type = "text/plain"
      message_body = "Helo from the other side!"
    }
  }
}

resource "aws_lb_target_group_attachment" "miniproject_attachment" {
  count            = 3
  target_group_arn = aws_lb_target_group.miniproject_tg.arn
  target_id        = aws_instance.terraform-mini-project[count.index].id
  port             = 80
}