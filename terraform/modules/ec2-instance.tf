# AWS EC2 Instance Terraform Module
#  EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # insert required variables here
  name = "test-instance"
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name = var.instance_keypair
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_sg.this_security_group_id]
  iam_instance_profile = "${aws_iam_instance_profile.zentekprofile.name}"
}
