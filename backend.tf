terraform {
  required_version = ">= 1.10"

  backend "s3" {
    bucket       = "depi-team-n-tfstate"
    key          = "project/terraform.tfstate"
    region       = "us-east-1"
    profile      = "depi-team-n"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "depi-team-n"

  default_tags {
    tags = {
      Project   = "depi-team-n"
      ManagedBy = "terraform"
    }
  }
}
