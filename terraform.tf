provider "aws" {
  region  = var.region
  version = "~> 2.0"
}

terraform {
  backend "s3" {
    encrypt = true
    bucket = "dpg-november-state-bucket"
    region = "eu-west-1"
    key = "jenkins.tfstate"
  }
}