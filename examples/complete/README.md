## Usage

This is a complete config to work with this module.

```
provider "aws" {
    region = "ap-southeast-2"
  
}

module "vpc" {
    source = "./module/vpc"

    vpc_config = {
      cidr_block = "10.0.0.0/16"
      name = "my-test-vpc"
    }

    subnet_config = {
      public_subnet1 = {
        cidr_block = "10.0.0.0/24"
        az = "ap-southeast-2a"
        public = true
      }

      public_subnet2 = {
        cidr_block = "10.0.2.0/24"
        az = "ap-southeast-2a"
        public = true
      }

      private_subnet = {
        cidr_block = "10.0.1.0/24"
        az = "ap-southeast-2b"
      }
    }
  
}

```