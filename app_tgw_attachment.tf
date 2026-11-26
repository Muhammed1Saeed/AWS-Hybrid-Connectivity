# Application VPC: Transit Gateway attachment
# Requires: aws_ec2_transit_gateway.tgw, aws_vpc.app, aws_subnet.app_tgw[*]

resource "aws_ec2_transit_gateway_vpc_attachment" "app" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.app.id
  subnet_ids         = aws_subnet.app_tgw[*].id # 10.10.5.0/24, 10.10.6.0/24

  tags = { Name = "app-tgw-attachment" }
}
