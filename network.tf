resource "aws_vpc" "test_vpc" {
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "menta-vpc2"
  }
}