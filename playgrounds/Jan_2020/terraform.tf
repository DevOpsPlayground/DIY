
provider "aws" {
  region = var.region
}
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  backend "remote" {
    organization = "devops-playground-ldn"
    workspaces {
      name = "DIY"
    }
  }
}


