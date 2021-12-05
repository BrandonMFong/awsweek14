# Author: Brando 

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.59.0"
    }
  }

  backend "s3" {
    bucket = "ece592-cloudtrail-brando"
    key    = "state.week14"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default" # From a ~/.aws/credentials file.
}

# VPC
resource "aws_vpc" "week14-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "week14-vpc"
  }
}

# Subnets 

# Public Subnet 1
resource "aws_subnet" "week14-sub-a" {
  vpc_id                  = aws_vpc.week14-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "week14-sub-a"
  }
}

resource "aws_route_table_association" "week14-sub-a-assoc" {
  subnet_id      = aws_subnet.week14-sub-a.id
  route_table_id = aws_route_table.week14-pub-rt.id
}

# Public Subnet 2
resource "aws_subnet" "week14-sub-b" {
  vpc_id                  = aws_vpc.week14-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "week14-sub-b"
  }
}

resource "aws_route_table_association" "week14-sub-b-assoc" {
  subnet_id      = aws_subnet.week14-sub-b.id
  route_table_id = aws_route_table.week14-pub-rt.id
}

# Private Subnet 1
resource "aws_subnet" "week14-pri-a" {
  vpc_id                  = aws_vpc.week14-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "week14-pri-a"
  }
}

resource "aws_route_table_association" "week14-pri-a-assoc" {
  subnet_id      = aws_subnet.week14-pri-a.id
  route_table_id = aws_route_table.week14-pri-rt.id
}

# Private Subnet 2
resource "aws_subnet" "week14-pri-b" {
  vpc_id                  = aws_vpc.week14-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "week14-pri-b"
  }
}

resource "aws_route_table_association" "week14-pri-b-assoc" {
  subnet_id      = aws_subnet.week14-pri-b.id
  route_table_id = aws_route_table.week14-pri-rt.id
}

# Internet Gate Way 
resource "aws_internet_gateway" "week14-igw-v2" {
  vpc_id = aws_vpc.week14-vpc.id

  tags = {
    Name = "week14-igw"
  }
}

# Route Table
resource "aws_route_table" "week14-pri-rt" {
  vpc_id = aws_vpc.week14-vpc.id

  route = []

  tags = {
    Name = "week14-pri-rt"
  }
}

resource "aws_route_table" "week14-pub-rt" {
  vpc_id = aws_vpc.week14-vpc.id

  route = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.week14-igw-v2.id

    # Values suggested by professor
    egress_only_gateway_id    = ""
    instance_id               = ""
    ipv6_cidr_block           = ""
    nat_gateway_id            = ""
    network_interface_id      = ""
    transit_gateway_id        = ""
    vpc_endpoint_id           = ""
    vpc_peering_connection_id = ""

    # Values suggested by the validate process
    # Investigate these values if there is an issue
    # with our config
    carrier_gateway_id         = ""
    destination_prefix_list_id = ""
    local_gateway_id           = ""
  }, ]

  tags = {
    Name = "week14-pub-rt"
  }
}

# Security Group
resource "aws_security_group" "week14-ssh-sg-v2" {
  name        = "week14_ssh_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.week14-vpc.id

  ingress = [{
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    # Suggested by professor
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  egress = [{
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    # Suggested
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = "week14-ssh-sg"
  }
}

# Security group for db
resource "aws_security_group" "week14-rds-sg" {
  name        = "week14-rds-sg"
  description = "DB Security group for week 12"
  vpc_id      = aws_vpc.week14-vpc.id

  ingress = [{
    description = "SSH from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    # Suggested by professor
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  egress = []

  tags = {
    Name = "DB security group Week 12"
  }
}
