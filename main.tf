terraform {
  cloud {
    organization = "test-horosi1900day"

    workspaces {
      name = "terraform-cloud"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "test-horosi1900day"

    workspaces {
      name = "terraform-cloud"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
