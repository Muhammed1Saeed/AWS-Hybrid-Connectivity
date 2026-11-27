########################################################
# Hub VPC Attachment to the Transit Gateway
# Uses the Hub TGW subnets (10.0.4.0/24 and 10.0.5.0/24),
# one subnet per Availability Zone.
########################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.Trasit-GW.id
  vpc_id             = aws_vpc.hub.id

  subnet_ids = [
    aws_subnet.hub-pvt-TGW-a.id,
    aws_subnet.hub-pvt-TGW-b.id
  ]

  tags = {
    Name = "hub-tgw-attachment"
  }
}
