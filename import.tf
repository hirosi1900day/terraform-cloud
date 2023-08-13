import {
  to = aws_vpc.test_vpc
  id = "vpc-073288b1bab4dd9c1"
}

resource "aws_vpc" "test_vpc" {
    cidr_block = "172.31.0.0/16"
}