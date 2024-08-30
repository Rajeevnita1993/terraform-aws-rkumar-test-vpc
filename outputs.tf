# VPC
output "vpc_id" {
    value = aws_vpc.my_vpc.id
  
}

locals {
  public_subnet_output = {
    for key, config in local.public_subnets: key => {
        subnet_id = aws_subnet.my_subnet[key].id
        az = aws_subnet.my_subnet[key].availability_zone
    }
  }

  private_subnet_output = {
    for key, config in local.private_subnets: key => {
        subnet_id = aws_subnet.my_subnet[key].id
        az = aws_subnet.my_subnet[key].availability_zone
    }
  }
}

# Public subnets
output "public_subnets" {
    value = local.public_subnet_output
  
}

# Private subnets
output "private_subnets" {
  value = local.private_subnet_output
}