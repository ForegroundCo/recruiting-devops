terraform {
  backend "s3" {
    profile        = "myaws"
    bucket         = "sai-terraform"
    key            = "terraform/test/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "sai-terraform"
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}