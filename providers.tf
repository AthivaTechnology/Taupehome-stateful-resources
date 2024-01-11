terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.14.0"
    }
  }
    backend "s3" {
    bucket = "leadgen-liberty-terraform-statefile"
    dynamodb_table = "s3_state_lock"
    key    = "leadgen-tfstatefile/terraform.tfstate"
    region = "us-west-2"
    profile = "liberty-admin-profile"
#    encrypt = true
  }  
}

# Configure the AWS Provider
provider "aws" {
  region = local.region
  profile = "liberty-admin-profile"
}