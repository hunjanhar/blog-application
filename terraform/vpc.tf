resource "aws_vpc" "blog_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "blog-app-vpc" }
}

resource "aws_subnet" "blog_app_subnet" {
  vpc_id = aws_vpc.blog_app_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "blog-app-public-subnet" }
}

resource "aws_subnet" "rds_private_subnet_a" {
  vpc_id                  = aws_vpc.blog_app_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags                    = { Name = "rds-private-subnet-a" }
}

resource "aws_subnet" "rds_private_subnet_b" {
  vpc_id                  = aws_vpc.blog_app_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false 
  tags                    = { Name = "rds-private-subnet-b" }
}

resource "aws_internet_gateway" "blog_app_igw" {
  vpc_id = aws_vpc.blog_app_vpc.id
  tags   = { Name = "blog-app-igw" }
}

resource "aws_route_table" "blog_app_rt" {
  vpc_id = aws_vpc.blog_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.blog_app_igw.id
  }
  tags = { Name = "blog-app-route-table" }
}

resource "aws_route_table_association" "blog_app_rta" {
  subnet_id      = aws_subnet.blog_app_subnet.id
  route_table_id = aws_route_table.blog_app_rt.id
}