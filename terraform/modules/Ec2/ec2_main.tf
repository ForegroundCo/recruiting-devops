resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  disable_api_termination     = var.termination_protection
  key_name                    = var.key_name
  monitoring                  = var.monitoring
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.public_ip_address
  iam_instance_profile        = var.ec2_role
  root_block_device {
    volume_size           = var.root_volume
    encrypted             = var.root_volume_encryption
    delete_on_termination = var.root_volume_delete
  }
  user_data   = var.user_data
  volume_tags = merge(var.ec2Name, var.sub_tags)
  tags        = merge(var.ec2Name, var.sub_tags)
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}
