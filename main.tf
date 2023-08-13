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
  profile =  "my-account"
}

resource "aws_sqs_queue" "my_queue" {
  name = "my-queue"
}