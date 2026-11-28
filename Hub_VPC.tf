//Hub VPC
resource "aws_vpc" "hub" {
  cidr_block = "10.0.0.0/16"
   tags = {
    Name = "hub"
  }
}


//Hub VPC subnets
resource "aws_subnet" "hub-pub-a" {
  vpc_id     = aws_vpc.hub.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "hub-pub-a"
  }
}
resource "aws_subnet" "hub-pvt-ALB-a" {
  vpc_id     = aws_vpc.hub.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "hub-pvt-ALB-a"
  }
}
resource "aws_subnet" "hub-pvt-ALB-b" {
  vpc_id     = aws_vpc.hub.id
  cidr_block = "10.0.3.0/24"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "hub-pvt-ALB-b"
  }
}
resource "aws_subnet" "hub-pvt-TGW-a" {
  vpc_id     = aws_vpc.hub.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "hub-pvt-TGW-a"
  }
}
resource "aws_subnet" "hub-pvt-TGW-b" {
  vpc_id     = aws_vpc.hub.id
  cidr_block = "10.0.5.0/24"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "hub-pvt-TGW-b"
  }
}
resource "aws_internet_gateway" "hub-igw" {
  vpc_id = aws_vpc.hub.id

  tags = {
    Name = "hub-igw"
  }
}
# 1. Create the Elastic IP (Required for public NAT Gateways)
resource "aws_eip" "eip-nat" {
  domain = "vpc"

  tags = {
    Name = "eip-nat"
  }
}

# 2. Attach it to the NAT Gateway
resource "aws_nat_gateway" "hub-nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.hub-pub-a.id # Must be a PUBLIC subnet

  tags = {
    Name = "hub-nat"
  }

  depends_on = [aws_internet_gateway.hub-igw]
}


