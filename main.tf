provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "my_app" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.my_app.id
  cidr_block = var.subnet_cidr_block
  tags = {
    Name = "${var.env_prefix}-subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_app.id
  tags = {
      Name = "${var.env_prefix}-igw"
  }
}
resource "aws_route_table" "my_app_route_table" {
  vpc_id = aws_vpc.my_app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
      Name = "${var.env_prefix}-rtb"
  }
}