data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "test-horosi1900day"
    workspaces = {
      name = "terraform-cloud-state-test"
    }
  }
}

resource "aws_vpc" "test_vpc2" {
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "menta-vpc2"
  }
}

resource "aws_subnet" "elb-public1" {
  vpc_id            = aws_vpc.test_vpc2.id
  cidr_block        = "172.31.102.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "elb-public1"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_http"
  description = "state shared security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

moved {
  from = aws_vpc.test_vpc
  to   = aws_vpc.test_vpc2
}

output "test" {
  value       = data.terraform_remote_state.vpc.outputs.vpc_id
  description = "ステート共有確認"
}

# module "vpc" {
#   source  = "app.terraform.io/test-horosi1900day/vpc/aws"
#   version = "0.0.2"
#   system   = "test"
#   env      = "prd"
#   cidr_vpc = "10.1.0.0/16"
#   cidr_public = [
#     "10.1.1.0/24",
#     "10.1.2.0/24",
#     "10.1.3.0/24"
#   ]
#   cidr_private = [
#     "10.1.101.0/24",
#     "10.1.102.0/24",
#     "10.1.103.0/24"
#   ]
#   cidr_secure = [
#     "10.1.201.0/24",
#     "10.1.202.0/24",
#     "10.1.203.0/24"
#   ]
# }