provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name        = var.cidr_blocks[0].name
    Environment = var.env
  }
}
resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.cidr_blocks[1].cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name = var.cidr_blocks[1].name
  }
}
resource "aws_subnet" "tf_subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.cidr_blocks[2].cidr_block
  availability_zone = "us-east-1b"
  tags = {
    Name = var.cidr_blocks[2].name
  }
}