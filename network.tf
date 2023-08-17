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