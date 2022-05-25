# AWS EC2 Security Group Terraform Module
# Security Group for Public instance
module "public_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name        = "public-sg"
  description = "Security group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Block
  ingress_rules = ["https-443-tcp","ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0","1.1.1.1/32"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
}
