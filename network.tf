resource "aws_vpc" "test_vpc" {
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "menta-vpc2"
  }
}

resource "aws_subnet" "elb-public1" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.31.102.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "elb-public1" 
  }
}

module "vpc" {
  source  = "app.terraform.io/test-horosi1900day/vpc/aws"
  version = "0.0.2"
  system   = "test"
  env      = "prd"
  cidr_vpc = "10.1.0.0/16"
  cidr_public = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]
  cidr_private = [
    "10.1.101.0/24",
    "10.1.102.0/24",
    "10.1.103.0/24"
  ]
  cidr_secure = [
    "10.1.201.0/24",
    "10.1.202.0/24",
    "10.1.203.0/24"
  ]
}