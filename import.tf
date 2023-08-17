import {
  to = aws_vpc.test_vpc
  id = "vpc-073288b1bab4dd9c1"
}

resource "aws_vpc" "test_vpc" {
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "menta-vpc2"
  }
}