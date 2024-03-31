terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "test-horosi1900day"

    workspaces {
      name = "terraform-cloud-state-test"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
