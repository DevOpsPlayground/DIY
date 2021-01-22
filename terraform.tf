provider "aws" {
  region = var.region
}

# Used to provide random names for instance profiles:
// Untill a fix is found an instance profile is created for each user.
// The use of a data source would help but means that a user will need to change this. 

provider "random" {
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