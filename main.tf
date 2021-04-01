# Provider AWS
provider "aws" {
  region = "us-east-1"
}
# AWS VPC
resource "aws_vpc" "my_app" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}
module "my_app_subnet" {
  source            = "./modules/subnets"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  env_prefix        = var.env_prefix
  vpc_id            = aws_vpc.my_app.id
}
#AWS Security Group
resource "aws_security_group" "sg" {
  name   = "my_sg"
  vpc_id = aws_vpc.my_app.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0    # for any
    to_port     = 0    #for any
    protocol    = "-1" #for any 
    cidr_blocks = ["0.0.0.0/0"]
    # prefix_list_ids = [] fpr vpc enpoints
  }
  tags = {
    Name = "${var.env_prefix}-sg"
  }
}
data "aws_ami" "latest_amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_key_pair" "my-key" {
  key_name = "my-key"
  ##  ssh-keygen -f tf_ec2_key
  public_key = file("tf_ec2.pub")
}
resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.latest_amazon_linux_ami.id
  instance_type               = var.instance_type
  subnet_id                   = module.my_app_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my-key.key_name
  user_data                   = file("script.sh")
  tags = {
    Name = "${var.env_prefix}-ec2"
  }
}