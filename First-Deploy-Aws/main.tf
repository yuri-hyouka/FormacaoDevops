terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Create a VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "dev_vpc_tag"
  }
}

resource "aws_subnet" "dev_subnet" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "172.16.10.0/24"

  tags = {
    Name = "dev_subnet_tag"
  }
}

resource "aws_network_interface" "enp" {
  subnet_id   = aws_subnet.dev_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

#Configure the AWS Instance
resource "aws_instance" "dev" {

    ami = "ami-052efd3df9dad4825"
    instance_type = "t2.micro"
    key_name = "terraform-aws"
    tags = {
      Name = "dev1"
    }

    network_interface {
    network_interface_id = aws_network_interface.enp.id
    device_index         = 0
  }
}