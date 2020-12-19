provider "aws" {
  region  = "us-east-1"
  version = "~> 2.63"
}


terraform {
  backend "s3" {
    bucket = "s3-ecr-tr"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}