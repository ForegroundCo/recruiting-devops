variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Vpc CIDR Range"
}

variable "vpc_tenancy" {
  default = "default"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "VpcName" {
  type        = map(string)
  description = "VPC Name"
}

variable "sub_tags" {
  type        = map(string)
  description = "Sub Tags Name"
}

variable "igwName" {
  type        = map(string)
  description = "Igw Name"
}

##SubNets


variable "subnet_availabilityZone" {
  description = "Availability Zone Id"
}

variable "PublicSubnetName" {
  default     = {}
  type        = map(string)
  description = "Subnet Name"
}

variable "PublicRouteTableName" {
  default     = {}
  type        = map(string)
  description = "Subnet Name"
}

variable "public_subnet_cidr" {
}

variable "service_name" {
  default = "com.amazonaws.ap-south-1.s3"
}