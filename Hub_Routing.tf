# ============================================================
# Core 1 - Layer 3: Hub VPC route tables
# ============================================================

# ---------- Public subnet (10.0.1.0/24) ----------
resource "aws_route_table" "hub_public" {
  vpc_id = aws_vpc.hub.id

  tags = {
    Name = "hub-public-rt"
  }
}

resource "aws_route" "hub_public_internet" {
  route_table_id         = aws_route_table.hub_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hub-igw.id
}

# Return routes so replies to Spoke/On-Prem go back through the TGW
resource "aws_route" "hub_public_to_spoke" {
  route_table_id         = aws_route_table.hub_public.id
  destination_cidr_block = "10.10.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

resource "aws_route" "hub_public_to_onprem" {
  route_table_id         = aws_route_table.hub_public.id
  destination_cidr_block = "192.168.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

resource "aws_route_table_association" "hub_public_a" {
  subnet_id      = aws_subnet.hub-pub-a.id
  route_table_id = aws_route_table.hub_public.id
}

# ---------- Private ALB subnets (10.0.2.0/24, 10.0.3.0/24) ----------
resource "aws_route_table" "hub_alb" {
  vpc_id = aws_vpc.hub.id

  tags = {
    Name = "hub-alb-rt"
  }
}

resource "aws_route" "hub_alb_to_spoke" {
  route_table_id         = aws_route_table.hub_alb.id
  destination_cidr_block = "10.10.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

resource "aws_route" "hub_alb_to_onprem" {
  route_table_id         = aws_route_table.hub_alb.id
  destination_cidr_block = "192.168.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

resource "aws_route" "hub_alb_internet" {
  route_table_id         = aws_route_table.hub_alb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.hub-nat.id
}

resource "aws_route_table_association" "hub_alb_a" {
  subnet_id      = aws_subnet.hub-pvt-ALB-a.id
  route_table_id = aws_route_table.hub_alb.id
}

resource "aws_route_table_association" "hub_alb_b" {
  subnet_id      = aws_subnet.hub-pvt-ALB-b.id
  route_table_id = aws_route_table.hub_alb.id
}

# ---------- TGW subnets (10.0.4.0/24, 10.0.5.0/24) ----------
# Spoke outbound internet traffic arrives here and is sent to the NAT Gateway
resource "aws_route_table" "hub_tgw" {
  vpc_id = aws_vpc.hub.id

  tags = {
    Name = "hub-tgw-rt"
  }
}

resource "aws_route" "hub_tgw_internet" {
  route_table_id         = aws_route_table.hub_tgw.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.hub-nat.id
}

resource "aws_route_table_association" "hub_tgw_a" {
  subnet_id      = aws_subnet.hub-pvt-TGW-a.id
  route_table_id = aws_route_table.hub_tgw.id
}

resource "aws_route_table_association" "hub_tgw_b" {
  subnet_id      = aws_subnet.hub-pvt-TGW-b.id
  route_table_id = aws_route_table.hub_tgw.id
}
