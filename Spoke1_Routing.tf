# ============================================================
# Core 1 - Layer 3: Application (Spoke1) VPC route tables
# Spoke1 has no IGW/NAT: all outbound traffic goes through the TGW
# ============================================================

# ---------- App subnets (10.10.1.0/24, 10.10.2.0/24) ----------
resource "aws_route_table" "spoke1_app" {
  vpc_id = aws_vpc.spoke1.id

  tags = {
    Name = "spoke1-app-rt"
  }
}

resource "aws_route" "spoke1_app_to_hub" {
  route_table_id         = aws_route_table.spoke1_app.id
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

resource "aws_route" "spoke1_app_to_onprem" {
  route_table_id         = aws_route_table.spoke1_app.id
  destination_cidr_block = "192.168.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

# Centralized egress: internet traffic goes TGW -> Hub NAT Gateway
resource "aws_route" "spoke1_app_internet" {
  route_table_id         = aws_route_table.spoke1_app.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

resource "aws_route_table_association" "spoke1_app_a" {
  subnet_id      = aws_subnet.spoke1-app-a.id
  route_table_id = aws_route_table.spoke1_app.id
}

resource "aws_route_table_association" "spoke1_app_b" {
  subnet_id      = aws_subnet.spoke1-app-b.id
  route_table_id = aws_route_table.spoke1_app.id
}

# ---------- DB subnets (10.10.3.0/24, 10.10.4.0/24) ----------
# Isolated: NO 0.0.0.0/0 route
resource "aws_route_table" "spoke1_db" {
  vpc_id = aws_vpc.spoke1.id

  tags = {
    Name = "spoke1-db-rt"
  }
}

resource "aws_route" "spoke1_db_to_hub" {
  route_table_id         = aws_route_table.spoke1_db.id
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

resource "aws_route" "spoke1_db_to_onprem" {
  route_table_id         = aws_route_table.spoke1_db.id
  destination_cidr_block = "192.168.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id
}

resource "aws_route_table_association" "spoke1_db_a" {
  subnet_id      = aws_subnet.spoke1-DB-a.id
  route_table_id = aws_route_table.spoke1_db.id
}

resource "aws_route_table_association" "spoke1_db_b" {
  subnet_id      = aws_subnet.spoke1-DB-b.id
  route_table_id = aws_route_table.spoke1_db.id
}
