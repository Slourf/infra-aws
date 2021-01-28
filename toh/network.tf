resource "aws_vpc" "devops_vpc_toh" {
    cidr_block = "10.0.0.0/16"

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        "Name" = "devops-vpc-toh"
    }
}

resource "aws_subnet" "devops_vpc_toh_subnet_1" {
    vpc_id = aws_vpc.devops_vpc_toh.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-3a"

    tags = {
      "Name" = "devops-vpc-toh-subnet-1"
    }
}

resource "aws_subnet" "devops_vpc_toh_subnet_2" {
    vpc_id = aws_vpc.devops_vpc_toh.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-3b"

    tags = {
      "Name" = "devops-vpc-toh-subnet-2"
    }
}

resource "aws_internet_gateway" "devops_vpc_toh_internet_gateway" {
    vpc_id = aws_vpc.devops_vpc_toh.id

    tags = {
      Name = "devops-vpc-toh-internet-gateway"
    }
}

resource "aws_route" "devops_vpc_route_table_gateway" {
  route_table_id = aws_vpc.devops_vpc_toh.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id     = aws_internet_gateway.devops_vpc_toh_internet_gateway.id
}