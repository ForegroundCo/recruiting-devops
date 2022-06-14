### Network Stack

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.vpc_tenancy
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags                 = merge(var.VpcName, var.sub_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.igwName, var.sub_tags)
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.subnet_availabilityZone
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags                    = merge(var.PublicSubnetName, var.sub_tags)
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.PublicRouteTableName, var.sub_tags)
}

resource "aws_route" "Public_Routes" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = var.service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.route_table.id]
  tags              = var.sub_tags
}