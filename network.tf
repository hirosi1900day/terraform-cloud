resource "aws_vpc" "test_vpc" {
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "menta-vpc2"
  }
}

resource "aws_subnet" "elb-public1" {
  vpc_id            = aws_vpc.test_vpc.id

  tags = {
    Name = "elb-public1" 
  }
}