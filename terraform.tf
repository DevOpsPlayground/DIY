provider "aws" {
  region = var.region
}
# depends if we can use tf cloud - if not - set up the state bucket?
/*terraform {
  backend "s3" {
    encrypt = true
    bucket  = "dpg-november-tfstate-bucket"
    region  = "eu-west-2"
    key     = "jenkins.tfstate"
  }
}*/