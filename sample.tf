provider "aws" {
  region = "ap-south-1"
}

variable "vpc_cidr" {
    description = "For the Cidr block"
    type = list (object({
        cidr_block = string
        name= string
    }))
  
}

resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_cidr[0].cidr_block
  
  tags = {
    "name" = var.vpc_cidr[0].name
  }
}

resource "aws_subnet" "dev_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.dev_vpc.id
}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "default_subnet" {
  cidr_block = "172.31.48.0/20"
  vpc_id = data.aws_vpc.existing_vpc.id
}

output "vpc_output" {
  value = aws_vpc.dev_vpc.id
}