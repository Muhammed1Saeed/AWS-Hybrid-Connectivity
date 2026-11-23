########################################################
# Core 1 - Internal Application Load Balancer (Hub VPC)
# ALB + Target Group (type ip) + HTTP Listener
# Targets (app servers in Spoke1) are registered in Spoke1_Compute.tf
########################################################

############################
# Internal ALB
############################
resource "aws_lb" "hub_alb" {
  name               = "hub-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.hub-pvt-ALB-a.id,
    aws_subnet.hub-pvt-ALB-b.id
  ]

  tags = {
    Name = "hub-internal-alb"
  }
}

############################
# Target Group (type ip)
############################
resource "aws_lb_target_group" "app" {
  name        = "spoke1-app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.hub.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "spoke1-app-tg"
  }
}

############################
# Listener (HTTP 80 -> Target Group)
############################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.hub_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

############################
# Output: ALB DNS name (used for curl test from the Bastion)
############################
output "hub_alb_dns_name" {
  description = "Internal ALB DNS name"
  value       = aws_lb.hub_alb.dns_name
}
