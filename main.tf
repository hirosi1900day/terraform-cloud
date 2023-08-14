terraform {
  cloud {
    organization = "test-horosi1900day"

    workspaces {
      name = "terraform-cloud"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  
  role {
    role_arn = var.TFC_AWS_RUN_ROLE_ARN
  }
}
