# Application VPC: route tables, associations, and routes via Transit Gateway

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.spoke1.id
  tags   = { Name = "spoke1-app-rt" }
}

resource "aws_route_table" "app_db" {
  vpc_id = aws_vpc.spoke1.id
  tags   = { Name = "spoke1-db-rt" }
}

resource "aws_route_table_association" "app_a" {
  subnet_id      = aws_subnet.spoke1-app-a.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "app_b" {
  subnet_id      = aws_subnet.spoke1-app-b.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.spoke1-DB-a.id
  route_table_id = aws_route_table.app_db.id
}

resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.spoke1-DB-b.id
  route_table_id = aws_route_table.app_db.id
}

locals {
  app_tgw_routes = ["10.0.0.0/16", "192.168.0.0/16", "0.0.0.0/0"]
  db_tgw_routes  = ["10.0.0.0/16", "192.168.0.0/16"]
}

resource "aws_route" "app_via_tgw" {
  for_each = toset(local.app_tgw_routes)

  route_table_id         = aws_route_table.app.id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.app]
}

resource "aws_route" "db_via_tgw" {
  for_each = toset(local.db_tgw_routes)

  route_table_id         = aws_route_table.app_db.id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.Trasit-GW.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.app]
}
