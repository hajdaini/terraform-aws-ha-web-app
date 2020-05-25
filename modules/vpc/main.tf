# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  
  tags = {
    Name = "${var.prefix_name}-vpc"
  }
}

# Public subnets
resource "aws_subnet" "main-public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]

  tags = {
    Name = "${var.prefix_name}-public-${count.index}"
  }
}

# Private subnets
resource "aws_subnet" "main-private" {
  count                   = length(var.private_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.azs[count.index]

  tags = {
    Name = "${var.prefix_name}-private-${count.index}"
  }
}


# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix_name}"
  }
}

# Public route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "${var.prefix_name}-public"
  }
}

# Route associations public
resource "aws_route_table_association" "main-public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.main-public[count.index].id
  route_table_id = aws_route_table.main-public.id
}


# Elastic IP for NAT gw
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "${var.prefix_name}-eip"
  }
}

# Nat gw
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main-public[0].id
  depends_on    = [aws_internet_gateway.main-gw]
}

# Private route tables
resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "${var.prefix_name}-private"
  }
}

# Route associations private
resource "aws_route_table_association" "main-private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.main-private[count.index].id
  route_table_id = aws_route_table.main-private.id
}

