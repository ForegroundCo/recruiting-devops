module "vpc" {
  source                  = "../../modules/Vpc_Network_Stack"
  vpc_cidr                = var.vpc_cidr
  sub_tags                = var.sub_tags
  VpcName                 = { Name = "${var.ProjectName}-${var.EnvironmentName}-VPC" }
  igwName                 = { Name = "${var.ProjectName}-${var.EnvironmentName}-IGW" }
  PublicSubnetName        = { Name = "${var.ProjectName}-${var.EnvironmentName}-PublicSubnet" }
  subnet_availabilityZone = data.aws_availability_zones.azs.names[0]
  public_subnet_cidr      = var.public_subnet_cidr[0]
  PublicRouteTableName    = { Name = "${var.ProjectName}-${var.EnvironmentName}-PublicRouteTable" }
}

module "S3" {
  source     = "../../modules/S3"
  bucketName = lower("${var.ProjectName}-${var.EnvironmentName}")
  tags       = merge({ Name = "${var.ProjectName}-${var.EnvironmentName}-S3" }, var.sub_tags)
}

resource "aws_security_group" "Web_sg" {
  name   = "${var.ProjectName}-${var.EnvironmentName}-Public-SG"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "${var.ProjectName}-${var.EnvironmentName}-Public-SG" }, var.sub_tags)
}

resource "aws_security_group" "ssh_sg" {
  name   = "${var.ProjectName}-${var.EnvironmentName}-Ssh-SG"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["1.1.1.1/32", "8.8.8.8/32"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["1.1.1.1/32", "8.8.8.8/32"]
  }
  tags = merge({ Name = "${var.ProjectName}-${var.EnvironmentName}-Ssh-SG" }, var.sub_tags)
}

resource "aws_iam_policy" "Ec2_S3_policy" {
  name        = "Ec2_S3_policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          module.S3.s3_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.Ec2_S3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_S3_profile" {
  name = "some-profile"
  role = aws_iam_role.ec2_role.name
}

module "Ec2" {
  source                 = "../../modules/Ec2"
  subnet_id              = module.vpc.public_subnet_id
  ec2_role               = aws_iam_instance_profile.ec2_S3_profile.id
  vpc_security_group_ids = [aws_security_group.Web_sg.id, aws_security_group.ssh_sg.id]
  sub_tags               = var.sub_tags
  ec2Name                = { Name = "${var.ProjectName}-${var.EnvironmentName}-App" }
  user_data              = <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx
EOF
}