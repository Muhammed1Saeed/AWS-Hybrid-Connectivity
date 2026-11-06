terraform {
  required_version = ">= 1.10"

  backend "s3" {
    bucket       = "hybrid-connectivity-tfstate"
    key          = "project/terraform.tfstate"
    region       = "us-east-1"
    profile      = "hybrid-connectivity"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1. Default Provider: Main Region (Hub VPC, Spoke VPC, TGW, WAF)
provider "aws" {
  region  = "us-east-1"
  profile = "hybrid-connectivity"

  default_tags {
    tags = {
      Project   = "AWS-Hybrid-Connectivity"
      ManagedBy = "terraform"
      Role      = "Cloud-Infrastructure"
    }
  }
}

# 2. Aliased Provider: On-Premises Simulation (FortiGate & On-Prem VPC)
provider "aws" {
  alias   = "onprem"
  region  = "eu-north-1"
  profile = "hybrid-connectivity"

  default_tags {
    tags = {
      Project     = "AWS-Hybrid-Connectivity"
      ManagedBy   = "terraform"
      Environment = "Simulated-On-Premises"
    }
  }
}