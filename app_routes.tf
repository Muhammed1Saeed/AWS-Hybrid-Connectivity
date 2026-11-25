# Application VPC: route injection via Transit Gateway
# Requires: aws_route_table.app, aws_route_table.app_db and the app attachment

locals {
  # App subnets: Hub, On-Prem, centralized egress via TGW
  app_tgw_routes = ["10.0.0.0/16", "192.168.0.0/16", "0.0.0.0/0"]

  # DB subnets: isolated, no default route
  db_tgw_routes = ["10.0.0.0/16", "192.168.0.0/16"]
}

resource "aws_route" "app_via_tgw" {
  for_each = toset(local.app_tgw_routes)

  route_table_id         = aws_route_table.app.id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.app]
}

resource "aws_route" "db_via_tgw" {
  for_each = toset(local.db_tgw_routes)

  route_table_id         = aws_route_table.app_db.id
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.app]
}
