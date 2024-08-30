
resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_config.cidr_block

    tags = {
      Name = var.vpc_config.name
    }
  
}

resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.my_vpc.id

    for_each = var.subnet_config  # key = {cidr_block, az}

    cidr_block = each.value.cidr_block
    availability_zone = each.value.az

    tags = {
      Name = each.key
    }
  
}

locals {
  public_subnets = {
    for key, config in var.subnet_config: key => config if config.public
  }

  private_subnets = {
    for key, config in var.subnet_config: key => config if !config.public
  }
}

# Internet gateway if there is at least one public subnet
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(local.public_subnets) > 0 ? 1 : 0
  
}

# Routing table
resource "aws_route_table" "my_rt" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(local.public_subnets) > 0 ? 1 : 0
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw[0].id
    }
}

# Routing table association
resource "aws_route_table_association" "my_rta" {
    for_each = local.public_subnets
    subnet_id = aws_subnet.my_subnet[each.key].id
    route_table_id = aws_route_table.my_rt[0].id
  
}