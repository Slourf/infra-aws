resource "aws_vpc" "devops-vpc-2" {
    cidr_block = "10.0.0.0/16"

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        "Name" = "devops-vpc-2"
    }
}

resource "aws_subnet" "devops-vpc-2-subnet-1" {
    vpc_id = aws_vpc.devops-vpc-2.id
    cidr_block = "10.0.1.0/24"

    tags = {
      "Name" = "devops-vpc-2-subnet-1"
    }
}

resource "aws_subnet" "devops-vpc-2-subnet-2" {
    vpc_id = aws_vpc.devops-vpc-2.id
    cidr_block = "10.0.2.0/24"

    tags = {
      "Name" = "devops-vpc-2-subnet-2"
    }
}