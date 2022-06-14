
### Terraform Provider 

profile = "myaws"
region  = "ap-south-1"

### Terraform Tags

ProjectName     = "Foreground"
EnvironmentName = "Test"
sub_tags = {
  ResourceOwner = "saishashank"
  ProjectOwner  = "saishashank"
  ENV           = "Test"
}

### Vpc 

vpc_cidr = "10.0.0.0/16"

public_subnet_cidr = ["10.0.251.0/24"]