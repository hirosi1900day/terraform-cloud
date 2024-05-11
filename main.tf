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
}

module "global" {
  source = "./modules/global"
}