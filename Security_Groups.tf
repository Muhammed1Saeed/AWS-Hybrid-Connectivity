########################################################
# Core 1 - Security Groups
# ALB (Hub), Bastion (Hub), App (Spoke1), DB (Spoke1)
# Note: SGs cannot reference SGs across VPCs here, so CIDRs are used.
########################################################

variable "bastion_ssh_cidr" {
  description = "CIDR allowed to SSH into the Bastion. Tighten to your own IP, e.g. 197.x.x.x/32"
  type        = string
  default     = "0.0.0.0/0"
}

############################
# ALB Security Group (Hub)
############################
resource "aws_security_group" "alb" {
  name        = "hub-alb-sg"
  description = "Internal ALB in Hub VPC"
  vpc_id      = aws_vpc.hub.id

  tags = {
    Name = "hub-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_from_spoke" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from Spoke1"
  cidr_ipv4         = "10.10.0.0/16"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_from_onprem" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from On-Prem"
  cidr_ipv4         = "192.168.0.0/16"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound (to app servers via TGW)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

############################
# Bastion Security Group (Hub)
############################
resource "aws_security_group" "bastion" {
  name        = "hub-bastion-sg"
  description = "Bastion host in Hub public subnet"
  vpc_id      = aws_vpc.hub.id

  tags = {
    Name = "hub-bastion-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion.id
  description       = "SSH to Bastion"
  cidr_ipv4         = var.bastion_ssh_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion_all_out" {
  security_group_id = aws_security_group.bastion.id
  description       = "Allow all outbound"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

############################
# App Security Group (Spoke1)
############################
resource "aws_security_group" "app" {
  name        = "spoke1-app-sg"
  description = "App servers in Spoke1 app subnets"
  vpc_id      = aws_vpc.spoke1.id

  tags = {
    Name = "spoke1-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_http_from_alb_a" {
  security_group_id = aws_security_group.app.id
  description       = "HTTP from ALB subnet a"
  cidr_ipv4         = "10.0.2.0/24"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "app_http_from_alb_b" {
  security_group_id = aws_security_group.app.id
  description       = "HTTP from ALB subnet b"
  cidr_ipv4         = "10.0.3.0/24"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_bastion" {
  security_group_id = aws_security_group.app.id
  description       = "SSH from Bastion subnet"
  cidr_ipv4         = "10.0.1.0/24"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "app_all_out" {
  security_group_id = aws_security_group.app.id
  description       = "Allow all outbound (internet via TGW and NAT)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

############################
# DB Security Group (Spoke1)
############################
resource "aws_security_group" "db" {
  name        = "spoke1-db-sg"
  description = "Database in Spoke1 DB subnets"
  vpc_id      = aws_vpc.spoke1.id

  tags = {
    Name = "spoke1-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_mysql_from_app_a" {
  security_group_id = aws_security_group.db.id
  description       = "MySQL from app subnet a"
  cidr_ipv4         = "10.10.1.0/24"
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
}

resource "aws_vpc_security_group_ingress_rule" "db_mysql_from_app_b" {
  security_group_id = aws_security_group.db.id
  description       = "MySQL from app subnet b"
  cidr_ipv4         = "10.10.2.0/24"
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
}

resource "aws_vpc_security_group_ingress_rule" "db_mysql_from_onprem_lan" {
  security_group_id = aws_security_group.db.id
  description       = "MySQL from On-Prem LAN"
  cidr_ipv4         = "192.168.2.0/24"
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
}
