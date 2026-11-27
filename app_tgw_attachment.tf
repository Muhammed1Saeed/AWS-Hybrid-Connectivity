# Application VPC: Transit Gateway attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "app" {
  transit_gateway_id = aws_ec2_transit_gateway.Trasit-GW.id
  vpc_id             = aws_vpc.spoke1.id
  subnet_ids = [
    aws_subnet.spoke1-TGW-a.id,
    aws_subnet.spoke1-TGW-b.id
  ]

  tags = { Name = "app-tgw-attachment" }
}
