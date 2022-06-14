### Terraform Provider 

variable "profile" {}
variable "region" {}

### Terraform Aws Resource Tags

variable "sub_tags" {
  type = map(any)
}

variable "EnvironmentName" {}
variable "ProjectName" {}


variable "vpc_cidr" {}

variable "public_subnet_cidr" {
}

data "aws_availability_zones" "azs" {
}
