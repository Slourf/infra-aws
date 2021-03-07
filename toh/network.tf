resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        "Name" = "${var.app_name}-vpc"
    }
}

resource "aws_subnet" "vpc_subnet_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-3a"

    tags = {
      "Name" = "${var.app_name}-vpc-subnet-1"
    }
}

resource "aws_subnet" "vpc_subnet_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-3b"

    tags = {
      "Name" = "${var.app_name}-vpc-subnet-2"
    }
}

resource "aws_internet_gateway" "vpc_internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.app_name}-vpc-internet-gateway"
    }
}

resource "aws_route" "vpc_route_table_gateway" {
  route_table_id = aws_vpc.vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id     = aws_internet_gateway.vpc_internet_gateway.id
}