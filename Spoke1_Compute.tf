########################################################
# Core 1 - Compute
# 2 App servers (Spoke1), 1 Bastion (Hub), Target Group registrations
# Key Pair "core1-key" is created manually in the AWS Console.
########################################################

variable "key_name" {
  description = "Name of the existing EC2 Key Pair (created manually in the console)"
  type        = string
  default     = "core1-key"
}

############################
# AMI: latest Amazon Linux 2023
############################
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

############################
# User data: install nginx and deploy the website from GitHub
# (written as a joined list so line endings are always LF)
############################
locals {
  app_user_data = join("\n", [
    "#!/bin/bash",
    "dnf install -y nginx git",
    "git clone https://github.com/mahmoudgamal26/cyber_shield /tmp/site",
    "cp -r /tmp/site/* /usr/share/nginx/html/",
    "systemctl enable --now nginx"
  ])
}

############################
# App Server 1 (spoke1-app-a)
############################
resource "aws_instance" "app_a" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.spoke1-app-a.id
  private_ip                  = "10.10.1.10"
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  user_data                   = local.app_user_data
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "spoke1-app-a"
  }
}

############################
# App Server 2 (spoke1-app-b)
############################
resource "aws_instance" "app_b" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.spoke1-app-b.id
  private_ip                  = "10.10.2.10"
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  user_data                   = local.app_user_data
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "spoke1-app-b"
  }
}

############################
# Bastion Host (hub-pub-a)
############################
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.hub-pub-a.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "hub-bastion"
  }
}

############################
# Register the app servers in the ALB Target Group
# availability_zone = "all" is required because the targets
# are in a different VPC (Spoke1) than the ALB (Hub).
############################
resource "aws_lb_target_group_attachment" "app_a" {
  target_group_arn  = aws_lb_target_group.app.arn
  target_id         = aws_instance.app_a.private_ip
  port              = 80
  availability_zone = "all"
}

resource "aws_lb_target_group_attachment" "app_b" {
  target_group_arn  = aws_lb_target_group.app.arn
  target_id         = aws_instance.app_b.private_ip
  port              = 80
  availability_zone = "all"
}

############################
# Output: Bastion public IP
############################
output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = aws_instance.bastion.public_ip
}
