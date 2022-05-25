# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"
  # version = "~> 2.78"

  # VPC Basic Details
  name = "vpc-dev"
  cidr = "10.0.0.0/16"
  azs                 = ["us-east-2a"]
  public_subnets      = ["10.0.101.0/24"]

  #create_database_nat_gateway_route = true
  #create_database_internet_gateway_route = true

  # NAT Gateways - Outbound Communication
  #enable_nat_gateway = true
  #single_nat_gateway = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support = true

  public_subnet_tags = {
    Type = "public-subnets"
  }

  tags = {
    Owner = "mahen"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-dev"
  }
}
