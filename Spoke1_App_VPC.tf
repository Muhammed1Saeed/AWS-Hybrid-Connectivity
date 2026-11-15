//spoke1 VPC
resource "aws_vpc" "spoke1" {
  cidr_block = "10.10.0.0/16"
   tags = {
    Name = "spoke1"
  }
}


//spoke1 VPC subnets
resource "aws_subnet" "spoke1-app-a" {
  vpc_id     = aws_vpc.spoke1.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "spoke1-app-a"
  }
}
resource "aws_subnet" "spoke1-app-b" {
  vpc_id     = aws_vpc.spoke1.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "spoke1-app-b"
  }
}
resource "aws_subnet" "spoke1-DB-a" {
  vpc_id     = aws_vpc.spoke1.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "spoke1-DB-a"
  }
}
resource "aws_subnet" "spoke1-DB-b" {
  vpc_id     = aws_vpc.spoke1.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "spoke1-DB-b"
  }
}
resource "aws_subnet" "spoke1-TGW-a" {
  vpc_id     = aws_vpc.spoke1.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "spoke1-TGW-a"
  }
}
resource "aws_subnet" "spoke1-TGW-b" {
  vpc_id     = aws_vpc.spoke1.id
  cidr_block = "10.10.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "spoke1-TGW-b"
  }
}
resource "aws_subnet" "spoke1-endpoint-a" {
  vpc_id     = aws_vpc.spoke1.id
  cidr_block = "10.10.7.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "spoke1-endpoint-a"
  }
}
resource "aws_subnet" "spoke1-endpoint-b" {
  vpc_id     = aws_vpc.spoke1.id
  cidr_block = "10.10.8.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "spoke1-endpoint-b"
  }
}


