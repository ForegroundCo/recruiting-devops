variable "ami" {
  default = "ami-0ebc1ac48dfd14136"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "termination_protection" {
  default = false
}

variable "key_name" {
  default = "talent"

}

variable "monitoring" {
  default = true
}

variable "vpc_security_group_ids" {
  default = []
}

variable "subnet_id" {}

variable "public_ip_address" {
  default = true
}

variable "ec2_role" {
  default = ""
}


variable "root_volume" {
  default = 11
}

variable "root_volume_encryption" {
  default = true
}

variable "root_volume_delete" {
  default = true
}

variable "user_data" {
  default = ""
}

variable "elastic_ip" {
  default = false
}

variable "sub_tags" {
  type = map(string)
}

variable "ec2Name" {
  type = map(string)
}
