//on-prem VPC
resource "aws_vpc" "on-prem" {
    provider = aws.onprem
  cidr_block = "192.168.0.0/16"
   tags = {
    Name = "on-prem"
  }
}


//on-prem VPC subnets
resource "aws_subnet" "on-prem-WAN" {
    provider = aws.onprem
  vpc_id     = aws_vpc.on-prem.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "on-prem-WAN"
  }
}
resource "aws_subnet" "on-prem-LAN" {
    provider = aws.onprem
  vpc_id     = aws_vpc.on-prem.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "on-prem-LAN"
  }
}
resource "aws_internet_gateway" "on-prem-igw" {
    provider = aws.onprem
  vpc_id = aws_vpc.on-prem.id

  tags = {
    Name = "on-prem-igw"
  }
}
