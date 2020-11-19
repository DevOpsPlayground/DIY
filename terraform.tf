provider "aws" {
  region  = var.region
  version = "~> 2.0"
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "dpg-november-tfstate-bucket"
    region  = "eu-west-2"
    key     = "jenkins.tfstate"
  }
}